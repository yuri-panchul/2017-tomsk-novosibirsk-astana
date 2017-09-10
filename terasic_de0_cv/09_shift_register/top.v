//----------------------------------------------------------------------------
//
//  Exercise   9. Shift register
//
//  Упражнение 9. Сдвиговый регистр
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Exercise   9.1. All components in one module
//
//  Упражнение 9.1. Все компоненты в одном модуле
//
//----------------------------------------------------------------------------

module top_1
(
    input        clock,    // Clock signal 50 MHz  // Тактовый сигнал 50 МГц
    input        reset_n,  // Reset active low     // Сброс с активным
                                                   // низким уровнем
    input  [3:0] key,      // Four buttons         // Четыре кнопки
    output [9:0] led       // LEDs                 // Светодиоды
);

    wire button = ~ key [0];

    reg [21:0] counter;

    // Счетчик для генерации сигнала разрешения для сдвигового регистра
    // Counter to generate enable signal for the shift register

    always @(posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            counter <= 22'b0;
        else
            counter <= counter + 22'b1;
    end

    wire shift_enable = (counter [21:0] == 22'b0);

    // Сдвиговый регистр
    // Shift register

    reg [9:0] shift_reg;
    
    always @(posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            shift_reg <= 10'b0;
        else if (shift_enable)
            shift_reg <= { button, shift_reg [9:1] };
    end

    assign led = shift_reg;

endmodule

//----------------------------------------------------------------------------
//
//  Exercise   9.2. Variant with a timer in a submodule
//
//  Упражнение 9.2. Вариант с таймером в подмодуле
//
//----------------------------------------------------------------------------

module timer
(
    input  clock_50_mhz,
    input  reset_n,
    output strobe_with_period_0_35_second
);

    reg [21:0] counter;

    always @ (posedge clock_50_mhz or negedge reset_n)
    begin
        if (! reset_n)
            counter <= 22'b0;
        else
            counter <= counter + 22'b1;
    end

    assign strobe_with_period_0_35_second = (counter [21:0] == 22'b0);

endmodule

//----------------------------------------------------------------------------
    
module top_2
(
    input        clock,    // Clock signal 50 MHz  // Тактовый сигнал 50 МГц
    input        reset_n,  // Reset active low     // Сброс с активным
                                                   // низким уровнем
    input  [3:0] key,      // Four buttons         // Четыре кнопки
    output [9:0] led       // LEDs                 // Светодиоды
);

    wire button = ~ key [0];

    wire shift_enable;

    // Экземпляр модуля таймера
    // Timer module instance

    timer timer_i
    (
        .clock_50_mhz                   ( clock        ),
        .reset_n                        ( reset_n      ),
        .strobe_with_period_0_35_second ( shift_enable )
    );

    // Сдвиговый регистр
    // Shift register

    reg [9:0] shift_reg;
    
    always @ (posedge clock or negedge reset_n)
    begin
        if (! reset_n)
            shift_reg <= 10'b0;
        else if (shift_enable)
            shift_reg <= { button, shift_reg [9:1] };
    end

    assign led = shift_reg;

endmodule

//----------------------------------------------------------------------------
//
//  Exercise   9.3. Using module hierarchy for both timer and shift register
//
//  Упражнение 9.3. С модульной иерархией для таймера и сдвигового регистра
//
//----------------------------------------------------------------------------

module shift
(
    input            clock,
    input            reset_n,
    input            shift_enable,
    input            button,
    output reg [9:0] shift_reg
);

    reg [9:0] counter;

    always @ (posedge clock_50_mhz or negedge reset_n)
    begin
        if (! reset_n)
            shift_reg <= 10'b0;
        else if (shift_enable)
            shift_reg <= { button, shift_reg [9:1] };
    end

endmodule

//--------------------------------------------------------------------
    
module top
(
    input        clock, // Clock signal 50 MHz // тактовый сигнал 50 МГц
    input  [1:0] key,   // Two buttons         // две кнопки
    output [9:0] led    // LEDs                // Светодиоды
);

    wire button = ~ key [0];
    wire shift_enable;

    timer timer_i
    (
        .clock_50_mhz                   ( clock        ),
        .reset_n                        ( reset_n      ),
        .strobe_with_period_0_35_second ( shift_enable )
    );

    shift shift_i
    (
        .clock                          ( clock        ),
        .reset_n                        ( reset_n      ),
        .shift_enable                   ( shift_enable ),
        .button                         ( button       ),
        .shift_reg                      ( led          )
    );

endmodule
