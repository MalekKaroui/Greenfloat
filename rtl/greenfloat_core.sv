`timescale 1ns/1ps

module greenfloat_core
    import fp16_green_pkg::*;
(
    input  logic        clk,
    input  logic        rst_n,
    input  logic        mode,           // 0 = FP32, 1 = FP16
    input  logic [1:0]  operation,      // 00=add, 10=mul
    input  logic        valid_in,
    input  logic [31:0] a32,
    input  logic [31:0] b32,
    input  logic [15:0] a16,
    input  logic [15:0] b16,
    output logic [31:0] result32,
    output logic [15:0] result16,
    output logic        valid_out,
    output logic        overflow,
    output logic        underflow,
    output logic [15:0] cycle_count,
    output logic [7:0]  active_bits
);

    // Internal wires
    logic [31:0] fp32_add_result, fp32_mul_result;
    logic [15:0] fp16_add_result, fp16_mul_result;
    logic        fp32_add_valid, fp32_mul_valid;
    logic        fp16_add_valid, fp16_mul_valid;
    logic        fp32_add_ovf, fp32_mul_ovf;
    logic        fp16_add_ovf, fp16_mul_ovf;
    
    logic is_add, is_mul;
    assign is_add = (operation == 2'b00);
    assign is_mul = (operation == 2'b10);
    
    // FP32 Units
    fp32_adder u_fp32_add (
        .clk(clk), .rst_n(rst_n),
        .valid_in(valid_in && !mode && is_add),
        .a(a32), .b(b32), .subtract(1'b0),
        .result(fp32_add_result),
        .valid_out(fp32_add_valid),
        .overflow(fp32_add_ovf),
        .underflow()
    );
    
    fp32_multiplier u_fp32_mul (
        .clk(clk), .rst_n(rst_n),
        .valid_in(valid_in && !mode && is_mul),
        .a(a32), .b(b32),
        .result(fp32_mul_result),
        .valid_out(fp32_mul_valid),
        .overflow(fp32_mul_ovf),
        .underflow()
    );
    
    // FP16 Units
    fp16_adder u_fp16_add (
        .clk(clk), .rst_n(rst_n),
        .valid_in(valid_in && mode && is_add),
        .a(a16), .b(b16), .subtract(1'b0),
        .result(fp16_add_result),
        .valid_out(fp16_add_valid),
        .overflow(fp16_add_ovf),
        .underflow()
    );
    
    fp16_multiplier u_fp16_mul (
        .clk(clk), .rst_n(rst_n),
        .valid_in(valid_in && mode && is_mul),
        .a(a16), .b(b16),
        .result(fp16_mul_result),
        .valid_out(fp16_mul_valid),
        .overflow(fp16_mul_ovf),
        .underflow()
    );
    
    // Output muxing
    always_comb begin
        if (mode) begin
            result16 = is_mul ? fp16_mul_result : fp16_add_result;
            result32 = {16'b0, result16};
            valid_out = is_mul ? fp16_mul_valid : fp16_add_valid;
            overflow = is_mul ? fp16_mul_ovf : fp16_add_ovf;
            active_bits = 8'd16;
        end else begin
            result32 = is_mul ? fp32_mul_result : fp32_add_result;
            result16 = result32[15:0];
            valid_out = is_mul ? fp32_mul_valid : fp32_add_valid;
            overflow = is_mul ? fp32_mul_ovf : fp32_add_ovf;
            active_bits = 8'd32;
        end
        underflow = 1'b0;
    end
    
    // Cycle counter
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cycle_count <= 16'b0;
        else if (valid_in)
            cycle_count <= cycle_count + 1'b1;
    end

endmodule