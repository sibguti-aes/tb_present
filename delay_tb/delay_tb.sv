`ifndef DELAY_TB 
`define DELAY_TB

`include "../libs/macros/macros.sv"
`include "../libs/function/params.sv"
`include "../delay/delay.sv"

localparam delay_time  = 0;
localparam delay_size  = 8;
localparam cnt_size    = 4;

typedef struct packed {
    logic                     clk  ;
    logic                     reset;
    logic                     valid;
    logic [delay_size - 1: 0] in   ;
    logic [delay_size - 1: 0] out  ;
    logic                     ready;
    logic                     next ;
} struct_delay;
struct_delay st_delay;

`ifndef CLK
    `define CLK @(posedge st_delay.clk);
`endif

task automatic test_st_reset ();
    st_delay.reset =  0;
    st_delay.valid =  0;
    st_delay.in    = '0;
    `CLK
    st_delay.reset =  1;
    `CLK
    st_delay.reset =  0;
    `CLK
endtask

task automatic test_in (ref bit bits_in[][]);
    for (int i = 0; i < bits_in.size(); i++)
    begin
        if (st_delay.next)
        begin
            st_delay.valid = 1;
            for (int j = 0; j < delay_size; j++)
            begin
                st_delay.in[j] = bits_in[i][j];
            end
        end else i--;
        `CLK
        st_delay.valid = 0;
        /* mandatory */
        if (delay_time != 0) @(negedge st_delay.next);
    end
    `CLK
endtask

task automatic test_out (ref bit bits_out[][]);
    for (int i = 0; i < $size(bits_out); i++)
    begin
        if (st_delay.ready)
        begin
            for (int j = 0; j < delay_size; j++)
            begin
                bits_out[i][j] = st_delay.out[j];
            end
        end else i--;
        `CLK
    end
    `CLK
endtask

task automatic test_delay (ref bit bits_in[][], ref bit bits_out[][]);
    test_st_reset();
    fork
        test_in (bits_in );
        test_out(bits_out);
    join
endtask

module delay_tb #() ();
    string name_in_file  = "input";
    string name_out_file = "output";

    bit bits_in [][];
    bit bits_out[][];
    bit bits_xor[][];

    initial st_delay.clk = 0;
    always #10 st_delay.clk = ~st_delay.clk;

    initial begin
        initParams(name_in_file, bits_in, bits_out);
        `PM(bits_in)

        test_delay(bits_in, bits_out);
        `PM(bits_out)

        bits_xor = xorMatrBits(bits_in, bits_out);
        `PM(bits_xor)

        writeFileBitsStr(name_out_file, bits_out);

        $finish();
    end

    delay #(
        .delay_time (delay_time     ),
        .cnt_size   (cnt_size       ),
        .delay_size (delay_size     )
    ) delay_inst (
        .clk        (st_delay.clk   ),
        .reset      (st_delay.reset ),
        .valid      (st_delay.valid ),
        .in         (st_delay.in    ),
        .out        (st_delay.out   ),
        .ready      (st_delay.ready ),
        .next       (st_delay.next  )
    );
endmodule

`endif
