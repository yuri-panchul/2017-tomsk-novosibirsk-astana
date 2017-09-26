module pow_5_combinational
(
    input  [17:0] n,
    output [17:0] n_pow_5
);

    assign n_pow_5 = n * n * n * n * n;

endmodule

//--------------------------------------------------------------------

module pow_5_sequential
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

module pow_5_pipelined
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

    wire [17:0] n_pow_5_combinational;
    wire [17:0] n_pow_5_sequential;
    wire [17:0] n_pow_5_pipelined;

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

    pow_5_combinatonal pow_5_combinatonal
        (clock, reset_n, n, n_pow_5_combinatonal);

    pow_5_sequential pow_5_sequential
        (clock, reset_n, run, n, ready, n_pow_5_sequential);

    pow_5_pipelined pow_5_pipelined
        (clock, reset_n, n, n_pow_5_pipelined);


    integer i;

    initial
    begin
        $dumpvars;

        @(posedge reset_n);
        @(posedge clock);

        for (i = 0; i < 50; i = i + 1)
        begin
            n <= i & 3;
            @(posedge clock);
        end

        $finish;
    end

endmodule
