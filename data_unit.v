module data_unit #(parameter DATA_WIDTH = 8,
                   parameter RAM_ADDR_BITS = 6,
                   parameter OPERATION_WIDTH = 3)
                  (clk,
                   reset,
                   load_enable,
                   operation_select,
                   a_select,
                   b_select,
                   destination_select,
                   constant_in,
                   mb_select,
                   md_select,
                   write_ram_enable,
                   output_data_wire,
                   zero_flag,
                   carrier_flag,
                   negative_flag);
    input clk, load_enable, mb_select, md_select, write_ram_enable, reset;
    input [1:0] a_select, b_select, destination_select;
    input [DATA_WIDTH - 1:0] constant_in;
    input [OPERATION_WIDTH - 1:0] operation_select;
    
    output wire zero_flag, carrier_flag, negative_flag;
    reg [DATA_WIDTH - 1:0] output_data;
    output [DATA_WIDTH - 1:0] output_data_wire;
    
    reg [DATA_WIDTH - 1:0] data_in;
    wire [DATA_WIDTH - 1:0] out_alu, reg_a, reg_b, ram_output_data;
    
    reg_file #(DATA_WIDTH, 2) reg_file_instance (
    .data(output_data_wire),
    .clk(clk),
    .load_enable(load_enable),
    .destination_select(destination_select),
    .a_select(a_select),
    .b_select(b_select),
    .reset(reset),
    .a_data(reg_a),
    .b_data(reg_b));
    
    alu #(DATA_WIDTH) alu_instance (
    .reg_a(reg_a),
    .reg_b(data_in),
    .select(operation_select),
    .out(out_alu),
    .zero_flag(zero_flag),
    .carrier_flag(carrier_flag),
    .negative_flag(negative_flag));
    
    ram #(DATA_WIDTH, RAM_ADDR_BITS) ram_instance (
    .clk(clk),
    .write_enable(write_ram_enable),
    .address(reg_a[5:0]),
    .input_data(data_in),
    .output_data(ram_output_data));
    
    always @(*) begin
        if (mb_select == 0)
            data_in = reg_b;
        else
            data_in = constant_in;
    end
    
    always @(*) begin
        if (md_select == 0)
            output_data = out_alu;
        else
            output_data = ram_output_data;
    end
    
    assign output_data_wire = output_data;
endmodule
