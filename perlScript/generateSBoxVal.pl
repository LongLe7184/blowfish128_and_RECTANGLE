#!user/bin/perl

# Open file handle
open $fh, '<', "piDigits.txt" or die "Can't open file!";
open $fo, '>', "./../rtl/blowfish128/blowfish128_DEF.svh" or die "Can't create file!";

$n = 0;
$parr_size = 0;

$parr_flag = 0;
$sbox_flag = 0;
$p_arr = 0;	#parr pointer
$p_sbox = 0;	#sbox pointer

# Print .svh file header
print $fo "//-----------------------------------------------------------
// Function: Blowfish-128's Definition
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Feb-11th, 2025
// Description	: Contain S-Boxes's values
//-----------------------------------------------------------\n\n";

while($line = <$fh>) {

	#SBox Macros
	if($line =~ /D1310BA6/){
		$sbox_flag = 1;	
		$p_sbox = $-[0]; #position of 'D' in $line
	}
	if($sbox_flag){
		while($p_sbox < 64){
			$substring = substr($line, $p_sbox, 8);
			$p_sbox += 8;
			if($n<=255){
				# Adding begining lines of SBoxes's Macros
				if($n==0) {
					print $fo "\n//SBox1 Macro's Values\n";
				}
				
				# Print out file
				$macro_label = sprintf("SBOX1_ELEMENT_%03d", $n);
				$macro_str = sprintf("`define %s 32'h%s", $macro_label, $substring);
				print $fo "$macro_str\n";
				
				# Print on Console
				$hex = sprintf("8'h%02X", $n);
				print("$hex: blowfish128_sbox1[31:0] = `$macro_label;\n");
			}
			if($n>255 && $n<512){
				# Adding spliting lines between 2 SBoxes's Macros
				if($n==256) {
					print $fo "\n//SBox2 Macro's Values\n";
				}
				
				# Print out file
				$macro_label = sprintf("SBOX2_ELEMENT_%03d", ($n-256));
				$macro_str = sprintf("`define %s 32'h%s", $macro_label, $substring);
				print $fo "$macro_str\n";
				
				# Print on Console
				$hex = sprintf("8'h%02X", ($n-256));
				print("$hex: blowfish128_sbox2[31:0] = `$macro_label;\n");
			}
			if($n>=512){
				$sbox_flag = 0;
				last; #break while loop
			}
			$n++;
		}	
		$p_sbox = 0;
	}

	#PArr Macros
	if($line =~ /BCF46B2E/){
		$parr_flag = 1;
		$p_parr = $-[0]; #position of 'B' in $line
	}
	if($parr_flag){
		while($p_parr < 64){
			$substring = substr($line, $p_parr, 8);
			$p_parr += 8;
			if($parr_size <= 19){
				# Adding begining lines of SBoxes's Macros
				if($parr_size==0) {
					print $fo "\n//PArr Macro's Values\n";
				}
				# Print out file
				$macro_label = sprintf("PARR_ELEMENT_%03d", $parr_size);
				$macro_str = sprintf("`define %s 32'h%s", $macro_label, $substring);
				print $fo "$macro_str\n";
				
				# Print on Console
				print("p_array[$parr_size] <= `$macro_label;\n");
			}
			$parr_size++;
		}
		$p_parr = 0;
	}
}
