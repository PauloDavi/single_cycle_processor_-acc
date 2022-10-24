module ram #(parameter RAM_WIDTH = 8,
             parameter RAM_ADDR_BITS = 6,
             parameter DATA_FILE = "C:/Users/paulo/OneDrive/Documentos/faculdade/2022.2/arquitetura/ram_data.txt")
            (clk,
             write_enable,
             address,
             input_data,
             output_data);
    input clk, write_enable;
    input [RAM_ADDR_BITS - 1:0] address;
    input [RAM_WIDTH - 1:0] input_data;
    
    output reg [RAM_WIDTH - 1:0] output_data;
    
    reg [RAM_WIDTH - 1:0] ram_data [(2 ** RAM_ADDR_BITS) - 1:0];
    
    initial $readmemb(DATA_FILE, ram_data);
    
    always @(posedge clk) begin
        if (write_enable)
            ram_data[address] = input_data;
        
        output_data = ram_data[address];
    end
endmodule
