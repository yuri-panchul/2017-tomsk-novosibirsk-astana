		module sum
		(
			input logic [2:0] a,b,
			output logic [3:0] res
		 );
			logic [3:1] c;
			
			always @*
			begin
			  res[0] = a[0] ^ b[0];
			  c[1] = a[0] & b[0];
			  res[1] = (a[1] ^ b[1]) ^ c[1];
			  c[2] = (a[1] & b[1]) | (a[1] & c[1]) | (c[1] & b[1]);
			  res[2] = (a[2] ^ b[2]) ^ c[2];
			  c[3] = (a[2] & b[2]) | (a[2] & c[2]) | (c[2] & b[2]);
			  res[3] = c[3];
			end

			endmodule


module de0_cv
(
    input           CLOCK2_50,
    input           CLOCK3_50,
    inout           CLOCK4_50,
    input           CLOCK_50,
                   
    input           RESET_N,

    input   [ 3:0]  KEY,
    input   [ 9:0]  SW,

    output  [ 9:0]  LEDR,

    output  [ 6:0]  HEX0,
    output  [ 6:0]  HEX1,
    output  [ 6:0]  HEX2,
    output  [ 6:0]  HEX3,
    output  [ 6:0]  HEX4,
    output  [ 6:0]  HEX5,
                   
    output  [12:0]  DRAM_ADDR,
    output  [ 1:0]  DRAM_BA,
    output          DRAM_CAS_N,
    output          DRAM_CKE,
    output          DRAM_CLK,
    output          DRAM_CS_N,
    inout   [15:0]  DRAM_DQ,
    output          DRAM_LDQM,
    output          DRAM_RAS_N,
    output          DRAM_UDQM,
    output          DRAM_WE_N,
                   
    output  [ 3:0]  VGA_B,
    output  [ 3:0]  VGA_G,
    output          VGA_HS,
    output  [ 3:0]  VGA_R,
    output          VGA_VS,

    inout           PS2_CLK,
    inout           PS2_CLK2,
    inout           PS2_DAT,
    inout           PS2_DAT2,
                   
    output          SD_CLK,
    inout           SD_CMD,
    inout   [ 3:0]  SD_DATA,
                   
    inout   [35:0]  GPIO_0,
    inout   [35:0]  GPIO_1
);


  sum sum_inst
  (
    .a   (SW [2:0]),
	 .b   (SW [5:3]),
	 .res (LEDR [3:0])
  );

`ifdef UNDEF
    /*parameter [6:0] A = 7'b0001000,
                    L = 7'b1000111,
                    M = 7'b1101010,
                    N = 7'b0101011,
                    S = 7'b0010010,
                    T = 7'b0000111,
                    Y = 7'b0010001;
*/
	parameter[6:0] S = 7'b0010010,
					V =    7'b1100011,
					D =    7'b0100001,
					K =    7'b0001001,
					five = 7'b0010010,
					four = 7'b0011001,
					H =    7'b0001001,
					E =    7'b0000110,
					L =    7'b1000111,
					O =    7'b1000000,
					P =    7'b0001100,
					M =    7'b1101010,
					_ =    7'b1111111,
					one =  7'b1111001,
					null = 7'b1000000;
					
		 
    //wire sel  = KEY [0];
	 //wire sel2 = KEY [3];
/*
    assign HEX5 = KEY[3] == 0?V:H;
    assign HEX4 = KEY[3] == 0?S:E;
    assign HEX3 = KEY[3] == 0?D:L;
    assign HEX2 = KEY [0] == 0?P:KEY[3] == 0?K:L;
    assign HEX1 = KEY [0] == 0?M:KEY[3] == 0?five:O;
    assign HEX0 = KEY [0] == 0?E:KEY[3] == 0?four:_;
*/
    // Alternative way
    
    // assign { HEX5, HEX4, HEX3, HEX2, HEX1, HEX0 } =
    //    sel ? { A, L, M, A, T, Y } : { A, S, T, A, N, A };
`endif
	 
endmodule
