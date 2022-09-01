

//module for data memory


module Data_memory(
    input MemRead,  //enable for Memory read
    input MemWrite, //enable for Memory write
    //input clk,
    input [15:0] Address,  //Address to be read/written into
    input [15:0] Write_Data,  //data to be written
    output reg [15:0] MDR  
    );
    reg [7:0] storage [0:65535];  //64kB of data memory storage
    
    initial begin
        $readmemh("/home/v/Documents/FPGA/OurProcessorRISCKY/dummy.dat",storage);  //Inititaling Data memory with dummy.dat file  
    end
    
    always @(MemWrite,Address,Write_Data) begin
        if(MemWrite==1'b1)
           {storage[Address+1],storage[Address]} = Write_Data;  //writing data from appropriate address of storage
    

    end
    
    always@(MemRead,Address)
    begin
        if ( MemRead == 1'b1)
          MDR = {storage[Address+1],storage[Address]};  //reading data from appropriate address of storage
    

    end
    
endmodule

module mdr_latch(input [15:0] datain,output reg [15:0] dataout,input MDRwrite);  //MDR latch(latch was designed for the same reason as for PC), MDRwrite is enabling write into MDR
always @(MDRwrite,datain) begin
    if(MDRwrite == 1'b1) dataout = datain;
end
endmodule

