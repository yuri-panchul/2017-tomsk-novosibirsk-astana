module timer
# (
    parameter counter_width = 23
)
(
    input  clk,
    input  reset_n,
    output strobe
);

    reg [counter_width - 1:0] counter;

    always @(posedge clk or negedge reset_n)
    begin
        if (! reset_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign strobe = (counter == { counter_width { 1'b0 } });

endmodule

module top_3
# (
    parameter n_anodes = 8
)
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

    output reg [n_anodes - 1:0] anodes
);

    wire move_anode;

    timer # (.counter_width (18))
    i_timer_move_anode
    (
        .clk     ( clk        ),
        .reset_n ( reset_n    ),
        .strobe  ( move_anode )
    );

    always @ (posedge clk or negedge reset_n)
        if (! reset_n)
            anodes <= { 1'b0, { n_anodes - 1 { 1'b1 } } };
        else if (move_anode)
            anodes <= { anodes [0], anodes [n_anodes - 1: 1] };

    wire move_segment;

    timer # (.counter_width (23))
    i_timer_move_segment
    (
        .clk     ( clk          ),
        .reset_n ( reset_n      ),
        .strobe  ( move_segment )
    );

    assign led [0] = clk;
    assign led [1] = reset_n;
    assign led [2] = move_anode;
    assign led [3] = move_segment;
    assign led [15:8] = anodes [7:0];

    reg [5:0] new_abcdef, old_abcdef;

    always @*
    begin
        new_abcdef [1] = old_abcdef [0];
        new_abcdef [2] = old_abcdef [1];
        new_abcdef [3] = old_abcdef [2];
        new_abcdef [4] = old_abcdef [3];
        new_abcdef [5] = old_abcdef [4];
        new_abcdef [0] = old_abcdef [5];
    end

    always @ (posedge clk or negedge reset_n)
        if (! reset_n)
            old_abcdef <= 6'b111110;
        else if (move_segment)
            old_abcdef <= new_abcdef;

    assign { seg_a, seg_b, seg_c, seg_d, seg_e, seg_f } = old_abcdef;
    assign seg_g = 1;

endmodule
