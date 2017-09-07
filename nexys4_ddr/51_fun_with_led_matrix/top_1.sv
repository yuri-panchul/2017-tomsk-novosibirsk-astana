module top_1
(
    input         clk,
    input         reset_n,

    input         btn_up,
    input         btn_down,
    input         btn_left,
    input         btn_right,
    input         btn_center,

    input  [15:0] sw, 

    output [15:0] led,

    output        led16_b,
    output        led16_g,
    output        led16_r,
    output        led17_b,
    output        led17_g,
    output        led17_r,

    output        seg_a,
    output        seg_b,
    output        seg_c,
    output        seg_d,
    output        seg_e,
    output        seg_f,
    output        seg_g,

    output [ 7:0] anodes,

    inout  [12:1] ja,
    inout  [12:1] jb
);

    assign led = sw;

    assign led16_b = 0;
    assign led16_g = 0;
    assign led16_r = 0;
    assign led17_b = 0;
    assign led17_g = 0;
    assign led17_r = 0;

    assign { seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g } = ~ sw [6:0];

    assign anodes = ~ sw [15:8];

    wire [7:0] rows, cols;

    assign rows = sw [7:0];
    assign cols = sw [15:8];

    assign ja [ 4:1] = { ~ cols [5], ~ cols [6],   rows [1],   rows [3] };
    assign ja [10:7] = {   rows [5],   rows [2], ~ cols [3],   rows [0] };
    assign jb [ 4:1] = {   rows [7], ~ cols [4], ~ cols [2],   rows [4] };
    assign jb [10:7] = { ~ cols [7],   rows [6], ~ cols [1], ~ cols [0] };

endmodule
