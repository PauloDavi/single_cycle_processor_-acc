module pc #(parameter PC_COUNT_WIDTH = 6)
           (clk,
            reset,
            jump_enable,
            jump_value,
            pc_count);
    input clk, reset, jump_enable;
    input [PC_COUNT_WIDTH - 1:0] jump_value;
    
    output reg [PC_COUNT_WIDTH - 1:0] pc_count;
    
    initial begin
        pc_count = 0;
    end
    
    always@ (posedge clk or posedge reset) begin
        if (reset)
            pc_count = 0;
        else begin
            if (jump_enable)
                pc_count = jump_value;
            else
                pc_count = pc_count + 1;
        end
    end
endmodule
