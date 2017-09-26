module spi_transmitter
(
    input            clock,
    input            reset,

    input      [7:0] data,

    input            transmit,
    output reg       ready,

    output reg       sclk,
    output reg       sdi,
    output reg       cs
);

    localparam IDLE                = 0,
               DRIVE_POSEDGE_CLOCK = 1,
               DRIVE_DATA          = 2;

    reg       d_ready;
    reg       d_sclk;
    reg       d_sdi;
    reg       d_cs;

    reg [2:0] counter;
    reg [6:0] shift_reg;
    reg [1:0] state;

    reg [2:0] d_counter;
    reg [6:0] d_shift_reg;
    reg [1:0] d_state;

    always @*
    begin
        d_ready     = ready;
        d_sclk      = 0;
        d_sdi       = sdi;
        d_cs        = cs;

        d_counter   = counter;
        d_shift_reg = shift_reg;
        d_state     = state;
        
        case (state)

        IDLE:
        begin
            if (transmit)
            begin
                d_ready     = 0;
                d_sclk      = 0;
                d_sdi       = data [7];
                d_cs        = 0;

                d_counter   = 7;
                d_shift_reg = data [6:0];
                
                d_state     = DRIVE_POSEDGE_CLOCK;
            end
            else
            begin
                d_cs        = 1;
            end
        end

        DRIVE_POSEDGE_CLOCK:
        begin
            d_sclk    = 1;
            // d_sdi stays the same

            if (d_counter == 0)
            begin
                d_ready = 1;
                d_state = IDLE;
            end
            else
            begin
                d_state = DRIVE_DATA;
            end
        end

        DRIVE_DATA:
        begin
            d_sclk      = 0;
            d_sdi       = d_shift_reg [6];

            d_counter   = d_counter - 3'd1;
            d_shift_reg = d_shift_reg << 1;

            d_state     = DRIVE_POSEDGE_CLOCK;
        end
		  
        endcase
    end

    always @(posedge clock)
    begin
        if (reset)
        begin
            ready     <= 1;
            sclk      <= 0;
            sdi       <= 0;
            cs        <= 0;

            counter   <= 0;
            shift_reg <= 0;
            state     <= IDLE;
        end
        else
        begin
            ready     <= d_ready;
            sclk      <= d_sclk;
            sdi       <= d_sdi;
            cs        <= d_cs;
                                      
            counter   <= d_counter;
            shift_reg <= d_shift_reg;
            state     <= d_state;
        end
    end

endmodule

//--------------------------------------------------------------------

module cmod_s6_pmod_dpot
(
    input        clock,

    input  [1:0] buttons,
    output [3:0] leds,

    output       dpot_vcc,
    output       dpot_gnd,
    output       dpot_sclk,
    output       dpot_sdi,
    output       dpot_cs
);

    wire reset    = buttons [0];
    wire increase = buttons [1];

    assign dpot_vcc = 1'b1;
    assign dpot_gnd = 1'b0;

    reg [7:0] d_resistance;
    reg       d_transmit;

    reg [7:0] resistance;
    reg       transmit;

    wire      ready;

    spi_transmitter spi_transmitter_inst
    (
        .clock     ( clock       ),
        .reset     ( reset       ),

        .data      ( resistance  ),

        .transmit  ( transmit    ),
        .ready     ( ready       ),

        .sclk      ( dpot_sclk   ),
        .sdi       ( dpot_sdi    ),
        .cs        ( dpot_cs     )
    );

    always @*
    begin
        d_resistance = resistance;
        d_transmit   = 0;

        if (ready & increase)
        begin
            d_resistance = d_resistance + 19;
            d_transmit   = 1;
        end
    end

    always @(posedge clock)
    begin
        if (reset)
        begin
            resistance <= 0;
            transmit   <= 0;
        end
        else
        begin
            resistance <= d_resistance;
            transmit   <= d_transmit;
        end
    end

    assign leds [0] = clock;
    assign leds [1] = dpot_sclk;
    assign leds [2] = dpot_sdi;
    assign leds [3] = ready;

endmodule
