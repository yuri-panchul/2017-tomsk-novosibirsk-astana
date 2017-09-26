module chip
(
    input        mclk,
    output [6:0] seg,
    output       dp,
    output [3:0] an,
    output [7:0] Led,
    input  [7:0] sw,
    input  [3:0] btn
);

    system system
    (
        .clock          ( mclk ),
        .switches       ( sw   ),
        .buttons        ( btn  ),
        .leds           ( Led  ),
        .seven_segments ( seg  ),
        .dot            ( dp   ),
        .anodes         ( an   )
    );

endmodule
