module ALU_16bit(in1, in2, ALU_op, out, zero_flag);
	input [15:0] in1;
	input [15:0] in2;
	input [1:0] ALU_op;
	output reg [15:0] out;
	output reg zero_flag;
	
	always @(*)
	begin
	case(ALU_op)  //Deciding the operation performed by ALU based on ALUop (Covers ADD, SUB, NAND, OR)
		
		2'b00: out= in1+in2;  

		2'b01: begin
			out= in1-in2;
			zero_flag= (in1==in2)?1'b1:1'b0;
			end

		2'b10: out= ((~in1)|(~in2));
			
		2'b11: out= (in1|in2);

		default: out=16'h0000;
	endcase
	end
endmodule

module ALU_Out(output reg [15:0] out,input [15:0] in,input ALUoutwrite);  //Again, same reason as PC, IR
always @(ALUoutwrite,in) begin
	if(ALUoutwrite == 1'b1)
	out = in;
end
endmodule

/*module ALU_16bit_tb();
	reg[15:0] in1_tb, in2_tb, ALU_op_tb;
	wire[15:0] out_tb;
	wire cry_out_tb, zero_flag_tb;
	
ALU_16bit uut (.in1(in1_tb), .in2(in2_tb), .ALU_op(ALU_op_tb), .out(out_tb), .cry_out(cry_out_tb), .zero_flag(zero_flag_tb));

	initial
	begin
		in1_tb= 16'd1528;
		in2_tb= 16'd7352;
		ALU_op_tb=2'b00;
		#5 ALU_op_tb= 2'b01;
		#5 ALU_op_tb= 2'b10;
		#5 ALU_op_tb= 2'b11;
	end
endmodule
*/
	
			
		
		
		
		

