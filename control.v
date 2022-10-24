module control #(parameter INTRUCTION_WIDTH = 10,
                 parameter DATA_WIDTH = 8,
                 parameter ADDR_BITS_WIDTH = 6,
                 parameter OPERATIONS_SELECTOR_WIDTH = 3)
                (clk,
                 output_data,
                 output_enable);
    input clk;
    
    output reg output_enable;
    output [DATA_WIDTH - 1:0] output_data;
    
    reg md_select, mb_select, ram_enable, load_enable, reset, jump_enable;
    reg [OPERATIONS_SELECTOR_WIDTH - 1:0] operation_select, selector_reg_a, selector_reg_b, destination_select;
    reg [DATA_WIDTH - 1:0] constant_in;
    reg [ADDR_BITS_WIDTH - 1:0] jump_value, pc_count;
    
    wire [INTRUCTION_WIDTH - 1:0] instruction;
    wire [ADDR_BITS_WIDTH - 1:0] pc_count_wire;
    wire zero_flag, carrier_flag, negative_flag;
    
    data_unit #(DATA_WIDTH, ADDR_BITS_WIDTH, OPERATIONS_SELECTOR_WIDTH) data_unit_instance (
    .clk(clk),
    .reset(reset),
    .load_enable(load_enable),
    .operation_select(operation_select),
    .a_select(selector_reg_a),
    .b_select(selector_reg_b),
    .destination_select(destination_select),
    .constant_in(constant_in),
    .mb_select(mb_select),
    .md_select(md_select),
    .write_ram_enable(ram_enable),
    .output_data_wire(output_data),
    .zero_flag(zero_flag),
    .carrier_flag(carrier_flag),
    .negative_flag(negative_flag));
    
    instruction_memory #(INTRUCTION_WIDTH, ADDR_BITS_WIDTH) instruction_memory_instance (
    .clk(clk),
    .address(pc_count),
    .instruction(instruction));
    
    pc #(ADDR_BITS_WIDTH)  pc_instance (
    .clk(clk),
    .reset(reset),
    .jump_enable(jump_enable),
    .jump_value(jump_value),
    .pc_count(pc_count_wire));
    
    always @(pc_count_wire) begin
        pc_count <= pc_count_wire;
    end
    
    initial begin
        md_select          = 1'b0;
        mb_select          = 1'b0;
        ram_enable         = 1'b0;
        load_enable        = 1'b0;
        reset              = 1'b0;
        jump_enable        = 1'b0;
        operation_select   = 3'b000;
        selector_reg_a     = 3'b000;
        selector_reg_b     = 3'b000;
        destination_select = 3'b000;
        jump_value         = 6'b000000;
        constant_in        = 8'b00000000;
    end
    
    always @(posedge clk) begin
        case (instruction[9:6])
            4'b0000: begin // ADD
                operation_select   <= 3'b000;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                selector_reg_b     <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b0;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b0001: begin // SUB
                operation_select   <= 3'b001;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                selector_reg_b     <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b0;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b0010: begin // ADDi
                operation_select   <= 3'b000;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                constant_in        <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b1;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b0011: begin // SUBi
                operation_select   <= 3'b001;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                constant_in        <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b1;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b0100: begin // MUL2
                operation_select   <= 3'b010;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                constant_in        <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b1;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b0101: begin //DIV2
                operation_select   <= 3'b011;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                constant_in        <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b1;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b0110: begin // CLR
                operation_select   <= 3'b100;
                destination_select <= instruction[5:3];
                constant_in        <= 3'b000;
                output_enable      <= 1'b0;
                mb_select          <= 1'b1;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b0111: begin // RST
                reset         <= 1'b0;
                output_enable <= 1'b0;
            end
            4'b1000: begin // MOV
                operation_select   <= 3'b100;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[2:0];
                selector_reg_b     <= instruction[5:3];
                output_enable      <= 1'b0;
                mb_select          <= 1'b0;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b1001:begin // JMP
                jump_value    <= instruction[5:0];
                output_enable <= 1'b0;
                jump_enable   <= 1'b1;
                ram_enable    <= 1'b0;
                load_enable   <= 1'b0;
                reset         <= 1'b0;
            end
            4'b1010: begin // OUT
                output_enable <= 1'b1;
                reset <= 1'b0;
            end
            4'b1011: begin // LOAD
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                selector_reg_b     <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b0;
                md_select          <= 1'b1;
                ram_enable         <= 1'b1;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b1100: begin // STORE
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                selector_reg_b     <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b0;
                md_select          <= 1'b0;
                ram_enable         <= 1'b1;
                load_enable        <= 1'b0;
                reset              <= 1'b0;
            end
            4'b1101: begin // AND
                operation_select   <= 3'b101;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                selector_reg_b     <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b0;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b1110: begin // OR
                operation_select   <= 3'b110;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                selector_reg_b     <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b0;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
            4'b1111: begin // XOR
                operation_select   <= 3'b111;
                destination_select <= instruction[5:3];
                selector_reg_a     <= instruction[5:3];
                selector_reg_b     <= instruction[2:0];
                output_enable      <= 1'b0;
                mb_select          <= 1'b0;
                md_select          <= 1'b0;
                ram_enable         <= 1'b0;
                load_enable        <= 1'b1;
                reset              <= 1'b0;
            end
        endcase
    end
endmodule
