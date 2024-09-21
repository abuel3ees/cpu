module instruction_memory (clk,address,read_data );
    input clk;
    input [13:0] address;
    output reg [7:0] read_data;
    reg [7:0] mem [0:16383]; 

    always @(posedge clk) begin
        if (address < 16384) begin
            read_data <= mem[address]; 
        end else begin
            read_data <= 8'h00; 
        end
    end
endmodule

module stimulus();
    reg clk;
    reg [13:0] address; 
    wire [7:0] read_data; 

    instruction_memory mem1(clk, address, read_data);

    always #1 clk = ~clk;

    initial begin
        
        clk = 0;

      
        mem1.mem[4096] = 8'h12; 
        mem1.mem[4097] = 8'h00; 
        mem1.mem[4098] = 8'h00; 
        mem1.mem[4099] = 8'h00; 

        mem1.mem[8192] = 8'h34; 
        mem1.mem[8193] = 8'h00; 
        mem1.mem[8194] = 8'h00; 
        mem1.mem[8195] = 8'h00; 

        mem1.mem[12288] = 8'h56;
        mem1.mem[12289] = 8'h00; 
        mem1.mem[12290] = 8'h00; 
        mem1.mem[12291] = 8'h00; 

       
        #50; 

        // Test case 1: Read from address 4096
        address = 4096; 
        #10; 
        $display("The read data from address %d is %h", address, read_data);
        
        // Test case 2: Read from address 8192
        #10;
        address = 8192; 
        #10; 
        $display("The read data from address %d is %h", address, read_data);
        
        // Test case 3: Read from address 12288
        #10;
        address = 12288;
        #10; 
        $display("The read data from address %d is %h", address, read_data);
        
        $finish;
    end
endmodule
