
//had PC been a register, the simultaneous change of input and clk would have given the wrong output, hence the latch first, register next.

module PC_latch(input [15:0] PCin,input PCwritefinal,input reset,output reg [15:0] PCout1);  
always @(PCwritefinal,reset,PCin) begin
    if(reset == 1'b1) PCout1 = 16'd0;
    else if(PCwritefinal == 1'b1) PCout1 = PCin;
end
endmodule

module PC_reg(input clk,input [15:0] PCout1,output reg [15:0] PCout2);
always @(posedge clk) begin
    PCout2 = PCout1;
end
endmodule
 

module Instruction_memory(
    input [15:0] PCout2,
    output [15:0] Instruction
    );
    
    reg [7:0] storage [0:65535];  //64kB of Instruction Memory
    
    initial begin
        $readmemh("/home/v/Documents/FPGA/OurProcessorRISCKY/InstructionMemory.dat",storage);   //initializing storage from InstructionMemory.dat, written in a way that register bank will self populate  
    end
    
    assign Instruction[15:0] = {storage[PCout2 + 1],storage[PCout2] };  //reading instruction from appropriate address of storage
    
endmodule

module IR(
    input [15:0] Instruction,
    input IR_write,
    output [3:0] out_15_12,
    output [3:0] out_11_8,
    output [3:0] out_7_4,
    output [3:0] out_3_0
    );
    
    reg [15:0] Instruction_reg;
    
    always@(IR_write) begin  //Same reason as PC to define IR as a latch(more like a combinational circuit), with IR_write as enable.
    if(IR_write == 1'b1)
        Instruction_reg = Instruction ;
    end

    assign out_15_12 = Instruction_reg[15:12];
    assign out_11_8 = Instruction_reg[11:8];
    assign out_7_4 = Instruction_reg[7:4];
    assign out_3_0 = Instruction_reg[3:0];
    
    
endmodule
  
  
/*module main_tb();

reg rst_tb;
reg clk_tb;
reg PCwritefinal;
reg IRwrite;
wire [3:0] out_15_12_tb;
wire [3:0] out_11_8_tb;
wire[3:0] out_7_4_tb;
wire [3:0] out_3_0_tb;

IF_circuit md( clk_tb ,rst_tb ,PCwritefinal, IRwrite, out_15_12_tb , out_11_8_tb , out_7_4_tb , out_3_0_tb );


initial 
clk_tb = 1'b0;

always
begin
#5 clk_tb =~ clk_tb;
end

initial begin
    $dumpfile("IF_test.vcd");
    $dumpvars(0,main_tb);
    rst_tb = 1'b1;PCwritefinal = 1'b0; IRwrite = 1'b0;
    #2 rst_tb = 1'b0;
    #3 PCwritefinal = 1'b1; IRwrite = 1'b1;
    #5 PCwritefinal = 1'b0; IRwrite = 1'b0;
    #10 $finish;
end
endmodule     
    */

