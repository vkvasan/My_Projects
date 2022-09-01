// FIR Filter for EEG Signal


module FIR_Filter(
    input clk,
    input reset,
    input [11:0] A0,
    input [11:0] A1,
    input [11:0] A2,
    input [11:0] A3,
    input [11:0] A4,
    input [11:0] A5,
    input [11:0] A6,
    input [11:0] A7,
    input [11:0] A8,
    input [11:0] A9,
    input [11:0] A10,
    input [11:0] A11,
    input [11:0] A12,
    input [11:0] A13,
    input [11:0] A14,
    input [11:0] A15,
    input [11:0] A16,
    input [11:0] A17,
    input [11:0] A18,
    input [11:0] A19,
    input [11:0] A20,
    input [11:0] A21,
    input [11:0] A22,
    input [11:0] A23,
    input [11:0] A24,
    input [11:0] A25,
    input [11:0] A26,
    input [11:0] A27,
    input [11:0] A28,
    input [11:0] A29,
    input [11:0] A30,
    input [11:0] A31,
    output reg [28:0] B0,
    output reg[28:0] B1,
    output reg[28:0] B2,
    output reg[28:0] B3,
    output reg[28:0] B4,
    output reg[28:0] B5,
    output reg[28:0] B6,
    output reg[28:0] B7,
    output reg[28:0] B8,
    output reg[28:0] B9,
    output reg[28:0] B10,
    output reg[28:0] B11,
    output reg[28:0] B12,
    output reg[28:0] B13,
    output reg[28:0] B14,
    output reg[28:0] B15,
    output reg[28:0] B16,
    output reg[28:0] B17,
    output reg[28:0] B18,
    output reg[28:0] B19,
    output reg[28:0] B20,
    output reg[28:0] B21,
    output reg[28:0] B22,
    output reg[28:0] B23,
    output reg[28:0] B24,
    output reg[28:0] B25,
    output reg[28:0] B26,
    output reg[28:0] B27,
    output reg[28:0] B28,
    output reg[28:0] B29,
    output reg[28:0] B30,
    output reg[28:0] B31
    );
  
  parameter b0= 12'b111111111011;                           // Coefficients 
  parameter b1= 12'b111111100010;
  parameter b2= 12'b111110101010;
  parameter b3= 12'b111101101001;
  parameter b4= 12'b111101100011;
  parameter b5= 12'b111111010111;  
  parameter b6= 12'b000000101101;
  parameter b7= 12'b000110010100;
  parameter b8= 12'b000011111001;
  parameter b9= 12'b000110010100;
  parameter b10= 12'b000000101101;
  parameter b11= 12'b111111010111;
  parameter b12= 12'b111101100011;
  parameter b13= 12'b111101101001;
  parameter b14= 12'b111110101010;  
  parameter b15= 12'b111111100010;
  parameter b16= 12'b111111111011;
  
  


  reg [23:0]Tempreg0;
  reg [23:0]Tempreg1;
  reg [23:0]Tempreg2;
  reg [23:0]Tempreg3;
  reg [23:0]Tempreg4;
  reg [23:0]Tempreg5;
  reg [23:0]Tempreg6;
  reg [23:0]Tempreg7;
  reg [23:0]Tempreg8;
  reg [23:0]Tempreg9;
  reg [23:0]Tempreg10;
  reg [23:0]Tempreg11;
  reg [23:0]Tempreg12;
  reg [23:0]Tempreg13;
  reg [23:0]Tempreg14;
  reg [23:0]Tempreg15;
  reg [23:0]Tempreg16;
  
  
    reg [11:0] A0_reg;
    reg [11:0] A1_reg;
    reg [11:0] A2_reg;
    reg [11:0] A3_reg;
    reg [11:0] A4_reg;
    reg [11:0] A5_reg;
    reg [11:0] A6_reg;
    reg [11:0] A7_reg;
    reg [11:0] A8_reg;
    reg [11:0] A9_reg;
    reg [11:0] A10_reg;
    reg [11:0] A11_reg;
    reg [11:0] A12_reg;
    reg [11:0] A13_reg;
    reg [11:0] A14_reg;
    reg [11:0] A15_reg;  
    reg [11:0] A16_reg;
    reg [11:0] A17_reg;
    reg [11:0] A18_reg;
    reg [11:0] A19_reg;
    reg [11:0] A20_reg;
    reg [11:0] A21_reg;
    reg [11:0] A22_reg;
    reg [11:0] A23_reg;
    reg [11:0] A24_reg;
    reg [11:0] A25_reg;
    reg [11:0] A26_reg;
    reg [11:0] A27_reg;
    reg [11:0] A28_reg;
    reg [11:0] A29_reg;
    reg [11:0] A30_reg;
    reg [11:0] A31_reg;
    reg [11:0] A32_reg;
    reg [11:0] A33_reg;
    reg [11:0] A34_reg;
    reg [11:0] A35_reg;
    reg [11:0] A36_reg;
    reg [11:0] A37_reg;
    reg [11:0] A38_reg;
    reg [11:0] A39_reg;
    reg [11:0] A40_reg;
    reg [11:0] A41_reg;
    reg [11:0] A42_reg;
    reg [11:0] A43_reg;
    reg [11:0] A44_reg;
    reg [11:0] A45_reg;
    reg [11:0] A46_reg;
    reg [11:0] A47_reg;
  

  
  
  reg [5:0]count;
  
  always@(posedge clk)
  begin
  if(reset)   
  begin
      count <= 6'b000000;
      A0_reg <= 0;
      A1_reg <= 0;
      A2_reg <= 0;
      A3_reg <= 0;
      A4_reg <= 0;
      A5_reg <= 0;
      A6_reg <= 0;
      A7_reg <= 0;
      A8_reg <= 0;
      A9_reg <= 0;
      A10_reg <= 0;
      A11_reg <= 0;
      A12_reg <= 0;
      A13_reg <= 0;
      A14_reg <= 0;
      A15_reg <= 0;
      A16_reg <= A0;
      A17_reg <= A1;
      A18_reg <= A2;
      A19_reg <= A3;
      A20_reg <= A4;
      A21_reg <= A5;
      A22_reg <= A6;
      A23_reg <= A7;
      A24_reg <= A8;
      A25_reg <= A9;
      A26_reg <= A10;
      A27_reg <= A11;
      A28_reg <= A12;
      A29_reg <= A13;
      A30_reg <= A14;
      A31_reg <= A15;
      A32_reg <= A16;
      A33_reg <= A17;
      A34_reg <= A18;
      A35_reg <= A19;
      A36_reg <= A20;
      A37_reg <= A21;
      A38_reg <= A22;
      A39_reg <= A23;
      A40_reg <= A24;
      A41_reg <= A25;
      A42_reg <= A26;
      A43_reg <= A27;
      A44_reg <= A28;
      A45_reg <= A29;
      A46_reg <= A30;
      A47_reg <= A31;
  end
  else if ( count >= 6'b0000000 & count <= 6'd31 )
  begin
    case(count) 
    6'b000000: 
    begin
        Tempreg0 = A16_reg * b0;
        Tempreg1 = A15_reg * b1;
        Tempreg2 = A14_reg * b2;
        Tempreg3 = A13_reg * b3;
        Tempreg4 = A12_reg * b4;
        Tempreg5 = A11_reg * b5;
        Tempreg6 = A10_reg * b6;
        Tempreg7 = A9_reg * b7;
        Tempreg8 = A8_reg * b8;
        Tempreg9 = A7_reg * b9;
        Tempreg10 = A6_reg * b10;
        Tempreg11 = A5_reg * b11;
        Tempreg12 = A4_reg * b12;
        Tempreg13 = A3_reg * b13;
        Tempreg14 = A2_reg * b14;
        Tempreg15 = A1_reg * b15;
        Tempreg16 = A0_reg * b16;
        count = count +1;
       
    B0 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    end
    
    6'b000001:
    begin
        Tempreg0 = A17_reg * b0;
        Tempreg1 = A16_reg * b1;
        Tempreg2 = A15_reg * b2;
        Tempreg3 = A14_reg * b3;
        Tempreg4 = A13_reg * b4;
        Tempreg5 = A12_reg * b5;
        Tempreg6 = A11_reg * b6;
        Tempreg7 = A10_reg * b7;
        Tempreg8 = A9_reg * b8;
        Tempreg9 = A8_reg * b9;
        Tempreg10 = A7_reg * b10;
        Tempreg11 = A6_reg * b11;
        Tempreg12 = A5_reg * b12;
        Tempreg13 = A4_reg * b13;
        Tempreg14 = A3_reg * b14;
        Tempreg15 = A2_reg * b15;
        Tempreg16 = A1_reg * b16;        
        count = count +1;
    
    B1 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    
  end
  
  6'b000010:
    begin
        Tempreg0 = A18_reg * b0;
        Tempreg1 = A17_reg * b1;
        Tempreg2 = A16_reg * b2;
        Tempreg3 = A15_reg * b3;
        Tempreg4 = A14_reg * b4;
        Tempreg5 = A13_reg * b5;
        Tempreg6 = A12_reg * b6;
        Tempreg7 = A11_reg * b7;
        Tempreg8 = A10_reg * b8;
        Tempreg9 = A9_reg * b9;
        Tempreg10 = A8_reg * b10;
        Tempreg11 = A7_reg * b11;
        Tempreg12 = A6_reg * b12;
        Tempreg13 = A5_reg * b13;
        Tempreg14 = A4_reg * b14;
        Tempreg15 = A3_reg * b15;
        Tempreg16 = A2_reg * b16;        
        count = count +1;
    
    B2 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
  end
  6'b000011:
    begin
        Tempreg0 = A19_reg * b0;
        Tempreg1 = A18_reg * b1;
        Tempreg2 = A17_reg * b2;
        Tempreg3 = A16_reg * b3;
        Tempreg4 = A15_reg * b4;
        Tempreg5 = A14_reg * b5;
        Tempreg6 = A13_reg * b6;
        Tempreg7 = A12_reg * b7;
        Tempreg8 = A11_reg * b8;
        Tempreg9 = A10_reg * b9;
        Tempreg10 = A9_reg * b10;
        Tempreg11 = A8_reg * b11;
        Tempreg12 = A7_reg * b12;
        Tempreg13 = A6_reg * b13;
        Tempreg14 = A5_reg * b14;
        Tempreg15 = A4_reg * b15;
        Tempreg16 = A3_reg * b16;        
        count = count +1;
    
    B3 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   
   end
   
   6'b000100:
    begin
        Tempreg0 = A20_reg * b0;
        Tempreg1 = A19_reg * b1;
        Tempreg2 = A18_reg * b2;
        Tempreg3 = A17_reg * b3;
        Tempreg4 = A16_reg * b4;
        Tempreg5 = A15_reg * b5;
        Tempreg6 = A14_reg * b6;
        Tempreg7 = A13_reg * b7;
        Tempreg8 = A12_reg * b8;
        Tempreg9 = A11_reg * b9;
        Tempreg10 = A10_reg * b10;
        Tempreg11 = A9_reg * b11;
        Tempreg12 = A8_reg * b12;
        Tempreg13 = A7_reg * b13;
        Tempreg14 = A6_reg * b14;
        Tempreg15 = A5_reg * b15;
        Tempreg16 = A4_reg * b16;        
        count = count +1;
    
    B4 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
   
   6'b000101:
    begin
        Tempreg0 = A21_reg * b0;
        Tempreg1 = A20_reg * b1;
        Tempreg2 = A19_reg * b2;
        Tempreg3 = A18_reg * b3;
        Tempreg4 = A17_reg * b4;
        Tempreg5 = A16_reg * b5;
        Tempreg6 = A15_reg * b6;
        Tempreg7 = A14_reg * b7;
        Tempreg8 = A13_reg * b8;
        Tempreg9 = A12_reg * b9;
        Tempreg10 = A11_reg * b10;
        Tempreg11 = A10_reg * b11;
        Tempreg12 = A9_reg * b12;
        Tempreg13 = A8_reg * b13;
        Tempreg14 = A7_reg * b14;
        Tempreg15 = A6_reg * b15;
        Tempreg16 = A5_reg * b16;        
        count = count +1;
    
    B5 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
   
   6'b000110: 
    begin
        Tempreg0 = A22_reg * b0;
        Tempreg1 = A21_reg * b1;
        Tempreg2 = A20_reg * b2;
        Tempreg3 = A19_reg * b3;
        Tempreg4 = A18_reg * b4;
        Tempreg5 = A17_reg * b5;
        Tempreg6 = A16_reg * b6;
        Tempreg7 = A15_reg * b7;
        Tempreg8 = A14_reg * b8;
        Tempreg9 = A13_reg * b9;
        Tempreg10 = A12_reg * b10;
        Tempreg11 = A11_reg * b11;
        Tempreg12 = A10_reg * b12;
        Tempreg13 = A9_reg * b13;
        Tempreg14 = A8_reg * b14;
        Tempreg15 = A7_reg * b15;
        Tempreg16 = A6_reg * b16;
        count = count +1;
       
    B6 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    end
    
    6'b000111:
    begin
        Tempreg0 = A23_reg * b0;
        Tempreg1 = A22_reg * b1;
        Tempreg2 = A21_reg * b2;
        Tempreg3 = A20_reg * b3;
        Tempreg4 = A19_reg * b4;
        Tempreg5 = A18_reg * b5;
        Tempreg6 = A17_reg * b6;
        Tempreg7 = A16_reg * b7;
        Tempreg8 = A15_reg * b8;
        Tempreg9 = A14_reg * b9;
        Tempreg10 = A13_reg * b10;
        Tempreg11 = A12_reg * b11;
        Tempreg12 = A11_reg * b12;
        Tempreg13 = A10_reg * b13;
        Tempreg14 = A9_reg * b14;
        Tempreg15 = A8_reg * b15;
        Tempreg16 = A7_reg * b16;        
        count = count +1;
    
    B7 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    
  end
  
  6'b001000:
    begin
        Tempreg0 = A24_reg * b0;
        Tempreg1 = A23_reg * b1;
        Tempreg2 = A22_reg * b2;
        Tempreg3 = A21_reg * b3;
        Tempreg4 = A20_reg * b4;
        Tempreg5 = A19_reg * b5;
        Tempreg6 = A18_reg * b6;
        Tempreg7 = A17_reg * b7;
        Tempreg8 = A16_reg * b8;
        Tempreg9 = A15_reg * b9;
        Tempreg10 = A14_reg * b10;
        Tempreg11 = A13_reg * b11;
        Tempreg12 = A12_reg * b12;
        Tempreg13 = A11_reg * b13;
        Tempreg14 = A10_reg * b14;
        Tempreg15 = A9_reg * b15;
        Tempreg16 = A8_reg * b16;        
        count = count +1;
    
    B8 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
  end
  6'b001001:
    begin
        Tempreg0 = A25_reg * b0;
        Tempreg1 = A24_reg * b1;
        Tempreg2 = A23_reg * b2;
        Tempreg3 = A22_reg * b3;
        Tempreg4 = A21_reg * b4;
        Tempreg5 = A20_reg * b5;
        Tempreg6 = A19_reg * b6;
        Tempreg7 = A18_reg * b7;
        Tempreg8 = A17_reg * b8;
        Tempreg9 = A16_reg * b9;
        Tempreg10 = A15_reg * b10;
        Tempreg11 = A14_reg * b11;
        Tempreg12 = A13_reg * b12;
        Tempreg13 = A12_reg * b13;
        Tempreg14 = A11_reg * b14;
        Tempreg15 = A10_reg * b15;
        Tempreg16 = A9_reg * b16;        
        count = count +1;
    
    B9 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   
   end
   
   6'b001010:
    begin
        Tempreg0 = A26_reg * b0;
        Tempreg1 = A25_reg * b1;
        Tempreg2 = A24_reg * b2;
        Tempreg3 = A23_reg * b3;
        Tempreg4 = A22_reg * b4;
        Tempreg5 = A21_reg * b5;
        Tempreg6 = A20_reg * b6;
        Tempreg7 = A19_reg * b7;
        Tempreg8 = A18_reg * b8;
        Tempreg9 = A17_reg * b9;
        Tempreg10 = A16_reg * b10;
        Tempreg11 = A15_reg * b11;
        Tempreg12 = A14_reg * b12;
        Tempreg13 = A13_reg * b13;
        Tempreg14 = A12_reg * b14;
        Tempreg15 = A11_reg * b15;
        Tempreg16 = A10_reg * b16;        
        count = count +1;
    
    B10 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
   
   6'b001011:
    begin
        Tempreg0 = A27_reg * b0;
        Tempreg1 = A26_reg * b1;
        Tempreg2 = A25_reg * b2;
        Tempreg3 = A24_reg * b3;
        Tempreg4 = A23_reg * b4;
        Tempreg5 = A22_reg * b5;
        Tempreg6 = A21_reg * b6;
        Tempreg7 = A20_reg * b7;
        Tempreg8 = A19_reg * b8;
        Tempreg9 = A18_reg * b9;
        Tempreg10 = A17_reg * b10;
        Tempreg11 = A16_reg * b11;
        Tempreg12 = A15_reg * b12;
        Tempreg13 = A14_reg * b13;
        Tempreg14 = A13_reg * b14;
        Tempreg15 = A12_reg * b15;
        Tempreg16 = A11_reg * b16;        
        count = count +1;
    
    B11 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
   
    6'b001100: 
    begin
        Tempreg0 = A28_reg * b0;
        Tempreg1 = A27_reg * b1;
        Tempreg2 = A26_reg * b2;
        Tempreg3 = A25_reg * b3;
        Tempreg4 = A24_reg * b4;
        Tempreg5 = A23_reg * b5;
        Tempreg6 = A22_reg * b6;
        Tempreg7 = A21_reg * b7;
        Tempreg8 = A20_reg * b8;
        Tempreg9 = A19_reg * b9;
        Tempreg10 = A18_reg * b10;
        Tempreg11 = A17_reg * b11;
        Tempreg12 = A16_reg * b12;
        Tempreg13 = A15_reg * b13;
        Tempreg14 = A14_reg * b14;
        Tempreg15 = A13_reg * b15;
        Tempreg16 = A12_reg * b16;
        count = count +1;
       
    B12 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    end
    
    6'b001101:
    begin
        Tempreg0 = A29_reg * b0;
        Tempreg1 = A28_reg * b1;
        Tempreg2 = A27_reg * b2;
        Tempreg3 = A26_reg * b3;
        Tempreg4 = A25_reg * b4;
        Tempreg5 = A24_reg * b5;
        Tempreg6 = A23_reg * b6;
        Tempreg7 = A22_reg * b7;
        Tempreg8 = A21_reg * b8;
        Tempreg9 = A20_reg * b9;
        Tempreg10 = A19_reg * b10;
        Tempreg11 = A18_reg * b11;
        Tempreg12 = A17_reg * b12;
        Tempreg13 = A16_reg * b13;
        Tempreg14 = A15_reg * b14;
        Tempreg15 = A14_reg * b15;
        Tempreg16 = A13_reg * b16;        
        count = count +1;
    
    B13 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    
  end
  
  6'b001110:
    begin
        Tempreg0 = A30_reg * b0;
        Tempreg1 = A29_reg * b1;
        Tempreg2 = A28_reg * b2;
        Tempreg3 = A27_reg * b3;
        Tempreg4 = A26_reg * b4;
        Tempreg5 = A25_reg * b5;
        Tempreg6 = A24_reg * b6;
        Tempreg7 = A23_reg * b7;
        Tempreg8 = A22_reg * b8;
        Tempreg9 = A21_reg * b9;
        Tempreg10 = A20_reg * b10;
        Tempreg11 = A19_reg * b11;
        Tempreg12 = A18_reg * b12;
        Tempreg13 = A17_reg * b13;
        Tempreg14 = A16_reg * b14;
        Tempreg15 = A15_reg * b15;
        Tempreg16 = A14_reg * b16;        
        count = count +1;
    
    B14 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
  end
  6'b001111:
    begin
        Tempreg0 = A31_reg * b0;
        Tempreg1 = A30_reg * b1;
        Tempreg2 = A29_reg * b2;
        Tempreg3 = A28_reg * b3;
        Tempreg4 = A27_reg * b4;
        Tempreg5 = A26_reg * b5;
        Tempreg6 = A25_reg * b6;
        Tempreg7 = A24_reg * b7;
        Tempreg8 = A23_reg * b8;
        Tempreg9 = A22_reg * b9;
        Tempreg10 = A21_reg * b10;
        Tempreg11 = A20_reg * b11;
        Tempreg12 = A19_reg * b12;
        Tempreg13 = A18_reg * b13;
        Tempreg14 = A17_reg * b14;
        Tempreg15 = A16_reg * b15;
        Tempreg16 = A15_reg * b16;        
        count = count +1;
    
    B15 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   
   end
   
   6'b010000:
    begin
        Tempreg0 = A32_reg * b0;
        Tempreg1 = A31_reg * b1;
        Tempreg2 = A30_reg * b2;
        Tempreg3 = A29_reg * b3;
        Tempreg4 = A28_reg * b4;
        Tempreg5 = A27_reg * b5;
        Tempreg6 = A26_reg * b6;
        Tempreg7 = A25_reg * b7;
        Tempreg8 = A24_reg * b8;
        Tempreg9 = A23_reg * b9;
        Tempreg10 = A22_reg * b10;
        Tempreg11 = A21_reg * b11;
        Tempreg12 = A20_reg * b12;
        Tempreg13 = A19_reg * b13;
        Tempreg14 = A18_reg * b14;
        Tempreg15 = A17_reg * b15;
        Tempreg16 = A16_reg * b16;        
        count = count +1;
    
    B16 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
   
   6'b010001:
    begin
        Tempreg0 = A33_reg * b0;
        Tempreg1 = A32_reg * b1;
        Tempreg2 = A31_reg * b2;
        Tempreg3 = A30_reg * b3;
        Tempreg4 = A29_reg * b4;
        Tempreg5 = A28_reg * b5;
        Tempreg6 = A27_reg * b6;
        Tempreg7 = A26_reg * b7;
        Tempreg8 = A25_reg * b8;
        Tempreg9 = A24_reg * b9;
        Tempreg10 = A23_reg * b10;
        Tempreg11 = A22_reg * b11;
        Tempreg12 = A21_reg * b12;
        Tempreg13 = A20_reg * b13;
        Tempreg14 = A19_reg * b14;
        Tempreg15 = A18_reg * b15;
        Tempreg16 = A17_reg * b16;        
        count = count +1;
    
    B17 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
   
   6'b010010: 
    begin
        Tempreg0 = A34_reg * b0;
        Tempreg1 = A33_reg * b1;
        Tempreg2 = A32_reg * b2;
        Tempreg3 = A31_reg * b3;
        Tempreg4 = A30_reg * b4;
        Tempreg5 = A29_reg * b5;
        Tempreg6 = A28_reg * b6;
        Tempreg7 = A27_reg * b7;
        Tempreg8 = A26_reg * b8;
        Tempreg9 = A25_reg * b9;
        Tempreg10 = A24_reg * b10;
        Tempreg11 = A23_reg * b11;
        Tempreg12 = A22_reg * b12;
        Tempreg13 = A21_reg * b13;
        Tempreg14 = A20_reg * b14;
        Tempreg15 = A19_reg * b15;
        Tempreg16 = A18_reg * b16;
        count = count +1;
       
    B18 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    end
    
    6'b010011:
    begin
        Tempreg0 = A35_reg * b0;
        Tempreg1 = A34_reg * b1;
        Tempreg2 = A33_reg * b2;
        Tempreg3 = A32_reg * b3;
        Tempreg4 = A31_reg * b4;
        Tempreg5 = A30_reg * b5;
        Tempreg6 = A29_reg * b6;
        Tempreg7 = A28_reg * b7;
        Tempreg8 = A27_reg * b8;
        Tempreg9 = A26_reg * b9;
        Tempreg10 = A25_reg * b10;
        Tempreg11 = A24_reg * b11;
        Tempreg12 = A23_reg * b12;
        Tempreg13 = A22_reg * b13;
        Tempreg14 = A21_reg * b14;
        Tempreg15 = A20_reg * b15;
        Tempreg16 = A19_reg * b16;        
        count = count +1;
    
    B19 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    
  end
  
  6'b010100:
    begin
        Tempreg0 = A36_reg * b0;
        Tempreg1 = A35_reg * b1;
        Tempreg2 = A34_reg * b2;
        Tempreg3 = A33_reg * b3;
        Tempreg4 = A32_reg * b4;
        Tempreg5 = A31_reg * b5;
        Tempreg6 = A30_reg * b6;
        Tempreg7 = A29_reg * b7;
        Tempreg8 = A28_reg * b8;
        Tempreg9 = A27_reg * b9;
        Tempreg10 = A26_reg * b10;
        Tempreg11 = A25_reg * b11;
        Tempreg12 = A24_reg * b12;
        Tempreg13 = A23_reg * b13;
        Tempreg14 = A22_reg * b14;
        Tempreg15 = A21_reg * b15;
        Tempreg16 = A20_reg * b16;        
        count = count +1;
    
    B20 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
  end
  6'b010101:
    begin
        Tempreg0 = A37_reg * b0;
        Tempreg1 = A36_reg * b1;
        Tempreg2 = A35_reg * b2;
        Tempreg3 = A34_reg * b3;
        Tempreg4 = A33_reg * b4;
        Tempreg5 = A32_reg * b5;
        Tempreg6 = A31_reg * b6;
        Tempreg7 = A30_reg * b7;
        Tempreg8 = A29_reg * b8;
        Tempreg9 = A28_reg * b9;
        Tempreg10 = A27_reg * b10;
        Tempreg11 = A26_reg * b11;
        Tempreg12 = A25_reg * b12;
        Tempreg13 = A24_reg * b13;
        Tempreg14 = A23_reg * b14;
        Tempreg15 = A22_reg * b15;
        Tempreg16 = A21_reg * b16;        
        count = count +1;
    
    B21 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   
   end
   
   6'b010110:
    begin
        Tempreg0 = A38_reg * b0;
        Tempreg1 = A37_reg * b1;
        Tempreg2 = A36_reg * b2;
        Tempreg3 = A35_reg * b3;
        Tempreg4 = A34_reg * b4;
        Tempreg5 = A33_reg * b5;
        Tempreg6 = A32_reg * b6;
        Tempreg7 = A31_reg * b7;
        Tempreg8 = A30_reg * b8;
        Tempreg9 = A29_reg * b9;
        Tempreg10 = A28_reg * b10;
        Tempreg11 = A27_reg * b11;
        Tempreg12 = A26_reg * b12;
        Tempreg13 = A25_reg * b13;
        Tempreg14 = A24_reg * b14;
        Tempreg15 = A23_reg * b15;
        Tempreg16 = A22_reg * b16;        
        count = count +1;
    
    B22 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   
   end
   
   6'b010111:
    begin
        Tempreg0 = A39_reg * b0;
        Tempreg1 = A38_reg * b1;
        Tempreg2 = A37_reg * b2;
        Tempreg3 = A36_reg * b3;
        Tempreg4 = A35_reg * b4;
        Tempreg5 = A34_reg * b5;
        Tempreg6 = A33_reg * b6;
        Tempreg7 = A32_reg * b7;
        Tempreg8 = A31_reg * b8;
        Tempreg9 = A30_reg * b9;
        Tempreg10 = A29_reg * b10;
        Tempreg11 = A28_reg * b11;
        Tempreg12 = A27_reg * b12;
        Tempreg13 = A26_reg * b13;
        Tempreg14 = A25_reg * b14;
        Tempreg15 = A24_reg * b15;
        Tempreg16 = A23_reg * b16;        
        count = count +1;
    
    B23 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
   
   
      6'b011000:
    begin
        Tempreg0 = A40_reg * b0;
        Tempreg1 = A39_reg * b1;
        Tempreg2 = A38_reg * b2;
        Tempreg3 = A37_reg * b3;
        Tempreg4 = A36_reg * b4;
        Tempreg5 = A35_reg * b5;
        Tempreg6 = A34_reg * b6;
        Tempreg7 = A33_reg * b7;
        Tempreg8 = A32_reg * b8;
        Tempreg9 = A31_reg * b9;
        Tempreg10 = A30_reg * b10;
        Tempreg11 = A29_reg * b11;
        Tempreg12 = A28_reg * b12;
        Tempreg13 = A27_reg * b13;
        Tempreg14 = A26_reg * b14;
        Tempreg15 = A25_reg * b15;
        Tempreg16 = A24_reg * b16;        
        count = count +1;
    
    B24 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
   
   6'b011001:
    begin
        Tempreg0 = A41_reg * b0;
        Tempreg1 = A40_reg * b1;
        Tempreg2 = A39_reg * b2;
        Tempreg3 = A38_reg * b3;
        Tempreg4 = A37_reg * b4;
        Tempreg5 = A36_reg * b5;
        Tempreg6 = A35_reg * b6;
        Tempreg7 = A34_reg * b7;
        Tempreg8 = A33_reg * b8;
        Tempreg9 = A32_reg * b9;
        Tempreg10 = A31_reg * b10;
        Tempreg11 = A30_reg * b11;
        Tempreg12 = A29_reg * b12;
        Tempreg13 = A28_reg * b13;
        Tempreg14 = A27_reg * b14;
        Tempreg15 = A26_reg * b15;
        Tempreg16 = A25_reg * b16;        
        count = count +1;
    
    B25 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
   
   6'b011010: 
    begin
        Tempreg0 = A42_reg * b0;
        Tempreg1 = A41_reg * b1;
        Tempreg2 = A40_reg * b2;
        Tempreg3 = A39_reg * b3;
        Tempreg4 = A38_reg * b4;
        Tempreg5 = A37_reg * b5;
        Tempreg6 = A36_reg * b6;
        Tempreg7 = A35_reg * b7;
        Tempreg8 = A34_reg * b8;
        Tempreg9 = A33_reg * b9;
        Tempreg10 = A32_reg * b10;
        Tempreg11 = A31_reg * b11;
        Tempreg12 = A30_reg * b12;
        Tempreg13 = A29_reg * b13;
        Tempreg14 = A28_reg * b14;
        Tempreg15 = A27_reg * b15;
        Tempreg16 = A26_reg * b16;
        count = count +1;
       
    B26 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    end
    
    6'b011011:
    begin
        Tempreg0 = A43_reg * b0;
        Tempreg1 = A42_reg * b1;
        Tempreg2 = A41_reg * b2;
        Tempreg3 = A40_reg * b3;
        Tempreg4 = A39_reg * b4;
        Tempreg5 = A38_reg * b5;
        Tempreg6 = A37_reg * b6;
        Tempreg7 = A36_reg * b7;
        Tempreg8 = A35_reg * b8;
        Tempreg9 = A34_reg * b9;
        Tempreg10 = A33_reg * b10;
        Tempreg11 = A32_reg * b11;
        Tempreg12 = A31_reg * b12;
        Tempreg13 = A30_reg * b13;
        Tempreg14 = A29_reg * b14;
        Tempreg15 = A28_reg * b15;
        Tempreg16 = A27_reg * b16;        
        count = count +1;
    
    B27 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
    
  end
  
  6'b011100:
    begin
        Tempreg0 = A44_reg * b0;
        Tempreg1 = A43_reg * b1;
        Tempreg2 = A42_reg * b2;
        Tempreg3 = A41_reg * b3;
        Tempreg4 = A40_reg * b4;
        Tempreg5 = A39_reg * b5;
        Tempreg6 = A38_reg * b6;
        Tempreg7 = A37_reg * b7;
        Tempreg8 = A36_reg * b8;
        Tempreg9 = A35_reg * b9;
        Tempreg10 = A34_reg * b10;
        Tempreg11 = A33_reg * b11;
        Tempreg12 = A32_reg * b12;
        Tempreg13 = A31_reg * b13;
        Tempreg14 = A30_reg * b14;
        Tempreg15 = A29_reg * b15;
        Tempreg16 = A28_reg * b16;        
        count = count +1;
    
    B28 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
  end
  6'b011101:
    begin
        Tempreg0 = A45_reg * b0;
        Tempreg1 = A44_reg * b1;
        Tempreg2 = A43_reg * b2;
        Tempreg3 = A42_reg * b3;
        Tempreg4 = A41_reg * b4;
        Tempreg5 = A40_reg * b5;
        Tempreg6 = A39_reg * b6;
        Tempreg7 = A38_reg * b7;
        Tempreg8 = A37_reg * b8;
        Tempreg9 = A36_reg * b9;
        Tempreg10 = A35_reg * b10;
        Tempreg11 = A34_reg * b11;
        Tempreg12 = A33_reg * b12;
        Tempreg13 = A32_reg * b13;
        Tempreg14 = A31_reg * b14;
        Tempreg15 = A30_reg * b15;
        Tempreg16 = A29_reg * b16;        
        count = count +1;
    
    B29 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   
   end
   
   6'b011110:
    begin
        Tempreg0 = A46_reg * b0;
        Tempreg1 = A45_reg * b1;
        Tempreg2 = A44_reg * b2;
        Tempreg3 = A43_reg * b3;
        Tempreg4 = A42_reg * b4;
        Tempreg5 = A41_reg * b5;
        Tempreg6 = A40_reg * b6;
        Tempreg7 = A39_reg * b7;
        Tempreg8 = A38_reg * b8;
        Tempreg9 = A37_reg * b9;
        Tempreg10 = A36_reg * b10;
        Tempreg11 = A35_reg * b11;
        Tempreg12 = A34_reg * b12;
        Tempreg13 = A33_reg * b13;
        Tempreg14 = A32_reg * b14;
        Tempreg15 = A31_reg * b15;
        Tempreg16 = A30_reg * b16;        
        count = count +1;
    
    B30 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   
   end
   
   6'b011111:
    begin
        Tempreg0 = A47_reg * b0;
        Tempreg1 = A46_reg * b1;
        Tempreg2 = A45_reg * b2;
        Tempreg3 = A44_reg * b3;
        Tempreg4 = A43_reg * b4;
        Tempreg5 = A42_reg * b5;
        Tempreg6 = A41_reg * b6;
        Tempreg7 = A40_reg * b7;
        Tempreg8 = A39_reg * b8;
        Tempreg9 = A38_reg * b9;
        Tempreg10 = A37_reg * b10;
        Tempreg11 = A36_reg * b11;
        Tempreg12 = A35_reg * b12;
        Tempreg13 = A34_reg * b13;
        Tempreg14 = A33_reg * b14;
        Tempreg15 = A32_reg * b15;
        Tempreg16 = A31_reg * b16;        
        count = count +1;
    
    B31 = Tempreg0 + Tempreg1 + Tempreg2 + Tempreg3 + Tempreg4 + Tempreg5 + Tempreg6 + Tempreg7 + Tempreg8 + Tempreg9 + Tempreg10 + Tempreg11 + Tempreg12 + Tempreg13 + Tempreg14 + Tempreg15 + Tempreg16; 
   end
        
   endcase
   end
   end
   endmodule
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
   
  
    
    
    
    
    
    
    
  
    
   


