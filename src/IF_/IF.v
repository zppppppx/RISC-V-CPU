`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:  zju
// Engineer: qmj
//////////////////////////////////////////////////////////////////////////////////
module IF(clk, reset, Branch, Jump, IFWrite, JumpAddr, Instruction_if, PC, IF_flush);
    input clk;
    input reset;
    input Branch;
    input Jump;
    input IFWrite;
    input [31:0] JumpAddr;
    output [31:0] Instruction_if;
    output [31:0] PC;
    output IF_flush;

    //PC
    wire [31:0] PC_in;
    PC PC_inst(.PC_in(PC_in), .clk(clk), .reset(reset), .en(IFWrite), .PC_out(PC));

    //IF_flush
    assign IF_flush=Jump||Branch;

    //PC_adder
    wire [31:0] NextPC_if;
    adder_32bits adder_inst(.a(PC), .b(32'd4), .ci(32'b0), .s(NextPC_if), .co());

    //PC_in
    assign PC_in=(IF_flush)?JumpAddr:NextPC_if;

    //InstructionROM
    wire[5:0] addr_in;
    assign addr_in=PC[5:0]>>2;
    //InstructionROM ROM_inst(.addr(PC[5:0]), .dout(Instruction_if));
    InstructionROM ROM_inst(.addr(addr_in), .dout(Instruction_if));
    
endmodule
