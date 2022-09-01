//`timescale 1ns / 1ps

//Register bank is coded in this file

module Register_Bank(
    input Regwrite, //enabling write to register bank
    input [3:0] Read_reg1,
    input [3:0] Read_reg2,
    input [3:0] Read_reg3,
    input [3:0] Read_reg4,
    input [3:0] Read_reg5,  //Able to read 5 register at once.(To complete the task in given clock cycles)
    input [3:0] Write_reg,
    input [15:0] Write_data,
    input clk,
    output reg[15:0] A,
    output reg[15:0] B,
    output reg[15:0] C,
    output reg[15:0] D,
    output reg[15:0] E    );
    
    reg [15:0]R0;    //16 registers
    reg [15:0]R1;
    reg [15:0]R2;
    reg [15:0]R3;
    reg [15:0]R4;
    reg [15:0]R5;
    reg [15:0]R6;
    reg [15:0]R7;
    reg [15:0]R8;
    reg [15:0]R9;
    reg [15:0]R10;
    reg [15:0]R11;
    reg [15:0]R12;
    reg [15:0]R13;
    reg [15:0]R14;
    reg [15:0]R15;
    
always@(posedge clk)   //feeding the intermediate registers A,B,C,D,E appropriately with contents in the register bank
    begin
    R0 = 16'd0;  //R0 is hard coded to 16'd0
    case( Read_reg1)  // initializing C using read_reg1 from instruction
    4'b0000: C = R0;   
    4'b0001: C = R1;
    4'b0010: C = R2;
    4'b0011: C = R3;
    4'b0100: C = R4;
    4'b0101: C = R5;
    4'b0110: C = R6;
    4'b0111: C = R7;
    4'b1000: C = R8;
    4'b1001: C = R9;
    4'b1010: C = R10;
    4'b1011: C = R11;
    4'b1100: C = R12;
    4'b1101: C = R13;
    4'b1110: C = R14;
    4'b1111: C = R15;
    default: C= 16'hxxxx;
    endcase
    end
    
 always@(posedge clk)
    begin
    case( Read_reg2)  // initializing A using read_reg2 from instruction
    4'b0000: A = R0;
    4'b0001: A = R1;
    4'b0010: A = R2;
    4'b0011: A = R3;
    4'b0100: A = R4;
    4'b0101: A = R5;
    4'b0110: A = R6;
    4'b0111: A = R7;
    4'b1000: A = R8;
    4'b1001: A = R9;
    4'b1010: A = R10;
    4'b1011: A = R11;
    4'b1100: A = R12;
    4'b1101: A = R13;
    4'b1110: A = R14;
    4'b1111: A = R15;
    default: A= 16'hxxxx;
    endcase
    end   
    
 always@(posedge clk)
    begin
    case( Read_reg3)    // initializing B using read_reg3 from instruction
    4'b0000: B = R0;
    4'b0001: B = R1;
    4'b0010: B = R2;
    4'b0011: B = R3;
    4'b0100: B = R4;
    4'b0101: B = R5;
    4'b0110: B = R6;
    4'b0111: B = R7;
    4'b1000: B = R8;
    4'b1001: B = R9;
    4'b1010: B = R10;
    4'b1011: B = R11;
    4'b1100: B = R12;
    4'b1101: B = R13;
    4'b1110: B = R14;
    4'b1111: B = R15;
    default: B = 16'hxxxx;
    endcase
    end      
    
always@(posedge clk)
    begin
    case( Read_reg4)      // initializing E using read_reg4 from instruction
    4'b0000: E  = R0;
    4'b0001: E = R1;
    4'b0010: E = R2;
    4'b0011: E = R3;
    4'b0100: E = R4;
    4'b0101: E = R5;
    4'b0110: E = R6;
    4'b0111: E = R7;
    4'b1000: E = R8;
    4'b1001: E = R9;
    4'b1010: E = R10;
    4'b1011: E = R11;
    4'b1100: E = R12;
    4'b1101: E = R13;
    4'b1110: E = R14;
    4'b1111: E = R15;
    default: E =  16'hxxxx;
    endcase
    end   
    
always@(posedge clk)
    begin
    case( Read_reg5)     // initializing D using read_reg5 from instruction
    4'b0000: D  = R0;
    4'b0001: D = R1;
    4'b0010: D = R2;
    4'b0011: D = R3;
    4'b0100: D = R4;
    4'b0101: D = R5;
    4'b0110: D = R6;
    4'b0111: D = R7;
    4'b1000: D = R8;
    4'b1001: D = R9;
    4'b1010: D = R10;
    4'b1011: D = R11;
    4'b1100: D = R12;
    4'b1101: D = R13;
    4'b1110: D = R14;
    4'b1111: D = R15;
    default: D =  16'hxxxx;
    endcase
    end       
    
always@(Regwrite,Write_data,Write_reg)
begin
    if (Regwrite==1'b1)    //Writing the data into Destination Register when RegWrite is enabled 
    case( Write_reg)
        4'b0000: R0  = 1'b1;
        4'b0001: R1 = Write_data;
        4'b0010: R2 = Write_data;
        4'b0011: R3 = Write_data;
        4'b0100: R4 = Write_data;
        4'b0101: R5 = Write_data;
        4'b0110: R6 = Write_data;
        4'b0111: R7 = Write_data;
        4'b1000: R8 = Write_data;
        4'b1001: R9 = Write_data;
        4'b1010: R10 = Write_data;
        4'b1011: R11 = Write_data;
        4'b1100: R12 = Write_data;
        4'b1101: R13 = Write_data;
        4'b1110: R14 = Write_data;
        4'b1111: R15 = Write_data;
    default:
    begin
        
        R0 =  R0;   //dfault case resulting in no change among the registers
        R1 =  R1;
        R2 =  R2;
        R3 =  R3;
        R4 =  R4;
        R5 =  R5;
        R6 =  R6;
        R7 =  R7;
        R8 =  R8;
        R9 =  R9;
        R10 =  R10;
        R11 =  R11;
        R12 =  R12;
        R13 =  R13;
        R14 =  R14;
        R15 =  R15;
    end
    endcase
    else 
    begin
        R0 = R0;
        R1 = R1;
        R2 = R2;
        R3 = R3;
        R4 = R4;
        R5 = R5;
        R6 = R6;
        R7 = R7;
        R8 = R8;
        R9 = R9;
        R10 = R10;
        R11 = R11;
        R12 = R12;
        R13 = R13;
        R14 = R14;
        R15 = R15;
    end
    end           
endmodule

