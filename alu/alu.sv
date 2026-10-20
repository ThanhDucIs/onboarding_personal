
module alu (
    input logic [31:0] input1, input2,
    input logic [3:0] opcode,
    output logic [31:0] result

);

localparam ADD = 4'h0;
localparam SUB = 4'h1;
localparam AND = 4'h2;
localparam OR  = 4'h3;
localparam XOR = 4'h4;
localparam NOT = 4'h5;
localparam SLL = 4'h6;
localparam SRL = 4'h7;
localparam SLT = 4'h8;
localparam EQ  = 4'h9;



always_comb begin
    case(opcode)
        ADD: result = input1 + input2; 
        SUB: result = input1 - input2; 
        AND: result = input1 & input2;
        OR:  result = input1 | input2; 
        XOR: result = input1 ^ input2;
        NOT: result = ~input2;
        SLL: result = input1 << 1;
        SRL: result = input1 >> 1;               
        SLT: result = input1 < input2;
        EQ:  result = input1 == input2;  
        default: result = 32'h00000000;
    endcase
end
endmodule 
