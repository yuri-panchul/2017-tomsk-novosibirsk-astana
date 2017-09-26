`include "defines.vh"

module calculator_behavioral
(
    input             clock,
    input             reset,
    input             enter,
    input             add,
    input             multiply,
    input      [ 7:0] data,
    output reg [15:0] result,
    output reg        overflow,
    output reg [ 3:0] error
);

    reg [`stack_pointer_size - 1:0] sp;
    reg [15:0] stack [0 : `stack_size - 1];
    reg        empty;

    reg [16:0] result_17;
    reg [31:0] result_32;

    integer i;

    //  This software-like style is not a good RTL style because:
    //
    //  1. It mixes blocking and non-blocking assignments
    //
    //  2. It is difficult to figure out whether a reg
    //     is going to become a flip-flop or a wire
    //
    //  3. It makes timing optimization difficult
    //
    //  However this style of coding is easier to read for a software
    //  or a verification person

    always @(posedge clock or posedge reset)
    begin
        if (reset)
        begin
            sp        =  0;
            empty     =  1;

            result    <= 0;
            overflow  <= 0;
            error     <= 0;
        end
        else
        begin
            if (enter)
            begin
                if (sp == `stack_size - 1)
                begin
                    error <= 1;
                end
                else
                begin
                    if (! empty)
                        sp = sp + 1;

                    empty = 0;

                    for (i = `stack_size - 1; i >= 1; i = i - 1)
                        stack [i] = stack [i - 1];

                    stack [0] = data;
                end
            end
            else if (add)
            begin
                if (sp == 0)
                begin
                    error <= 2;
                end
                else
                begin
                    sp = sp - 1;

                    result_17 = stack [0] + stack [1];
                    stack [0] = result_17 [15:0];
                    overflow <= result_17 [16];

                    for (i = 1; i <= `stack_size - 2; i = i + 1)
                        stack [i] = stack [i + 1];
                end
            end
            else if (multiply)
            begin
                if (sp == 0)
                begin
                    error <= 3;
                end
                else
                begin
                    sp = sp - 1;

                    result_32 = stack [0] * stack [1];
                    stack [0] = result_32 [15:0];
                    overflow <= | result_32 [31:16];

                    for (i = 1; i <= `stack_size - 2; i = i + 1)
                        stack [i] = stack [i + 1];
                end
            end

            result <= empty ? 0 : stack [0];
        end
    end

endmodule
