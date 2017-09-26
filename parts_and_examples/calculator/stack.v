`include "defines.vh"

module stack
(
    input  clock,
    input  reset,
    input  push,
    input  pop,

    input  [`word_width - 1:0] write_data,
    output [`word_width - 1:0] read_data
);

    reg [`word_width - 1:0] stack [0:`stack_size - 1];

    assign read_data = stack [0];

    integer i;

    always @(posedge clock)
    begin
        if (reset)
        begin
            for (i = 0; i < `stack_size; i = i + 1)
                stack [i] <= 0;
        end
        else if (push)
        begin
            for (i = 0; i < `stack_size - 1; i = i + 1)
                stack [i + 1] <= stack [i];

            stack [0] <= write_data;
        end
        else if (pop)
        begin
            for (i = 0; i < `stack_size - 1; i = i + 1)
                stack [i] <= stack [i + 1];

            stack [`stack_size - 1] <= 0;
        end
    end

endmodule
