
`timescale 1ns / 1ps
 
module alu_tb;

 
logic [32:0] tb_input1;
logic [32:0] tb_input2;
logic [3:0]  tb_opcode;
logic [32:0] tb_result;
 

 
alu DUT (
    .input1(tb_input1),
    .input2(tb_input2),
    .opcode(tb_opcode),
    .result(tb_result)
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


 
task automatic check_op(input logic [32:0] a, input logic [32:0] b, input logic [3:0] op,
                         input string op_name);
    logic [32:0] expected;
 
    tb_input1 = a;
    tb_input2 = b;
    tb_opcode = op;
    #1;
 
    case (op)
        ADD: expected = a + b;
        SUB: expected = a - b;
        AND: expected = a & bl
        OR:  expected = a | b;
        XOR: expected = a ^ b;
        NOT: expected = ~b;      
        SLL: expected = a << 1;
        SRL: expected = a >> 1;
        SLT: expected = a < b;     
        EQ:  expected = a = b;      
        default: expected = 33'h00000000;
    endcase
 
    if (tb_result === expected)
        $display("PASS: %-4s  a=%0d b=%0d  result=%0d", op_name, a, b, tb_result);
    else
        $display("FAIL: %-4s  a=%0d b=%0d  expected=%0d got=%0d", op_name, a, b, expected, tb_result);
endtask

 
initial begin
    check_op(32'd10, 32'd20, ADD, "ADD");
    check_op(32'd20, 32'd10, SUB, "SUB");
    check_op(32'd10, 32'd20, SUB, "SUB");
    check_op(32'd20, 32'd10, AND, "AND");
    check_op(32'd20, 32'd10, OR, "OR");
    check_op(32'd20, 32'd20, OR, "OR");
    check_op(32'd10, 32'd20, OR, "OR");
    check_op(32'd20,         NOT, "NOT");
    check_op(32'd10,         SLL, "SLL");
    check_op(32'd10,         SRL, "SRL");
    check_op(32'd20, 32'd10, SLT, "SLT");
    check_op(32'd20, 32'd10, EQ, "EQ");
    check_op(32'd20, 32'd20, EQ, "EQ");

    $finish;
end
 
endmodule
 