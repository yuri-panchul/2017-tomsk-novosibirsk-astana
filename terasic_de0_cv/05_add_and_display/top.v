//----------------------------------------------------------------------------
//
//  Exercise   5. Adders
//
//  Упражнение 5. Сложение и вывод на 7-сегментный индикатор
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Exercise 5.1. Simple 4-bit adder. Carry is displayed as a dot.
//
//  Упражнение 5.1. Простое сложение четырехбитовых чисел. Перенос отображается
//  как точка.
//
//----------------------------------------------------------------------------

module top
(
    input  [7:0] sw,   // switches // переключатели
    output [7:0] hex0  // Seven-segment display // индикатор
);

    wire [3:0] a = sw [3:0];
    wire [3:0] b = sw [7:4];

    wire [4:0] result = a + b;
    wire carry = result [4];

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

    reg [6:0] abcdefg;

    always @*
    begin
        case (result[3:0])
        4'h0: abcdefg = 7'b1000000;
        4'h1: abcdefg = 7'b1111001;
        4'h2: abcdefg = 7'b0100100;
        4'h3: abcdefg = 7'b0110000;
        4'h4: abcdefg = 7'b0011001;
        4'h5: abcdefg = 7'b0010010;
        4'h6: abcdefg = 7'b0000010;
        4'h7: abcdefg = 7'b1111000;
        4'h8: abcdefg = 7'b0000000;
        4'h9: abcdefg = 7'b0010000;
        4'ha: abcdefg = 7'b0001000;
        4'hb: abcdefg = 7'b0000011;
        4'hc: abcdefg = 7'b1000110;
        4'hd: abcdefg = 7'b0100001;
        4'he: abcdefg = 7'b0000110;
        4'hf: abcdefg = 7'b0001110;
        endcase
    end

    assign hex0[7:0] = { ~carry, abcdefg };

endmodule

