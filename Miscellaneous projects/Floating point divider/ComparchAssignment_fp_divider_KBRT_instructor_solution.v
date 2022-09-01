//code

module fp_module(input [31:0]inA,input [31:0]inB,input clk,input reset ,output [31:0]outC, output done );
assign outC[31]=inA[31]^inB[31];
assign outC[30:23] = inA[30:23] - inB[30:23]+7'b1111111;
reg done_temp;
wire [31:0]tempA;
wire [31:0]tempB;
reg [31:0]reminder;
reg [23:0]q;
reg [5:0]count;
assign tempA = {9'b000000001,inA[22:0]};                 //Mantissa of A 
assign tempB = {9'b000000001,inB[22:0]};                //Mantissa of B 
assign done = done_temp;
always@(posedge clk)
begin
    if (reset)
    begin
        count = 6'b010111;
        reminder = 32'b00000000000000000000000000000000;
        done_temp = 1'b0;
        q=24'b000000000000000000000000;
    end
    else if ( count == 6'b010111 & done_temp ==1'b0 )
    begin
        reminder = tempA -tempB ;
                if (reminder[31] == 1'b0)  //checking if reminder>0
                begin
                    reminder = { reminder[30:0], 1'b0 };
                    q[23]=1'b1;
                end
                else if ( reminder == 0 )   //checking if reminder =0 
                begin
                    q[23]=1'b1;
                    q[22:0] = 23'd0;
                    done_temp = 1'b1;
                end
                else                        //if reminder <0 
                begin
                    q[23] = 1'b0;
                    reminder = { reminder[30:0], 1'b0 };
                end
                count=count-6'b000001;      //decrement the count
    end 
    else if ( count > 6'b000000 & done_temp == 1'b0)
    begin
                if(reminder[31] == 1'b0 )  //checking if reminder>0
                begin
                    reminder = reminder - tempB;
                    if ( reminder[31]==1'b0 )  //checking if reminder>0
                    begin
                        q[count]=1'b1;
                        reminder = { reminder[30:0], 1'b0};
                    end
                    else if (reminder ==0)begin  //checking if reminder=0
                        q[count]=1'b1;
                        done_temp = 1'b1;
                    end
                    else                        // if reminder<0
                        q[count]=1'b0;
                        reminder = { reminder[30:0], 1'b0};
                end
                else                         // if reminder <0
                begin
                    reminder = reminder + tempB;
                    if ( reminder[31]==1'b0 )   //checking if reminder>0
                    begin
                        q[count]=1'b1;
                        reminder = { reminder[30:0], 1'b0};
                    end
                    else if (reminder ==0)begin //checking if reminder=0
                        q[count]=1'b1;
                        done_temp = 1'b1;
                    end
                    else                        // if reminder<0
                    begin
                        q[count]=1'b0;
                        reminder = { reminder[30:0], 1'b0};
                    end
                end
                count=count-6'b000001;
    end
    else if( count == 6'b000000 & done_temp == 1'b0 )
    begin
                if(reminder[31]==1'b0 )         //checking if reminder>0
                begin
                    reminder = reminder - tempB;
                    if ( reminder[31]==1'b0 )
                    begin                          //checking if reminder>0
                        q[0]=1'b1;
                        done_temp = 1'b1;
                    end
                    else if (reminder ==0)begin //checking if reminder=0
                        q[0]=1'b1;
                        done_temp = 1'b1;
                    end
                    else                        // if reminder<0
                    begin                      
                        q[0]=1'b0;  
                        done_temp = 1'b1;
                    end
                end
                else                            // if reminder<0
                begin
                    reminder = reminder + tempB;
                    done_temp = 1'b1;
                    if ( reminder[31]==1'b0 )   //checking if reminder>0
                     begin
                        q[0]=1'b1;
                        done_temp = 1'b1;
                     end
                    else if(reminder ==0)
                    begin                       //checking if reminder>0
                        q[0]=1'b1;
                        done_temp = 1'b1;
                    end
                    else                        // if reminder<0
                        q[0]=1'b0;
                        done_temp = 1'b1;
                end
    end
    end
        
assign outC[22:0] = q[22:0];
endmodule 

//test bench 

module fp_module_tb(
    );
    reg [31:0]inA_tb;
    reg [31:0]inB_tb;
    reg clk_tb;
    reg reset_tb;
    wire [31:0]outC_tb;
    wire done_tb;
    
    fp_module uut(.inA(inA_tb), .inB(inB_tb) ,.clk(clk_tb) ,.outC(outC_tb) ,.reset(reset_tb),.done(done_tb));
    always
    begin
        clk_tb = 0;
        forever #5 clk_tb = ~clk_tb;
    end
    
    initial
    begin
    reset_tb =1'b1;
    #8
    reset_tb =1'b0;
    inA_tb=32'b11011111110101010000000000000000;
    inB_tb=32'b11011001110001000000100000000000;
    #300 ;
    $stop;
    end
endmodule


