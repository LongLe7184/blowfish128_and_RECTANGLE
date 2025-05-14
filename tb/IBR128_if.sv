import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

interface IBR128_if;
	logic Clk;
	logic RstN;
	logic CS;
	logic Write;
	logic Read;
	logic [4:0] Addr;
	logic [31:0] WData;
	logic [31:0] RData;

	transtype trans_type_debug;
endinterface
