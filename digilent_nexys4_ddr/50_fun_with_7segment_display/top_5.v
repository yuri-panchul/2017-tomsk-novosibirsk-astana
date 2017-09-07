module top_5
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

    timer # (.counter_width (28))
    i_timer_move_segment
    (
        .clk     ( clk          ),
        .reset_n ( reset_n      ),
        .strobe  ( move_segment )
    );

    reg new_a, new_b, new_c, new_d, new_e, new_f, new_g;
    reg old_a, old_b, old_c, old_d, old_e, old_f, old_g;

    reg new_mode, old_mode;

    always @*
    begin
        if (old_f | old_b)
            new_mode = ! old_mode;
        else
            new_mode =   old_mode;

        if (new_mode)
        begin
            new_a = old_f;
            new_b = old_a;
            new_g = old_b;
            new_e = old_g;
            new_d = old_e;
            new_c = old_d;
            new_f = old_f;
        end
        else
        begin
            new_a = old_b;
            new_f = old_a;
            new_g = old_f;
            new_c = old_g;
            new_d = old_c;
            new_e = old_d;
            new_b = old_b;
        end
    end

    always @ (posedge clk or negedge reset_n)
        if (! reset_n)
        begin
            { old_a, old_b, old_c, old_d, old_e, old_f, old_g }
            =
            7'b1000000;

            old_mode <= 1'b0;
        end
        else if (move_segment)
        begin
            { old_a, old_b, old_c, old_d, old_e, old_f, old_g }
            =
            { new_a, new_b, new_c, new_d, new_e, new_f, new_g };

            old_mode <= new_mode;
        end

    assign { seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g }
           =
         ~ { old_a, old_b, old_c, old_d, old_e, old_f, old_g };

endmodule
