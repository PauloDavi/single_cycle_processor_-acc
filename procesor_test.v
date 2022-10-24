module procesor_test();
    reg clk;
    
    wire shift_output_data;
    
    always #1 clk = ~clk;
    
    shift_register dll(
    .clk(clk),
    .shift_output_data(shift_output_data));
    
    initial begin
        clk = 1'b1;
        
        #22 $stop;
    end
endmodule
