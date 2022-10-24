module pc_test();
    reg [5:0] jump_value;
    reg jump_enable, clk, reset;
    
    wire [5:0] pc_count;
    
    always #1 clk = ~clk;
    
    pc dll(
    .clk(clk),
    .reset(reset),
    .jump_enable(jump_enable),
    .jump_value(jump_value),
    .pc_count(pc_count));
    
    initial begin
        clk         = 1'b1;
        jump_value  = 6'd0;
        reset       = 1'b0;
        jump_enable = 1'b0;
        
        #4
        jump_enable = 1'b1;
        jump_value  = 6'd30;
        
        #2
        jump_enable = 1'b0;
        
        #2
        reset = 1'b1;
        
        #2
        reset = 1'b0;
        
        #2 $stop;
    end
endmodule
