module immediate_gen(instruction,immediate);
    input [31:0] instruction;
    output reg [31:0] immediate;
    always @(*) begin
        if(instruction[6:0]==7'b0010011 || instruction[6:0]==7'b0011011 ) //I type
        immediate = instruction[31:20]; 
        else if(instruction[6:0]==7'b0100011)//S type
        immediate = {instruction[31:25],instruction[11:7]};
        else if(instruction[6:0]==7'b0111000)//U type
        immediate = instruction[31:12];
        else if(instruction[6:0]==7'b1101111)//SB type
        immediate={instruction[31],instruction[7],instruction[30:25],instruction[11:6]};
        else if(instruction[6:0]==7'b1100011)//UJ type
      immediate={instruction[31],instruction[22:13],instruction[23],instruction[30:24]};

    end

endmodule // immediate_gen


module stimulus();
    reg [31:0] instruction;
    wire [31:0] immediate;

    immediate_gen generator1(instruction, immediate);

    initial begin
        // Test case 1: I-Type (ADDI)
        instruction = 32'b00010000000000010000000010010011;
        #1;
        $display("Test case 1: Instruction = %b, Immediate = %b", instruction, immediate);
        

        // Test case 2: S-Type (SB)
        instruction = 32'b00000001111000001000000010100011; 
        #1;
        $display("Test case 3: Instruction = %b, Immediate = %b", instruction, immediate);
        
        // Test case 3: U-Type (BEQ)
        instruction = 32'b00000001111100001000000000111000; 
        #1;
        $display("Test case 4: Instruction = %b, Immediate = %b", instruction, immediate);
        
        // Test case 4: UJ-Type (JAL)
        instruction = 32'b00000010000000000000000001100011; 
        #1;
        $display("Test case 5: Instruction = %b, Immediate = %b", instruction, immediate);
        
        // Test case 5: SB-Type (SB)
        instruction = 32'b00000010000000000000000001101111; 
        #1;
        $display("Test case 5: Instruction = %b, Immediate = %b", instruction, immediate);
        
        $finish; // End simulation
    end
endmodule

