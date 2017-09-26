module display
(
    input             clock,
    input             reset,
    input      [15:0] number,
    input             overflow,
    input      [ 3:0] error,

    output reg [ 6:0] seven_segments,
    output reg        dot,
    output reg [ 3:0] anodes
);

    parameter [6:0] seg_E = 'b0000110;
    parameter [6:0] seg_r = 'b0101111;

    function [6:0] bcd_to_seg (input [3:0] bcd);

        case (bcd)
        'h0: bcd_to_seg = 'b1000000;  // a b c d e f g
        'h1: bcd_to_seg = 'b1111001;
        'h2: bcd_to_seg = 'b0100100;  //   --a--
        'h3: bcd_to_seg = 'b0110000;  //  |     |
        'h4: bcd_to_seg = 'b0011001;  //  f     b
        'h5: bcd_to_seg = 'b0010010;  //  |     |
        'h6: bcd_to_seg = 'b0000010;  //   --g--
        'h7: bcd_to_seg = 'b1111000;  //  |     |
        'h8: bcd_to_seg = 'b0000000;  //  e     c
        'h9: bcd_to_seg = 'b0011000;  //  |     |
        'ha: bcd_to_seg = 'b0001000;  //   --d-- 
        'hb: bcd_to_seg = 'b0000011;
        'hc: bcd_to_seg = 'b1000110;
        'hd: bcd_to_seg = 'b0100001;
        'he: bcd_to_seg = 'b0000110;
        'hf: bcd_to_seg = 'b0001110;
        endcase

    endfunction

    reg [1:0] i;

    always @(posedge clock)
    begin
        if (reset)
        begin
            i <= 0;

            seven_segments <=   bcd_to_seg (0);
            dot            <= ~ 0;
            anodes         <= ~ 'b1111;
        end
        else
        begin
            if (error != 0)
            begin
                case (i)
                0    : seven_segments <= bcd_to_seg (error);
                1, 2 : seven_segments <= seg_r;
                3    : seven_segments <= seg_E;
                endcase

                dot            <= ~ 0;
                anodes         <= ~ (1 << i);
            end
            else
            begin
                seven_segments <=   bcd_to_seg (number [i * 4 +: 4]);
                dot            <= ~ (i == 0 ? overflow : 0);
                anodes         <= ~ (1 << i);
            end

            i <= i + 1;
        end
    end

endmodule
