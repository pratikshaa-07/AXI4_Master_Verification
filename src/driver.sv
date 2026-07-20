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

    // build the exact bit stream for this packet, MSB-first per field
    stream = get_stream(req);
    
    total_bits = stream.size();
    num_beats  = (total_bits + 127) / 128;
    idx        = 0;

    `uvm_info("DRV", $sformatf("Driving packet: total_bits=%0d, num_beats=%0d", total_bits, num_beats), UVM_HIGH)

    for (int b = 0; b < num_beats; b++) begin
      // wait until fifo has space
      while (vif.full == 1'b1)
        @(vif.drv_cb);

      beat = '0;
      for (int k = 127; k >= 0; k--) begin
        if (idx < total_bits)
          beat[k] = stream[idx++];
        // else: remaining bits stay 0 (padding on last beat)
      end

      vif.drv_cb.wr_data <= beat;
      vif.drv_cb.wr_en   <= 1'b1;
      @(vif.drv_cb);

      `uvm_info("DRV", $sformatf("Beat %0d/%0d driven: %0h", b, num_beats-1, beat), UVM_DEBUG)
    end

    vif.drv_cb.wr_en <= 1'b0;
  endtask
    
  function void get_stream[$](seq_item tx);
    bit temp[$];
    get_stream = {};
    temp={};
    temp = {>>{tx.sop}};
    stream = {stream, temp};
    temp={};
    temp ={>>{tx.txn_id}};
    stream = {temp,stream};
    stream = {stream, {>>{txn_id}}};
  stream = {stream, {>>{addr}}};
  stream = {stream, {>>{len}}};
  stream = {stream, {>>{size}}};
  stream = {stream, {>>{burst}}};
  stream = {stream, {>>{lock}}};
  stream = {stream, {>>{cache}}};
  stream = {stream, {>>{prot}}};
  foreach (strobe[i])
    stream = {stream, strobe[i]};
  foreach (data[i])
    stream = {stream, {<<{data[i]}}};
  stream = {stream, {<<{eop}}};
endfunction
    
endclass
