module reg_file_test();
    reg [7:0] data;
    reg [1:0] destination_select, a_select, b_select;
    reg load_enable, clk, reset;
    
    wire [7:0] a_data, b_data;
    
    always #1 clk = ~clk;
    
    reg_file dll (
    .data(data),
    .clk(clk),
    .load_enable(load_enable),
    .destination_select(destination_select),
    .a_select(a_select),
    .b_select(b_select),
    .reset(reset),
    .a_data(a_data),
    .b_data(b_data));
    
    initial begin
        clk                = 1'b1;
        reset              = 1'b0;
        a_select           = 2'b0;
        b_select           = 2'b0;
        data               = 8'd100;
        destination_select = 2'b0;
        load_enable        = 1'b1;
        
        #5
        data               = 8'd50;
        destination_select = 2'b1;
        load_enable        = 1'b1;
        
        #2
        load_enable = 1'b0;
        a_select    = 2'b0;
        b_select    = 2'b1;
        
        #2
        reset = 1'b1;
        
        #2 $stop;
    end
endmodule
