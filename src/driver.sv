// class driver extends uvm_driver#(seq_item);
//   `uvm_component_utils(driver);

//   //virtual interface
//   virtual inf.DRV vif;
  
//   // to track the sequence count
//   int i;
//   function new(string name="",uvm_component parent);
//     super.new(name,parent);
//     i=0;
//   endfunction

//   function void build_phase(uvm_phase);
//     super.build_phase(phase);
//     if(!(uvm_config_db#(virtual inf)::get(this,"","vif",vif)))
//       `uvm_fatal("DRIVER","Virtual inteface not set");
//   endfunction
  
//   task run_phase(uvm_phase phase);
//     super.run_phase(phase);
//     repeat(3)@(vif.drv_cb);
//     forever
//       begin
//         seq_item_port.get_next_item(req);
//         drive();
//         seq_item_port.item_done();
//       end
//   endtask

//   task drive();
//   endtask
// endclass

class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)
  bit[127:0] fifo_data;
  int total_bits;
  bit packed_bits;
  
  virtual inf.DRV vif;
  int i;

  function new(string name="", uvm_component parent);
    super.new(name,parent);
    i = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual inf)::get(this,"","vif",vif))
      `uvm_fatal("DRIVER","Virtual Interface not set")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);

    repeat(3) @(vif.drv_cb);

    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

    task drive();
      total_bis=req.pack(packed_bits);

      //driving
      for(int j=0;j<128;j++)
        begin
          
        end
    endtask

endclass
