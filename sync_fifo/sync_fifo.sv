module sync_fifo #(
  parameter DEPTH  = 8,    // number of slots
  parameter DWIDTH = 16    // bits per word
) (
  input  logic clk,
  input  logic rst_n,    // active-low reset
  input  logic wr_en,
  input  logic rd_en,
  input  logic [DWIDTH-1:0] din,
  output logic [DWIDTH-1:0] dout,
  output logic empty,
  output logic full
);
 
    // Storage: DEPTH words, each DWIDTH bits wide
    logic [DWIDTH-1:0] fifo [DEPTH];
 
    // Pointers into the storage array.
    // wptr = where the next write goes, rptr = where the next read comes from
    logic [$clog2(DEPTH)-1:0] wptr, rptr;
 

    // Write logic

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            wptr <= '0;
        end else begin
            // TODO: if wr_en is high and the FIFO is not full,
            // store din at fifo[wptr] and increment wptr
        end
    end

    // Read logic

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            rptr <= '0;
            dout <= '0;
        end else begin
        // TODO: if rd_en is high and the FIFO is not empty,
        //       put fifo[rptr] on dout and increment rptr
        end
    end

  // Status flags
  // TODO: empty is 1 when the two pointers are equal
  // TODO: full is 1 when the NEXT write would make the pointers equal
  // (hint: compare wptr + 1'b1 with rptr. Use 1'b1, not 1 — a plain 1 is 32 bits wide, so the sum won't wrap back to 0 like the pointer does)
 
endmodule