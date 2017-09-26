module pow_5_implementation_1
(
    input  [17:0] n,
    output [17:0] n_pow_5
);

    assign n_pow_5 = n * n * n * n * n;

endmodule

//--------------------------------------------------------------------

module pow_5_implementation_2
(
    input         clock,
    input         reset_n,
    input         run,
    input  [17:0] n,
    output        ready,
    output [17:0] n_pow_5
);

    reg [4:0] shift;

    always @(posedge clock or negedge reset_n)
        if (! reset_n)
            shift <= 0;
        else if (run)
            shift <= 5'b10000;
        else
            shift <= shift >> 1;

    assign ready = shift [0];

    reg [17:0] r_n, mul;

    always @(posedge clock)
        if (run)
        begin
            r_n <= n;
            mul <= n;
        end
        else
        begin
            mul <= mul * r_n;
        end

    assign n_pow_5 = mul;

endmodule

//--------------------------------------------------------------------

module pow_5_implementation_3
(
    input             clock,
    input      [17:0] n,
    output reg [17:0] n_pow_5
);

    reg [17:0] n_1, n_2, n_3;
    reg [17:0] n_pow_2, n_pow_3, n_pow_4;

    always @(posedge clock)
    begin
        n_1 <= n;
        n_2 <= n_1;
        n_3 <= n_2;

        n_pow_2 <= n * n;
        n_pow_3 <= n_pow_2 * n_1;
        n_pow_4 <= n_pow_3 * n_2;
        n_pow_5 <= n_pow_4 * n_3;
    end

endmodule

//--------------------------------------------------------------------

module testbench;

    reg         clock;
    reg         reset_n;
    reg         run;
    reg  [17:0] n;
    wire        ready;

    wire [17:0] n_pow_5_implementation_1;
    wire [17:0] n_pow_5_implementation_2;
    wire [17:0] n_pow_5_implementation_3;

    initial
    begin
        clock = 1;

        forever
            # 50 clock = ! clock;
    end

    initial
    begin
        repeat (2) @(posedge clock);
        reset_n <= 0;
        repeat (2) @(posedge clock);
        reset_n <= 1;
    end

    pow_5_implementation_1 pow_5_implementation_1
        (n, n_pow_5_implementation_1);

    pow_5_implementation_2 pow_5_implementation_2
        (clock, reset_n, run, n, ready, n_pow_5_implementation_2);

    pow_5_implementation_3 pow_5_implementation_3
        (clock, n, n_pow_5_implementation_3);

    integer i;

    initial
    begin
        #0
        $dumpvars;

        $monitor ("clock %b reset_n %b n %d comb %d seq %d run %b ready %b pipe %d",
            clock,
            reset_n,
            n,
            n_pow_5_implementation_1,
            n_pow_5_implementation_2,
            run,
            ready,
            n_pow_5_implementation_3);

        @(posedge reset_n);
        @(posedge clock);

        for (i = 0; i < 50; i = i + 1)
        begin
            n   <= i & 7;
            run <= (i == 0 || ready);

            @(posedge clock);
        end

        $finish;
    end

endmodule
