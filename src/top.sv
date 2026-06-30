`include "uvm_macros.svh"
`include "inf.sv"

module top();
 import uvm_pkg::*;

 bit clk=0;
 
 always#5 clk=~clk;
  
  initial begin
    rst = 0;
    #20;
    rst = 1;
end

  inf vif(clk,rst);

initial begin
 uvm_config_db#(virtual inf)::set(uvm_root::get(),"*","vif",vif);
  
end

  initial begin
    run_test("test");
    #1000 $finish;
  end
  
endmodule
