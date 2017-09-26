module display
(
    input             clock,
    input             reset,
    input      [15:0] number,
    output reg [ 6:0] seven_segments,
    output reg [ 3:0] cathodes
);

    function [6:0] bcd_to_seg (input [3:0] bcd);

        case (bcd)
        'h0: bcd_to_seg = 'b0111111;  // g f e d c b a
        'h1: bcd_to_seg = 'b0000110;
        'h2: bcd_to_seg = 'b1011011;  //   --a--
        'h3: bcd_to_seg = 'b1001111;  //  |     |
        'h4: bcd_to_seg = 'b1100110;  //  f     b
        'h5: bcd_to_seg = 'b1101101;  //  |     |
        'h6: bcd_to_seg = 'b1111101;  //   --g--
        'h7: bcd_to_seg = 'b0000111;  //  |     |
        'h8: bcd_to_seg = 'b1111111;  //  e     c
        'h9: bcd_to_seg = 'b1100111;  //  |     |
        'ha: bcd_to_seg = 'b1110111;  //   --d-- 
        'hb: bcd_to_seg = 'b1111100;
        'hc: bcd_to_seg = 'b0111001;
        'hd: bcd_to_seg = 'b1011110;
        'he: bcd_to_seg = 'b1111001;
        'hf: bcd_to_seg = 'b1110001;
        endcase

    endfunction

    reg [1:0] i;

    always @(posedge clock or posedge reset)
    begin
        if (reset)
        begin
            i <= 0;

            seven_segments <= bcd_to_seg (0);
            cathodes       <= 'b0000;
        end
        else
        begin
            seven_segments <= bcd_to_seg (number [i * 4 +: 4]);
            cathodes       <= ~ (1 << i);

            i <= i + 1;
        end
    end

endmodule
