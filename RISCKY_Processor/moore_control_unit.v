
// Control Unit is build as a moore machine
//To keep things simple, Behavioural modelling style was followed
module processor_control_unit_moore_fsm(
   output PCwritefinal,output reg [1:0] ALUop, output reg [1:0] ALUSrcA, output reg [2:0] ALUSrcB,
   output reg MemtoReg,output reg MDRwrite,output reg ALUoutwrite,output reg IRWrite, output reg MemRead,output reg MemWrite,output reg RegWrite,output reg Shift,
   output reg [1:0] PCsrc,output reg RegDst, input [3:0] OPCODE,input clk,input isZero
);
    reg PCWrite;
    reg BE;
    reg BNE;
    reg [4:0] present_state; 
    reg [4:0] next_state;
    parameter S0 = 5'b00000;  //Assigning parametric names to all the states
    parameter S1 = 5'b00001;
    parameter S2 = 5'b00010;
    parameter S3 = 5'b00011;
    parameter S4 = 5'b00100;
    parameter S5 = 5'b00101;
    parameter S6 = 5'b00110;
    parameter S7 = 5'b00111;
    parameter S8 = 5'b01000;
    parameter S9 = 5'b01001;
    parameter S10 = 5'b01010;
    parameter S11 = 5'b01011;
    parameter S12 = 5'b01100;
    parameter S13 = 5'b01101;
    parameter S14 = 5'b01110;
    parameter S15 = 5'b01111;
    parameter S16 = 5'b10000;
    parameter S17 = 5'b10001;
    parameter S18 = 5'b10010;
    parameter S19 = 5'b10011;
    parameter S20 = 5'b10100;
    parameter S21 = 5'b10101;

    wire [1:0] branch_or;
    and (branch_or[0],BE,isZero);
    and (branch_or[1],BNE,(~isZero));
    or (PCwritefinal,PCWrite,branch_or[0],branch_or[1]);  //Computing PCwritefianl from BE, BNE, Zeroflag, PCwrite
    
    initial begin
        next_state = S0;    //State at t=0
    end

    always @(posedge clk) begin
        present_state = next_state;
    end

    always @(present_state,OPCODE) begin      // Deciding next state based on OPCODE and Present State
        case(present_state) 
             S0 : next_state = S1;
             S1 : begin 
                 if(OPCODE == 4'b1000) next_state = S2;
                 else if(OPCODE == 4'b1001) next_state = S3;
                 else if(OPCODE == 4'b1010) next_state = S4;
                 else if(OPCODE == 4'b1100) next_state = S5;
                 else if(OPCODE == 4'b1101) next_state = S6;
                 else if(OPCODE == 4'b1110) next_state = S7;
                 else if(OPCODE == 4'b0000) next_state = S8;
                 else if(OPCODE == 4'b0100) next_state = S9;
                 else if(OPCODE == 4'b0101) next_state = S10;
                 else if(OPCODE == 4'b0011) next_state = S11;
                 else if(OPCODE == 4'b1011) next_state = S12;
                 else if(OPCODE == 4'b0111) next_state = S13;
                 else if(OPCODE == 4'b1111) next_state = S14;
                 else if(OPCODE == 4'b0110) next_state = S15;
                 else if(OPCODE == 4'b0001) next_state = S16;
                 else if(OPCODE == 4'b0010) next_state = S21;
             end 
             S2,S3,S4,S5,S6,S7,S8,S12,S13,S14,S15 : next_state = S17;
             S9,S10,S11,S17,S19,S20 : next_state = S0;
             S16 : next_state = S18;
             S18 : next_state = S20;
             S21 : next_state = S19;
             default : next_state = S0;          
        endcase
        
    end

	//PCWrite: Signal from control unit;   BE: Branch if Equal;  BNE: Branch if Not Equal;  ALUop: Signal to ALU to decide operation on operands;
	//ALUSrcA: Select line for mux feeding ALUinA;  ALUSrcB: Select line for mux feeding ALUinB;  
	//MemtoReg: Data to desitantion register from MDR or ALUOut;  ALUoutwrite: Enable to write into ALUout;  
	//IRWrite: Enable to write into Instruction Register;  MemRead: Enable memory read;  MemWrite: Enable memory write; 
	//RegWrite: Enable Register bank write;  Shift: Active for Shifting Opertaion;  PCsrc: Choosing what to write into PC; 
	//RegDst: Choosing Destination Register;  MDRwrite: Enable to write into MDR;
	 
    always @(present_state) begin   // Since this is a moore machine, The control signals(o/ps) are dependent solely on the state of the machine
        case(present_state)         //Deciding the values of control signals in each state
             
             S0 : begin PCWrite = 1'b1; BE = 1'bx; BNE = 1'bx; ALUop = 2'b00; ALUSrcA = 2'b11; ALUSrcB = 3'b110; MemtoReg = 1'bx; ALUoutwrite = 1'b0;
                        IRWrite = 1'b1; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'bx; PCsrc = 2'b01; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S1 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'bxx; ALUSrcA = 2'bxx; ALUSrcB = 3'bxxx; MemtoReg = 1'bx; ALUoutwrite = 1'b0;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S2 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b00; ALUSrcA = 2'b01; ALUSrcB = 3'b101; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S3 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b00; ALUSrcA = 2'b10; ALUSrcB = 3'b010; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S4 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b00; ALUSrcA = 2'b10; ALUSrcB = 3'b001; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S5 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b01; ALUSrcA = 2'b01; ALUSrcB = 3'b101; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S6 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b01; ALUSrcA = 2'b10; ALUSrcB = 3'b010; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S7 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b01; ALUSrcA = 2'b10; ALUSrcB = 3'b001; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S8 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'bxx; ALUSrcA = 2'bxx; ALUSrcB = 3'bxxx; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b1; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S9 : begin PCWrite = 1'b0; BE = 1'b1; BNE = 1'b0; ALUop = 2'b01; ALUSrcA = 2'b01; ALUSrcB = 3'b101; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'bx; PCsrc = 2'b10; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S10 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b1; ALUop = 2'b01; ALUSrcA = 2'b01; ALUSrcB = 3'b101; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'bx; PCsrc = 2'b10; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S11 : begin PCWrite = 1'b1; BE = 1'bx; BNE = 1'bx; ALUop = 2'b00; ALUSrcA = 2'b11; ALUSrcB = 3'b000; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'b00; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S12 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b10; ALUSrcA = 2'b01; ALUSrcB = 3'b101; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S13 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b10; ALUSrcA = 2'b10; ALUSrcB = 3'b010; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S14 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b11; ALUSrcA = 2'b01; ALUSrcB = 3'b101; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S15 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b11; ALUSrcA = 2'b10; ALUSrcB = 3'b010; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S17 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'bxx; ALUSrcA = 2'bxx; ALUSrcB = 3'bxxx; MemtoReg = 1'b1; ALUoutwrite = 1'b0;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b1; Shift = 1'bx; PCsrc = 2'bxx; RegDst = 1'b0; MDRwrite = 1'b0;
             end
             S16 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b00; ALUSrcA = 2'b00; ALUSrcB = 3'b100; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S18 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'bxx; ALUSrcA = 2'bxx; ALUSrcB = 3'bxxx; MemtoReg = 1'bx; ALUoutwrite = 1'b0;
                        IRWrite = 1'b0; MemRead = 1'b1; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'bx; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b1;
             end
             S20 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'bxx; ALUSrcA = 2'bxx; ALUSrcB = 3'bxxx; MemtoReg = 1'b0; ALUoutwrite = 1'b0;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b1; Shift = 1'bx; PCsrc = 2'bxx; RegDst = 1'b1; MDRwrite = 1'b0;
             end
             S21 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'b00; ALUSrcA = 2'b00; ALUSrcB = 3'b011; MemtoReg = 1'bx; ALUoutwrite = 1'b1;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'b0; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             S19 : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'bxx; ALUSrcA = 2'bxx; ALUSrcB = 3'bxxx; MemtoReg = 1'bx; ALUoutwrite = 1'b0;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b1; RegWrite = 1'b0; Shift = 1'bx; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end
             default : begin PCWrite = 1'b0; BE = 1'b0; BNE = 1'b0; ALUop = 2'bxx; ALUSrcA = 2'bxx; ALUSrcB = 3'bxxx; MemtoReg = 1'bx; ALUoutwrite = 1'b0;
                        IRWrite = 1'b0; MemRead = 1'b0; MemWrite = 1'b0; RegWrite = 1'b0; Shift = 1'bx; PCsrc = 2'bxx; RegDst = 1'bx; MDRwrite = 1'b0;
             end

        endcase
    end


endmodule

/*module tb_cu();
wire PCwritefinal,MemtoReg,IRWrite,MemRead,MemWrite,RegWrite,Shift,RegDst,ALUoutwrite,MDRwrite;
wire [1:0] ALUop;
wire [1:0] ALUSrcA;
wire [1:0] PCsrc;
wire [2:0] ALUSrcB;
reg [3:0] OPCODE;
reg clk;
reg isZero;
processor_control_unit_moore_fsm uut(
   PCwritefinal,ALUop,ALUSrcA,ALUSrcB,MemtoReg,MDRwrite,ALUoutwrite,IRWrite,MemRead,MemWrite,RegWrite,Shift,PCsrc,RegDst,OPCODE,clk,isZero
);
initial begin
        clk = 1'b1;
        forever begin
            #2 clk = ~clk;
        end
end
initial begin
    $dumpfile("CU_test.vcd");
    $dumpvars(0,tb_cu);
    $monitor($time," PCWrite = %b ,BE = %b ,BNE = %b ,ALUop = %b ,ALUSrcA = %b ,ALUSrcB = %b ,MemtoReg = %b ,IRWrite = %b ,MemRead = %b ,MemWrite = %b ,RegWrite = %b ,Shift = %b ,PCsrc = %b ,RegDst = %b ,OPCODE = %b",PCwritefinal,ALUop,ALUSrcA,ALUSrcB,MemtoReg,IRWrite,MemRead,MemWrite,RegWrite,Shift,PCsrc,RegDst,OPCODE);
    OPCODE = 4'b1001;
    #20 OPCODE = 4'b0011;
    #50 $finish;
end
endmodule*/
