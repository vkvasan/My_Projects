
//This file deals with the inputs to MUX_ALUinB. i.e. all the shifting and sign-extending sort of operations.
//This is not the file for Shifting Operations. A seperate module is created for that sake

module sign_extend_12bits(in,out);  //sign extending a 12-bit number. Used for Jump Instruction
	input [15:0] in;
	output reg[15:0] out;
	
	always@(*)
	begin
		out={{4{in[11]}},in[11:0]};  //out={in[11],in[11],in[11],in[11],in[11:0]};
	end
endmodule

/*module sign_extend_12bits_tb();
	reg[15:0] in_tb;
	wire[15:0] out_tb;

sign_extend_12bits uut(.in(in_tb), .out(out_tb));

initial
begin
	in_tb=16'h56a2;
	#5 in_tb= 16'h1234;
	#5 in_tb= 16'h975a;
end
endmodule
*/
module zeros_extend(in,out);   //Zeros extend module. Used for some of the immediate R-type instructions
input [7:0] in;
	output reg[15:0] out;
	
	always@(*)
	begin
		out={8'h00,in[7:0]};
	end
endmodule
/*
module zeros_extend_tb();
	reg[15:0] in_tb;
	wire[15:0] out_tb;

zeros_extend uut(.in(in_tb), .out(out_tb));

initial
begin
	in_tb=16'h56a2;
	#5 in_tb= 16'h1234;
	#5 in_tb= 16'h975a;
end
endmodule
*/
module sign_extend_8bits(in,out);   //Sign extending 8-bit number
	input [7:0] in;
	output reg[15:0] out;
	
	always@(*)
	begin
		out={{8{in[7]}},in[7:0]};		   //out={in[7],in[7],in[7],in[7],in[7],in[7],in[7],in[7],in[7:0]};
	end
endmodule
/*
module sign_extend_8bits_tb();
	reg[15:0] in_tb;
	wire[15:0] out_tb;

sign_extend_8bits uut(.in(in_tb), .out(out_tb));

initial
begin
	in_tb=16'h56a2;
	#5 in_tb= 16'h1234;
	#5 in_tb= 16'h975a;
end
endmodule
*/

module pad0_sign_extend(in,out); //Though this and normal left shift and sign-extend are one and the same, due to initial confusion, this module was made and thus continued for the sake of proper functioning of processor
	input [15:0] in;
	output reg [15:0] out;
	
	always@(*)
	begin
		out={{7{in[7]}},in[7:0],1'b0};  //out={in[7],in[7],in[7],in[7],in[7],in[7],in[7],in[7:0],1'b0};
	end
endmodule
/*
module pad0_sign_extend_tb();
	reg[15:0] in_tb;
	wire[15:0] out_tb;

pad0_sign_extend uut(.in(in_tb), .out(out_tb));

initial
begin
	in_tb=16'h56a2;
	#5 in_tb= 16'h1234;
	#5 in_tb= 16'h975a;
end
endmodule
*/

module left_shift_sign_extend(in,out);  //used for load/store instructions
	input [15:0] in;
	output reg[15:0] out;
	
	
	always@(*)
	begin
		out={{7{in[7]}},in[7:0],1'b0};  //out={in[7],in[7],in[7],in[7],in[7],in[7],in[7],in[7:0],1'b0};
		
	end
endmodule
/*
module left_shift_sign_extend_tb();
	reg[15:0] in_tb;
	wire[15:0] out_tb;
left_shift_sign_extend uut(.in(in_tb), .out(out_tb));
	
initial
begin
	in_tb=16'h56a2;
	#5 in_tb= 16'h1234;
	#5 in_tb= 16'h975a;
end
endmodule
*/
module append_10(in,out);  //Appending 2'b10 to MSB to Rp field in load/store instructions 
	input [15:0] in;
	output reg[3:0] out;
 	
	always@(*)
	begin
	out={2'b10,in[9:8]};
	end
endmodule

/*
module append_10_tb();
	reg[15:0] in_tb;
	wire[3:0] out_tb;

append_10 uut(.in(in_tb), .out(out_tb));
initial
begin
	in_tb=16'h56a2;
	#5 in_tb= 16'h1234;
	#5 in_tb= 16'h975a;
end
endmodule
*/

module append_11(in,out);  //Appending 2'b11 to MSB to Rd field in load/store instructions 
	input [15:0] in;
	output reg[3:0] out;
 	
	always@(*)
	begin
	out={2'b11,in[11:10]};
	end
endmodule

/*
module append_11_tb();
	reg[15:0] in_tb;
	wire[3:0] out_tb;

append_11 uut(.in(in_tb), .out(out_tb));
initial
begin
	in_tb=16'h56a2;
	#5 in_tb= 16'h1234;
	#5 in_tb= 16'h975a;
end
endmodule
*/




