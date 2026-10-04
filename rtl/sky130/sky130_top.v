module sky130_top (
    input clk,
    input rst,

    output reg [7:0] gpio
);
    wire [31:0] mem_addr;
    wire [31:0] cpu_write_data;
    wire mem_write_en;
    wire [2:0] mem_write_mask;
    reg [31:0] cpu_read_data;

    wire [31:0] inst_addr;
    wire [31:0] inst_read;

    reg [3:0] mem_decoded_mask;
    wire [31:0] mem_read_data;
    reg [31:0] mem_write_data;

    riscv_top core (
        .clk(clk),
        .rst(rst),

        .control_word(),

        .mem_addr(mem_addr),
        .mem_write_data(cpu_write_data),
        .mem_write_en(mem_write_en),
        .mem_write_mask(mem_write_mask),
        .mem_read_data(cpu_read_data),

        .inst_addr(inst_addr),
        .inst_read(inst_read),

        .cpu_stall(1'b0)
    );

    always_comb begin
        case (mem_write_mask)
            `MEM_WIDTH_BYTE: mem_decoded_mask = 4'b0001;
            `MEM_WIDTH_HALF: mem_decoded_mask = 4'b0011;
            default: mem_decoded_mask = 4'b1111;
        endcase
    end

    always @(*) begin
        case (mem_addr[31:24])
            8'hff: begin
                cpu_read_data = {24'b0, gpio};
                gpio = cpu_write_data[7:0];
            end
            default: begin
                cpu_read_data  = mem_read_data;
                mem_write_data = cpu_write_data;
            end
        endcase

    end

    (* keep *)
    sky130_sram_2kbyte_1rw1r_32x512_8 imem (
        .clk0  (1'b0),
        .csb0  (1'b1),
        .web0  (1'b1),
        .wmask0(4'b0000),
        .addr0 (9'b0),
        .din0  (9'b0),
        .dout0 (),

        .clk1 (clk),
        .csb1 (1'b0),
        .addr1(inst_addr),
        .dout1(inst_read)
    );


    (* keep *)
    sky130_sram_2kbyte_1rw1r_32x512_8 dmem (
        .clk0  (clk),
        .csb0  (1'b0),
        .web0  (~mem_write_en),
        .wmask0(mem_decoded_mask),
        .addr0 (mem_addr),
        .din0  (mem_write_data),
        .dout0 (mem_read_data),

        .clk1 (1'b0),
        .csb1 (1'b1),
        .addr1(9'b0),
        .dout1()
    );

endmodule
