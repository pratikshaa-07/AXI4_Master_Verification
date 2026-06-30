class seq_item extends uvm_sequence_item;
  
  //write data
  rand  bit [7:0]   sop;
  randc bit [3:0]   txn_id;
  rand bit  [31:0]  addr;
  rand bit  [3:0]   len;
  rand bit  [2:0]   size;
  rand bit  [1:0]   burst;
  rand bit  [1:0]   lock;
  rand bit  [1:0]   cache;
  rand bit  [2:0]   prot;
  rand bit  [3:0]   strobe;
  rand bit  [7:0]   eop;
  rand bit  [7:0]   data[];
  
  function new(string name="");
    super.new(name="");
  endfunction
  
  `uvm_object_utils_begin(seq_item)
  
  
endclass
