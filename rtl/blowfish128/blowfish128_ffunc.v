//-----------------------------------------------------------
// Module: Blowfish-128's F-function Module
//-----------------------------------------------------------
// Author	: Long Le, Manh Nguyen
// Date  	: Feb-8th, 2025
// Description	: F-function module used in encrypting process
//-----------------------------------------------------------

/* USING NOTE:
*  This module reset state is trigger by Global ResetN (IP Reset signal) OR
*  the Enable control signal from Feistel rounds. Reset is REQUIRE to clear
*  previous values storing in this module and start the state machine (IDLE
*  phase).
* */

`include "blowfish128_DEF.vh"

module blowfish128_ffunc(
	input Clk,
	input RstN,
	input Enable,
	input [63:0] X,
	output [63:0] Y,
	output outputValid
	);

	function [31:0] blowfish128_sbox1;
		input [7:0] sbox_in;
		begin
			case(sbox_in[7:0])
				8'h00: blowfish128_sbox1 = `SBOX1_ELEMENT_000;
				8'h01: blowfish128_sbox1 = `SBOX1_ELEMENT_001;
				8'h02: blowfish128_sbox1 = `SBOX1_ELEMENT_002;
				8'h03: blowfish128_sbox1 = `SBOX1_ELEMENT_003;
				8'h04: blowfish128_sbox1 = `SBOX1_ELEMENT_004;
				8'h05: blowfish128_sbox1 = `SBOX1_ELEMENT_005;
				8'h06: blowfish128_sbox1 = `SBOX1_ELEMENT_006;
				8'h07: blowfish128_sbox1 = `SBOX1_ELEMENT_007;
				8'h08: blowfish128_sbox1 = `SBOX1_ELEMENT_008;
				8'h09: blowfish128_sbox1 = `SBOX1_ELEMENT_009;
				8'h0A: blowfish128_sbox1 = `SBOX1_ELEMENT_010;
				8'h0B: blowfish128_sbox1 = `SBOX1_ELEMENT_011;
				8'h0C: blowfish128_sbox1 = `SBOX1_ELEMENT_012;
				8'h0D: blowfish128_sbox1 = `SBOX1_ELEMENT_013;
				8'h0E: blowfish128_sbox1 = `SBOX1_ELEMENT_014;
				8'h0F: blowfish128_sbox1 = `SBOX1_ELEMENT_015;
				8'h10: blowfish128_sbox1 = `SBOX1_ELEMENT_016;
				8'h11: blowfish128_sbox1 = `SBOX1_ELEMENT_017;
				8'h12: blowfish128_sbox1 = `SBOX1_ELEMENT_018;
				8'h13: blowfish128_sbox1 = `SBOX1_ELEMENT_019;
				8'h14: blowfish128_sbox1 = `SBOX1_ELEMENT_020;
				8'h15: blowfish128_sbox1 = `SBOX1_ELEMENT_021;
				8'h16: blowfish128_sbox1 = `SBOX1_ELEMENT_022;
				8'h17: blowfish128_sbox1 = `SBOX1_ELEMENT_023;
				8'h18: blowfish128_sbox1 = `SBOX1_ELEMENT_024;
				8'h19: blowfish128_sbox1 = `SBOX1_ELEMENT_025;
				8'h1A: blowfish128_sbox1 = `SBOX1_ELEMENT_026;
				8'h1B: blowfish128_sbox1 = `SBOX1_ELEMENT_027;
				8'h1C: blowfish128_sbox1 = `SBOX1_ELEMENT_028;
				8'h1D: blowfish128_sbox1 = `SBOX1_ELEMENT_029;
				8'h1E: blowfish128_sbox1 = `SBOX1_ELEMENT_030;
				8'h1F: blowfish128_sbox1 = `SBOX1_ELEMENT_031;
				8'h20: blowfish128_sbox1 = `SBOX1_ELEMENT_032;
				8'h21: blowfish128_sbox1 = `SBOX1_ELEMENT_033;
				8'h22: blowfish128_sbox1 = `SBOX1_ELEMENT_034;
				8'h23: blowfish128_sbox1 = `SBOX1_ELEMENT_035;
				8'h24: blowfish128_sbox1 = `SBOX1_ELEMENT_036;
				8'h25: blowfish128_sbox1 = `SBOX1_ELEMENT_037;
				8'h26: blowfish128_sbox1 = `SBOX1_ELEMENT_038;
				8'h27: blowfish128_sbox1 = `SBOX1_ELEMENT_039;
				8'h28: blowfish128_sbox1 = `SBOX1_ELEMENT_040;
				8'h29: blowfish128_sbox1 = `SBOX1_ELEMENT_041;
				8'h2A: blowfish128_sbox1 = `SBOX1_ELEMENT_042;
				8'h2B: blowfish128_sbox1 = `SBOX1_ELEMENT_043;
				8'h2C: blowfish128_sbox1 = `SBOX1_ELEMENT_044;
				8'h2D: blowfish128_sbox1 = `SBOX1_ELEMENT_045;
				8'h2E: blowfish128_sbox1 = `SBOX1_ELEMENT_046;
				8'h2F: blowfish128_sbox1 = `SBOX1_ELEMENT_047;
				8'h30: blowfish128_sbox1 = `SBOX1_ELEMENT_048;
				8'h31: blowfish128_sbox1 = `SBOX1_ELEMENT_049;
				8'h32: blowfish128_sbox1 = `SBOX1_ELEMENT_050;
				8'h33: blowfish128_sbox1 = `SBOX1_ELEMENT_051;
				8'h34: blowfish128_sbox1 = `SBOX1_ELEMENT_052;
				8'h35: blowfish128_sbox1 = `SBOX1_ELEMENT_053;
				8'h36: blowfish128_sbox1 = `SBOX1_ELEMENT_054;
				8'h37: blowfish128_sbox1 = `SBOX1_ELEMENT_055;
				8'h38: blowfish128_sbox1 = `SBOX1_ELEMENT_056;
				8'h39: blowfish128_sbox1 = `SBOX1_ELEMENT_057;
				8'h3A: blowfish128_sbox1 = `SBOX1_ELEMENT_058;
				8'h3B: blowfish128_sbox1 = `SBOX1_ELEMENT_059;
				8'h3C: blowfish128_sbox1 = `SBOX1_ELEMENT_060;
				8'h3D: blowfish128_sbox1 = `SBOX1_ELEMENT_061;
				8'h3E: blowfish128_sbox1 = `SBOX1_ELEMENT_062;
				8'h3F: blowfish128_sbox1 = `SBOX1_ELEMENT_063;
				8'h40: blowfish128_sbox1 = `SBOX1_ELEMENT_064;
				8'h41: blowfish128_sbox1 = `SBOX1_ELEMENT_065;
				8'h42: blowfish128_sbox1 = `SBOX1_ELEMENT_066;
				8'h43: blowfish128_sbox1 = `SBOX1_ELEMENT_067;
				8'h44: blowfish128_sbox1 = `SBOX1_ELEMENT_068;
				8'h45: blowfish128_sbox1 = `SBOX1_ELEMENT_069;
				8'h46: blowfish128_sbox1 = `SBOX1_ELEMENT_070;
				8'h47: blowfish128_sbox1 = `SBOX1_ELEMENT_071;
				8'h48: blowfish128_sbox1 = `SBOX1_ELEMENT_072;
				8'h49: blowfish128_sbox1 = `SBOX1_ELEMENT_073;
				8'h4A: blowfish128_sbox1 = `SBOX1_ELEMENT_074;
				8'h4B: blowfish128_sbox1 = `SBOX1_ELEMENT_075;
				8'h4C: blowfish128_sbox1 = `SBOX1_ELEMENT_076;
				8'h4D: blowfish128_sbox1 = `SBOX1_ELEMENT_077;
				8'h4E: blowfish128_sbox1 = `SBOX1_ELEMENT_078;
				8'h4F: blowfish128_sbox1 = `SBOX1_ELEMENT_079;
				8'h50: blowfish128_sbox1 = `SBOX1_ELEMENT_080;
				8'h51: blowfish128_sbox1 = `SBOX1_ELEMENT_081;
				8'h52: blowfish128_sbox1 = `SBOX1_ELEMENT_082;
				8'h53: blowfish128_sbox1 = `SBOX1_ELEMENT_083;
				8'h54: blowfish128_sbox1 = `SBOX1_ELEMENT_084;
				8'h55: blowfish128_sbox1 = `SBOX1_ELEMENT_085;
				8'h56: blowfish128_sbox1 = `SBOX1_ELEMENT_086;
				8'h57: blowfish128_sbox1 = `SBOX1_ELEMENT_087;
				8'h58: blowfish128_sbox1 = `SBOX1_ELEMENT_088;
				8'h59: blowfish128_sbox1 = `SBOX1_ELEMENT_089;
				8'h5A: blowfish128_sbox1 = `SBOX1_ELEMENT_090;
				8'h5B: blowfish128_sbox1 = `SBOX1_ELEMENT_091;
				8'h5C: blowfish128_sbox1 = `SBOX1_ELEMENT_092;
				8'h5D: blowfish128_sbox1 = `SBOX1_ELEMENT_093;
				8'h5E: blowfish128_sbox1 = `SBOX1_ELEMENT_094;
				8'h5F: blowfish128_sbox1 = `SBOX1_ELEMENT_095;
				8'h60: blowfish128_sbox1 = `SBOX1_ELEMENT_096;
				8'h61: blowfish128_sbox1 = `SBOX1_ELEMENT_097;
				8'h62: blowfish128_sbox1 = `SBOX1_ELEMENT_098;
				8'h63: blowfish128_sbox1 = `SBOX1_ELEMENT_099;
				8'h64: blowfish128_sbox1 = `SBOX1_ELEMENT_100;
				8'h65: blowfish128_sbox1 = `SBOX1_ELEMENT_101;
				8'h66: blowfish128_sbox1 = `SBOX1_ELEMENT_102;
				8'h67: blowfish128_sbox1 = `SBOX1_ELEMENT_103;
				8'h68: blowfish128_sbox1 = `SBOX1_ELEMENT_104;
				8'h69: blowfish128_sbox1 = `SBOX1_ELEMENT_105;
				8'h6A: blowfish128_sbox1 = `SBOX1_ELEMENT_106;
				8'h6B: blowfish128_sbox1 = `SBOX1_ELEMENT_107;
				8'h6C: blowfish128_sbox1 = `SBOX1_ELEMENT_108;
				8'h6D: blowfish128_sbox1 = `SBOX1_ELEMENT_109;
				8'h6E: blowfish128_sbox1 = `SBOX1_ELEMENT_110;
				8'h6F: blowfish128_sbox1 = `SBOX1_ELEMENT_111;
				8'h70: blowfish128_sbox1 = `SBOX1_ELEMENT_112;
				8'h71: blowfish128_sbox1 = `SBOX1_ELEMENT_113;
				8'h72: blowfish128_sbox1 = `SBOX1_ELEMENT_114;
				8'h73: blowfish128_sbox1 = `SBOX1_ELEMENT_115;
				8'h74: blowfish128_sbox1 = `SBOX1_ELEMENT_116;
				8'h75: blowfish128_sbox1 = `SBOX1_ELEMENT_117;
				8'h76: blowfish128_sbox1 = `SBOX1_ELEMENT_118;
				8'h77: blowfish128_sbox1 = `SBOX1_ELEMENT_119;
				8'h78: blowfish128_sbox1 = `SBOX1_ELEMENT_120;
				8'h79: blowfish128_sbox1 = `SBOX1_ELEMENT_121;
				8'h7A: blowfish128_sbox1 = `SBOX1_ELEMENT_122;
				8'h7B: blowfish128_sbox1 = `SBOX1_ELEMENT_123;
				8'h7C: blowfish128_sbox1 = `SBOX1_ELEMENT_124;
				8'h7D: blowfish128_sbox1 = `SBOX1_ELEMENT_125;
				8'h7E: blowfish128_sbox1 = `SBOX1_ELEMENT_126;
				8'h7F: blowfish128_sbox1 = `SBOX1_ELEMENT_127;
				8'h80: blowfish128_sbox1 = `SBOX1_ELEMENT_128;
				8'h81: blowfish128_sbox1 = `SBOX1_ELEMENT_129;
				8'h82: blowfish128_sbox1 = `SBOX1_ELEMENT_130;
				8'h83: blowfish128_sbox1 = `SBOX1_ELEMENT_131;
				8'h84: blowfish128_sbox1 = `SBOX1_ELEMENT_132;
				8'h85: blowfish128_sbox1 = `SBOX1_ELEMENT_133;
				8'h86: blowfish128_sbox1 = `SBOX1_ELEMENT_134;
				8'h87: blowfish128_sbox1 = `SBOX1_ELEMENT_135;
				8'h88: blowfish128_sbox1 = `SBOX1_ELEMENT_136;
				8'h89: blowfish128_sbox1 = `SBOX1_ELEMENT_137;
				8'h8A: blowfish128_sbox1 = `SBOX1_ELEMENT_138;
				8'h8B: blowfish128_sbox1 = `SBOX1_ELEMENT_139;
				8'h8C: blowfish128_sbox1 = `SBOX1_ELEMENT_140;
				8'h8D: blowfish128_sbox1 = `SBOX1_ELEMENT_141;
				8'h8E: blowfish128_sbox1 = `SBOX1_ELEMENT_142;
				8'h8F: blowfish128_sbox1 = `SBOX1_ELEMENT_143;
				8'h90: blowfish128_sbox1 = `SBOX1_ELEMENT_144;
				8'h91: blowfish128_sbox1 = `SBOX1_ELEMENT_145;
				8'h92: blowfish128_sbox1 = `SBOX1_ELEMENT_146;
				8'h93: blowfish128_sbox1 = `SBOX1_ELEMENT_147;
				8'h94: blowfish128_sbox1 = `SBOX1_ELEMENT_148;
				8'h95: blowfish128_sbox1 = `SBOX1_ELEMENT_149;
				8'h96: blowfish128_sbox1 = `SBOX1_ELEMENT_150;
				8'h97: blowfish128_sbox1 = `SBOX1_ELEMENT_151;
				8'h98: blowfish128_sbox1 = `SBOX1_ELEMENT_152;
				8'h99: blowfish128_sbox1 = `SBOX1_ELEMENT_153;
				8'h9A: blowfish128_sbox1 = `SBOX1_ELEMENT_154;
				8'h9B: blowfish128_sbox1 = `SBOX1_ELEMENT_155;
				8'h9C: blowfish128_sbox1 = `SBOX1_ELEMENT_156;
				8'h9D: blowfish128_sbox1 = `SBOX1_ELEMENT_157;
				8'h9E: blowfish128_sbox1 = `SBOX1_ELEMENT_158;
				8'h9F: blowfish128_sbox1 = `SBOX1_ELEMENT_159;
				8'hA0: blowfish128_sbox1 = `SBOX1_ELEMENT_160;
				8'hA1: blowfish128_sbox1 = `SBOX1_ELEMENT_161;
				8'hA2: blowfish128_sbox1 = `SBOX1_ELEMENT_162;
				8'hA3: blowfish128_sbox1 = `SBOX1_ELEMENT_163;
				8'hA4: blowfish128_sbox1 = `SBOX1_ELEMENT_164;
				8'hA5: blowfish128_sbox1 = `SBOX1_ELEMENT_165;
				8'hA6: blowfish128_sbox1 = `SBOX1_ELEMENT_166;
				8'hA7: blowfish128_sbox1 = `SBOX1_ELEMENT_167;
				8'hA8: blowfish128_sbox1 = `SBOX1_ELEMENT_168;
				8'hA9: blowfish128_sbox1 = `SBOX1_ELEMENT_169;
				8'hAA: blowfish128_sbox1 = `SBOX1_ELEMENT_170;
				8'hAB: blowfish128_sbox1 = `SBOX1_ELEMENT_171;
				8'hAC: blowfish128_sbox1 = `SBOX1_ELEMENT_172;
				8'hAD: blowfish128_sbox1 = `SBOX1_ELEMENT_173;
				8'hAE: blowfish128_sbox1 = `SBOX1_ELEMENT_174;
				8'hAF: blowfish128_sbox1 = `SBOX1_ELEMENT_175;
				8'hB0: blowfish128_sbox1 = `SBOX1_ELEMENT_176;
				8'hB1: blowfish128_sbox1 = `SBOX1_ELEMENT_177;
				8'hB2: blowfish128_sbox1 = `SBOX1_ELEMENT_178;
				8'hB3: blowfish128_sbox1 = `SBOX1_ELEMENT_179;
				8'hB4: blowfish128_sbox1 = `SBOX1_ELEMENT_180;
				8'hB5: blowfish128_sbox1 = `SBOX1_ELEMENT_181;
				8'hB6: blowfish128_sbox1 = `SBOX1_ELEMENT_182;
				8'hB7: blowfish128_sbox1 = `SBOX1_ELEMENT_183;
				8'hB8: blowfish128_sbox1 = `SBOX1_ELEMENT_184;
				8'hB9: blowfish128_sbox1 = `SBOX1_ELEMENT_185;
				8'hBA: blowfish128_sbox1 = `SBOX1_ELEMENT_186;
				8'hBB: blowfish128_sbox1 = `SBOX1_ELEMENT_187;
				8'hBC: blowfish128_sbox1 = `SBOX1_ELEMENT_188;
				8'hBD: blowfish128_sbox1 = `SBOX1_ELEMENT_189;
				8'hBE: blowfish128_sbox1 = `SBOX1_ELEMENT_190;
				8'hBF: blowfish128_sbox1 = `SBOX1_ELEMENT_191;
				8'hC0: blowfish128_sbox1 = `SBOX1_ELEMENT_192;
				8'hC1: blowfish128_sbox1 = `SBOX1_ELEMENT_193;
				8'hC2: blowfish128_sbox1 = `SBOX1_ELEMENT_194;
				8'hC3: blowfish128_sbox1 = `SBOX1_ELEMENT_195;
				8'hC4: blowfish128_sbox1 = `SBOX1_ELEMENT_196;
				8'hC5: blowfish128_sbox1 = `SBOX1_ELEMENT_197;
				8'hC6: blowfish128_sbox1 = `SBOX1_ELEMENT_198;
				8'hC7: blowfish128_sbox1 = `SBOX1_ELEMENT_199;
				8'hC8: blowfish128_sbox1 = `SBOX1_ELEMENT_200;
				8'hC9: blowfish128_sbox1 = `SBOX1_ELEMENT_201;
				8'hCA: blowfish128_sbox1 = `SBOX1_ELEMENT_202;
				8'hCB: blowfish128_sbox1 = `SBOX1_ELEMENT_203;
				8'hCC: blowfish128_sbox1 = `SBOX1_ELEMENT_204;
				8'hCD: blowfish128_sbox1 = `SBOX1_ELEMENT_205;
				8'hCE: blowfish128_sbox1 = `SBOX1_ELEMENT_206;
				8'hCF: blowfish128_sbox1 = `SBOX1_ELEMENT_207;
				8'hD0: blowfish128_sbox1 = `SBOX1_ELEMENT_208;
				8'hD1: blowfish128_sbox1 = `SBOX1_ELEMENT_209;
				8'hD2: blowfish128_sbox1 = `SBOX1_ELEMENT_210;
				8'hD3: blowfish128_sbox1 = `SBOX1_ELEMENT_211;
				8'hD4: blowfish128_sbox1 = `SBOX1_ELEMENT_212;
				8'hD5: blowfish128_sbox1 = `SBOX1_ELEMENT_213;
				8'hD6: blowfish128_sbox1 = `SBOX1_ELEMENT_214;
				8'hD7: blowfish128_sbox1 = `SBOX1_ELEMENT_215;
				8'hD8: blowfish128_sbox1 = `SBOX1_ELEMENT_216;
				8'hD9: blowfish128_sbox1 = `SBOX1_ELEMENT_217;
				8'hDA: blowfish128_sbox1 = `SBOX1_ELEMENT_218;
				8'hDB: blowfish128_sbox1 = `SBOX1_ELEMENT_219;
				8'hDC: blowfish128_sbox1 = `SBOX1_ELEMENT_220;
				8'hDD: blowfish128_sbox1 = `SBOX1_ELEMENT_221;
				8'hDE: blowfish128_sbox1 = `SBOX1_ELEMENT_222;
				8'hDF: blowfish128_sbox1 = `SBOX1_ELEMENT_223;
				8'hE0: blowfish128_sbox1 = `SBOX1_ELEMENT_224;
				8'hE1: blowfish128_sbox1 = `SBOX1_ELEMENT_225;
				8'hE2: blowfish128_sbox1 = `SBOX1_ELEMENT_226;
				8'hE3: blowfish128_sbox1 = `SBOX1_ELEMENT_227;
				8'hE4: blowfish128_sbox1 = `SBOX1_ELEMENT_228;
				8'hE5: blowfish128_sbox1 = `SBOX1_ELEMENT_229;
				8'hE6: blowfish128_sbox1 = `SBOX1_ELEMENT_230;
				8'hE7: blowfish128_sbox1 = `SBOX1_ELEMENT_231;
				8'hE8: blowfish128_sbox1 = `SBOX1_ELEMENT_232;
				8'hE9: blowfish128_sbox1 = `SBOX1_ELEMENT_233;
				8'hEA: blowfish128_sbox1 = `SBOX1_ELEMENT_234;
				8'hEB: blowfish128_sbox1 = `SBOX1_ELEMENT_235;
				8'hEC: blowfish128_sbox1 = `SBOX1_ELEMENT_236;
				8'hED: blowfish128_sbox1 = `SBOX1_ELEMENT_237;
				8'hEE: blowfish128_sbox1 = `SBOX1_ELEMENT_238;
				8'hEF: blowfish128_sbox1 = `SBOX1_ELEMENT_239;
				8'hF0: blowfish128_sbox1 = `SBOX1_ELEMENT_240;
				8'hF1: blowfish128_sbox1 = `SBOX1_ELEMENT_241;
				8'hF2: blowfish128_sbox1 = `SBOX1_ELEMENT_242;
				8'hF3: blowfish128_sbox1 = `SBOX1_ELEMENT_243;
				8'hF4: blowfish128_sbox1 = `SBOX1_ELEMENT_244;
				8'hF5: blowfish128_sbox1 = `SBOX1_ELEMENT_245;
				8'hF6: blowfish128_sbox1 = `SBOX1_ELEMENT_246;
				8'hF7: blowfish128_sbox1 = `SBOX1_ELEMENT_247;
				8'hF8: blowfish128_sbox1 = `SBOX1_ELEMENT_248;
				8'hF9: blowfish128_sbox1 = `SBOX1_ELEMENT_249;
				8'hFA: blowfish128_sbox1 = `SBOX1_ELEMENT_250;
				8'hFB: blowfish128_sbox1 = `SBOX1_ELEMENT_251;
				8'hFC: blowfish128_sbox1 = `SBOX1_ELEMENT_252;
				8'hFD: blowfish128_sbox1 = `SBOX1_ELEMENT_253;
				8'hFE: blowfish128_sbox1 = `SBOX1_ELEMENT_254;
				8'hFF: blowfish128_sbox1 = `SBOX1_ELEMENT_255;
			endcase
		end
	endfunction

	function [31:0] blowfish128_sbox2;
		input [7:0] sbox_in;
		begin
			case(sbox_in[7:0])
				8'h00: blowfish128_sbox2 = `SBOX2_ELEMENT_000;
				8'h01: blowfish128_sbox2 = `SBOX2_ELEMENT_001;
				8'h02: blowfish128_sbox2 = `SBOX2_ELEMENT_002;
				8'h03: blowfish128_sbox2 = `SBOX2_ELEMENT_003;
				8'h04: blowfish128_sbox2 = `SBOX2_ELEMENT_004;
				8'h05: blowfish128_sbox2 = `SBOX2_ELEMENT_005;
				8'h06: blowfish128_sbox2 = `SBOX2_ELEMENT_006;
				8'h07: blowfish128_sbox2 = `SBOX2_ELEMENT_007;
				8'h08: blowfish128_sbox2 = `SBOX2_ELEMENT_008;
				8'h09: blowfish128_sbox2 = `SBOX2_ELEMENT_009;
				8'h0A: blowfish128_sbox2 = `SBOX2_ELEMENT_010;
				8'h0B: blowfish128_sbox2 = `SBOX2_ELEMENT_011;
				8'h0C: blowfish128_sbox2 = `SBOX2_ELEMENT_012;
				8'h0D: blowfish128_sbox2 = `SBOX2_ELEMENT_013;
				8'h0E: blowfish128_sbox2 = `SBOX2_ELEMENT_014;
				8'h0F: blowfish128_sbox2 = `SBOX2_ELEMENT_015;
				8'h10: blowfish128_sbox2 = `SBOX2_ELEMENT_016;
				8'h11: blowfish128_sbox2 = `SBOX2_ELEMENT_017;
				8'h12: blowfish128_sbox2 = `SBOX2_ELEMENT_018;
				8'h13: blowfish128_sbox2 = `SBOX2_ELEMENT_019;
				8'h14: blowfish128_sbox2 = `SBOX2_ELEMENT_020;
				8'h15: blowfish128_sbox2 = `SBOX2_ELEMENT_021;
				8'h16: blowfish128_sbox2 = `SBOX2_ELEMENT_022;
				8'h17: blowfish128_sbox2 = `SBOX2_ELEMENT_023;
				8'h18: blowfish128_sbox2 = `SBOX2_ELEMENT_024;
				8'h19: blowfish128_sbox2 = `SBOX2_ELEMENT_025;
				8'h1A: blowfish128_sbox2 = `SBOX2_ELEMENT_026;
				8'h1B: blowfish128_sbox2 = `SBOX2_ELEMENT_027;
				8'h1C: blowfish128_sbox2 = `SBOX2_ELEMENT_028;
				8'h1D: blowfish128_sbox2 = `SBOX2_ELEMENT_029;
				8'h1E: blowfish128_sbox2 = `SBOX2_ELEMENT_030;
				8'h1F: blowfish128_sbox2 = `SBOX2_ELEMENT_031;
				8'h20: blowfish128_sbox2 = `SBOX2_ELEMENT_032;
				8'h21: blowfish128_sbox2 = `SBOX2_ELEMENT_033;
				8'h22: blowfish128_sbox2 = `SBOX2_ELEMENT_034;
				8'h23: blowfish128_sbox2 = `SBOX2_ELEMENT_035;
				8'h24: blowfish128_sbox2 = `SBOX2_ELEMENT_036;
				8'h25: blowfish128_sbox2 = `SBOX2_ELEMENT_037;
				8'h26: blowfish128_sbox2 = `SBOX2_ELEMENT_038;
				8'h27: blowfish128_sbox2 = `SBOX2_ELEMENT_039;
				8'h28: blowfish128_sbox2 = `SBOX2_ELEMENT_040;
				8'h29: blowfish128_sbox2 = `SBOX2_ELEMENT_041;
				8'h2A: blowfish128_sbox2 = `SBOX2_ELEMENT_042;
				8'h2B: blowfish128_sbox2 = `SBOX2_ELEMENT_043;
				8'h2C: blowfish128_sbox2 = `SBOX2_ELEMENT_044;
				8'h2D: blowfish128_sbox2 = `SBOX2_ELEMENT_045;
				8'h2E: blowfish128_sbox2 = `SBOX2_ELEMENT_046;
				8'h2F: blowfish128_sbox2 = `SBOX2_ELEMENT_047;
				8'h30: blowfish128_sbox2 = `SBOX2_ELEMENT_048;
				8'h31: blowfish128_sbox2 = `SBOX2_ELEMENT_049;
				8'h32: blowfish128_sbox2 = `SBOX2_ELEMENT_050;
				8'h33: blowfish128_sbox2 = `SBOX2_ELEMENT_051;
				8'h34: blowfish128_sbox2 = `SBOX2_ELEMENT_052;
				8'h35: blowfish128_sbox2 = `SBOX2_ELEMENT_053;
				8'h36: blowfish128_sbox2 = `SBOX2_ELEMENT_054;
				8'h37: blowfish128_sbox2 = `SBOX2_ELEMENT_055;
				8'h38: blowfish128_sbox2 = `SBOX2_ELEMENT_056;
				8'h39: blowfish128_sbox2 = `SBOX2_ELEMENT_057;
				8'h3A: blowfish128_sbox2 = `SBOX2_ELEMENT_058;
				8'h3B: blowfish128_sbox2 = `SBOX2_ELEMENT_059;
				8'h3C: blowfish128_sbox2 = `SBOX2_ELEMENT_060;
				8'h3D: blowfish128_sbox2 = `SBOX2_ELEMENT_061;
				8'h3E: blowfish128_sbox2 = `SBOX2_ELEMENT_062;
				8'h3F: blowfish128_sbox2 = `SBOX2_ELEMENT_063;
				8'h40: blowfish128_sbox2 = `SBOX2_ELEMENT_064;
				8'h41: blowfish128_sbox2 = `SBOX2_ELEMENT_065;
				8'h42: blowfish128_sbox2 = `SBOX2_ELEMENT_066;
				8'h43: blowfish128_sbox2 = `SBOX2_ELEMENT_067;
				8'h44: blowfish128_sbox2 = `SBOX2_ELEMENT_068;
				8'h45: blowfish128_sbox2 = `SBOX2_ELEMENT_069;
				8'h46: blowfish128_sbox2 = `SBOX2_ELEMENT_070;
				8'h47: blowfish128_sbox2 = `SBOX2_ELEMENT_071;
				8'h48: blowfish128_sbox2 = `SBOX2_ELEMENT_072;
				8'h49: blowfish128_sbox2 = `SBOX2_ELEMENT_073;
				8'h4A: blowfish128_sbox2 = `SBOX2_ELEMENT_074;
				8'h4B: blowfish128_sbox2 = `SBOX2_ELEMENT_075;
				8'h4C: blowfish128_sbox2 = `SBOX2_ELEMENT_076;
				8'h4D: blowfish128_sbox2 = `SBOX2_ELEMENT_077;
				8'h4E: blowfish128_sbox2 = `SBOX2_ELEMENT_078;
				8'h4F: blowfish128_sbox2 = `SBOX2_ELEMENT_079;
				8'h50: blowfish128_sbox2 = `SBOX2_ELEMENT_080;
				8'h51: blowfish128_sbox2 = `SBOX2_ELEMENT_081;
				8'h52: blowfish128_sbox2 = `SBOX2_ELEMENT_082;
				8'h53: blowfish128_sbox2 = `SBOX2_ELEMENT_083;
				8'h54: blowfish128_sbox2 = `SBOX2_ELEMENT_084;
				8'h55: blowfish128_sbox2 = `SBOX2_ELEMENT_085;
				8'h56: blowfish128_sbox2 = `SBOX2_ELEMENT_086;
				8'h57: blowfish128_sbox2 = `SBOX2_ELEMENT_087;
				8'h58: blowfish128_sbox2 = `SBOX2_ELEMENT_088;
				8'h59: blowfish128_sbox2 = `SBOX2_ELEMENT_089;
				8'h5A: blowfish128_sbox2 = `SBOX2_ELEMENT_090;
				8'h5B: blowfish128_sbox2 = `SBOX2_ELEMENT_091;
				8'h5C: blowfish128_sbox2 = `SBOX2_ELEMENT_092;
				8'h5D: blowfish128_sbox2 = `SBOX2_ELEMENT_093;
				8'h5E: blowfish128_sbox2 = `SBOX2_ELEMENT_094;
				8'h5F: blowfish128_sbox2 = `SBOX2_ELEMENT_095;
				8'h60: blowfish128_sbox2 = `SBOX2_ELEMENT_096;
				8'h61: blowfish128_sbox2 = `SBOX2_ELEMENT_097;
				8'h62: blowfish128_sbox2 = `SBOX2_ELEMENT_098;
				8'h63: blowfish128_sbox2 = `SBOX2_ELEMENT_099;
				8'h64: blowfish128_sbox2 = `SBOX2_ELEMENT_100;
				8'h65: blowfish128_sbox2 = `SBOX2_ELEMENT_101;
				8'h66: blowfish128_sbox2 = `SBOX2_ELEMENT_102;
				8'h67: blowfish128_sbox2 = `SBOX2_ELEMENT_103;
				8'h68: blowfish128_sbox2 = `SBOX2_ELEMENT_104;
				8'h69: blowfish128_sbox2 = `SBOX2_ELEMENT_105;
				8'h6A: blowfish128_sbox2 = `SBOX2_ELEMENT_106;
				8'h6B: blowfish128_sbox2 = `SBOX2_ELEMENT_107;
				8'h6C: blowfish128_sbox2 = `SBOX2_ELEMENT_108;
				8'h6D: blowfish128_sbox2 = `SBOX2_ELEMENT_109;
				8'h6E: blowfish128_sbox2 = `SBOX2_ELEMENT_110;
				8'h6F: blowfish128_sbox2 = `SBOX2_ELEMENT_111;
				8'h70: blowfish128_sbox2 = `SBOX2_ELEMENT_112;
				8'h71: blowfish128_sbox2 = `SBOX2_ELEMENT_113;
				8'h72: blowfish128_sbox2 = `SBOX2_ELEMENT_114;
				8'h73: blowfish128_sbox2 = `SBOX2_ELEMENT_115;
				8'h74: blowfish128_sbox2 = `SBOX2_ELEMENT_116;
				8'h75: blowfish128_sbox2 = `SBOX2_ELEMENT_117;
				8'h76: blowfish128_sbox2 = `SBOX2_ELEMENT_118;
				8'h77: blowfish128_sbox2 = `SBOX2_ELEMENT_119;
				8'h78: blowfish128_sbox2 = `SBOX2_ELEMENT_120;
				8'h79: blowfish128_sbox2 = `SBOX2_ELEMENT_121;
				8'h7A: blowfish128_sbox2 = `SBOX2_ELEMENT_122;
				8'h7B: blowfish128_sbox2 = `SBOX2_ELEMENT_123;
				8'h7C: blowfish128_sbox2 = `SBOX2_ELEMENT_124;
				8'h7D: blowfish128_sbox2 = `SBOX2_ELEMENT_125;
				8'h7E: blowfish128_sbox2 = `SBOX2_ELEMENT_126;
				8'h7F: blowfish128_sbox2 = `SBOX2_ELEMENT_127;
				8'h80: blowfish128_sbox2 = `SBOX2_ELEMENT_128;
				8'h81: blowfish128_sbox2 = `SBOX2_ELEMENT_129;
				8'h82: blowfish128_sbox2 = `SBOX2_ELEMENT_130;
				8'h83: blowfish128_sbox2 = `SBOX2_ELEMENT_131;
				8'h84: blowfish128_sbox2 = `SBOX2_ELEMENT_132;
				8'h85: blowfish128_sbox2 = `SBOX2_ELEMENT_133;
				8'h86: blowfish128_sbox2 = `SBOX2_ELEMENT_134;
				8'h87: blowfish128_sbox2 = `SBOX2_ELEMENT_135;
				8'h88: blowfish128_sbox2 = `SBOX2_ELEMENT_136;
				8'h89: blowfish128_sbox2 = `SBOX2_ELEMENT_137;
				8'h8A: blowfish128_sbox2 = `SBOX2_ELEMENT_138;
				8'h8B: blowfish128_sbox2 = `SBOX2_ELEMENT_139;
				8'h8C: blowfish128_sbox2 = `SBOX2_ELEMENT_140;
				8'h8D: blowfish128_sbox2 = `SBOX2_ELEMENT_141;
				8'h8E: blowfish128_sbox2 = `SBOX2_ELEMENT_142;
				8'h8F: blowfish128_sbox2 = `SBOX2_ELEMENT_143;
				8'h90: blowfish128_sbox2 = `SBOX2_ELEMENT_144;
				8'h91: blowfish128_sbox2 = `SBOX2_ELEMENT_145;
				8'h92: blowfish128_sbox2 = `SBOX2_ELEMENT_146;
				8'h93: blowfish128_sbox2 = `SBOX2_ELEMENT_147;
				8'h94: blowfish128_sbox2 = `SBOX2_ELEMENT_148;
				8'h95: blowfish128_sbox2 = `SBOX2_ELEMENT_149;
				8'h96: blowfish128_sbox2 = `SBOX2_ELEMENT_150;
				8'h97: blowfish128_sbox2 = `SBOX2_ELEMENT_151;
				8'h98: blowfish128_sbox2 = `SBOX2_ELEMENT_152;
				8'h99: blowfish128_sbox2 = `SBOX2_ELEMENT_153;
				8'h9A: blowfish128_sbox2 = `SBOX2_ELEMENT_154;
				8'h9B: blowfish128_sbox2 = `SBOX2_ELEMENT_155;
				8'h9C: blowfish128_sbox2 = `SBOX2_ELEMENT_156;
				8'h9D: blowfish128_sbox2 = `SBOX2_ELEMENT_157;
				8'h9E: blowfish128_sbox2 = `SBOX2_ELEMENT_158;
				8'h9F: blowfish128_sbox2 = `SBOX2_ELEMENT_159;
				8'hA0: blowfish128_sbox2 = `SBOX2_ELEMENT_160;
				8'hA1: blowfish128_sbox2 = `SBOX2_ELEMENT_161;
				8'hA2: blowfish128_sbox2 = `SBOX2_ELEMENT_162;
				8'hA3: blowfish128_sbox2 = `SBOX2_ELEMENT_163;
				8'hA4: blowfish128_sbox2 = `SBOX2_ELEMENT_164;
				8'hA5: blowfish128_sbox2 = `SBOX2_ELEMENT_165;
				8'hA6: blowfish128_sbox2 = `SBOX2_ELEMENT_166;
				8'hA7: blowfish128_sbox2 = `SBOX2_ELEMENT_167;
				8'hA8: blowfish128_sbox2 = `SBOX2_ELEMENT_168;
				8'hA9: blowfish128_sbox2 = `SBOX2_ELEMENT_169;
				8'hAA: blowfish128_sbox2 = `SBOX2_ELEMENT_170;
				8'hAB: blowfish128_sbox2 = `SBOX2_ELEMENT_171;
				8'hAC: blowfish128_sbox2 = `SBOX2_ELEMENT_172;
				8'hAD: blowfish128_sbox2 = `SBOX2_ELEMENT_173;
				8'hAE: blowfish128_sbox2 = `SBOX2_ELEMENT_174;
				8'hAF: blowfish128_sbox2 = `SBOX2_ELEMENT_175;
				8'hB0: blowfish128_sbox2 = `SBOX2_ELEMENT_176;
				8'hB1: blowfish128_sbox2 = `SBOX2_ELEMENT_177;
				8'hB2: blowfish128_sbox2 = `SBOX2_ELEMENT_178;
				8'hB3: blowfish128_sbox2 = `SBOX2_ELEMENT_179;
				8'hB4: blowfish128_sbox2 = `SBOX2_ELEMENT_180;
				8'hB5: blowfish128_sbox2 = `SBOX2_ELEMENT_181;
				8'hB6: blowfish128_sbox2 = `SBOX2_ELEMENT_182;
				8'hB7: blowfish128_sbox2 = `SBOX2_ELEMENT_183;
				8'hB8: blowfish128_sbox2 = `SBOX2_ELEMENT_184;
				8'hB9: blowfish128_sbox2 = `SBOX2_ELEMENT_185;
				8'hBA: blowfish128_sbox2 = `SBOX2_ELEMENT_186;
				8'hBB: blowfish128_sbox2 = `SBOX2_ELEMENT_187;
				8'hBC: blowfish128_sbox2 = `SBOX2_ELEMENT_188;
				8'hBD: blowfish128_sbox2 = `SBOX2_ELEMENT_189;
				8'hBE: blowfish128_sbox2 = `SBOX2_ELEMENT_190;
				8'hBF: blowfish128_sbox2 = `SBOX2_ELEMENT_191;
				8'hC0: blowfish128_sbox2 = `SBOX2_ELEMENT_192;
				8'hC1: blowfish128_sbox2 = `SBOX2_ELEMENT_193;
				8'hC2: blowfish128_sbox2 = `SBOX2_ELEMENT_194;
				8'hC3: blowfish128_sbox2 = `SBOX2_ELEMENT_195;
				8'hC4: blowfish128_sbox2 = `SBOX2_ELEMENT_196;
				8'hC5: blowfish128_sbox2 = `SBOX2_ELEMENT_197;
				8'hC6: blowfish128_sbox2 = `SBOX2_ELEMENT_198;
				8'hC7: blowfish128_sbox2 = `SBOX2_ELEMENT_199;
				8'hC8: blowfish128_sbox2 = `SBOX2_ELEMENT_200;
				8'hC9: blowfish128_sbox2 = `SBOX2_ELEMENT_201;
				8'hCA: blowfish128_sbox2 = `SBOX2_ELEMENT_202;
				8'hCB: blowfish128_sbox2 = `SBOX2_ELEMENT_203;
				8'hCC: blowfish128_sbox2 = `SBOX2_ELEMENT_204;
				8'hCD: blowfish128_sbox2 = `SBOX2_ELEMENT_205;
				8'hCE: blowfish128_sbox2 = `SBOX2_ELEMENT_206;
				8'hCF: blowfish128_sbox2 = `SBOX2_ELEMENT_207;
				8'hD0: blowfish128_sbox2 = `SBOX2_ELEMENT_208;
				8'hD1: blowfish128_sbox2 = `SBOX2_ELEMENT_209;
				8'hD2: blowfish128_sbox2 = `SBOX2_ELEMENT_210;
				8'hD3: blowfish128_sbox2 = `SBOX2_ELEMENT_211;
				8'hD4: blowfish128_sbox2 = `SBOX2_ELEMENT_212;
				8'hD5: blowfish128_sbox2 = `SBOX2_ELEMENT_213;
				8'hD6: blowfish128_sbox2 = `SBOX2_ELEMENT_214;
				8'hD7: blowfish128_sbox2 = `SBOX2_ELEMENT_215;
				8'hD8: blowfish128_sbox2 = `SBOX2_ELEMENT_216;
				8'hD9: blowfish128_sbox2 = `SBOX2_ELEMENT_217;
				8'hDA: blowfish128_sbox2 = `SBOX2_ELEMENT_218;
				8'hDB: blowfish128_sbox2 = `SBOX2_ELEMENT_219;
				8'hDC: blowfish128_sbox2 = `SBOX2_ELEMENT_220;
				8'hDD: blowfish128_sbox2 = `SBOX2_ELEMENT_221;
				8'hDE: blowfish128_sbox2 = `SBOX2_ELEMENT_222;
				8'hDF: blowfish128_sbox2 = `SBOX2_ELEMENT_223;
				8'hE0: blowfish128_sbox2 = `SBOX2_ELEMENT_224;
				8'hE1: blowfish128_sbox2 = `SBOX2_ELEMENT_225;
				8'hE2: blowfish128_sbox2 = `SBOX2_ELEMENT_226;
				8'hE3: blowfish128_sbox2 = `SBOX2_ELEMENT_227;
				8'hE4: blowfish128_sbox2 = `SBOX2_ELEMENT_228;
				8'hE5: blowfish128_sbox2 = `SBOX2_ELEMENT_229;
				8'hE6: blowfish128_sbox2 = `SBOX2_ELEMENT_230;
				8'hE7: blowfish128_sbox2 = `SBOX2_ELEMENT_231;
				8'hE8: blowfish128_sbox2 = `SBOX2_ELEMENT_232;
				8'hE9: blowfish128_sbox2 = `SBOX2_ELEMENT_233;
				8'hEA: blowfish128_sbox2 = `SBOX2_ELEMENT_234;
				8'hEB: blowfish128_sbox2 = `SBOX2_ELEMENT_235;
				8'hEC: blowfish128_sbox2 = `SBOX2_ELEMENT_236;
				8'hED: blowfish128_sbox2 = `SBOX2_ELEMENT_237;
				8'hEE: blowfish128_sbox2 = `SBOX2_ELEMENT_238;
				8'hEF: blowfish128_sbox2 = `SBOX2_ELEMENT_239;
				8'hF0: blowfish128_sbox2 = `SBOX2_ELEMENT_240;
				8'hF1: blowfish128_sbox2 = `SBOX2_ELEMENT_241;
				8'hF2: blowfish128_sbox2 = `SBOX2_ELEMENT_242;
				8'hF3: blowfish128_sbox2 = `SBOX2_ELEMENT_243;
				8'hF4: blowfish128_sbox2 = `SBOX2_ELEMENT_244;
				8'hF5: blowfish128_sbox2 = `SBOX2_ELEMENT_245;
				8'hF6: blowfish128_sbox2 = `SBOX2_ELEMENT_246;
				8'hF7: blowfish128_sbox2 = `SBOX2_ELEMENT_247;
				8'hF8: blowfish128_sbox2 = `SBOX2_ELEMENT_248;
				8'hF9: blowfish128_sbox2 = `SBOX2_ELEMENT_249;
				8'hFA: blowfish128_sbox2 = `SBOX2_ELEMENT_250;
				8'hFB: blowfish128_sbox2 = `SBOX2_ELEMENT_251;
				8'hFC: blowfish128_sbox2 = `SBOX2_ELEMENT_252;
				8'hFD: blowfish128_sbox2 = `SBOX2_ELEMENT_253;
				8'hFE: blowfish128_sbox2 = `SBOX2_ELEMENT_254;
				8'hFF: blowfish128_sbox2 = `SBOX2_ELEMENT_255;
			endcase
		end
	endfunction

	wire [127:0] SBox1, SBox2;
	wire [31:0] S1a, S1b, S1c, S1d, S2e, S2f, S2g, S2h;
	reg [31:0] res1H, res1L, res2H, res2L, res3H, res3L;
	reg valid_stage1, valid_stage2, valid_stage3;

	parameter [1:0] IDLE  = 2'b00;
	parameter [1:0] XOR_F = 2'b01;
	parameter [1:0] ADD   = 2'b10;
	parameter [1:0] XOR_S = 2'b11;

	reg [1:0] state;
	
	//State transition
	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
			state <= IDLE;
		end else begin
			case(state)
				IDLE: 	state <= XOR_F;
				XOR_F: 	state <= ADD;
				ADD: 	state <= XOR_S;
				XOR_S: 	state <= XOR_S;
			endcase
		end
	end

	//Substitution and Rotation
	assign SBox1[127:96] = blowfish128_sbox1(X[63:56]);
	assign SBox1[95:64]  = blowfish128_sbox1({X[48], X[55:49]});
	assign SBox1[63:32]  = blowfish128_sbox1(X[47:40]);
	assign SBox1[31:0]   = blowfish128_sbox1({X[32], X[39:33]});
	assign SBox2[127:96] = blowfish128_sbox2({X[24], X[31:25]});
	assign SBox2[95:64]  = blowfish128_sbox2(X[23:16]);
	assign SBox2[63:32]  = blowfish128_sbox2({X[8], X[15:9]});
	assign SBox2[31:0]   = blowfish128_sbox2(X[7:0]);


	assign S1a = {SBox1[96], SBox1[127:97]};
	assign S1b = SBox1[95:64];
	assign S1c = {SBox1[32], SBox1[63:33]};
	assign S1d = SBox1[31:0];
	assign S2e = SBox2[127:96];
	assign S2f = {SBox2[94:64], SBox2[95]};
	assign S2g = SBox2[63:32];
	assign S2h = {SBox2[30:0], SBox2[31]};
	
	always @(posedge Clk or negedge RstN or negedge Enable) begin
		if(!RstN | !Enable) begin
			//XOR-FIRST STEP
			res1H <= 32'b0;
			res1L <= 32'b0;
			valid_stage1 <= 1'b0;
			//ADD STEP
			res2H <= 32'b0;
			res2L <= 32'b0;
			valid_stage2 = 1'b0;
			//XOR-SECOND STEP
			res3H <= 32'b0;
			res3L <= 32'b0;
			valid_stage3 <= 1'b0;
		end else begin
			case(state)
				//XOR-first step
				XOR_F: begin
					if(Enable) begin
						res1H <= S1a ^ S1b;
						res1L <= S2e ^ S2f;
						valid_stage1 <= 1'b1;
					end
				end
				//ADD step
				ADD: begin
					if(Enable & valid_stage1) begin
						res2H <= res1H + S1c;
						res2L <= res1L + S2g;
						valid_stage2 <= 1'b1;
					end
				end
				//XOR-second step
				XOR_S: begin
					if(Enable & valid_stage2) begin
						res3H <= res2H ^ S1d;
						res3L <= res2L ^ S2h;
						valid_stage3 <= 1'b1;
					end
				end
			endcase
		end
	end

	assign outputValid = valid_stage3;
	assign Y = {res3H, res3L};

endmodule
