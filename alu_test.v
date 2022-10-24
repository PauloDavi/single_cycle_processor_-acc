module alu_test();
    reg [7:0]reg_a, reg_b;
    reg [2:0]select;
    
    wire [7:0] out;
    wire zero_flag, carrier_flag, negative_flag;
    
    alu dll(
    .reg_a(reg_a),
    .reg_b(reg_b),
    .select(select),
    .out(out),
    .zero_flag(zero_flag),
    .carrier_flag(carrier_flag),
    .negative_flag(negative_flag));
    
    initial begin
        reg_a  <= 8'd10;
        reg_b  <= 8'd20;
        select <= 3'd0;
        
        #1
        reg_a  <= 8'd30;
        reg_b  <= 8'd40;
        select <= 3'd1;
        
        #1
        reg_a  <= 8'd30;
        reg_b  <= 8'd30;
        select <= 3'd1;
        
        #1
        reg_a  <= 8'd50;
        reg_b  <= 8'd2;
        select <= 3'd2;
        
        #1
        reg_a  <= 8'd150;
        reg_b  <= 8'd5;
        select <= 3'd3;
        
        #1
        reg_b  <= 8'd30;
        select <= 3'd4;
        
        #1
        reg_a  <= 8'b00001111;
        reg_b  <= 8'b00000101;
        select <= 3'd5;
        
        #1
        reg_a  <= 8'b00100100;
        reg_b  <= 8'b10001000;
        select <= 3'd6;
        
        #1
        reg_a  <= 8'b00110011;
        reg_b  <= 8'b01110100;
        select <= 3'd7;
        
        #1 $stop;
    end
endmodule
