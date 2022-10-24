module shift_register_test();
    reg clk, enable, reset, wr_enable;
    reg [7:0] data_in;
    
    wire output_data;
    
    always #1 clk = ~clk;
    
    shift_register dll(
    .clk(clk),
    .data_in(data_in),
    .enable(enable),
    .wr_enable(wr_enable),
    .reset(reset),
    .output_data(output_data));
    
    initial begin
        clk       = 1'b1;
        enable    = 1'b1;
        wr_enable = 1'b1;
        reset     = 1'b0;
        data_in   = 8'b00101010;
        
        #2
        wr_enable = 1'b0;
        data_in   = 8'b11111111;
		
		#9
        wr_enable = 1'b1;
		
		#10
        wr_enable = 1'b0;
        
        #22 $stop;
    end
endmodule
