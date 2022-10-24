module procesor #(parameter INTRUCTION_WIDTH = 10,
                  parameter DATA_WIDTH = 8,
                  parameter ADDR_BITS_WIDTH = 6,
                  parameter OPERATIONS_SELECTOR_WIDTH = 3)
                  (clk,
                  shift_output_data);
    input clk;

    output shift_output_data;

    wire output_enable;
    wire [DATA_WIDTH - 1:0] output_data;

    control #(INTRUCTION_WIDTH, DATA_WIDTH, ADDR_BITS_WIDTH, OPERATIONS_SELECTOR_WIDTH) control_instance (
      .clk(clk),
      .output_data(output_data),
      .output_enable(output_enable));

    shift_register #(DATA_WIDTH) shift_register_instance (
      .clk(clk),
      .data_in(output_data),
      .enable(1'b1),
      .wr_enable(output_enable),
      .reset(1'b0),
      .output_data(shift_output_data));
endmodule