class seq_item extends uvm_sequence_item;
  
  //write phase signals
  rand  bit [7:0]   sop;
  randc bit [3:0]   txn_id;
  rand bit  [31:0]  waddr;
  rand bit  [3:0]   len;
  rand bit  [2:0]   size;
  rand bit  [1:0]   burst;
  rand bit  [1:0]   lock;
  rand bit  [1:0]   cache;
  rand bit  [2:0]   prot;
  rand bit  [127:0] strobe;
  rand bit  [7:0]   eop;
  
  rand bit  [7:0]   wrdata[];
  bit  wr_en;
  bit full;
  
  //read phase signals
  bit [7:0] rd_data[];
  bit rd_en;
  bit empty;
  
  function new(string name="");
    super.new(name="");
  endfunction
  
  `uvm_object_utils_begin(seq_item)
  `uvm_field_int(sop,UVM_ALL_ON)
  `uvm_field_int(txn_id,UVM_ALL_ON)
  `uvm_field_int(waddr,UVM_ALL_ON)
  `uvm_field_int(len,UVM_ALL_ON)
  `uvm_field_int(size,UVM_ALL_ON)
  `uvm_field_int(burst,UVM_ALL_ON)
  `uvm_field_int(lock,UVM_ALL_ON)
  `uvm_field_int(cache,UVM_ALL_ON)
  `uvm_field_int(prot,UVM_ALL_ON)
  `uvm_field_int(strobe,UVM_ALL_ON)
  `uvm_field_int(eop,UVM_ALL_ON)
  `uvm_field_int(wrdata,UVM_ALL_ON)
  `uvm_field_int(wr_en,UVM_ALL_ON)
  `uvm_field_int(full,UVM_ALL_ON)
  
  `uvm_field_int(rd_data,UVM_ALL_ON)
  `uvm_field_int(rd_en,UVM_ALL_ON)
  `uvm_field_int(empty,UVM_ALL_ON)
  
  `uvm_object_utils_end

  //basic constraints 

  constraint burst_size {
    size inside {};
  }
  
endclass
