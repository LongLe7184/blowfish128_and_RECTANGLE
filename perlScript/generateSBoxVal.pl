#!user/bin/perl

# Open file handle
open $fh, '<', "piDigits.txt" or die "Can't open file!";
open $fo, '>', "./../blowfish128/blowfish128_DEF.svh" or die "Can't create file!";

$n = 0;
$bool = 0;
$p = 0;

# Print .svh file header
print $fo "//-----------------------------------------------------------
// Function: Blowfish-128's Definition
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Feb-11th, 2025
// Description	: Contain S-Boxes's values
//-----------------------------------------------------------\n\n";

while($line = <$fh>) {
	if($line =~ /D1310BA6/){
		$bool = 1;	
		$p = $-[0]; #position of 'D' in $line
	}
	if($bool){
		while($p < 64){
			$substring = substr($line, $p, 8);
			$p += 8;
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
				exit;
			}
			$n++;
		}	
		$p = 0;
	}
}
