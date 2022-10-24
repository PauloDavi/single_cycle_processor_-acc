module shift_register #(parameter DATA_WIDTH = 8)
                       (clk,
                        data_in,
                        enable,
                        wr_enable,
                        reset,
                        output_data);
    input [DATA_WIDTH - 1:0] data_in;
    input clk, enable, wr_enable, reset;
    
    output output_data;
    
    reg [DATA_WIDTH - 1:0] buffer;
    
    assign output_data = (enable) ? buffer[DATA_WIDTH-1] : 1'hz;
    
    always @ (posedge clk) begin
        if (reset)
            buffer <= {DATA_WIDTH{1'h0}};
        else if (wr_enable)
            buffer <= data_in;
        else if (enable)
            buffer <= {buffer[DATA_WIDTH - 2:0], 1'h0};
	end
endmodule
