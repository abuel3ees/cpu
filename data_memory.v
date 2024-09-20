module data_memory(clk,reset_n,address,write_enable,read_enable,write_data,read_data);
    input clk;
    input reset_n;
    input [11:0] address;
    input [1:0] write_enable;
    input [1:0] read_enable;
    input [7:0] write_data;
    output reg [7:0] read_data;
    reg [31:0] mem[4095:0]; 

    always @(posedge clk) begin
        if (reset_n == 1'b1) begin
            
            for (integer i = 0; i < 4096; i = i + 1)
                mem[i] <= 0;
        end
        else begin
            if(write_enable==2'b10)
            mem[address] <= {write_data, write_data, write_data, write_data};  
            else if(write_enable==2'b01) 
            mem[address][7:0] <= write_data; 
            if (read_enable==2'b01)
                read_data <= mem[address][7:0];
            else if (read_enable==2'b01) 
                read_data <= mem[address][31:0];
        end
    end
endmodule

module stimulus();
    reg clk;
    reg reset_n;
    reg [11:0] address;
    reg [1:0] write_enable;
    reg [1:0] read_enable;
    reg [7:0] write_data;
    wire [7:0] read_data;

    data_memory dut(clk,reset_n,address,write_enable,read_enable,write_data,read_data);

    always #5 clk = ~clk;

    initial begin
    clk = 0;
    reset_n = 1;
    address = 0;
    write_enable = 2'b00;
    read_enable = 2'b00;
    write_data = 8'h00;
    #10;

    // Test case 1: Write to memory (byte)
    reset_n = 0;
    #20;
    address = 16; 
    write_enable = 2'b01;
    write_data = 8'hAA; 
    #20;
    write_enable = 2'b00;
    $display("Memory contents after writing byte (Address 16): %h", dut.mem[16]);

    // Test case 2: Read byte from memory
    address = 16;
    read_enable = 2'b01;
    #10;
    read_enable = 2'b00; 
    $display("Read byte from address 16: %h", read_data);
    $display("-------------------------------------------------------");

    // Test case 3: Write to memory (word)
    address = 32;
    write_enable = 2'b10; 
    write_data = 8'hFF; 
    #20;
    write_enable = 2'b00; 
    $display("Memory contents after writing word (Address 32): %h", dut.mem[32]);

    // Test case 4: Read word from memory
    address = 32;
    read_enable = 2'b10;
    #10;
    read_enable = 2'b00; 
    $display("Read word from address 32: %h", read_data);
    $display("-------------------------------------------------------");

    // Test case 5: Reset and check memory contents
    #20;
    reset_n = 1; 
    #40;
    $display("Memory contents after reset:");
    for (integer i = 0; i < 32; i=i+1) begin
        $display("Address %d: %h", i, dut.mem[i]);
    end
    $finish;
end
endmodule
