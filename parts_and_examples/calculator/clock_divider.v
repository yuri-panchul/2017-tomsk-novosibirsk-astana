module clock_divider
(
    input  clock,
    input  reset,
    output clock_for_debouncing,
    output clock_for_display
);

    reg [19:0] counter;

    always @(posedge clock)
    begin
        if (reset)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign clock_for_debouncing = counter [19];
    assign clock_for_display    = counter [15];

endmodule
