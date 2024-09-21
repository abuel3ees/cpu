module register_file(clk, reset_n, read_addr1, read_addr2, write_addr, write_enable, write_data, read_data1, read_data2);
    input clk;
    input reset_n;
    input [4:0] read_addr1; 
    input [4:0] read_addr2;
    input [4:0] write_addr;
    input write_enable;
    input [63:0] write_data;
    output reg [63:0] read_data1;
    output reg [63:0] read_data2;
    reg [63:0] registers[31:0]; 
    
    always@(posedge clk) begin
     if(reset_n==1)begin
     for(integer i=0;i<32;i=i+1)
     registers[i]=0;
     end
     else begin 
     read_data1<=registers[read_addr1];
     read_data2<=registers[read_addr2];
     end
    if(write_enable==1)begin
    registers[write_addr]=write_data;
    end
    end
    endmodule //register_file
    
    module testbench();

    reg clk;
    reg reset_n;
    reg [4:0] read_addr1, read_addr2, write_addr;
    reg write_enable;
    reg [63:0] write_data;
    wire [63:0] read_data1, read_data2;

    register_file dut(clk,reset_n,read_addr1,read_addr2,write_addr,write_enable,write_data,read_data1,read_data2);

   
    
    always #5 clk = ~clk; 


    
    initial begin
      
        clk = 0;
        reset_n = 0;
        read_addr1 = 0;
        read_addr2 = 1;
        write_addr = 2;
        write_enable = 0;
        write_data = 64'h1234567890ABCDEF;

        //Test case 1: Reset
        #10 reset_n = 1;
        #20 $display("Initial register contents:");
        #20
            for (integer i = 0; i < 32; i = i + 1) begin
                $display("Register[%d]: %b", i, dut.registers[i]);
            end
            $display("Time=%0t, read_data1=%h, read_data2=%h", $time, read_data1, read_data2);
        
        // Test case 2: Read Operation
        #20;
        reset_n=0;
        read_addr1 = 5;
        read_addr2 = 10;
        dut.registers[read_addr1]=12;
        dut.registers[read_addr2]=14;
        #20 $display("Register contents after reads:");
        #20  for (integer i = 0; i < 32; i = i + 1) begin
                $display("Register[%d]: %b", i, dut.registers[i]);
            end
            $display("Time=%0t, read_data1=%b, read_data2=%b", $time, read_data1, read_data2);

        // Test Case 3: Write Operation
        reset_n=1;
        write_addr = 2;
        write_enable = 1;
        write_data = 64'hAA55AA55AA55AA55;
        #20 write_enable = 1;
        reset_n=0;
        #20 $display("Register contents after write:");
        #20 for (integer i = 0; i < 32; i = i + 1) begin
                $display("Register[%d]: %b", i, dut.registers[i]);
            end
            $display("The value written in register %d is %b",write_addr, write_data);

        #20 $finish;
    end

    

endmodule 
