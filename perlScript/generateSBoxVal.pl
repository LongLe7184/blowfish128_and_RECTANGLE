#!user/bin/perl

# Open file with ReadOnly Access
open $fh, '<', "piDigits.txt" or die "Can't open file!";

$n = 0;
$bool = 0;
$p = 0;
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
				$hex = sprintf("8'h%02X", $n);
				print("$hex: blowfish128_sbox1[31:0] = 32'h$substring;\n");
			}
			if($n>255 && $n<512){
				$hex = sprintf("8'h%02X", ($n-256));
				print("$hex: blowfish128_sbox2[31:0] = 32'h$substring;\n");
			}
			if($n>=512){
				exit;
			}
			$n++;
		}	
		$p = 0;
	}
}
