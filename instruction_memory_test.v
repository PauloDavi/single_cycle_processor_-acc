module instruction_memory_test();
    reg [5:0] address;
    reg clk;
    
    wire [9:0] instruction;
    
    always #1 clk = ~clk;
    
    instruction_memory dll(.clk(clk), .address(address), .instruction(instruction));
    
    initial begin
        clk     = 1'b1;
        address = 6'd0;
        
        #2
        address = 6'd10;
        
        #4
        address = 6'd20;
        
        #2 $stop;
    end
endmodule
