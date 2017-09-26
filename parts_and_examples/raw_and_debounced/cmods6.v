module raw_and_debounced
(
    input        CLK,         // FPGA_GCLK, 8MHz
    input        CLK_LFC,     // FPGA_LFC, 1 Hz

    output       LED_0,
    output       LED_1,
    output       LED_2,
    output       LED_3,

    input        BTN_0,
    input        BTN_1,

    // DEPP interface

    // input        DEPP_ASTB,   // Address strobe
    // input        DEPP_DSTB,   // Data strobe
    // input        DEPP_WRITE,  // Write enable (write operation = 0, read operation = 1)
    // output       DEPP_WAIT,   // Ready 
    // inout  [7:0] DBUS,

    // General purpose I/O

    output [7:0] PORTA,
    output [7:0] PORTB,
    output [6:0] PORTC,
    output [7:0] PORTD,
    input  [7:0] PORTE,
    output [6:0] PORTF
);

    assign PORTB = 'hff;
    assign PORTC = 'h7f;
    assign PORTD = 'hff;
    
    wire clock = CLK;
    wire reset = BTN_0;

    wire clock_for_debouncing;
    wire clock_for_display;

    clock_divider clock_divider
    (
        .clock                 ( clock                ),
        .reset                 ( reset                ),
        .clock_for_debouncing  ( clock_for_debouncing ),
        .clock_for_display     ( clock_for_display    )
    );

    wire raw_button                = ~ PORTE [7];
    wire pre_debounced_button      = ~ PORTE [6];
    wire posedge_debounced_button;

    wire on_board_button = ~ BTN_1;

    debouncer debouncer
    (
        .clock                 ( clock                    ),
        .clock_for_debouncing  ( clock_for_debouncing     ),
        .reset                 ( reset                    ),
        .button                ( pre_debounced_button     ),
        .push                  ( posedge_debounced_button )
    );

    reg   [15:0] number;
    wire  [ 6:0] seven_segments;
    wire  [ 3:0] cathodes;

    display display
    (
        .clock           ( clock_for_display ),
        .reset           ( reset             ),
        .number          ( number            ),
        .seven_segments  ( seven_segments    ),
        .cathodes        ( cathodes          )
    );

    // g f e d c b a
    
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d-- 
		  
    assign PORTA [0] = seven_segments [4]; // E  1
    assign PORTA [1] = seven_segments [3]; // D  2
    assign PORTA [2] = 0;                  // .  3
    assign PORTA [3] = seven_segments [2]; // C  4
    assign PORTA [4] = seven_segments [6]; // G  5
    assign PORTA [5] = seven_segments [1]; // B  7
    assign PORTA [6] = seven_segments [5]; // F 10
    assign PORTA [7] = seven_segments [0]; // A 11

    assign PORTF = { 4'b1111, cathodes };

    assign LED_0 = 0; // raw_button;
    assign LED_1 = 0; // pre_debounced_button;
    assign LED_2 = 0;
    assign LED_3 = 0;

    reg prev_raw_button;

    always @(posedge CLK)
    begin
        if (reset)
            prev_raw_button <= 0;
        else
            prev_raw_button <= raw_button;
    end
	 
    wire posedge_raw_button = ~ prev_raw_button & raw_button;

    always @(posedge CLK)
    begin
        if (reset)
            number = 0;
        else if (posedge_raw_button | posedge_debounced_button)
            number = number + 1;
    end

endmodule
