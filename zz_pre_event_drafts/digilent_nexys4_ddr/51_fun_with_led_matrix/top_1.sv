//----------------------------------------------------------------------------
//
//  Упражнение 51: Матрица светодиодов
//
//  Exercise   51: LED matrix
//
//----------------------------------------------------------------------------

module timer
# ( parameter timer_divider = 25 )
(
    input  clock_100_mhz,
    input  reset_n,
    output strobe
);

    reg [timer_divider - 1:0] counter;

    always @ (posedge clock_100_mhz or negedge reset_n)
    begin
        if (! reset_n)
            counter <= { timer_divider { 1'b0 } };
        else
            counter <= counter + { { timer_divider - 1 { 1'b0 } }, 1'b1 };
    end

    assign strobe
        = (counter [timer_divider - 1:0] == { timer_divider { 1'b0 } } );

endmodule

//----------------------------------------------------------------------------

module shift
# ( parameter width = 16 )
(
    input                     clock,
    input                     reset_n,
    input                     shift_enable,
    input                     button,
    output reg [width - 1:0]  shift_reg
);

    reg [width - 1:0] counter;

    always @ (posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            shift_reg <= { width { 1'b0 } };
        else if (shift_enable)
            shift_reg <= { button, shift_reg [width - 1:1] };
    end

endmodule

//----------------------------------------------------------------------------

module top_1
(
    input         clk,
    input         reset_n,

    input         btn_up,
    input         btn_down,
    input         btn_left,
    input         btn_right,
    input         btn_center,

    input  [15:0] sw, 

    output [15:0] led,

    output        led16_b,
    output        led16_g,
    output        led16_r,
    output        led17_b,
    output        led17_g,
    output        led17_r,

    output        seg_a,
    output        seg_b,
    output        seg_c,
    output        seg_d,
    output        seg_e,
    output        seg_f,
    output        seg_g,

    output [ 7:0] anodes,

    inout  [12:1] ja,
    inout  [12:1] jb
);

    assign led = sw;

    assign led16_b = 0;
    assign led16_g = 0;
    assign led16_r = 0;
    assign led17_b = 0;
    assign led17_g = 0;
    assign led17_r = 0;

    assign { seg_a, seg_b, seg_c, seg_d, seg_e, seg_f, seg_g } = ~ sw [6:0];

    assign anodes = ~ sw [15:8];

    wire [7:0] rows, cols;

    assign ja [ 4:1] = { ~ cols [5], ~ cols [6],   rows [1],   rows [3] };
    assign ja [10:7] = {   rows [5],   rows [2], ~ cols [3],   rows [0] };
    assign jb [ 4:1] = {   rows [7], ~ cols [4], ~ cols [2],   rows [4] };
    assign jb [10:7] = { ~ cols [7],   rows [6], ~ cols [1], ~ cols [0] };

    //------------------------------------------------------------------------

    wire button = btn_center;
    wire enable_rows, enable_cols;

    timer
    # ( .timer_divider ( 25 ))
    timer_rows_i
    (
        .clock_100_mhz ( clk       ),
        .reset_n       ( reset_n     ),
        .strobe        ( enable_rows )
    );

    shift 
    # ( .width ( 8 ))
    shift_rows_i
    (
        .clock         ( clk       ),
        .reset_n       ( reset_n     ),
        .shift_enable  ( enable_rows ),
        .button        ( button      ),
        .shift_reg     ( rows        )
    );

    //------------------------------------------------------------------------

    timer
    # ( .timer_divider ( 25 ))
    timer_cols_i
    (
        .clock_100_mhz ( clk       ),
        .reset_n       ( reset_n     ),
        .strobe        ( enable_cols )
    );

    shift 
    # ( .width ( 8 ))
    shift_cols_i
    (
        .clock         ( clk       ),
        .reset_n       ( reset_n     ),
        .shift_enable  ( enable_cols ),
        .button        ( button      ),
        .shift_reg     ( cols        )
    );

endmodule
