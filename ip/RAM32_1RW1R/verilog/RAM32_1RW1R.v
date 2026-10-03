
(* blackbox *)
module RAM32_1RW1R #(
    parameter WSIZE = 4
) (
    input  wire                 CLK,  // FO: 1
    input  wire [    WSIZE-1:0] WE0,  // FO: 1
    input                       EN0,  // FO: 1
    input                       EN1,
    input  wire [          4:0] A0,   // FO: 1
    input  wire [          4:0] A1,
    input  wire [(WSIZE*8-1):0] Di0,  // FO: 1
    output wire [(WSIZE*8-1):0] Do0,
    output wire [(WSIZE*8-1):0] Do1
);

endmodule

