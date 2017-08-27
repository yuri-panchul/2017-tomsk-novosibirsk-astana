//----------------------------------------------------------------------------
//
//  Exercise   4. Combinational design
//
//  Упражнение 4. Combinational design
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Exercise 4.1. Display either 'Tomsk', 'Nsk', or 'Astana' depending on buttons 0 and 1.
//
//  Упражнение 4.1. Выводим 'Tomsk', 'Nsk' или 'Astana' в зависимости от кнопок 0 или 1. 
//
//----------------------------------------------------------------------------

module top
(
    input  [1:0]     key,  // Buttons // Кнопки
    output reg [7:0] hex0, // Seven-segment display // индикатор
    output reg [7:0] hex1,
    output reg [7:0] hex2,
    output reg [7:0] hex3,
    output reg [7:0] hex4,
    output reg [7:0] hex5
);

/*
        'h0: seven_segments = 'b01000000;  // . a b c d e f g
        'h1: seven_segments = 'b01111001;
        'h2: seven_segments = 'b00100100;  //   --a--
        'h3: seven_segments = 'b00110000;  //  |     |
        'h4: seven_segments = 'b00011001;  //  f     b
        S: seven_segments = 'b00010010;  //  |     |
        'h6: seven_segments = 'b00000010;  //   --g--
        'h7: seven_segments = 'b01111000;  //  |     |
        'h8: seven_segments = 'b00000000;  //  e     c
        'h9: seven_segments = 'b00011000;  //  |     |
        'ha: seven_segments = 'b00001000;  //   --d-- 
    parameter [9:0] A = 8'b10000100,
                    K = 8'b11111111,
                    L = 8'b11111111,
                    M = 8'b11111111,
                    N = 8'b11111111,
                    O = 8'b11111111,
                    S = 8'b11111111,
                    T = 8'b11111111,
                    Y = 8'b11111111,
                  eps = 8'b11111111;
                  */

    parameter [7:0] A = 8'b10001000,
                    K = 8'b10001001,
                    L = 8'b11000111,
                    M = 8'b11101010,
                    N = 8'b10101011,
                    O = 8'b11000000,
                    S = 8'b10010010,
                    T = 8'b10000111,
                    Y = 8'b10010001,
                  eps = 8'b11111111;

    always @*
        case (key)
        2'b11: { hex5, hex4, hex3, hex2, hex1, hex0 } = { eps, T,   O,   M,   S,   K   };
        2'b10: { hex5, hex4, hex3, hex2, hex1, hex0 } = { eps, eps, eps, N,   S,   K   };
        2'b01: { hex5, hex4, hex3, hex2, hex1, hex0 } = { A,   S,   T,   A,   N,   A   };
        2'b00: { hex5, hex4, hex3, hex2, hex1, hex0 } = { eps, eps, eps, eps, eps, eps };
        endcase

endmodule

