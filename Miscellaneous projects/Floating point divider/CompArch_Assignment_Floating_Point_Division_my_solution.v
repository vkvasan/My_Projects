//Name:V Keerthivasan
//ID:2018A8PS0480P

//Name: Ambedpelliwar sankalp 
//ID:2018A3PS0383P


//Code

module fp_main_divider( input [31:0]InputA, input [31:0]InputB , input CLOCK,input RESET, output DONE, output [1:0]EXCEPTION, output [31:0]AbyB);
wire [7:0]Aexp;
wire [7:0]Bexp;
wire [23:0]Aman;
wire [23:0]Bman;
reg [23:0]Cman_temp;
wire [23:0]Cman_temp_wires;
reg [7:0]Cexp_temp;

wire [5:0]Normalization_count;
reg [5:0]Normalization_count_actual;
wire [5:0]Normalization_count_actual_wires;

wire Aman_1bit;
wire Bman_1bit;
reg [8:0]Aexp_extended;
reg [8:0]Bexp_extended;
reg [8:0]Difference_temp;
reg [1:0]exception_register;
reg Aman_1bit_register;
reg Bman_1bit_register;


assign Aman_1bit=Aman_1bit_register;
assign Bman_1bit=Bman_1bit_register;
assign Aexp = InputA[30:23];
assign Aman = {Aman_1bit,InputA[22:0]};

assign Bman = {Bman_1bit,InputB[22:0]};
assign Bexp = InputB[30:23];
assign Normalization_count_actual_wires[5:0] = Normalization_count_actual[5:0];
assign EXCEPTION[1:0] = exception_register[1:0];
assign AbyB[31]= InputA[31]^InputB[31];
assign AbyB[30:23] = Cexp_temp[7:0];

mantissa_divider u0( .Dividend(Aman), . Divisor(Bman), .clk(CLOCK)  ,.Done_wire(DONE) ,.reset(RESET), .normalization_count_wires(Normalization_count) , .quotient(Cman_temp_wires)) ;
normalizer_mantissa u1( .Done_normalizer(DONE) , .count ( Normalization_count_actual_wires) , .number(Cman_temp_wires) , .out_number( AbyB[22:0] ) );

always@(*)
begin
if(RESET)
begin
    Aman_1bit_register = 1'b0;
    Aman_1bit_register = 1'b0;
end
else 
begin
    Aexp_extended = {1'b0, Aexp };
    Bexp_extended = {1'b0, Bexp };
        if ((Aexp_extended > 9'b000000000) & (Bexp_extended > 9'b000000000) & (Aexp_extended < 9'b011111111) & (Bexp_extended < 9'b011111111))  //
        begin
            if ( (Aexp_extended - Bexp_extended + 9'd127) >= 9'b00000001 &  (Aexp_extended - Bexp_extended + 9'd127) <= 9'b011111110 )     
            begin
                Aman_1bit_register = 1'b1;
                Bman_1bit_register = 1'b1;
                Cexp_temp = Aexp - Bexp + 8'd127 - Normalization_count;
                Normalization_count_actual = Normalization_count;
            end
            else if ( (Aexp - Bexp + 8'd127) ==1'b0 )
            begin
                
                Aman_1bit_register = 1'b1;
                Bman_1bit_register = 1'b1;
                Cexp_temp =0;   
                if(Aman>Bman)                           //for subnormal numbers
                    Normalization_count_actual = 6'b000001;
                else
                    Normalization_count_actual = 6'b000000; ////simple assignment of Cman_temp with Cman        
            end
            else if ( (Aexp_extended - Bexp_extended) > 8'd127 )
            begin
                Difference_temp = Aexp_extended - Bexp_extended ;
                if( Difference_temp[8] ==1'b1)
                    exception_register = 2'b01;         //underflow
                else 
                    exception_register = 2'b10;         //overflow
            end
        else if ((Aexp_extended > 9'b00000000) & (Aexp_extended < 9'b011111111) & (Bexp_extended == 9'b00000000) & (Bman !=0) ) //subnormal denominator
        begin
            if ( Aexp_extended <= 9'b001111111 )
            begin
                Aman_1bit_register = 1'b1;
                Bman_1bit_register = 1'b0;
                Cexp_temp = Aexp + 8'b01111111-Normalization_count;
                Normalization_count_actual = Normalization_count;
            end
            else
                exception_register = 2'b10;
            end
        end 
        else if ((Aexp_extended > 9'b00000000) & (Aexp_extended < 9'b011111111) & (InputB[30:0]==0 )) //Divide by 0.
                exception_register = 2'b00;                         
        else if ((Aexp_extended > 9'b00000000) & (Aexp_extended < 9'b011111111) & (Bexp_extended == 9'b011111111) & (Bman ==0) )
        begin
                Cexp_temp = 8'b00000000;
                Cman_temp = 0;
        end
        else if ((Aexp_extended > 9'b000000000) & (Aexp_extended < 9'b011111111) & (Bexp_extended == 9'b011111111) & (Bman !=0) )      
                 exception_register = 2'b11;
        else if ((Aexp_extended == 9'b000000000) & (Aman !=0) & (Bexp_extended > 9'b000000000) & (Bexp_extended < 9'b011111111) )  //subnormal Numerator  
        begin
                 Difference_temp = Aexp_extended - Bexp_extended +9'd127 ; 
                 if (Difference_temp[8] ==1'b1)
                    exception_register = 2'b01;
                 else
                 begin
                    Aman_1bit_register = 1'b0;
                    Bman_1bit_register = 1'b1;
                    Cexp_temp = Aexp - Bexp + 8'd127 - (Normalization_count-1);
                    Normalization_count_actual = (Normalization_count-1);
                end
        end                     
        else if ((Aexp_extended == 9'b00000000) & (Aman ==0) & (Bexp_extended > 9'b000000000) & (Bexp_extended < 9'b011111111) )  
        begin
                Cexp_temp = 8'b00000000;
                Cman_temp = 0;
        end
        else if ((Aexp_extended == 9'b011111111) & (Aman !=0) & (Bexp_extended > 9'b000000000) & (Bexp_extended < 9'b011111111) )   
                exception_register = 2'b11;
        else if ((Aexp_extended == 9'b011111111) & (Aman ==0) & (Bexp_extended > 9'b000000000) & (Bexp_extended < 9'b011111111) )   
        begin
                Cexp_temp = 8'b11111111;
                Cman_temp = 0;
        end
        else if ((Aexp_extended == 9'b011111111) & (Aman ==0) & (Bexp_extended == 9'b011111111) & Bman ==0 )  
        begin    
                Cexp_temp = 8'b11111111;
                Cman_temp = 0;
        end
        else if ((Aexp_extended == 9'b011111111) & (Aman ==0) & (Bexp_extended == 9'b011111111) & (Bman !=0) )  
                exception_register = 2'b11;
        else if ((Aexp_extended == 9'b011111111) & (Aman ==0) & (Bexp == 9'b000000000) & (Bman !=0) )  
        begin
                exception_register = 2'b11;
                Cexp_temp = 8'b11111111;
                Cman_temp = 0;
        end 
        else if ((Aexp_extended == 9'b011111111) & (Aman ==0) & (Bexp_extended == 9'b00000000) & (Bman ==0) )      
                exception_register = 2'b00;
        else if ((Aexp_extended == 9'b011111111) & Aman!=0)
                exception_register = 2'b11;
        else if ((Aexp_extended == 9'b000000000) & (Aman==0) & (Bexp_extended == 9'b011111111) & (Bman != 0) )
                exception_register = 2'b11;
        else if ((Aexp_extended == 9'b000000000) & (Aman == 0) )
        begin
                Cexp_temp = 8'b00000000;
                Cman_temp = 0;
        end
        else if ((Aexp_extended == 9'b000000000) & (Aman!=0) & (Bexp_extended ==9'b000000000) & (Bman!=0) )   //subnormal numerator and subnormal Denominator
        begin
                Aman_1bit_register = 1'b0;
                Bman_1bit_register = 1'b0;
                Cexp_temp =8'd127- Normalization_count;
                Normalization_count_actual = Normalization_count;
                
        end
        else if ((Aexp_extended == 9'b000000000) & (Aman!=0) & (Bexp_extended ==9'b000000000) & (Bman==0) )
                exception_register= 2'b00;
        else if ((Aexp_extended == 9'b000000000) & (Aman!=0) & (Bexp_extended ==9'b011111111) & (Bman!=0) )
                exception_register = 2'b11;
        else if ((Aexp_extended == 9'b000000000) & (Aman!=0) & (Bexp_extended ==9'b011111111) & (Bman==0) )
        begin
                Cexp_temp = 8'b00000000;
                Cman_temp = 0;
        end
                                   
  end
  end    
endmodule


module normalizer_mantissa(input Done_normalizer,input [5:0]count, input [23:0]number, output [22:0]out_number);
reg [23:0]number_temp;
reg [5:0]count_temp;
assign out_number = ( Done_normalizer ==1 ) ? number_temp[22:0] : number[22:0] ;
always@(posedge Done_normalizer)
begin
    number_temp = 24'd0;
    count_temp = 6'd23-count;
    case(count_temp)
    6'd23 :number_temp[22:0] = number [22:0];
    6'd22 :number_temp[22:0] = {number [21:0],1'b0};
    6'd21 :number_temp[22:0] = {number [20:0],2'b00};
    6'd20 :number_temp[22:0] = {number [19:0],3'b000};
    6'd19 :number_temp[22:0] = {number [18:0],4'b0000};
    6'd18 :number_temp[22:0] = {number [17:0],5'b00000};
    6'd17 :number_temp[22:0] = {number [16:0],6'b000000};
    6'd16 :number_temp[22:0] = {number [15:0],7'b0000000};
    6'd15 :number_temp[22:0] = {number [14:0],8'b00000000};
    6'd14 :number_temp[22:0] = {number [13:0],9'b000000000};
    6'd13 :number_temp[22:0] = {number [12:0],10'b0000000000};
    6'd12 :number_temp[22:0] = {number [11:0],11'b00000000000};
    6'd11 :number_temp[22:0] = {number [10:0],11'b000000000000};
    6'd10 :number_temp[22:0] = {number [9:0],12'b000000000000};
    6'd9 :number_temp[22:0] = {number [8:0],13'b0000000000000};
    6'd8 :number_temp[22:0] = {number [7:0],14'b00000000000000};
    6'd7 :number_temp[22:0] = {number [6:0],15'b000000000000000};
    6'd6 :number_temp[22:0] = {number [5:0],16'b0000000000000000};
    6'd5 :number_temp[22:0] = {number [4:0],17'b00000000000000000};
    6'd4 :number_temp[22:0] = {number [3:0],18'b000000000000000000};
    6'd3 :number_temp[22:0] = {number [2:0],19'b0000000000000000000};
    6'd2 :number_temp[22:0] = {number [1:0],20'b00000000000000000000};
    6'd1 :number_temp[22:0] = {number [1:0],21'b000000000000000000000};   
    endcase
end
endmodule




module mantissa_divider ( input [23:0]Dividend ,input clk, input [23:0]Divisor,input [5:0]reset, output [23:0]quotient , output Done_wire, output [5:0]normalization_count_wires);
wire [31:0]tempA;
wire [31:0]tempB;
reg [31:0]reminder;
reg [31:0]reminder1;
reg [23:0]q;
wire Done_temp;
reg normalization_count_stop;
reg [5:0]count;
reg Done;
reg [5:0]normalization_count; 
assign normalization_count_wires[5:0]= normalization_count[5:0]; 
assign Done_wire = Done;
assign Done_temp=0;
assign tempA = {8'b00000000,Dividend[23:0]};                 //Mantissa of A extended
assign tempB = {8'b00000000,Divisor[23:0]};                //Mantissa of B extended
assign Done_temp = (count==6'b010111) ? 1'b0 : 1'b1;
assign quotient[22:0] = q[22:0];
always@(posedge clk)
begin
    if (reset)
    begin
        count = 6'b010111;
        reminder = 32'b00000000000000000000000000000000;
        q=24'b000000000000000000000000;
        reminder1 = 32'b00000000000000000000000000000000;
    end
    else if ( count== 6'b010111 & Done_temp ==1'b0 )
    begin   
        reminder1 = tempA -tempB ;
                if (reminder1[31] == 1'b0)  //checking if reminder>0
                begin
                    reminder = { reminder1[30:0], 1'b0 };
                    q[23]=1'b1;
                    Done= 1'b0;
                end
                else if ( reminder1 == 0 )   //checking if reminder =0 
                begin
                    q[23]=1'b1;
                    q[22:0] = 23'd0;
                    Done = 1'b1;
                end
                else                        //if reminder <0 
                begin
                    q[23] = 1'b0;
                    Done=1'b0;
                    reminder = { reminder1[30:0], 1'b0 };
                end 
                if(q[23]==0)   // normalization count start
                begin             
                    normalization_count = 6'b000001;
                    normalization_count_stop=1'b0;
                end
                else 
                begin
                    normalization_count = 0;    
                    normalization_count_stop=1'b1;    
                end        
                count=count-6'b000001;      //decrement the count
    end 
    else if ( count > 6'b000000 & Done == 1'b0)
    begin
                if(reminder[31] == 1'b0 )  //checking if reminder>0
                begin
                    reminder1 = reminder - tempB;
                    if ( reminder1[31]==1'b0 )  //checking if reminder>0
                    begin
                        q[count]=1'b1;
                        reminder = { reminder1[30:0], 1'b0};
                    end
                    else if (reminder1 ==0)begin  //checking if reminder=0
                        q[count]=1'b1;
                        Done = 1'b1;
                    end
                    else                        // if reminder<0
                        q[count]=1'b0;
                        reminder = { reminder1[30:0], 1'b0};
                end
                else                         // if reminder <0
                begin
                    reminder1 = reminder + tempB;
                    if ( reminder1[31]==1'b0 )   //checking if reminder>0
                    begin
                        q[count]=1'b1;
                        reminder = { reminder1[30:0], 1'b0};
                    end
                    else if (reminder1 ==0)begin //checking if reminder=0
                        q[count]=1'b1;
                        Done = 1'b1;
                    end
                    else                        // if reminder<0
                    begin
                        q[count]=1'b0;
                        reminder = { reminder1[30:0], 1'b0};
                    end
                end
                if(q[count]==0 & normalization_count_stop ==1'b0)             
                    normalization_count = normalization_count + 1;
                else 
                    normalization_count_stop = 1'b1;
                count=count-6'b000001;
    end
    else if( count == 6'b000000 & Done == 1'b0 )
    begin
                if(reminder[31]==1'b0 )         //checking if reminder>0
                begin
                    reminder1 = reminder - tempB;
                    if ( reminder1[31]==1'b0 )
                    begin                          //checking if reminder>0
                        q[0]=1'b1;
                        Done = 1'b1;
                    end
                    else if (reminder1 ==0)begin //checking if reminder=0
                        q[0]=1'b1;
                        Done = 1'b1;
                    end
                    else                        // if reminder<0
                    begin                      
                        q[0]=1'b0;  
                        Done = 1'b1;
                    end
                end
                else                            // if reminder<0
                begin
                    reminder1 = reminder + tempB;
                    Done = 1'b1;
                    if ( reminder1[31]==1'b0 )   //checking if reminder>0
                     begin
                        q[0]=1'b1;
                        Done = 1'b1;
                     end
                    else if(reminder1 ==0)
                    begin                       //checking if reminder>0
                        q[0]=1'b1;
                        Done = 1'b1;
                    end
                    else                        // if reminder<0
                        q[0]=1'b0;
                        Done = 1'b1;
                end
    end
    end

endmodule


//Testbench

module fp_main_divider_tb(
    );
    reg [31:0]A_tb;
    reg [31:0]B_tb;
    reg clk_tb;
    wire done_tb;
    wire [31:0]C_tb;
    wire [1:0]exceptions_tb;
    reg reset_tb;
    fp_main_divider uut(.InputA(A_tb), .InputB(B_tb) ,.CLOCK(clk_tb) ,.AbyB(C_tb) ,.DONE(done_tb), .RESET(reset_tb) ,.EXCEPTION(exceptions_tb));
    always
    begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end
    
    initial
    begin
    
    reset_tb=1'b1;
    #8
    reset_tb =1'b0;
    A_tb=32'b11011111110101010000000000000000;//Both Inputs normalized 
    B_tb=32'b11011001110001000000100000000000;
    #300
    
    reset_tb = 1'b1;
    #8
    reset_tb = 1'b0;
    A_tb= 32'b01111111100000000000000000000000;//infinite operation 
    B_tb= 32'b00111111100000000000000000000000;
    #300
    
    reset_tb = 1'b1;
    #8
    reset_tb = 1'b0;
    A_tb= 32'b00111111100000001000010000000101;//divide by 0
    B_tb= 32'b00000000000000000000000000000000; 
    #300
    
    reset_tb =1'b1;
    #8;
    reset_tb =1'b0;
    A_tb= 32'b01111111100010100000000000000000; //invalid operand
    B_tb= 32'b00101110000000100110011111000000;
    #300
    
    reset_tb = 1'b1;
    #8
    reset_tb=1'b0;
    B_tb= 32'b00000000100000000000000000000000;//subnormal Numerator
    A_tb= 32'b00000000010111011010110101010100;
    #300
    
    reset_tb = 1'b1;
    #8
    reset_tb = 1'b0;
    A_tb=32'b00000000001000000000000000000000;//Subnormal Numerator,Denominator 
    B_tb=32'b00000000010111110101011101110101;
    #300
    
    reset_tb =1'b1;
    #8
    reset_tb =1'b0;
    A_tb= 32'b00000000100000000000100000000000;//subnormalized result
    B_tb= 32'b00111111110000001000000000000000;
    #300
    
    reset_tb =1'b1;
    #8
    reset_tb =1'b0;
    A_tb=32'b00000000100000000010001000001000;//underflow
    B_tb=32'b01100111110100111100001000011100;
    #300
    
    reset_tb =1'b1;
    #8
    reset_tb =1'b0;
    A_tb = 32'b01111111011111111111111111111111;//overflow
    B_tb=32'b00111100101000111101011100001010;
    #300
    

    $stop;
    end
endmodule

