//----------------------------------------------------------------------------
//
//  Exercise   6. Multiplexors and modules
//
//  Упражнение 6. Мультиплексоры и модули
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
// Select one of two 2-bit elements
//
// Выбор одного из двух двухбитовых элементов
//
//----------------------------------------------------------------------------

module mux_2_1
(
    input  [1:0] d0,
    input  [1:0] d1,
    input        sel,
    output [1:0] y
);

    assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
//
// Select one of four 2-bit elements
// Implementation 1 with conditional operator
//
// Мультиплексор, выбирающий один из четырех двухбитовых элементов
// Реализация 1 с использованием условного оператора
//
//----------------------------------------------------------------------------

module mux_4_1_implementation_1
(
    input  [1:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [1:0] y
);
    
    assign y = sel [1]
        ? (sel [0] ? d3 : d2)
        : (sel [0] ? d1 : d0);

endmodule

//----------------------------------------------------------------------------
//
// Select one of four 2-bit elements
// Implementation 2 with case operator
//
// Мультиплексор, выбирающий один из четырех двухбитовых элементов
// Реализация 2 с использованием оператора выбора case
//
//----------------------------------------------------------------------------

module mux_4_1_implementation_2
(
    input      [1:0] d0, d1, d2, d3,
    input      [1:0] sel,
    output reg [1:0] y
);
    
    always @*
        case (sel)
        2'b00: y = d0;
        2'b01: y = d1;
        2'b10: y = d2;
        2'b11: y = d3;
        endcase

endmodule

//----------------------------------------------------------------------------
//
// Select one of four 2-bit elements
// Implementation 3 using tree with three submodules with two 2-bit inputs
//
// Мультиплексор, выбирающий один из четырех двухбитовых элементов
// Реализация 3 с помощью дерева из трех подмодулей с двумя двухбитовыми входами
//
//----------------------------------------------------------------------------

module mux_4_1_implementation_3
(
    input  [1:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [1:0] y
);

    wire [1:0] w01, w23;

    mux_2_1 i0 (.d0 ( d0  ), .d1 ( d1  ), .sel ( sel [0] ), .y ( w01 ));
    mux_2_1 i1 (.d0 ( d2  ), .d1 ( d3  ), .sel ( sel [0] ), .y ( w23 ));
    mux_2_1 i2 (.d0 ( w01 ), .d1 ( w23 ), .sel ( sel [1] ), .y ( y   ));

endmodule

//----------------------------------------------------------------------------
//
// Select one of four 1-bit elements
//
// Мультиплексор, выбирающий один из четырех однобитовых элементов
//
//----------------------------------------------------------------------------

module mux_4_1_bits_1
(
    input        d0, d1, d2, d3,
    input  [1:0] sel,
    output       y
);

    assign y = sel [1]
        ? (sel [0] ? d3 : d2)
        : (sel [0] ? d1 : d0);

endmodule

//----------------------------------------------------------------------------
//
// Select one of four 2-bit elements
// Implementation 4 using two submodules with four 1-bit inputs
//
// Мультиплексор, выбирающий один из четырех двухбитовых элементов
// Реализация 4 с помощью двух подмодулей с четырьмя однобитовыми входами
//
//----------------------------------------------------------------------------

module mux_4_1_implementation_4
(
    input  [1:0] d0, d1, d2, d3,
    input  [1:0] sel,
    output [1:0] y
);

    mux_4_1_bits_1 high
    (
        .d0  ( d0 [1] ),
        .d1  ( d1 [1] ),
        .d2  ( d2 [1] ),
        .d3  ( d3 [1] ),
        .sel ( sel    ),
        .y   ( y  [1] )
    );

    mux_4_1_bits_1 low
    (
        .d0  ( d0 [0] ),
        .d1  ( d1 [0] ),
        .d2  ( d2 [0] ),
        .d3  ( d3 [0] ),
        .sel ( sel    ),
        .y   ( y  [0] )
    );

endmodule

//----------------------------------------------------------------------------
//
// Select one of four 2-bit elements
// Implementation 5 using if statements
//
// Мультиплексор, выбирающий один из четырех однобитовых элементов
// Реализация 5 с помощью оператора 'if'
//
//----------------------------------------------------------------------------

module mux_4_1_implementation_5
(
    input      [1:0] d0, d1, d2, d3,
    input      [1:0] sel,
    output reg [1:0] y
);

    always @*
    begin
        if (sel == 2'b00)
            y = d0;
        else if (sel == 2'b01)
            y = d1;
        else if (sel == 2'b10)
            y = d2;
        else if (sel == 2'b11)
            y = d3;
    end

endmodule

//----------------------------------------------------------------------------
//
// Top module which sets up five multiplexor implementations
//
// Верхний модуль, который устанавливает пять вариантов реализации мультиплексора
//
//----------------------------------------------------------------------------

module top
(
    input  [7:0] sw,  // Switches // Переключатели
    input  [1:0] key, // Buttons  // Две кнопки
    output [9:0] led  // LEDs     // Светодиоды
);

    wire [1:0] d0 = sw [1:0];
    wire [1:0] d1 = sw [3:2];
    wire [1:0] d2 = sw [5:4];
    wire [1:0] d3 = sw [7:6];

    wire [1:0] y0, y1, y2, y3, y4;

    assign led = { y4, y3, y2, y1, y0 };

    mux_4_1_implementation_1 mux_4_1_i1
    (
        .d0  ( d0  ),
        .d1  ( d1  ),
        .d2  ( d2  ),
        .d3  ( d3  ),
        .sel ( key ),
        .y   ( y0  )
    );

    mux_4_1_implementation_2 mux_4_1_i2
    (
        .d0  ( d0  ),
        .d1  ( d1  ),
        .d2  ( d2  ),
        .d3  ( d3  ),
        .sel ( key ),
        .y   ( y1  )
    );

    mux_4_1_implementation_3
    (
        .d0  ( d0  ),
        .d1  ( d1  ),
        .d2  ( d2  ),
        .d3  ( d3  ),
        .sel ( key ),
        .y   ( y2  )
    );

    mux_4_1_implementation_4
    (
        .d0  ( d0  ),
        .d1  ( d1  ),
        .d2  ( d2  ),
        .d3  ( d3  ),
        .sel ( key ),
        .y   ( y3  )
    );

    mux_4_1_implementation_5
    (
        .d0  ( d0  ),
        .d1  ( d1  ),
        .d2  ( d2  ),
        .d3  ( d3  ),
        .sel ( key ),
        .y   ( y4  )
    );

endmodule
