// UART transmitter — 8-N-1 (8 data bits, no parity, 1 stop bit)
//
// CLK_FREQ_HZ / BAUD_RATE sets how many clk cycles make up one bit period.
// For simulation these get overridden to small values so tests don't take
// forever (e.g. CLK_FREQ_HZ=1000, BAUD_RATE=100 -> 10 clks/bit) — don't
// hardcode CLKS_PER_BIT yourself, compute it from the parameters.
//
// What to do:
//   The IDLE state is done for you as a worked example. Follow the same
//   pattern to fill in START, DATA, and STOP below.
//
// Done when:
//   - tx idles high and tx_busy is low until tx_start is pulsed
//   - a full frame is: 1 start bit (low) -> 8 data bits, LSB first ->
//     1 stop bit (high), each held for exactly CLKS_PER_BIT cycles
//   - tx_busy stays high for the whole frame and drops after the stop bit

module uart_tx #(
    parameter int CLK_FREQ_HZ = 50_000_000,
    parameter int BAUD_RATE   = 115_200
) (
    input  logic       clk,
    input  logic       rst_n,

    input  logic       tx_start,   // pulse high for 1 cycle to begin sending tx_data
    input  logic [7:0] tx_data,

    output logic       tx,         // serial line; idles high
    output logic       tx_busy     // high while a frame is in flight
);

    localparam int CLKS_PER_BIT = CLK_FREQ_HZ / BAUD_RATE;

    typedef enum logic [1:0] {
        IDLE,
        START,
        DATA,
        STOP
    } state_t;

    state_t state;
    logic [$clog2(CLKS_PER_BIT)-1:0] clk_count;
    logic [2:0] bit_index;
    logic [7:0] data_reg;
    logic       tx_reg;

    assign tx      = tx_reg;
    assign tx_busy = (state != IDLE);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state     <= IDLE;
            clk_count <= '0;
            bit_index <= '0;
            data_reg  <= '0;
            tx_reg    <= 1'b1; // idle high
        end else begin
            case (state)

                // --- worked example -------------------------------------
                // Sits at logic 1 until tx_start pulses, then latches the
                // byte to send and moves on to the start bit.
                IDLE: begin
                    tx_reg    <= 1'b1;
                    clk_count <= '0;
                    bit_index <= '0;
                    if (tx_start) begin
                        data_reg <= tx_data;
                        state    <= START;
                    end
                end

                // --- TODO: START -----------------------------------------
                // Drive tx low for one full bit period (CLKS_PER_BIT
                // cycles using clk_count), then move to DATA.
                START: begin

                end

                // --- TODO: DATA ------------------------------------------
                // Drive tx from data_reg, one bit at a time, LSB first
                // (data_reg[bit_index]). Hold each bit for CLKS_PER_BIT
                // cycles. After bit_index reaches 7, move to STOP.
                DATA: begin

                end

                // --- TODO: STOP ------------------------------------------
                // Drive tx high (the stop bit) for one full bit period,
                // then return to IDLE.
                STOP: begin

                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule