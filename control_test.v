module control_test();
    reg clk;
    
    wire [7:0] output_data;
    
    always #1 clk = ~clk;
    
    initial begin
        clk = 1'b1;
        
        #20 $stop;
    end
    
    control dll(.clk(clk), .output_data(output_data));
    
endmodule
