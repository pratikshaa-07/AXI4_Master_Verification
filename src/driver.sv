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

    bit [127:0] fifo_word;
    byte unsigned pkt_q[$];
    int idx;

    pkt_q.push_back(req.sop);
    pkt_q.push_back({4'b0,req.txn_id});

    pkt_q.push_back(req.addr[31:24]);
    pkt_q.push_back(req.addr[23:16]);
    pkt_q.push_back(req.addr[15:8]);
    pkt_q.push_back(req.addr[7:0]);

    pkt_q.push_back({4'b0,req.len});
    pkt_q.push_back({5'b0,req.size});
    pkt_q.push_back({6'b0,req.burst});
    pkt_q.push_back({6'b0,req.lock});
    pkt_q.push_back({6'b0,req.cache});
    pkt_q.push_back({5'b0,req.prot});

    foreach(req.strobe[k])
      pkt_q.push_back({7'b0,req.strobe[k]});

    foreach(req.data[k])
      pkt_q.push_back(req.data[k]);

    pkt_q.push_back(req.eop);

    idx = 0;

    while(idx < pkt_q.size()) begin

      fifo_word = '0;

      for(int j=0;j<16;j++) begin
        if(idx < pkt_q.size()) begin
          fifo_word[(15-j)*8 +: 8] = pkt_q[idx];
          idx++;
        end
      end

      @(vif.drv_cb);
      wait(vif.drv_cb.full == 0);
      
      vif.drv_cb.wr_en   <= 1'b1;
      vif.drv_cb.wr_data <= fifo_word;

      @(vif.drv_cb);

      vif.drv_cb.wr_en <= 1'b0;
      vif.drv_cb.wr_data <= '0;

    end

  endtask

endclass
