//----------------------------------------------------------------------------
//
//  Exercise   3. Buttons and Letters
//
//  Упражнение 3. Буква в зависимости от кнопки
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Exercise 3.1. Show letter 'Y' on seven-segment display,
//  using continuous assignment for each bit.
//
//  Упражнение 3.1. Выводим букву 'Y' на семисегментный индикатор,
//  используя операторы непрерывного присваивания для каждого бита
//
//----------------------------------------------------------------------------

module top_1
(
    input  [1:0] key,  // Two buttons // Две кнопки
    output [7:0] hex0  // Seven-segment display // индикатор
);

    // a b c d e f g .   // Letter from scheme below
    // 0 1 2 3 4 5 6 7   // Bit in hex0
                      
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--        

    assign hex0 [0] = 1'b1; // a
    assign hex0 [1] = 1'b0; // b
    assign hex0 [2] = 1'b0; // c
    assign hex0 [3] = 1'b0; // d
    assign hex0 [4] = 1'b1; // e
    assign hex0 [5] = 1'b0; // f
    assign hex0 [6] = 1'b0; // g
    assign hex0 [7] = 1'b1; // .

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 3.2. Show letter 'P'. Assign as a bitvector using
//  continuous assignment for every bit.
//
//  Упражнение 3.2. Выводим одну букву 'P'. Присваиваем целым битовым
//  вектором, используя операторы непрерывного присваивания для каждого
//  бита.
//
//----------------------------------------------------------------------------

module top_2
(
    input  [1:0] key,  // Two buttons // Две кнопки
    output [7:0] hex0  // Seven-segment display // индикатор
);

    // a b c d e f g .   // Letter from scheme below
    // 0 1 2 3 4 5 6 7   // Bit in hex0
                      
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--        

    assign hex0 [7:0] = 8'b10001100; // abcdefg.

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 3.3. Show letter Y or P depending on the input from key[0].
//
//  Упражнение 3.3. Выводим Y или P в зависимости от кнопки 0.
//
//----------------------------------------------------------------------------

module top_3
(
    input  [1:0] key,  // Two buttons // Две кнопки
    output [7:0] hex0  // Seven-segment display // индикатор
);

    // a b c d e f g .   // Letter from scheme below
    // 0 1 2 3 4 5 6 7   // Bit in hex0
                      
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--        

    assign hex0 [7:0] = key[0] ? 8'b10001100 /* Y */ : 8'b10010001 /* P */; 

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 3.4. Show letter Y or P depending on the input from key[0].
//  Key[1] flips the letter. Assign + ternary operator.
//
//  Упражнение 3.4. Выводим Y или P в зависимости от кнопки 0.
//  Кнопка 1 переворачивает букву.
//  Способ 1. assign и операция '?'
//
//----------------------------------------------------------------------------

module top_4
(
    input  [1:0] key,  // Two buttons // Две кнопки
    output [7:0] hex0  // Seven-segment display // индикатор
);

    // a b c d e f g .   // Letter from scheme below
    // 0 1 2 3 4 5 6 7   // Bit in hex0
                      
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--        

    assign hex0 [7:0]
        = 
        key [1]
            ? (key [0]
                ? 8'b10001100    /* P */
                : 8'b10010001 )  /* Y */
            : (key [0]
                ? 8'b10100001    /* flipped P */
                : 8'b10001010 ); /* flipped Y */

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 3.5. Show letter Y or P depending on the input from key[0].
//  Key[1] flips the letter. 
//  Always-block and 'if' operator.
//
//  Упражнение 3.5. Выводим Y или P в зависимости от кнопки 0.
//  Кнопка 1 переворачивает букву.
//  Способ 2. Always-блок и оператор 'if'
//
//----------------------------------------------------------------------------

module top_5
(
    input  [1:0] key,  // Two buttons // Две кнопки
    output [7:0] hex0  // Seven-segment display // индикатор
);

    // a b c d e f g .   // Letter from scheme below
    // 0 1 2 3 4 5 6 7   // Bit in hex0
                      
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--        

    reg [7:0] hex_r; 
    always @*
    begin
        if (key [1])
        begin
            if (key [0])
                hex_r = 8'b10001100; /* P */
            else
                hex_r = 8'b10010001; /* Y */
        end
        else
        begin
            if (key [0])
                hex_r = 8'b10100001; /* flipped P */
            else
                hex_r = 8'b10001010; /* flipped Y */
        end
    end

    assign hex0 [7:0] = hex_r;

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 3.6. Show letter Y or P depending on the input from key[0].
//  Key[1] flips the letter. 
//  Always-block and 'case' operator.
//
//  Упражнение 3.6. Выводим Y или P в зависимости от кнопки 0.
//  Кнопка 1 переворачивает букву.
//  Способ 3. Always-блок и оператор 'case'
//
//----------------------------------------------------------------------------

module top_6
(
    input  [1:0] key,  // Two buttons // Две кнопки
    output [7:0] hex0  // Seven-segment display // индикатор
);

    // a b c d e f g .   // Letter from scheme below
    // 0 1 2 3 4 5 6 7   // Bit in hex0
                      
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--        

    reg [7:0] hex_r; 
    always @*
        case (key)
        2'b00: hex_r = 8'b10001010; /* flipped Y */
        2'b01: hex_r = 8'b10100001; /* flipped P */
        2'b10: hex_r = 8'b10010001; /* Y */
        2'b11: hex_r = 8'b10001100; /* P */
        endcase

    assign hex0 [7:0] = hex_r;

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 3.7. Show numbers from 0 to 7 depending on switches.
//
//  Упражнение 3.7. Выводим числа от 0 до 7 в зависимости от трех переключателей.
//
//----------------------------------------------------------------------------

module top
(
    input  [2:0] sw,   // switches // переключатели
    output [7:0] hex0  // Seven-segment display // индикатор
);

    // a b c d e f g .   // Letter from scheme below
    // 0 1 2 3 4 5 6 7   // Bit in hex0
                      
    //   --a--
    //  |     |
    //  f     b
    //  |     |
    //   --g--
    //  |     |
    //  e     c
    //  |     |
    //   --d--        

    reg [7:0] hex_r; 
    always @*
        case (sw)
        3'b000: hex_r = 8'b11000000; // 0
        3'b001: hex_r = 8'b11111001; // 1
        3'b010: hex_r = 8'b10100100; // 2
        3'b011: hex_r = 8'b10110000; // 3
        3'b100: hex_r = 8'b10011001; // 4
        3'b101: hex_r = 8'b10010010; // 5
        3'b110: hex_r = 8'b10000010; // 6
        3'b111: hex_r = 8'b11111000; // 7
        endcase

    assign hex0 [7:0] = hex_r;

endmodule

