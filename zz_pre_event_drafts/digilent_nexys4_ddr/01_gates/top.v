//----------------------------------------------------------------------------
//
//  Exercise   1. Simple combinational logic
//
//  Упражнение 1. Простая комбинационная логика
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Method 1. Using continuous assignments
//
//  Метод  1. Используем операторы непрерывного присваивания
//
//----------------------------------------------------------------------------

module top
(
    input        a,   // Кнопка слева
    input        b,   // Кнопка справа
    output [9:0] led  // Светодиоды
);

    // Basic gates AND, OR and NOT
    
    // Базовые логические элементы И, ИЛИ, НЕ

    assign led [0] = a & b;
    assign led [1] = a | b;
    assign led [2] = ~ a;
    
    // XOR gates (useful for adders, comparisons,
    // parity and control sum calculation)

    // Логический элемент ИСКЛЮЧАЮЩЕЕ ИЛИ (полезный для сумматоров,
    // сравнений, вычисления четности и контрольных сумм)

    assign led [3] = a ^ b;

    // Building XOR only using AND, OR and NOT
    
    // Строим XOR используя только И, ИЛИ, НЕ

    assign led [4] = (a | b) & ~ (a & b);

    // Building NOT by XORing with 1
    
    // Строим НЕ, делая ИСКЛЮЧАЮЩЕЕ ИЛИ с единицей

    assign led [5] = a ^ 1'b1;

    // De Morgan law illustration
    
    // Иллюстрация законов де Моргана

    assign led [6] = ~ ( a &   b ) ;
    assign led [7] = ~   a | ~ b   ;
    assign led [8] = ~ ( a |   b ) ;
    assign led [9] = ~   a & ~ b   ;
    
endmodule

//----------------------------------------------------------------------------
//
//  Method 2. Using always-blocks and blocking assignments
//
//  Метод  2. Используем always-блок и блокирующие присваивания
//  (blocking assignments)
//
//----------------------------------------------------------------------------

module top_2
(
    input            a,
    input            b,
    output reg [9:0] led
);

    always @*
    begin
        led [0] = a & b;
        led [1] = a | b;
        led [2] = ~ a;
    
        led [3] = a ^ b;

        led [4] = (a | b) & ~ (a & b);
        led [5] = a ^ 1'b1;

        led [6] = ~ ( a &   b ) ;
        led [7] = ~   a | ~ b   ;
        led [8] = ~ ( a |   b ) ;
        led [9] = ~   a & ~ b   ;
    end

endmodule

//----------------------------------------------------------------------------
//
//  Method 3. Using built-in primitives and, or, not, xor
//
//  Метод  3. Используем встроенные примитивы and, or, not, xor
//
//----------------------------------------------------------------------------

module top_3
(
    input        a,
    input        b,
    output [9:0] led
);

    and  and_1  (led [0], a, b);
    or   or_1   (led [1], a, b);
    not  not_3  (led [2], a);
    xor  xor_1  (led [3], a, b);

    // led [4] = (a | b) & ~ (a & b)

    wire w1, w2, w3;
    
    or   or_2   (w1, a, b);
    and  and_2  (w2, a, b);
    not  not_4  (w3, w2);
    and  and_3  (led [4], w1, w3);

    // led [5] = a ^ 1'b1

    xor  xor_2  (led [5], a, 1'b1);

    // led [6] = ~ (a & b)

    wire w4;

    and  and_4  (w4, a, b);
    not  not_5  (led [6], w4);
    
    // led [7] = ~ a | ~ b  

    wire w5, w6;

    not  not_6  (w5, a);
    not  not_7  (w6, b);
    or   or_3   (led [7], w5, w6);

    // led [8] = ~ (a | b)

    wire w7;

    or   or_4   (w7, a, b);
    not  not_8  (led [8], w7);

    // led [9] = ~ a & ~ b

    wire w8, w9;

    not  not_9  (w8, a);
    not  not_10 (w9, b);
    and  and_5  (led [9], w8, w9);

endmodule
