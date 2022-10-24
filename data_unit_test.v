module data_unit_test();
    reg clk, load_enable, mb_select, md_select, write_ram_enable, reset;
    reg [1:0] a_select, b_select, destination_select;
    reg [7:0] constant_in;
    reg [2:0] operation_select;
    
    wire zero_flag, carrier_flag, negative_flag;
    wire [7:0] output_data;
    
    always #1 clk = ~clk;
    
    data_unit dll (
    .clk(clk),
    .reset(reset),
    .load_enable(load_enable),
    .operation_select(operation_select),
    .a_select(a_select),
    .b_select(b_select),
    .destination_select(destination_select),
    .constant_in(constant_in),
    .mb_select(mb_select),
    .md_select(md_select),
    .write_ram_enable(write_ram_enable),
    .output_data(output_data),
    .zero_flag(zero_flag),
    .carrier_flag(carrier_flag),
    .negative_flag(negative_flag));
    
    initial begin
        clk                = 1'b1;
        reset              = 1'b0;
        operation_select   = 3'b100;
        load_enable        = 1'b1;
        mb_select          = 1'b1;
        md_select          = 1'b0;
        write_ram_enable   = 1'b0;
        a_select           = 2'b00;
        b_select           = 2'b01;
        destination_select = 2'b00;
        constant_in        = 8'd10;
        
        #2
        constant_in        = 8'd20;
        destination_select = 2'b01;
        
        #2
        mb_select          = 1'b0;
        operation_select   = 3'b000;
        a_select           = 2'b00;
        b_select           = 2'b01;
        destination_select = 2'b00;
        
        #2
        mb_select          = 1'b0;
        a_select           = 2'b00;
        b_select           = 2'b01;
        destination_select = 2'b01;
        md_select          = 1'b1;
        
        #2
        mb_select          = 1'b0;
        a_select           = 2'b00;
        b_select           = 2'b01;
        destination_select = 2'b00;
        md_select          = 1'b1;
        write_ram_enable   = 1'b1;
        load_enable        = 1'b0;
        
        #2 $stop;
    end
endmodule
