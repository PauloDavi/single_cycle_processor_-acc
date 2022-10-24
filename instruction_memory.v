module instruction_memory #(parameter INSTRUCTION_WIDTH = 10,
                            parameter ADDR_BITS = 6,
                            parameter PROGRAM_FILE = "C:/Users/paulo/OneDrive/Documentos/faculdade/2022.2/arquitetura/program.txt")
                           (clk,
                            address,
                            instruction);
    input clk;
    input [ADDR_BITS - 1:0] address;
    output reg [INSTRUCTION_WIDTH - 1:0] instruction;
    
    reg [INSTRUCTION_WIDTH - 1:0] rom [(2 ** ADDR_BITS) - 1:0];
    
    initial $readmemb(PROGRAM_FILE, rom);
    
    always @(posedge clk) begin
        instruction = rom[address];
    end
endmodule
