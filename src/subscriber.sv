
class subscriber extends uvm_component;

  `uvm_component_utils(subscriber)

  uvm_tlm_analysis_fifo #(seq_item) in_mon;
  uvm_tlm_analysis_fifo #(seq_item) op_mon;
  seq_item tr,tx;

  real cov_report;

  covergroup fifo_cg;

    WR_EN : coverpoint tr.wr_en {
      bins wr_en[] = {0,1};
    }

    RD_EN : coverpoint tr.rd_en {
      bins rd_en[] = {0,1};
    }

    FULL : coverpoint tr.full {
      bins full[] = {0,1};
    }

    EMPTY : coverpoint tr.empty {
      bins empty[] = {0,1};
    }

    WR_DATA : coverpoint tr.wr_data {
      bins low  = {[0:32'h7FFF_FFFF]};
      bins high = default;
    }

    RD_DATA : coverpoint tr.rd_data {
      bins low  = {[0:32'h7FFF_FFFF]};
      bins high = default;
    }

    cross WR_EN, FULL {
      bins fifo_full = binsof(WR_EN) intersect {1} &&
                       binsof(FULL)  intersect {1};
    }

    cross RD_EN, EMPTY {
      bins fifo_empty = binsof(RD_EN) intersect {1} &&
                        binsof(EMPTY) intersect {1};
    }

    cross WR_EN, RD_EN;

  endgroup

  function new(string name="", uvm_component parent);
    super.new(name,parent);
    in_mon = new("in_mon", this);
    op_mon = new("op_mon", this);
    fifo_cg = new();
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);

    forever 
      begin
        fork
          in_mon.get(tr);
          op_mon.get(tx);
        join
      fifo_cg.sample();
    end
  endtask

  virtual function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov_report = fifo_cg.get_coverage();
  endfunction

  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("FIFO_COVERAGE",$sformatf("FIFO Functional Coverage = %0.2f%%",cov_report),
              UVM_LOW)
  endfunction

endclass
