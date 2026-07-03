class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uvm_tlm_analysis_fifo#(seq_item) active_fifo;
  uvm_tlm_analysis_fifo#(seq_item) passive_fifo;
  
  function new(string name="",uvm_componet parent);
    super.new(name,parent);
    active_fifo=new("active_fifo");
    passive_fifo=new("passive_fifo");
  endfunction

  task run_phase(uvm_phase phase);
    forever
      begin
        fork
          begin
            active_fifo.get(req);
          end
          begin
            passive_fifo.get(resp);
          end
        join
      end
  endtask

  task 
  task compare();
  endtask
endclass
