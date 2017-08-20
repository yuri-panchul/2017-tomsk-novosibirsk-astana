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

    wire pwm = GPIO_1 [14];
	 reg  prev_pwm;
	 
	 always @ (posedge CLOCK_50)
	     if (! RESET_N)
		      prev_pwm <= 1'b0;
			else
			   prev_pwm <= pwm;
				
	wire start_counting = ~ prev_pwm & pwm;
	wire stop_counting  = prev_pwm & ~ pwm;
	wire count          = pwm;
	
	reg [31:0] counter;
	reg [31:0] distance;
	
	always @ (posedge CLOCK_50 or negedge RESET_N)
		if (! RESET_N)
		begin
		    counter  <= 32'd0;
			 distance <= 32'd0;
	   end
		else if (start_counting)
		    counter  <= 32'd0;
		else if (stop_counting)
		    distance <= counter;
		else
		    counter <= counter + 32'd1;
	 
    assign LEDR = distance [19:10];
	 
endmodule
