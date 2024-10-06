`ifndef DELAY_SV 
`define DELAY_SV

`include "../libs/macros/macros.sv"

module delay #(
    delay_time  = 1,
    cnt_size    = 4,
    delay_size  = 8 
) (
    input                           clk    ,
    input                           reset  ,
    input                           valid  ,
    input       [delay_size - 1: 0] in     ,
    output      [delay_size - 1: 0] out    ,
    output                          ready  ,
    output                          next
);

reg [cnt_size   - 1: 0] cnt;
reg [delay_size - 1: 0] buffer;

assign ready = (cnt == delay_time && delay_time != 0) || (delay_time == 0 && valid);
assign out   = (ready ? (cnt == 0 ? in : buffer) : '0 );
assign next  = (cnt != 0 && ready) || (cnt == 0 && ~ready) || (delay_time == 0);

always @(posedge clk) begin
    if (reset || (next && ~valid)) begin
        cnt <= '0;
    end else begin
        if (delay_time != 0 && valid && next) begin
            buffer <= in;
            cnt <= 1'b1;
        end else if (cnt > 0)
            cnt <= cnt + 1'b1;
    end
end

endmodule

`endif
