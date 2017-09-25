//----------------------------------------------------------------------------
//
//  Exercise   11. Finite state machines (FSMs)
//
//  Упражнение 11. Конечные автоматы
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Exercise   11.1. Moore FSM
//
//  Упражнение 11.1. Конечный автомат Мура
//
//----------------------------------------------------------------------------

module pattern_fsm_moore
(
    input  clock,
    input  reset_n,
    input  enable,
    input  a,
    output y
);

    parameter [1:0] S0 = 0, S1 = 1, S2 = 2;

    reg [1:0] state, next_state;

    // State register
    // Регистр состояния

    always @ (posedge clock or negedge reset_n)
        if (! reset_n)
            state <= S0;
        else if (enable)
            state <= next_state;

    // Next state logic
    // Логика определения следующего состояния

    always @*
        case (state)
        
        S0:
            if (a)
                next_state = S0;
            else
                next_state = S1;

        S1:
            if (a)
                next_state = S2;
            else
                next_state = S1;

        S2:
            if (a)
                next_state = S0;
            else
                next_state = S1;

        default:

            next_state = S0;

        endcase

    // Output logic based on current state
    // Логика определения выводов на основе текущего состояния

    assign y = (state == S2);

endmodule

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

module shift
# ( parameter width = 10 )
(
    input                     clock,
    input                     reset_n,
    input                     shift_enable,
    input                     button,
    output reg [width - 1:0]  shift_reg,
    output                    out
);

    reg [width - 1:0] counter;

    always @ (posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            shift_reg <= { width { 1'b0 } };
        else if (shift_enable)
            shift_reg <= { button, shift_reg [width - 1:1] };
    end

    assign out = shift_reg [0];

endmodule

//----------------------------------------------------------------------------
//
//  Exercise   11.2. Mealy FSM
//
//  Упражнение 11.2. Конечный автомат Мили
//
//----------------------------------------------------------------------------

module pattern_fsm_mealy
(
    input  clock,
    input  reset_n,
    input  enable,
    input  a,
    output y
);

    parameter [0:0] S0 = 1'b0, S1 = 1'b1;

    reg state, next_state;

    // State register
    // Регистр состояния

    always @ (posedge clock or negedge reset_n)
        if (! reset_n)
            state <= S0;
        else if (enable)
            state <= next_state;

    // Next state logic
    // Логика определения следующего состояния

    always @*
        case (state)
        
        S0:
            if (a)
                next_state = S0;
            else
                next_state = S1;

        S1:
            if (a)
                next_state = S0;
            else
                next_state = S1;

        default:

            next_state = S0;

        endcase

    // Output logic based on current state
    // Логика определения выводов на основе текущего состояния и вводах

    assign y = (a & state == S1);

endmodule

//----------------------------------------------------------------------------

module top
(
    input        clock,    // Clock signal 50 MHz  // Тактовый сигнал 50 МГц
    input        reset_n,  // Reset active low     // Сброс с активным
                                                   // низким уровнем
    input  [3:0] key,      // Four buttons         // Четыре кнопки
    output [9:0] led,      // LEDs                 // Светодиоды
    output [6:0] hex0,     // 7-segment display    // Семисегментный индикатор
    output [6:0] hex1,     
    output [6:0] hex2,
    output [6:0] hex3,
    output [6:0] hex4,
    output [6:0] hex5
);

    wire       button  = ~ key [0];
    wire       enable;
    wire [9:0] shift_data;
    wire       shift_out;

    timer
    # ( .timer_divider ( 24 ))
    timer_i
    (
        .clock_50_mhz ( clock   ),
        .reset_n      ( reset_n ),
        .strobe       ( enable  )
    );

    shift 
    # ( .width ( 10 ))
    shift_i
    (
        .clock        ( clock      ),
        .reset_n      ( reset_n    ),
        .shift_enable ( enable     ),
        .button       ( button     ),
        .shift_reg    ( shift_data ),
        .out          ( shift_out  )
    );

    assign led = shift_data;

    pattern_fsm_moore
    (
        .clock   ( clock         ),
        .reset_n ( reset_n       ),
        .enable  ( enable        ),
        .a       ( shift_out     ),
        .y       ( moore_fsm_out )
    );

    pattern_fsm_mealy
    (
        .clock   ( clock         ),
        .reset_n ( reset_n       ),
        .enable  ( enable        ),
        .a       ( shift_out     ),
        .y       ( mealy_fsm_out )
    );

    assign hex0 = moore_fsm_out ? 8'b10100011 : 8'b11111111;
    assign hex1 = mealy_fsm_out ? 8'b10011100 : 8'b11111111;

endmodule
