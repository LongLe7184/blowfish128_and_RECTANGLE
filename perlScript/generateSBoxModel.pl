#!/usr/bin/perl

open my $fi, '<', "./../rtl/blowfish128/blowfish128_DEF.svh" or die "Can't open file!";
open my $fo, '>', "./../tb/env/model/model_DEF.sv" or die "Can't create file!";

# my @sbox1;
# my @sbox2;
# my @parr;
my @sbox1_val;
my @sbox2_val;
my @parr_val;

# Print out array macros
print $fo "//-----------------------------------------------------------
// Model Class: Blowfish-128 Model SBoxes
// Note       : This file is generated automatically! Do Not Edit!
//-----------------------------------------------------------\n\n";

print $fo "class model_DEF;\n";

while (my $line = <$fi>) {
	# \s+ -> whitespace
	# (SBOX1\w+) -> get words following by SBOX1 and store both in $1 - ()
	# (32'h[0-9A-F]+) -> get hexa character 32'h... and store in $2 - ()
	if($line =~ /`define\s+(SBOX1\w+)\s+(32'h[0-9A-F]+)/) {
		# push(@sbox1, $1);
		push(@sbox1_val, $2);
	}
	elsif($line =~ /`define\s+(SBOX2\w+)\s+(32'h[0-9A-F]+)/) {
		# push(@sbox2, $1);
		push(@sbox2_val, $2);
	}
	elsif($line =~ /`define\s+(PARR\w+)\s+(32'h[0-9A-F]+)/) {
		# push(@parr, $1);
		push(@parr_val, $2);
	}
}

print $fo "\n\t// SBOX1\n";

print $fo "\tlogic [31:0] SBOX1 [255:0] = '{\n\t\t";
print("logic [31:0] SBOX1 [255:0] = '{\n\t");

my $i = 0;
my $n = 0;
foreach my $word (@sbox1_val) {
    # Comma control
    if ($n != 255) {
        print $fo "$word,";
        print("$word,");
    } else {
        print $fo "$word";
        print("$word");
    }
    $n++;
    # Spacing and newline control
    if ($i != 3) {
        $i++;
        print $fo " ";
        print(" ");
    } else {
        $i = 0;
        print("\n\t");
        print $fo "\n\t\t";
    }
}
print ("}\n");
print $fo "};\n";

print $fo "\n// SBOX2\n";

print $fo "\tlogic [31:0] SBOX2 [255:0] = '{\n\t\t";
print("logic [31:0] SBOX2 [255:0] = '{\n\t");

my $i = 0;
my $n = 0;
foreach my $word (@sbox2_val) {
    # Comma control
    if ($n != 255) {
        print $fo "$word,";
        print("$word,");
    } else {
        print $fo "$word";
        print("$word");
    }
    $n++;
    # Spacing and newline control
    if ($i != 3) {
        $i++;
        print $fo " ";
        print(" ");
    } else {
        $i = 0;
        print("\n\t");
        print $fo "\n\t\t";
    }
}
print ("}\n");
print $fo "};\n";

print $fo "\t\n// PARR\n";

print $fo "\tlogic [31:0] PARR [19:0] = '{\n\t\t";
print("logic [31:0] PARR [19:0] = '{\n\t");

my $i = 0;
my $n = 0;
foreach my $word (@parr_val) {
    # Comma control
    if ($n != 19) {
        print $fo "$word,";
        print("$word,");
    } else {
        print $fo "$word";
        print("$word");
    }
    $n++;
    # Spacing and newline control
    if ($i != 3) {
        $i++;
        print $fo " ";
        print(" ");
    } else {
        $i = 0;
        print("\n\t");
        print $fo "\n\t\t";
    }
}
print ("}\n");
print $fo "};\n\nendclass";

close $fi;
close $fo;
