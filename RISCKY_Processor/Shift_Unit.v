module shift_unit(in, func_field, shift_bits, out);  //func_field: function field, shift_bits: No" of bits to be shifted

	input [15:0] in;
	input [3:0] func_field;
	input [3:0] shift_bits;
	output reg[15:0] out;
	reg[3:0] i;
	reg [15:0] dummy;  //dummy register
	
	always @(*)
	begin
	dummy[15:0]=in;
	case(func_field)  //deciding on type of shifting based on function field
		4'b0001: begin                                                   //Left logical shift
				for(i=0; i<shift_bits; i=i+4'b0001)
				begin
				dummy={dummy,1'b0};
				end
			out<=dummy;
			end			
		
		4'b0010: begin                                                   //Right logical shift
				//out={shift_bits, 1'b0, in};
				/*for(j=0; j<shift_bits; j=j+4'b0001)
				//begin
				//dummy=dummy/(2'b10);   //divide right shifts the operand
				dummy={1'b0,dummy};
				//out={0,in[15-shift_bits:0]};
				//end
			out<=dummy;*/
				case(shift_bits) //since shifting operation as basically hard wired approach, this was followed, case statement can be excecuted using a MUX
					
					4'b0001: out={1'h0,in[15:1]};
					4'b0010: out={2'h0,in[15:2]};
					4'b0011: out={3'h0,in[15:3]};
					4'b0100: out={4'h0,in[15:4]};
					4'b0101: out={5'h00,in[15:5]};
					4'b0110: out={6'h00,in[15:6]};
					4'b0111: out={7'h00,in[15:7]};
					4'b1000: out={8'h00,in[15:8]};
					4'b1001: out={9'h000,in[15:9]};
					4'b1010: out={10'h000,in[15:10]};
					4'b1011: out={11'h000,in[15:11]};
					4'b1100: out={12'h000,in[15:12]};
					4'b1101: out={13'h0000,in[15:13]};
					4'b1110: out={14'h0000,in[15:14]};
					4'b1111: out={15'h0000,in[15]};
					default: out=in;
			endcase

			end

		4'b0011: begin                                                  //Right Arithmetic Shift (Preserving MSB and thus Sign)
				/*for (k=0; k<shift_bits; k=k+4'b0001)
				begin
				dummy={in[15],dummy};
				end
			out<=dummy;*/
				case(shift_bits) //since shifting operation as basically hard wired approach, this was followed, case statement can be excecuted using a MUX

					4'b0001: out={in[15],in[15:1]};
					4'b0010: out={in[15],in[15],in[15:2]};
					4'b0011: out={in[15],in[15],in[15],in[15:3]};
					4'b0100: out={in[15],in[15],in[15],in[15],in[15:4]};
					4'b0101: out={in[15],in[15],in[15],in[15],in[15],in[15:5]};
					4'b0110: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15:6]};
					4'b0111: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15:7]};
					4'b1000: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15:8]};
					4'b1001: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15:9]};
					4'b1010: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15:10]};
					4'b1011: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15:11]};
					4'b1100: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15:12]};
					4'b1101: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15:13]};
					4'b1110: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15:14]};
					4'b1111: out={in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15],in[15]};
					default: out=in;
			endcase
			end

		default: out=in;
	endcase
	end
endmodule
		
/*module shift_unit_tb();
	reg[15:0] in_tb;
	reg[3:0] func_field_tb;
	reg[3:0] shift_bits_tb;
	wire[15:0] out_tb;

shift_unit uut(.in(in_tb), .shift_bits(shift_bits_tb), .func_field(func_field_tb), .out(out_tb));

initial
begin
	in_tb=16'b1000100101110100;
	func_field_tb=4'b0011;
	shift_bits_tb=4'b0001;
	#5 shift_bits_tb=4'b0010;
	
	//#5 func_field_tb=4'b0010;
	#5shift_bits_tb=4'b0011;
	
	//#5 func_field_tb=4'b0011;
	#5shift_bits_tb=4'b0100;
end
endmodule

*/		
