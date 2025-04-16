import IBR128_pkg::*;

class blowfish128_encrypt_ref_model;
	model_DEF model = new();
	logic [31:0] SBox1 [0:255] = model.SBOX1;
	logic [31:0] SBox2 [0:255] = model.SBOX2;
	logic [31:0] PArr [0:19] = model.PARR;

	function void subkey_generate(input bit [127:0] key);
		//128-bit case	
		logic [31:0] tmp;
		for(int i=0; i<20; i++) begin
			tmp = PArr[i];
			PArr[i] = PArr[i] ^ key[ (32*i)%128 +: 32 ]; 
			// $display($sformatf("P[%d] = %h XOR %h = %h", i, tmp, key[ (32*i)%128 +: 32 ], PArr[i]));
		end
	endfunction

	function automatic bit [63:0] f_funct(input bit [63:0] X);
		bit [63:0] Y = 0;
		bit [7:0] a, b, c, d, e, f, g, h;
		bit [31:0] S1a, S1b, S1c, S1d, S2e, S2f, S2g, S2h;

		//Extract X and rotate
		a = X[63:56];
		b = {X[48], X[55:49]};
		c = X[47:40];
		d = {X[32], X[39:33]};
		e = {X[24], X[31:25]};
		f = X[23:16];
		g = {X[8], X[15:9]};
		h = X[7:0];

		// $display($sformatf("a = %h\
				// \n b = %h\
				// \n c = %h\
				// \n d = %h\
				// \n e = %h\
				// \n f = %h\
				// \n g = %h\
				// \n h = %h", a, b, c, d, e, f, g, h));

		//Substitute and rotate
		S1a = SBox1[a];	S1a = {S1a[0], S1a[31:1]};
		S1b = SBox1[b];
		S1c = SBox1[c]; S1c = {S1c[0], S1c[31:1]};
		S1d = SBox1[d];
		S2e = SBox2[e];
		S2f = SBox2[f]; S2f = {S2f[30:0], S2f[31]};
		S2g = SBox2[g];
		S2h = SBox2[h]; S2h = {S2h[30:0], S2h[31]};

		// $display($sformatf("S1a = %h\
				// \n S1b = %h\
				// \n S1c = %h\
				// \n S1d = %h\
				// \n S2e = %h\
				// \n S2f = %h\
				// \n S2g = %h\
				// \n S2h = %h", S1a, S1b, S1c, S1d, S2e, S2f, S2g, S2h));

		Y[63:32] = ((S1a ^ S1b) + S1c) ^ S1d;
		// $display($sformatf("Y[63:32] = %h", Y[63:32]));

		Y[31:0] = ((S2e ^ S2f) + S2g) ^ S2h;
		// $display($sformatf("Y[31:0] = %h", Y[31:0]));

		return Y;
	endfunction

	function bit [127:0] encrypt(input bit [127:0] plain_text);
		bit [127:0] cipher_text;
		bit [63:0] left, right, tmp;

		left = plain_text[127:64];
		right = plain_text[63:0];
		
		for(int i=0; i<16; i+=2) begin
			left = left ^ {PArr[i], PArr[i+1]};
			// $display($sformatf("round: %d+%d, left: %h", i, i+1, left));
			right = f_funct(left) ^ right;
			// $display($sformatf("round: %d+%d, right: %h", i, i+1, right));
		
			//Swap
			tmp = left;
			left = right;
			right = tmp;
			// $display($sformatf("round: %d+%d, cipher: %h", i, i+1, {left, right}));
		end

		//Reverse previous swap at round 8th
		tmp = left;
		left = right;
		right = tmp;

		cipher_text[127:64] = left ^ {PArr[18], PArr[19]};
		cipher_text[63:0] = right ^ {PArr[16], PArr[17]};

		return cipher_text;
	endfunction

	function IBR128_seq_item predict(IBR128_seq_item input_tx);
		IBR128_seq_item output_tx = new();
		bit [127:0] PData;

		$display("MODEL_DEBUG");
		input_tx.print();

		// Generate subkeys
		subkey_generate(input_tx.Key);

		case(input_tx.BCOM)
			//BCOM: Cipher Block Chain
			CBC: begin
				if(input_tx.BlockNum == 1) begin
					PData = input_tx.PData ^ input_tx.IV;		
				end else begin
					PData = input_tx.PData ^ input_tx.CarryData;	
				end

				$display($sformatf("PData: %h", PData));

				// Encrypt plaintext
				$display("====ENCRYPT====");
				output_tx.EData = encrypt(PData);

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

				// Encrypt plaintext
				$display("====ENCRYPT====");
				output_tx.CarryData = encrypt(PData);

				output_tx.EData = output_tx.CarryData ^ input_tx.PData;
			end
			//BCOM: Counter Mode
			CTR: begin
				PData = input_tx.IV + (input_tx.BlockNum - 1);

				$display($sformatf("PData: %h", PData));

				// Encrypt plaintext
				$display("====ENCRYPT====");
				output_tx.EData = encrypt(PData);

				output_tx.EData = output_tx.EData ^ input_tx.PData;
				output_tx.CarryData = PData + 1; 	
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
