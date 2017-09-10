//----------------------------------------------------------------------------
//
//  Exercise   2. D flip-flop
//
//  Упражнение 2. D-триггер
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Exercise 2.1. D flip-flop without reset and enable.
//  Clock source is key [0], data is sampled from key [1].
//
//  Упражнение 2.1. D-триггер без сигналов сброса и разрешения.
//  Тактовый сигнал подается с кнопки key [0], данные считываются с key [1]
//
//----------------------------------------------------------------------------

module top  // _dff_wo_reset_wo_enable_clock_from_key
(
    input  [1:0] key,  // Кнопки
    output [1:0] led   // Светодиоды
);

    wire clk;
    wire d = ~ key [1];

    global g (.in (~ key [0]), .out (clk));
    
    // D flip-flop internal state 
    // Внутреннее состояние D-триггера

    reg q;

    // Store new data on positive front of the clock
    
    // Записать новые данные в момент
    // положительного фронта сигнала тактовой частоты
    
    always @ (posedge clk)
        q <= d;

    // Show the value of the clock and D-flip-flop output on LEDs
    
    // Вывести значение сигналов тактовой частоты
    // и вывода D-триггера на светодиоды

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
//  Exercise 2.4. D-Flip-Flop with Reset and Enable; clock source is counter bit 
//
//  Упражнение 2.4. Триггер с Reset и Enable, источник clock - бит счетчика
//
//----------------------------------------------------------------------------

module top_dff_w_reset_w_enable_clock_counter
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

    // Divide clock by 2^27
    reg [26:0] counter;
    always @(posedge clock or negedge reset_n)
        if (!reset_n)
            counter <= 0;
        else
            counter <= counter + 1;
    global g (.in (counter[26]), .out (one_hz_clk));

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

//----------------------------------------------------------------------------
//
//  Exercise 2.5. D-Flip-Flop with Reset and Enable; clock source is 'clock', counter bit as Enable
//
//  Упражнение 2.5. Триггер с Reset и Enable, источник clock - 'clock', бит счетчика в качетсве Enable
//
//----------------------------------------------------------------------------

module top_dff_w_reset_w_enable_clock_counter_enable
(
    input  clock,
    input  [1:0] key,  // Кнопки
    output [3:0] led,  // Светодиоды
    input  [1:0] sw    // Переключатель
);

    /*
    D - key[1]
    Q - led[1]
    Enable - led[0]
    Reset - sw[0] - led[2]
    */
    wire d = ~ key [1];
    wire reset_n = sw [0];
    wire enable;

    // Divide clock by 2^27
    reg [26:0] counter;
    always @(posedge clock or negedge reset_n)
        if (!reset_n)
            counter <= 0;
        else
            counter <= counter + 1;
    assign enable = counter == 0;

    // Internal state
    // Внутреннее состояние D-триггера
    reg q;

    // Assignment on clock
    always @(posedge clock or negedge reset_n)
        if (!reset_n)
            q <= 1'b0;
        else if (enable)
            q <= d;

    // LEDs
    assign led [0] = enable;
    assign led [1] = q;
    assign led [2] = reset_n;

endmodule
