`timescale 1 ns / 100 ps

module testbench;

    reg         clock;
    reg         reset_n;
    wire        cs;
    wire        sck;
    reg         sdo;
    wire [15:0] value;

    pmod_als_spi_receiver pmod_als_spi_receiver
    (
        clock,
        reset_n,
        cs,
        sck,
        sdo,
        value
    );

    initial
    begin
        clock = 0;

        forever
            # 50 clock = ~ clock;
    end

    initial
    begin
        reset_n    <= 1;
        repeat (5) @ (posedge clock);
        reset_n    <= 0;
        repeat (5) @ (posedge clock);
        reset_n    <= 1;
    end

    initial
    begin
        $dumpvars;

        $timeformat
        (
            -9,    // 1 ns
            1,     // Number of digits after decimal point
            "ns",  // suffix
            10     // Max number of digits 
        );

        repeat (2000)
        begin
            @ (negedge clock);
            sdo <= $random;
        end

        $finish;
    end

endmodule
