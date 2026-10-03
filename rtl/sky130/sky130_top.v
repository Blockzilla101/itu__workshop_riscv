module sky130_top (
    input clk,
    input rst,

    output [31:0] mem_addr,
    output [31:0] mem_write_data,
    output mem_write_en,
    output [2:0] mem_write_mask,
    input [31:0] mem_read_data,

    output [31:0] inst_addr,
    input  [31:0] inst_read
);

    riscv_top riscv (
        .clk(clk),
        .rst(rst),
        .control_word(),
        .mem_addr(mem_addr),
        .mem_write_data(mem_write_data),
        .mem_write_en(mem_write_en),
        .mem_write_mask(mem_write_mask),
        .mem_read_data(mem_read_data),
        .inst_addr(inst_addr),
        .inst_read(inst_read),
        .cpu_stall(1'b0)
    );

endmodule
