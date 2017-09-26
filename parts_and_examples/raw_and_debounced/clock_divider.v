module clock_divider
(
    input        clock,
    input        reset,
    output       clock_for_debouncing,
    output       clock_for_display
);

    reg [19:0] counter;

    always @(posedge clock)
    begin
        if (reset)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // clock is 8 MHz
    // clock_for_debouncing is 8 MHz / 2 ** (16 + 1) ~ 61 Hz
    // clock_for_display    is 8 MHz / 2 ** (12 + 1) ~ 977 Hz

    assign clock_for_debouncing = counter [16];
    assign clock_for_display    = counter [12];

endmodule
