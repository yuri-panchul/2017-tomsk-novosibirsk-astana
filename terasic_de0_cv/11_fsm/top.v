//----------------------------------------------------------------------------
//
//  Exercise   11. Finite state machine (FSM)
//
//  Упражнение 11. Конечные автоматы
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Exercise 11.1. Moore FSM
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

    // state register

    always @(posedge clock or negedge reset_n)
        if (!reset_n)
            state <= S0;
        else if (enable)
            state <= next_state;

    // next state logic

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

    // output logic

    assign y = (state == S2);

endmodule

module timer
# ( parameter timer_divider = 24 )
(
    input clock_50_mhz,
    input reset_n,
    output strobe
);

    reg [timer_divider-1:0] counter;

    always @(posedge clock_50_mhz or negedge reset_n)
    begin
        if (! reset_n)
            counter <= { timer_divider { 1'b0 } };
        else
            counter <= counter + { { timer_divider-1 { 1'b0 } }, 1'b1 } ;
    end

    assign strobe = (counter [timer_divider-1:0] == { timer_divider { 1'b0 } });

endmodule

module shift
# ( parameter counter_width = 10 )
(
    input        clock_50_mhz,
    input        reset_n,
    input        shift_enable,
    input        button,
    output reg [counter_width-1:0] shift_reg,
    output       out
);

    reg [counter_width-1:0] counter;

    always @(posedge clock_50_mhz or negedge reset_n)
    begin
        if (! reset_n)
            shift_reg <= { counter_width { 1'b0 } };
        else if (shift_enable)
            shift_reg <= { button, shift_reg [counter_width-1:1] };
    end

    assign out = shift_reg [0];

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 11.2. Mealy FSM
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

    parameter S0 = 1'b0, S1 = 1'b1;

    reg state, next_state;

    // state register

    always @(posedge clock or negedge reset_n)
        if (!reset_n)
            state <= S0;
        else if (enable)
            state <= next_state;

    // next state logic

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

    // output logic

    assign y = (a & state == S1);

endmodule

//----------------------------------------------------------------------------

module top
(
    input  clock,      // Clock signal 50 Mhz   // Тактовый сигнал 50 МГц
    input  [1:0] key,  // Buttons               // Кнопки
    output [9:0] led,  // LEDs                  // Светодиоды
    output [7:0] hex0, // Seven-segment display // индикатор
    output [7:0] hex1  // Seven-segment display // индикатор
);

    wire reset_n = key [0];
    wire button  = ! key [1];
    wire enable;
    wire [9:0] shift_data;
    wire shift_out;

    timer
    # ( .timer_divider ( 24 ))
    timer_i
    (
        .clock_50_mhz ( clock   ),
        .reset_n      ( reset_n ),
        .strobe       ( enable  )
    );

    shift 
    # ( .counter_width ( 10 ))
    shift_i
    (
        .clock_50_mhz ( clock      ),
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
        .a       ( shift_data    ),
        .y       ( moore_fsm_out )
    );

    pattern_fsm_mealy
    (
        .clock   ( clock         ),
        .reset_n ( reset_n       ),
        .enable  ( enable        ),
        .a       ( shift_data    ),
        .y       ( mealy_fsm_out )
    );

    assign hex0 = moore_fsm_out ? 8'b10100011 : 8'b11111111;
    assign hex1 = mealy_fsm_out ? 8'b10011100 : 8'b11111111;

endmodule

