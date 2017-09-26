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

    output        seg_a,
    output        seg_b,
    output        seg_c,
    output        seg_d,
    output        seg_e,
    output        seg_f,
    output        seg_g,

    output [ 7:0] anodes
);

    assign led = sw;

    assign { seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g } = ~ sw [6:0];

    assign anodes = ~ sw [15:8];

endmodule
