class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)

  //
    bit stream[$];

  virtual inf.DRV vif;

  function new(string name="", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual inf)::get(this, "", "vif", vif))
      `uvm_fatal("DRIVER", "Virtual Interface not set")
  endfunction

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat (3) @(vif.drv_cb);

    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask

  task drive();
    vif.drv_cb.wr_en<=req.wr_en;
    vif.drv_cb.rd_en<=req.rd_en;

    fork
      if(req.wr_en)
      begin
        //making a stream
        get_stream(req);
        write_task();
        @(vif.drv_cb);
      end

     if(req.rd_en)
      begin
        `uvm_info("DRV","rd_en is high",UVM_LOW)
        @(vif.drv_cb);
      end
      
    join

    if(req.rd_en == 0 && req.wr_en == 0)
      begin
        `uvm_info("DRV","Both rd_en and wr_en signals are low",UVM_LOW)
        @(vif.drv_cb);
      end
  endtask

  function void get_stream(seq_item tx);
    bit temp[$];
    stream = {};

    temp = {>>{tx.sop}};      stream = {stream,temp};

    temp = {>>{tx.txn_id}};   stream = {stream,temp};

    temp = {>>{tx.addr}};     stream = {stream,temp};

    temp = {>>{tx.len}};      stream = {stream,temp};

    temp = {>>{tx.size}};     stream = {stream,temp};

    temp = {>>{tx.burst}};    stream = {stream,temp};

    temp = {>>{tx.lock}};     stream = {stream,temp};

    temp = {>>{tx.cache}};    stream = {stream,temp};

    temp = {>>{tx.prot}};     stream = {stream,temp};

    foreach (tx.strobe[i])
      stream.push_back(tx.strobe[i]);

    foreach (tx.data[i])
    begin
      temp = {>>{tx.data[i]}};
      stream = {stream,temp};
    end

    temp = {>>{tx.eop}};
    stream = {stream,temp};
  endfunction

  task write_task();
    int total_bits;
    int num_beats;
    bit [127:0] beat;
    int idx;
    
    total_bits = stream.size();
    num_beats  = (total_bits + 127) / 128;
    idx = 0;

  for (int b = 0; b < num_beats; b++) 
    begin
    // while (vif.drv_cb.full == 1'b1)
    //   @(vif.drv_cb);
      beat = '0;
      for (int k = 127; k >= 0; k--) 
        begin
          if (idx < total_bits)
            beat[k] = stream[idx];
          idx++;
        end
    vif.drv_cb.wr_data <= beat;
    @(vif.drv_cb);
  end

endtask


endclass
