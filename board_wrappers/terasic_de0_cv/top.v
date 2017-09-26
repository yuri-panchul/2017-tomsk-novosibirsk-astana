module top
(
    input         clock,
    input         reset_n,
    input  [ 3:0] key,
    input  [ 9:0] sw,
    output [ 9:0] led,
    output [ 6:0] hex0,
    output [ 6:0] hex1,
    output [ 6:0] hex2,
    output [ 6:0] hex3,
    output [ 6:0] hex4,
    output [ 6:0] hex5,
    inout  [35:0] gpio_0,
    inout  [35:0] gpio_1
);

    assign led [0] =   sw [0] & sw [1];
    assign led [1] =   sw [0] | sw [1];
    assign led [2] =   sw [0] ^ sw [1];
    assign led [3] = ~ sw [0];

    reg [31:0] n;
    
    always @ (posedge clock or negedge reset_n)
        if (! reset_n)
            n <= 32'b0;
        else
            n <= n + 1'b1;
    
    assign led [9:4] = n [31:26];

    assign hex0 = sw [6:0];
    assign hex1 = sw [7:1];
    assign hex2 = sw [8:2];
    assign hex3 = sw [9:3];
    assign hex4 =   7'b0;
    assign hex5 = ~ 7'b0;

endmodule
