module pc_register(clk, reset_n, write_enable, data_in, data_out);
input clk,reset_n,write_enable;
input [31:0] data_in;
output reg[31:0] data_out;
reg [31:0] register_data;
always@(posedge clk)begin
if(reset_n==1)begin
register_data=0;
end
else if (write_enable==1)begin
register_data=data_in;
end
data_out=register_data;
end
endmodule // pc_register

module stimulus();

    reg clk;
    reg reset_n;
    reg write_enable;
    reg [31:0] data_in;
    wire [31:0] data_out;

    pc_register dut (clk,reset_n,write_enable,data_in,data_out);

    // Clock generation
    always begin
        clk = 0;
        #5;  // Delay of 5 time units
        clk = 1;
        #5;  // Delay of 5 time units
    end

    // Testbench initial block
    initial begin
        // Initialize inputs
        reset_n = 0;
        write_enable = 0;
        data_in = 32'h0000_0001; // Example input data

        
        reset_n = 1;
        #10

        // Test case 1: Reset and no write
        $display("Test Case 1: Reset and no write");
        $display("Time=%0t, data_out=%h", $time, data_out);
        reset_n = 0;
        #10
        // Test case 2: Write operation
        $display("Test Case 2: Write operation");
        write_enable = 1;
        data_in=32'b11011010010110001001011010101101;
        #10;
        $display("Time=%0t, data_out=%h", $time, data_out);


        // End simulation
        $finish;
    end

endmodule 
