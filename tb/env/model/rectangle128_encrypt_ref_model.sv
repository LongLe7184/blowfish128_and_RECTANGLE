import IBR128_pkg::*;

class rectangle128_encrypt_ref_model;
	// Substitution box
	const bit [3:0] S [16] = '{
		4'h6, 4'h5, 4'hC, 4'hA,
		4'h1, 4'hE, 4'h7, 4'h9,
		4'hB, 4'h0, 4'h3, 4'hD,
		4'h8, 4'hF, 4'h4, 4'h2
	};

	// Round constants
	const bit [4:0] RC [25] = '{
		5'b00001, 5'b00010, 5'b00100, 5'b01001, 5'b10010,
		5'b00101, 5'b01011, 5'b10110, 5'b01100, 5'b11001,
		5'b10011, 5'b00111, 5'b01111, 5'b11111, 5'b11110,
		5'b11100, 5'b11000, 5'b10001, 5'b00011, 5'b00110,
		5'b01101, 5'b11011, 5'b10111, 5'b01110, 5'b11101
	};

	// Subkeys storage
	bit [63:0] SKey [26];

	// Helper function to rotate left a bit vector
	function automatic bit [15:0] rotate_left(input bit [15:0] value, input int amount);
		return (value << amount) | (value >> (16 - amount));
	endfunction

	// Key schedule function for 128-bit key
	function automatic bit [127:0] key_schedule(input bit [127:0] key, input int round);
		bit [31:0] r0, r1, r2, r3;
		bit [31:0] r0_tmp;

		// Extract rows from key
		r0 = key[31:0];
		r1 = key[63:32];
		r2 = key[95:64];
		r3 = key[127:96];

		// Apply substitution for 8 right most columns
		for (int j = 0; j < 8; j++) begin
			bit [3:0] sbox_in, sbox_out;
			sbox_in = {r3[j], r2[j], r1[j], r0[j]};
			sbox_out = S[sbox_in];
			r3[j] = sbox_out[3];
			r2[j] = sbox_out[2];
			r1[j] = sbox_out[1];
			r0[j] = sbox_out[0];
		end

		// Feistel transform
		r0_tmp = r0;
		r0 = (r0 << 8 | r0 >> 24) ^ r1;
		r1 = r2;
		r2 = (r2 << 16 | r2 >> 16) ^ r3;
		r3 = r0_tmp;

		// Add round constant
		r0[4:0] = r0[4:0] ^ RC[round-1];

		return {r3, r2, r1, r0};
	endfunction

	// Extract 64-bit subkey from 128-bit key
	function automatic bit [63:0] subkey_extract(input bit [127:0] key);
		bit [63:0] subkey;
		subkey[63:48] = key[111:96];
		subkey[47:32] = key[79:64];
		subkey[31:16] = key[47:32];
		subkey[15:0]  = key[15:0];
		return subkey;
	endfunction

	// Generate all subkeys from main key
	function void subkey_generate(input bit [127:0] key);
		bit [127:0] current_key = key;
		SKey[0] = subkey_extract(current_key);

		for (int round = 1; round <= 25; round++) begin
			current_key = key_schedule(current_key, round);
			SKey[round] = subkey_extract(current_key);
		end
	endfunction

	// Main encryption round
	function automatic bit [63:0] main_round(input bit [63:0] text, input int round);
		bit [15:0] r0, r1, r2, r3;
		bit [63:0] cipher_text;

		//Extract rows from plain text
		r0 = text[15:0];
		r1 = text[31:16];
		r2 = text[47:32];
		r3 = text[63:48];
		
		// Extract rows
		// extract_rows(text, r0, r1, r2, r3);

		// SubColumns - Substitution Layer
		for (int j = 0; j < 16 ; j++) begin
			bit [3:0] sbox_in, sbox_out;
			sbox_in = {r3[j], r2[j], r1[j], r0[j]};
			sbox_out = S[sbox_in];
			r3[j] = sbox_out[3];
			r2[j] = sbox_out[2];
			r1[j] = sbox_out[1];
			r0[j] = sbox_out[0];
		end

		// ShiftRows - Permutation Layer
		r1 = rotate_left(r1, 1);
		r2 = rotate_left(r2, 12);
		r3 = rotate_left(r3, 13);

		// Pack rows back into state
		// cipher_text = pack_rows(r0, r1, r2, r3);
		cipher_text = {r3, r2, r1, r0};

		// Add round key
		cipher_text = cipher_text ^ SKey[round];

		return cipher_text;
	endfunction

	// Full encryption function
	function bit [63:0] encrypt(input bit [63:0] plain_text);
		bit [63:0] cipher_text;

		// Initial round - XOR with first subkey
		cipher_text = plain_text ^ SKey[0];

		// Main rounds
		for (int round = 1; round <= 25; round++) begin
			cipher_text = main_round(cipher_text, round);
			$display($sformatf("round: %d, cipher: %h", round, cipher_text));
		end

		return cipher_text;
	endfunction

	// Function to predict output from input
	function IBR128_seq_item predict(IBR128_seq_item input_tx);
		IBR128_seq_item output_tx = new();
		bit [127:0] PData;
		bit [127:0] key;
		bit [63:0] plain_text_upper, plain_text_lower;
		bit [63:0] cipher_text_upper, cipher_text_lower;
		
		$display("MODEL_DEBUG");
		input_tx.print();
		// $display($sformatf("KeyInput: %h, DataInput: %h", input_tx.Key, input_tx.PData));

		// Copy inputs from transaction
		key = input_tx.Key;

		// Generate subkeys
		subkey_generate(key);

		case(input_tx.BCOM)
			//BCOM: Cipher Block Chain
			CBC: begin
				if(input_tx.BlockNum == 1) begin
					PData = input_tx.PData ^ input_tx.IV;		
				end else begin
					PData = input_tx.PData ^ input_tx.CarryData;	
				end

				$display($sformatf("PData: %h", PData));
				plain_text_upper = PData[127:64];
				plain_text_lower = PData[63:0];

				// Encrypt plaintext
				$display("====UPPER====");
				cipher_text_upper = encrypt(plain_text_upper);
				$display("====LOWER====");
				cipher_text_lower = encrypt(plain_text_lower);

				output_tx.EData = {cipher_text_upper, cipher_text_lower};
				output_tx.CarryData = output_tx.EData;
			end
			//BCOM: Output Feedback Mode
			OFB: begin
				if(input_tx.BlockNum == 1) begin
					PData = input_tx.IV;		
				end else begin
					PData = input_tx.CarryData;	
				end

				$display($sformatf("PData: %h", PData));
				plain_text_upper = PData[127:64];
				plain_text_lower = PData[63:0];

				// Encrypt plaintext
				$display("====UPPER====");
				cipher_text_upper = encrypt(plain_text_upper);
				$display("====LOWER====");
				cipher_text_lower = encrypt(plain_text_lower);

				output_tx.CarryData = {cipher_text_upper, cipher_text_lower};
				output_tx.EData = output_tx.CarryData;
				output_tx.EData = output_tx.EData ^ input_tx.PData;
			end
			//BCOM: Counter Mode
			CTR: begin
				PData[127:64] = input_tx.IV[127:64] + (input_tx.BlockNum - 1);
				PData[63:0] = input_tx.IV[63:0] + (input_tx.BlockNum - 1);

				$display($sformatf("PData: %h", PData));
				plain_text_upper = PData[127:64];
				plain_text_lower = PData[63:0];

				// Encrypt plaintext
				$display("====UPPER====");
				cipher_text_upper = encrypt(plain_text_upper);
				$display("====LOWER====");
				cipher_text_lower = encrypt(plain_text_lower);

				output_tx.EData = {cipher_text_upper, cipher_text_lower};
				output_tx.EData = output_tx.EData ^ input_tx.PData;
				output_tx.CarryData = {(PData[127:64] + 1), (PData[63:0] + 1)}; 	
			end

		endcase


		//Copy other fields to output_tx
		output_tx.Operation = input_tx.Operation;
		output_tx.Algorithm = input_tx.Algorithm;
		output_tx.BCOM = input_tx.BCOM;
		output_tx.BlockNum = input_tx.BlockNum;
		output_tx.IV = input_tx.IV;
		output_tx.Key = input_tx.Key;    
		output_tx.PData = input_tx.PData;  

		return output_tx;
	endfunction
endclass
