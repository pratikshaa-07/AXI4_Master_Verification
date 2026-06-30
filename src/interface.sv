`include "define.sv"
`include "uvm_macros.svh"

interface inf(input bit clk, input bit rst);

  //write fifo signals
  bit wr_en;
  bit [127:0] wr_data;
  bit full;

  //read fifo signals
  bit rd_en;
  bit [127:0] rd_data;
  bit empty;

  //driver clocking block
  clocking drv_cb@(posedge clk);
    default input #0 output #0;
    input rd_data,empty,full;
    output wr_en,wr_data,rd_en;
  endclocking

  // monitor clocking block
  clocking mon_cb@(posedge clk);
    default input #0 output #0;
    input rd_data,empty,full;
    output wr_en,wr_data,rd_en;
  endclocking

  //modpoerts for driver and monitor
  modport DRV(clocking drv_cb,input rst);
  modport MON(clocking mon_cb, input rst);
  
endinterface
