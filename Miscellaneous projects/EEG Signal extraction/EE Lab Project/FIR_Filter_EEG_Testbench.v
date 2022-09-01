// FIR filter EEG Testbench



module FIR_Filter_tb(
    );
    reg [11:0] A0_tb;
    reg [11:0] A1_tb;
    reg [11:0] A2_tb;
    reg [11:0] A3_tb;
    reg [11:0] A4_tb;
    reg [11:0] A5_tb;
    reg [11:0] A6_tb;
    reg [11:0] A7_tb;
    reg [11:0] A8_tb;
    reg [11:0] A9_tb;
    reg [11:0] A10_tb;
    reg [11:0] A11_tb;
    reg [11:0] A12_tb;
    reg [11:0] A13_tb;
    reg [11:0] A14_tb;
    reg [11:0] A15_tb;
    reg [11:0] A16_tb;
    reg [11:0] A17_tb;
    reg [11:0] A18_tb;
    reg [11:0] A19_tb;
    reg [11:0] A20_tb;
    reg [11:0] A21_tb;
    reg [11:0] A22_tb;
    reg [11:0] A23_tb;
    reg [11:0] A24_tb;
    reg [11:0] A25_tb;
    reg [11:0] A26_tb;
    reg [11:0] A27_tb;
    reg [11:0] A28_tb;
    reg [11:0] A29_tb;
    reg [11:0] A30_tb;
    reg [11:0] A31_tb;
    
     wire[28:0] B0_tb;
     wire[28:0] B1_tb;
     wire[28:0] B2_tb;
     wire[28:0] B3_tb;
     wire[28:0] B4_tb;
     wire[28:0] B5_tb;
     wire[28:0] B6_tb;
     wire[28:0] B7_tb;
     wire[28:0] B8_tb;
     wire[28:0] B9_tb;
     wire[28:0] B10_tb;
     wire[28:0] B11_tb;
     wire[28:0] B12_tb;
     wire[28:0] B13_tb;
     wire[28:0] B14_tb;
     wire[28:0] B15_tb;
     wire[28:0] B16_tb;
     wire[28:0] B17_tb;
     wire[28:0] B18_tb;
     wire[28:0] B19_tb;
     wire[28:0] B20_tb;
     wire[28:0] B21_tb;
     wire[28:0] B22_tb;
     wire[28:0] B23_tb;
     wire[28:0] B24_tb;
     wire[28:0] B25_tb;
     wire[28:0] B26_tb;
     wire[28:0] B27_tb;
     wire[28:0] B28_tb;
     wire[28:0] B29_tb;
     wire[28:0] B30_tb;
     wire[28:0] B31_tb;
    
        
    reg clk_tb;
    reg reset_tb;
FIR_Filter uut ( .A0(A0_tb), .A1(A1_tb),.A2(A2_tb),.A3(A3_tb),.A4(A4_tb),.A5(A5_tb),.A6(A6_tb),.A7(A7_tb),.A8(A8_tb),.A9(A9_tb),.A10(A10_tb),.A11(A11_tb), .A12(A12_tb),.A13(A13_tb), .A14(A14_tb),.A15(A15_tb),.A16(A16_tb),.A17(A17_tb),.A18(A18_tb),.A19(A19_tb),.A20(A20_tb),.A21(A21_tb),.A22(A22_tb),.A23(A23_tb),.A24(A24_tb),.A25(A25_tb),.A26(A26_tb),.A27(A27_tb),.A28(A28_tb),.A29(A29_tb),.A30(A30_tb),.A31(A31_tb),.B0(B0_tb), .B1(B1_tb),.B2(B2_tb),.B3(B3_tb),.B4(B4_tb),.B5(B5_tb),.B6(B6_tb),.B7(B7_tb),.B8(B8_tb),.B9(B9_tb),.B10(B10_tb),.B11(B11_tb), .B12(B12_tb),.B13(B13_tb), .B14(B14_tb),.B15(B15_tb),.B16(B16_tb),.B17(B17_tb),.B18(B18_tb),.B19(B19_tb),.B20(B20_tb),.B21(B21_tb),.B22(B22_tb),.B23(B23_tb),.B24(B24_tb),.B25(B25_tb),.B26(B26_tb),.B27(B27_tb),.B28(B28_tb),.B29(B29_tb),.B30(B30_tb),.B31(B31_tb),.clk(clk_tb),.reset(reset_tb) );
    
always
    begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end

initial 
begin
 #3  reset_tb =1'b1;
     A0_tb = 12'b110011110011;
     A1_tb = 12'b110100001100;
     A2_tb = 12'b110111111010;
     A3_tb = 12'b111110000011;
     A4_tb = 12'b010000000001;
     A5_tb = 12'b001111101110;
     A6_tb = 12'b111011001000;
     A7_tb = 12'b110110011100;
     A8_tb = 12'b111100101100;
     A9_tb = 12'b001001000101;
     A10_tb =12'b001111010101;
     A11_tb =12'b000100001100;
     A12_tb =12'b110100011111;
     A13_tb =12'b101110001000;
     A14_tb =12'b101111101100;
     A15_tb =12'b111000000110;
     A16_tb =12'b110001100011;
     A17_tb =12'b110000000110;
     A18_tb =12'b110011111001;
     A19_tb =12'b110011000111;
     A20_tb =12'b111011100111;
     A21_tb =12'b111100111111;
     A22_tb =12'b000010011100;
     A23_tb =12'b000001000100;
     A24_tb =12'b000101011110;
     A25_tb =12'b000111111010;
     A26_tb =12'b110101010111;
     A27_tb =12'b100100110000;
     A28_tb =12'b100000010010;
     A29_tb =12'b100011001100;
     A30_tb =12'b111001000101; 
     A31_tb =12'b000111100001;
     
# 3 reset_tb =1'b0; 
 #500
 $stop;   
 end
endmodule


