import IBR128_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "./../rtl/IBR128_wrapper.sv"

module IBR128_tb_top;

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
		uvm_config_db#(virtual IBR128_if)::set(null, "*", "vif", vif);	
		run_test("IBR128_base_test");
	end

	initial begin
		vif.Clk <= 1'b1;
		forever #10 vif.Clk <= !vif.Clk;
	end

	initial begin
		$dumpvars(1);
		$dumpfile("dump.vcd");
	end

endmodule
