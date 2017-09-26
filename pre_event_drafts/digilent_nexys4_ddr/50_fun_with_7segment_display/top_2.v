module timer_23
(
    input  clk,
    input  reset_n,
    output strobe
);

    reg [22:0] counter;

    always @(posedge clk or negedge reset_n)
    begin
        if (! reset_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign strobe = (counter == 0);

endmodule

module top_2
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

    wire clk_enable;

    timer_23 i_timer
    (
        .clk     ( clk        ),
        .reset_n ( reset_n    ),
        .strobe  ( clk_enable )
    );

    assign led [0] = clk_enable;

    reg [5:0] new_abcdef, old_abcdef;

    integer i;

    always @*
    begin
        /*
        new_abcdef [1] = old_abcdef [0];
        new_abcdef [2] = old_abcdef [1];
        new_abcdef [3] = old_abcdef [2];
        new_abcdef [4] = old_abcdef [3];
        new_abcdef [5] = old_abcdef [4];
        new_abcdef [0] = old_abcdef [5];
        */

        for (i = 0; i < 5; i = i + 1)
            new_abcdef [i + 1] = old_abcdef [i];
        
        new_abcdef [0] = old_abcdef [5];
    end

    always @ (posedge clk or negedge reset_n)
        if (! reset_n)
            old_abcdef <= 6'b111110;
        else if (clk_enable)
            old_abcdef <= new_abcdef;

    assign { seg_a, seg_b, seg_c, seg_d, seg_e, seg_f } = old_abcdef;
    assign seg_g = 1;

    assign anodes = ~ sw [15:8];

endmodule
