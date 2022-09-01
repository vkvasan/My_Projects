
//All the required multiplexers are coded in this module
//for more information, kindly look into architecture of the processor

module mux_8to1_ALU_in2(in0,in1,in2,in3,in4,in5,out,ALU_srcB);  //multiplexer module feeding ALUinB

input [15:0] in0,in1,in2,in3,in4,in5;
input [2:0] ALU_srcB;
output reg[15:0] out;

	always@(*)
	begin
		case(ALU_srcB)  //Deciding the output of mux based on Control Signal generated
		
			3'b000: out=in0;
			3'b001: out=in1;
			3'b010: out=in2;
			3'b011: out=in3;
			3'b100: out=in4;
			3'b101: out=in5;
			3'b110: out=16'h0002;
			default: out=16'hzzzz;  //Default
		endcase
	end
endmodule

/*module mux_8to1_ALU_in2_tb();

reg[15:0] in0_tb, in1_tb, in2_tb, in3_tb, in4_tb, in5_tb;
reg[2:0] ALU_srcB_tb;
wire[15:0] out_tb;

mux_8to1_ALU_in2 uut(.in0(in0_tb), .in1(in1_tb), .in2(in2_tb), .in3(in3_tb), .in4(in4_tb), .in5(in5_tb), .ALU_srcB(ALU_srcB_tb), .out(out_tb));

initial 
begin
	in0_tb=16'h1532;
	in1_tb=16'h2643;
	in2_tb=16'h3754;
	in3_tb=16'h95a2;
	in4_tb=16'h74b1;
	in5_tb=16'h1234;
	
	ALU_srcB_tb=3'b000;
	#5 ALU_srcB_tb=3'b001;
	#5 ALU_srcB_tb=3'b010;
	#5 ALU_srcB_tb=3'b011;
	#5 ALU_srcB_tb=3'b100;
	#5 ALU_srcB_tb=3'b101;
	#5 ALU_srcB_tb=3'b110;
	#5 ALU_srcB_tb=3'b111;
end
endmodule*/



module mux_4to1_ALU_in1(in0,in1,in2,in3,ALU_srcA,out);  //multiplexer module feeding ALUinB
	
input [15:0] in0, in1, in2, in3;
input [1:0] ALU_srcA;
output reg[15:0] out;

	always@(*)
	begin
		case(ALU_srcA)  //Deciding the output of mux based on Control Signal generated
			
			2'b00: out=in0;
			2'b01: out=in1;
			2'b10: out=in2;
			2'b11: out=in3;
			
			default: out=16'hzzzz;  //default
		endcase
	end
endmodule

/*module mux_4to1_ALU_in1_tb();

	reg[15:0] in0_tb, in1_tb, in2_tb, in3_tb;
	reg[1:0] ALU_srcA_tb;
	wire[15:0] out_tb;

mux_4to1_ALU_in1 uut(.in0(in0_tb), .in1(in1_tb), .in2(in2_tb), .in3(in3_tb), .ALU_srcA(ALU_srcA_tb), .out(out_tb));

initial 
begin
	in0_tb=16'h1532;
	in1_tb=16'h2643;
	in2_tb=16'h3754;
	in3_tb=16'h95a2;
	
	ALU_srcA_tb=2'b00;
	#5 ALU_srcA_tb=2'b01;
	#5 ALU_srcA_tb=2'b10;
	#5 ALU_srcA_tb=2'b11;
	#5 ALU_srcA_tb=2'bzz;
end
endmodule
*/

module shift_mux(in0,in1,shift,out);  //shift signal decides whether data written into ALUOut comes from Shifting Unit or ALU

	input[15:0] in0, in1;
	input shift;
	output reg[15:0] out;

	always@(*)
	begin
		out=shift?in1:in0;
	end
endmodule

/*module shift_mux_tb();
	
	reg[15:0] in0_tb, in1_tb;
	reg shift_tb;
	wire[15:0] out_tb;

shift_mux uut(.in0(in0_tb), .in1(in1_tb), .shift(shift_tb), .out(out_tb));

initial
begin
	in0_tb=16'hf5a1;
	in1_tb=16'h54c3;

	shift_tb=1'b0;
	#10 shift_tb=1'b1;
end
endmodule
*/

module mux_reg_dst(in0,in1,reg_dst,out); //deciding the destination register 

input [3:0] in0, in1;
input reg_dst;
output reg[3:0] out;

	always@(*)
	begin
		out=reg_dst?in1:in0;
	end
endmodule

/*module mux_reg_dst_tb();
	
	reg[3:0] in0_tb, in1_tb;
	reg reg_dst_tb;
	wire[3:0] out_tb;

mux_reg_dst uut(.in0(in0_tb), .in1(in1_tb), .reg_dst(reg_dst_tb), .out(out_tb));

initial
begin
	in0_tb=4'b1101;
	in1_tb=4'b0111;

	reg_dst_tb=1'b0;
	#10 reg_dst_tb=1'b1;
end
endmodule
*/

module memtoreg_mux(in0,in1,memtoreg,out);  //deciding the data written into destination register (either ALU or MDR) 

	input[15:0] in0, in1;
	input memtoreg;
	output reg[15:0] out;

	always@(*)
	begin
		out=memtoreg?in1:in0;
	end
endmodule

/*module memtoreg_mux_tb();
	
	reg[15:0] in0_tb, in1_tb;
	reg memtoreg_tb;
	wire[15:0] out_tb;

memtoreg_mux uut(.in0(in0_tb), .in1(in1_tb), .memtoreg(memtoreg_tb), .out(out_tb));

initial
begin
	in0_tb=16'hf5a1;
	in1_tb=16'h54c3;

	memtoreg_tb=1'b0;
	#10 memtoreg_tb=1'b1;
end
endmodule
*/

module mux_PC_src(in0,in1,in2,PC_src,out);  //deciding the data to be written into PC
	
input [15:0] in0, in1, in2;
input [1:0] PC_src;
output reg[15:0] out;

	always@(*)
	begin
		case(PC_src)
			
			2'b00: out=in0;
			2'b01: out=in1;
			2'b10: out=in2;
			2'b11: out=16'h0000;
			
			default: out=16'h0000;
		endcase
	end
endmodule

/*module mux_PC_src_tb();

	reg[15:0] in0_tb, in1_tb, in2_tb;
	reg[1:0] PC_src_tb;
	wire[15:0] out_tb;

mux_PC_src uut(.in0(in0_tb), .in1(in1_tb), .in2(in2_tb), .PC_src(PC_src_tb), .out(out_tb));

initial 
begin
	in0_tb=16'h1532;
	in1_tb=16'h2643;
	in2_tb=16'h3754;
	
	PC_src_tb=2'b00;
	#5 PC_src_tb=2'b01;
	#5 PC_src_tb=2'b10;
	#5 PC_src_tb=2'b11;
	#5 PC_src_tb=2'bzz;
end
endmodule*/

