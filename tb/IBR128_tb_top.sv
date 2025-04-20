`timescale 1ns/1ps

import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "./../rtl/IBR128_wrapper.sv"

module IBR128_tb_top;

	//Add an enum signal of base_item.trns_type 
	//To display it on waveform

	//Interface
	IBR128_if vif();
	IBR128_wrapper dut(
			.Clk(vif.Clk),
			.RstN(vif.RstN),
			.CS(vif.CS),
			.Write(vif.Write),
			.Read(vif.Read),
			.Addr(vif.Addr),
			.WData(vif.WData),
			.RData(vif.RData)
	);
		
	initial begin

		string test_name;

		uvm_config_db#(virtual IBR128_if)::set(null, "*", "vif", vif);	

		if ($value$plusargs("UVM_TESTNAME=%s", test_name)) begin
			// Create a filename based on the test name
			$display("[TB_TOP] Running test: %s", test_name);
			$dumpfile({test_name, ".vcd"});
			$dumpvars(0, IBR128_tb_top);
		end
		else begin
			// Default case if no test name is provided
			test_name = "base_test";
			$display("[TB_TOP] Running default test: %s", test_name);
			$dumpfile({test_name, ".vcd"});
			$dumpvars(0, IBR128_tb_top);
		end

		run_test(test_name);
		run_test();

	end

	initial begin
		vif.Clk <= 1'b1;
		forever #10 vif.Clk <= !vif.Clk;
	end

endmodule
