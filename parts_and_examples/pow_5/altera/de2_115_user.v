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

module clock_divider_50_MHz_to_1_49_Hz
(
    input  clock_50_MHz,
    input  reset_n,
    output clock_1_49_Hz
);

    // 50 MHz / 2 ** 25 = 1.49 Hz

    reg [24:0] counter;

    always @ (posedge clock_50_MHz or negedge reset_n)
    begin
        if (! reset_n)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    assign clock_1_49_Hz = counter [24];

endmodule

//--------------------------------------------------------------------

module single_digit_display
(
    input      [3:0] digit,
    output reg [6:0] seven_segments
);

    always @*
        case (digit)
        'h0: seven_segments = 'b1000000;  // a b c d e f g
        'h1: seven_segments = 'b1111001;
        'h2: seven_segments = 'b0100100;  //   --a--
        'h3: seven_segments = 'b0110000;  //  |     |
        'h4: seven_segments = 'b0011001;  //  f     b
        'h5: seven_segments = 'b0010010;  //  |     |
        'h6: seven_segments = 'b0000010;  //   --g--
        'h7: seven_segments = 'b1111000;  //  |     |
        'h8: seven_segments = 'b0000000;  //  e     c
        'h9: seven_segments = 'b0011000;  //  |     |
        'ha: seven_segments = 'b0001000;  //   --d-- 
        'hb: seven_segments = 'b0000011;
        'hc: seven_segments = 'b1000110;
        'hd: seven_segments = 'b0100001;
        'he: seven_segments = 'b0000110;
        'hf: seven_segments = 'b0001110;
        endcase

endmodule

//--------------------------------------------------------------------

/*
module de2_115_user
(
    input         CLOCK_50,
    input  [ 3:0] KEY,
    input  [17:0] SW,
    output [ 8:0] LEDG,
    output [17:0] LEDR,
    output [ 6:0] HEX0,
    output [ 6:0] HEX1,
    output [ 6:0] HEX2,
    output [ 6:0] HEX3,
    output [ 6:0] HEX4,
    output [ 6:0] HEX5,
    output [ 6:0] HEX6,
    output [ 6:0] HEX7
);

    wire clock;

    wire reset_n                  =   KEY [3];

    wire        combinational     = ! KEY [2];
    wire        run_sequential    = ! KEY [1];
    wire        ready_sequential;
    wire        pipelined         = ! KEY [0];

    wire [15:0] n                 =   SW [15:0];

    wire [15:0] n_pow_5_combinational;
    wire [15:0] n_pow_5_pipelined;
    wire [15:0] n_pow_5_sequential;

    wire [15:0] n_pow_5  =   combinational ? n_pow_5_combinational
                           : pipelined     ? n_pow_5_pipelined
                           :                 n_pow_5_sequential;

    clock_divider_50_MHz_to_1_49_Hz clock_divider_50_MHz_to_1_49_Hz
    (
        .clock_50_MHz  (CLOCK_50),
        .reset_n       (reset_n),
        .clock_1_49_Hz (clock)
    );

    assign LEDR = n_pow_5;

    assign LEDG [8:7] = { 2 { ready_sequential } };
    assign LEDG [6:0] = { 6'b0, clock };

    pow_5_combinational pow_5_combinational
    (
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_combinational )
    );

    pow_5_sequential pow_5_sequential
    (
        .clock   ( clock                 ),
        .reset_n ( reset_n               ),
        .run     ( run_sequential        ),
        .n       ( n                     ),
        .ready   ( ready_sequential      ),
        .n_pow_5 ( n_pow_5_sequential    )
    );

    pow_5_pipelined pow_5_pipelined
    (
        .clock   ( clock                 ),
        .n       ( n                     ),
        .n_pow_5 ( n_pow_5_pipelined     )
    );

    single_digit_display digit_0
    (
        .digit          ( LEDR [ 3: 0] ),
        .seven_segments ( HEX0         )
    );

    single_digit_display digit_1
    (
        .digit          ( LEDR [ 7: 4] ),
        .seven_segments ( HEX1         )
    );

    single_digit_display digit_2
    (
        .digit          ( LEDR [11: 8] ),
        .seven_segments ( HEX2         )
    );

    single_digit_display digit_3
    (
        .digit          ( LEDR [15:12] ),
        .seven_segments ( HEX3         )
    );

    single_digit_display digit_4
    (
        .digit          ( { 2'b0 , LEDR [17:16] } ),
        .seven_segments ( HEX4                    )
    );

    assign HEX5 = 7'h7f;
    assign HEX6 = 7'h7f;
    assign HEX7 = 7'h7f;

endmodule
*/

//--------------------------------------------------------------------

module de2_115_user  // For measurements
(
    input         CLOCK_50,
    input  [ 3:0] KEY,
    input  [17:0] SW,
    output [ 8:0] LEDG,
    output [17:0] LEDR,
    output [ 6:0] HEX0,
    output [ 6:0] HEX1,
    output [ 6:0] HEX2,
    output [ 6:0] HEX3,
    output [ 6:0] HEX4,
    output [ 6:0] HEX5,
    output [ 6:0] HEX6,
    output [ 6:0] HEX7
);

    wire        clock    =   CLOCK_50;
    wire        reset_n  =   KEY [3];
    wire [15:0] n        =   SW [15:0];
    wire [15:0] n_pow_5;
    wire        run      = ! KEY [1];
    wire        ready;

    pow_5_combinational pow_5_combinational
    (
        .n       ( n       ),
        .n_pow_5 ( n_pow_5 )
    );

    assign ready = 1'b0;

    /*
    pow_5_sequential pow_5
    (
        .clock   ( clock   ),
        .reset_n ( reset_n ),
        .run     ( run     ),
        .n       ( n       ),
        .ready   ( ready   ),
        .n_pow_5 ( n_pow_5 )
    );
    */

    /*
    pow_5_pipelined pow_5_
    (
        .clock   ( clock   ),
        .n       ( n       ),
        .n_pow_5 ( n_pow_5 )
    );

    assign ready = 1'b0;
    */

    assign LEDG [8:7] = { 2 { ready } };
    assign LEDG [6:0] = { 6'b0, clock };

    reg [17:0] clocked_n_pow_5;

    always @(posedge clock)
        clocked_n_pow_5 <= n_pow_5;

    assign LEDR = clocked_n_pow_5;

    assign HEX0 = 7'h7f;
    assign HEX1 = 7'h7f;
    assign HEX2 = 7'h7f;
    assign HEX3 = 7'h7f;
    assign HEX4 = 7'h7f;
    assign HEX5 = 7'h7f;
    assign HEX6 = 7'h7f;
    assign HEX7 = 7'h7f;

endmodule
