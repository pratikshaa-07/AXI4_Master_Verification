class driver extends uvm_driver #(seq_item);
  `uvm_component_utils(driver)

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
    bit stream[$];
    int total_bits;
    int num_beats;
    bit [127:0] beat;
    int idx;

    vif.drv_cb.wr_en<=req.wr_en;
    vif.drv_cb.rd_en<=req.rd_en;
    
    if(req.wr_en)
      begin
        //making a stream
        get_stream(req);
        write_task();
        @(vif.drv_cb);
      end

    if(req.rd_en)
      begin
        read_task();
        @(vif.drv_cb);
      end

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
      
    endtask
//{SOP (8 bits) + TXN_ID (4 bits) + ADDR (32 bits) + LEN (4 bits) + SIZE (3 bits) + BURST (2 bits) + LOCK (2 bits) + CACHE (2 bits) + PROT (3 bits) + STROBE (4 bits) + DATA (8 bits) + EOP (8 bits)}
    task read_task();
      vif.drv_cb.rd_data<={req.sop,req.tx_id,req.addr,req.len,req.size,req.size,req.burst,req.lock,req.cache,req.prot,req.strobe,req.data,req.eop};
    endtask

endclass
