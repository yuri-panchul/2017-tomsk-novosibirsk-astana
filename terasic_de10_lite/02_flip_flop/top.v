//----------------------------------------------------------------------------
//
//  Exercise   2. D-Flip-Flop
//
//  Упражнение 2. Триггер
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Exercise 2.1. Simple D-Flip-Flop without Reset, without Enable, clock source is key[1]
//
//  Упражнение 2.1. Триггер без Reset и Enable, Clock - вход с кнопки
//
//----------------------------------------------------------------------------

module top_dff_wo_reset_wo_enable_key_clock
(
    input  [1:0] key,  // Кнопки
    output [1:0] led   // Светодиоды
);

    wire clk;
    wire d = ~ key [1];

    global g (.in (~ key [0]), .out (clk));
    
    // Internal state 
    // Внутреннее состояние D-триггера
    reg q;
    
    // Assignment on clock
    always @(posedge clk)
        q <= d;

    // LEDs
    assign led [0] = clk;
    assign led [1] = q;

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 2.2. D-Flip-Flop with Reset, without Enable; clock source is key[1]
//
//  Упражнение 2.2. Триггер с Reset, без Enable, источник clock - key[1]
//
//----------------------------------------------------------------------------

module top_dff_w_reset_wo_enable_key_clock
(
    input  [1:0] key,  // Кнопки
    output [2:0] led,  // Светодиоды
    input  [0:0] sw    // Переключатель
);

    wire clk;
    wire d = ~ key [1];
    wire reset_n = sw[0];

    global g (.in (~ key [0]), .out (clk));

    // Internal state
    // Внутреннее состояние D-триггера
    reg q;

    // Assignment on clock
    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            q <= 1'b0;
        else
            q <= d;

    // LEDs
    assign led [0] = clk;
    assign led [1] = q;
    assign led [2] = reset_n;
            
endmodule

//----------------------------------------------------------------------------
//
//  Exercise 2.3. D-Flip-Flop with Reset and Enable; clock source is key[1]
//
//  Упражнение 2.3. Триггер с Reset и Enable, источник clock - key[1]
//
//----------------------------------------------------------------------------

module top_dff_w_reset_w_enable_key_clock
(
    input  [1:0] key,  // Кнопки
    output [3:0] led,  // Светодиоды
    input  [1:0] sw    // Переключатель
);

    wire clk;
    wire d = ~ key [1];
    wire reset_n = sw [0];
    wire enable  = sw [1];

    global g (.in (~ key [0]), .out (clk));

    // Internal state
    // Внутреннее состояние D-триггера
    reg q;

    // Assignment on clock
    always @(posedge clk or negedge reset_n)
        if (!reset_n)
            q <= 1'b0;
        else if (enable)
            q <= d;

    // LEDs
    assign led [0] = clk;
    assign led [1] = q;
    assign led [2] = reset_n;
    assign led [3] = enable;

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 2.4. D-Flip-Flop with Reset and Enable; clock source is 'clock' with clock division to ~1Hz
//
//  Упражнение 2.4. Триггер с Reset и Enable, источник clock - 'clock' с понижением частоты до ~1Гц
//
//----------------------------------------------------------------------------

module top //_dff_w_reset_w_enable_clock_divider
(
    input  clock,
    input  [1:0] key,  // Кнопки
    output [3:0] led,  // Светодиоды
    input  [1:0] sw    // Переключатель
);

    wire one_hz_clk;
    wire d = ~ key [1];
    wire reset_n = sw [0];
    wire enable  = sw [1];

    // Divide clock by 2^25
    reg [24:0] counter;
    always @(posedge clock or negedge reset_n)
        if (!reset_n)
            counter <= 0;
        else
            counter <= counter + 1;
    global g (.in (counter[24]), .out (one_hz_clk));

    // Internal state
    // Внутреннее состояние D-триггера
    reg q;

    // Assignment on clock
    always @(posedge one_hz_clk or negedge reset_n)
        if (!reset_n)
            q <= 1'b0;
        else if (enable)
            q <= d;

    // LEDs
    assign led [0] = one_hz_clk;
    assign led [1] = q;
    assign led [2] = reset_n;
    assign led [3] = enable;

endmodule
