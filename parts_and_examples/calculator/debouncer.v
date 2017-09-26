module debouncer
(
    input      clock,
    input      clock_for_debouncing,
    input      reset,
    input      button,
    output reg push
);

    reg [2:0] samples;

    always @(posedge clock_for_debouncing)
    begin
        if (reset)
            samples <= 0;
        else
            samples <= { samples [1:0], button };
    end

    wire current = & samples;
    reg  previous;

    always @(posedge clock)
    begin
        if (reset)
        begin
            previous <= 0;
            push     <= 0;
        end
        else
        begin
            previous <= current;
            push     <= { previous, current } == 2'b01;
        end
    end

endmodule
