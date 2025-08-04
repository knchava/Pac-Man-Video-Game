module randN(
    input logic clk, reset,
    output logic [2:0]random_num
);

    logic [15:0] lfsr_reg;
    logic feedback;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr_reg <= 16'b1;
        end else begin
            feedback = lfsr_reg[15] ^ lfsr_reg[13] ^ lfsr_reg[12] ^ lfsr_reg[10];
            lfsr_reg <= {lfsr_reg[14:0], feedback};
        end
    end
    assign random_num = lfsr_reg[2:0];

endmodule
