//----------------------------------------------------------------------------
//
//  Упражнение 14: Матрица светодиодов
//
//  Exercise   14: LED matrix
//
//----------------------------------------------------------------------------

module timer
# ( parameter timer_divider = 24 )
(
    input  clock_50_mhz,
    input  reset_n,
    output strobe
);

    reg [timer_divider - 1:0] counter;

    always @ (posedge clock_50_mhz or negedge reset_n)
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
# ( parameter width = 10 )
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

module top
(
    input         clock,
    input         reset_n,
    input  [ 3:0] key,
    input  [ 9:0] sw,
    output [ 9:0] led,
    output [ 6:0] hex0,
    output [ 6:0] hex1,
    output [ 6:0] hex2,
    output [ 6:0] hex3,
    output [ 6:0] hex4,
    output [ 6:0] hex5,
    inout  [35:0] gpio_0,
    inout  [35:0] gpio_1
);

    reg  [15:0] matrix_pins;
    wire [ 7:0] rows, cols;

    assign { gpio_0 [34], gpio_0 [32], gpio_0 [30], gpio_0 [28],
             gpio_0 [24], gpio_0 [22], gpio_0 [20], gpio_0 [18],
             gpio_1 [35], gpio_1 [33], gpio_1 [31], gpio_1 [29],
             gpio_1 [25], gpio_1 [23], gpio_1 [21], gpio_1 [19]  }

        = matrix_pins;

    // assign matrix_pins = { sw [9:0], 6'b0 };
    
    always @ (posedge clock)
    matrix_pins =
    {
        ~ rows [0], ~ rows [1],   cols [1], ~ rows [7],
          cols [3], ~ rows [2],   cols [0], ~ rows [4],
          cols [4],   cols [6], ~ rows [6], ~ rows [5],
          cols [7], ~ rows [3],   cols [5],   cols [2]
    };

    //------------------------------------------------------------------------

    wire button = ~ key [0];
    wire enable_rows, enable_cols;

    timer
    # ( .timer_divider ( 24 ))
    timer_rows_i
    (
        .clock_50_mhz ( clock       ),
        .reset_n      ( reset_n     ),
        .strobe       ( enable_rows )
    );

    shift 
    # ( .width ( 8 ))
    shift_rows_i
    (
        .clock        ( clock       ),
        .reset_n      ( reset_n     ),
        .shift_enable ( enable_rows ),
        .button       ( button      ),
        .shift_reg    ( rows        )
    );

    //------------------------------------------------------------------------

    timer
    # ( .timer_divider ( 24 ))
    timer_cols_i
    (
        .clock_50_mhz ( clock       ),
        .reset_n      ( reset_n     ),
        .strobe       ( enable_cols )
    );

    shift 
    # ( .width ( 8 ))
    shift_cols_i
    (
        .clock        ( clock       ),
        .reset_n      ( reset_n     ),
        .shift_enable ( enable_cols ),
        .button       ( button      ),
        .shift_reg    ( cols        )
    );

endmodule
