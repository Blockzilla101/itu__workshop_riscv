`timescale 1ns / 1ps

module register_file (
    input clk,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] write_data,
    input write_enable,
    output [31:0] rs1_data,
    output [31:0] rs2_data
);
`ifdef ASIC
    (* keep *)
    RAM32_1RW1R reg_file (
        .CLK(clk),
        .WE0(write_enable),
        .EN0(1'b1),
        .EN1(1'b1),
        .A0 (rs1),
        .A1 (rs2),
        .Di0(write_data),
        .Do0(rs1_data),
        .Do1(rs2_data)
    );
`else
    reg [31:0] registers[0:31];

    // initial begin
    //     integer i;
    //     for (i = 1; i < 32; i = i + 1) begin
    //         registers[i] = 32'b0;
    //     end
    // end

    always @(posedge clk) begin
        if (write_enable && rd != 5'd0) registers[rd] <= write_data;
    end

    assign rs1_data = rs1 == 5'd0 ? 32'b0 : registers[rs1];
    assign rs2_data = rs2 == 5'd0 ? 32'b0 : registers[rs2];

`endif
endmodule
