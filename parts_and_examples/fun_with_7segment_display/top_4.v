module top_4
(
    input         clk,
    input         reset_n,

    output        seg_a,
    output        seg_b,
    output        seg_c,
    output        seg_d,
    output        seg_e,
    output        seg_f,
    output        seg_g,

    output [ 7:0] anodes
);

    assign anodes = 8'b11111110;

    wire move_segment;

    timer # (.counter_width (25))
    i_timer_move_segment
    (
        .clk     ( clk          ),
        .reset_n ( reset_n      ),
        .strobe  ( move_segment )
    );

    reg [5:0] new_abcdef, old_abcdef;
    reg       new_mode,   old_mode;

    always @*
    begin
        if (old_mode)
            new_abcdef = { old_abcdef [  0] , old_abcdef [5:1] };
        else
            new_abcdef = { old_abcdef [4:0] , old_abcdef [  5] };

        if (new_abcdef [7] == 1'b0)
            new_mode = ! old_mode;
        else
            new_mode =   old_mode;
    end

    always @ (posedge clk or negedge reset_n)
        if (! reset_n)
        begin
            old_abcdef <= 6'b111110;
            old_mode   <= 1'b0;
        end
        else if (move_segment)
        begin
            old_abcdef <= new_abcdef;
            old_mode   <= new_mode;
        end

    assign { seg_a, seg_b, seg_c, seg_d, seg_e, seg_f } = old_abcdef;
    assign seg_g = 1;

endmodule
