module ram_test();
    reg [5:0] address;
    reg [7:0] input_data;
    reg clk, write_enable;
    
    wire [7:0] output_data;
    
    always #1 clk = ~clk;
    
    ram dll (
    .clk(clk),
    .write_enable(write_enable),
    .address(address),
    .input_data(input_data),
    .output_data(output_data));
    
    initial begin
        clk          = 1'b1;
        address      = 6'd0;
        input_data   = 8'd0;
        write_enable = 1'b0;
        
        #4
        address = 6'd34;
        
        #2
        address = 6'd63;
        
        #2
        address      = 6'd3;
        write_enable = 1'b1;
        input_data   = 8'd10;
        
        #2
        write_enable = 1'b0;
        address      = 6'd3;
        
        #2 $stop;
    end
endmodule
