//----------------------------------------------------------------------------
//
//  Exercise   8. Counter
//
//  Упражнение 8. Счетчик
//
//----------------------------------------------------------------------------

//----------------------------------------------------------------------------
//
//  Exercise 8.1. All components in one module
//
//  Упражнение 8.1. Все компоненты в одном модуле
//
//----------------------------------------------------------------------------

module top_1
(
    input        clock, // Clock signal 50 MHz // Тактовый сигнал 50 МГц
    input  [0:0] key,   // Button // Кнопка
    output [7:0] hex0   // Seven-segment display // индикатор
);

    wire reset_n = key[0];

    reg [29:0] counter;

    always @(posedge clock or negedge reset_n)
    begin
        if (!reset_n)
            counter <= 30'b0;
        else
            counter <= counter + 30'b1;
    end

    wire [3:0] number = counter [29:26];

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
        case (number)
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

    assign hex0[7:0] = { 1'b1, abcdefg };

endmodule

//----------------------------------------------------------------------------
//
//  Exercise 8.2. With modules
//
//  Упражнение 8.2. С модульной иерархией
//
//----------------------------------------------------------------------------

module counter
(
    input             clock,
    input             reset_n,
    output reg [31:0] count
);

    always @(posedge clock or negedge reset_n)
    begin
        if (!reset_n)
            count <= 32'b0;
        else
            count <= count + 32'b1;
    end

endmodule

//----------------------------------------------------------------------------

module seven_segment_display_driver
(
    input      [3:0] number,
    output reg [6:0] abcdefg
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

    always @*
        case (number)
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

endmodule

module top
(
    input        clock, // Clock signal 50 MHz // Тактовый сигнал 50 МГц
    input  [0:0] key,   // Button // Кнопка
    output [7:0] hex0   // Seven-segment display // индикатор
);

    wire reset_n = key[0];

    wire [31:0] counter;

    counter counter_i
    (
        .clock   ( clock ),
        .reset_n ( reset_n ),
        .count   ( counter )
    );

    seven_segment_display_driver display_driver_i
    (
        .number  ( counter [29:26] ),
        .abcdefg ( hex0 [6:0]      )
    );

    assign hex0[7] = 1'b1;

endmodule

