module testbench;

    reg         clock;
    reg         reset;
    reg         enter;
    reg         add;
    reg         multiply;
    reg  [ 7:0] data;
    wire [15:0] result;
    wire        overflow;
    wire [ 3:0] error;

    calculator calculator
    (
        clock,
        reset,
        enter,
        add,
        multiply,
        data,
        result,
        overflow,
        error
    );

    initial
    begin
        clock = 0;

        forever
            # 5 clock = ! clock;
    end

    //----------------------------------------------------------------

    task dump;
    begin

        $write   ("data=%h enter=%h add=%h multiply=%h",
                   data,   enter,   add,   multiply);

        $display (" result=%h overflow=%h error=%h",
                    result,   overflow,   error);

    end
    endtask

    task t_reset;
    begin

        reset     <= 1; repeat (10) @(posedge clock);

        enter     <= 0;
        add       <= 0;
        multiply  <= 0;
        data      <= 0;

        reset     <= 0; repeat (10) @(posedge clock);

        $write ("After reset    "); dump;

    end
    endtask

    task t_enter (input [7:0] value);
    begin

        data      <= value;
        enter     <= 1;             @(posedge clock);
        enter     <= 0; repeat (10) @(posedge clock);

        $write ("After enter %x ", value); dump;

    end
    endtask

    task t_add;
    begin

        add       <= 1;             @(posedge clock);
        add       <= 0; repeat (10) @(posedge clock);

        $write ("After add      "); dump;

    end
    endtask

    task t_multiply;
    begin

        multiply  <= 1;             @(posedge clock);
        multiply  <= 0; repeat (10) @(posedge clock);

        $write ("After multiply "); dump;

    end
    endtask

    //----------------------------------------------------------------

    initial
    begin
        $display ("********  2 3 * 4 5 * + ********");

        t_reset;

        t_enter (2);
        t_enter (3);
        t_multiply;
        t_enter (4);
        t_enter (5);
        t_multiply;
        t_add;

        $display ("********  ff ff ff * * overflow ********");

        t_reset;

        t_enter ('hff);
        t_enter ('hff);
        t_enter ('hff);
        t_multiply;
        t_multiply;

        $display ("********  ff 1 + ff * ff + 1 + overflow ********");

        t_reset;

        t_enter ('hff);
        t_enter ('h01);
        t_add;
        t_enter ('hff);
        t_multiply;
        t_enter ('hff);
        t_add;
        t_enter ('h01);
        t_add;

        $display ("********  1 2 3 4 5 * * * * * ********");

        t_reset;

        t_enter ('h01);
        t_enter ('h02);
        t_enter ('h03);
        t_enter ('h04);
        t_enter ('h05);
        repeat (5) t_multiply;

        $finish;
    end

    initial $dumpvars;

endmodule
