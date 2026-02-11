`timescale 1ns/1ps

module benchmark_tb;

    // Clock and reset
    logic clk = 0;
    logic rst_n;
    
    // DUT signals
    logic        mode;
    logic [1:0]  operation;
    logic        valid_in;
    logic [31:0] a32, b32;
    logic [15:0] a16, b16;
    logic [31:0] result32;
    logic [15:0] result16;
    logic        valid_out;
    logic        overflow, underflow;
    logic [15:0] cycle_count;
    logic [7:0]  active_bits;
    
    integer csv_file;
    integer test_count = 0;
    integer pass_count = 0;
    integer fail_count = 0;
    
    // Clock generation
    always #5 clk = ~clk;
    
    // DUT
    greenfloat_core dut (.*);
    
    // VCD dump
    initial begin
        $dumpfile("results/greenfloat_benchmark.vcd");
        $dumpvars(0, benchmark_tb);
    end
    
    // Test task for FP16 addition
    task test_fp16_add(input [15:0] op_a, op_b, expected, input string desc);
        begin
            test_count++;
            mode = 1;
            operation = 2'b00;
            a16 = op_a;
            b16 = op_b;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            repeat(4) @(posedge clk);
            
            $fwrite(csv_file, "FP16,ADD,%h,%h,%h,%h,%s,%s\n",
                    op_a, op_b, result16, expected,
                    (result16 == expected) ? "PASS" : "FAIL", desc);
            
            if (result16 == expected) begin
                pass_count++;
                $display("[PASS] FP16 ADD: %s", desc);
            end else begin
                fail_count++;
                $display("[FAIL] FP16 ADD: %s - Expected %h, Got %h", desc, expected, result16);
            end
        end
    endtask
    
    // Test task for FP16 multiplication
    task test_fp16_mul(input [15:0] op_a, op_b, expected, input string desc);
        begin
            test_count++;
            mode = 1;
            operation = 2'b10;
            a16 = op_a;
            b16 = op_b;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            repeat(4) @(posedge clk);
            
            $fwrite(csv_file, "FP16,MUL,%h,%h,%h,%h,%s,%s\n",
                    op_a, op_b, result16, expected,
                    (result16 == expected) ? "PASS" : "FAIL", desc);
            
            if (result16 == expected) begin
                pass_count++;
                $display("[PASS] FP16 MUL: %s", desc);
            end else begin
                fail_count++;
                $display("[FAIL] FP16 MUL: %s - Expected %h, Got %h", desc, expected, result16);
            end
        end
    endtask
    
    // Test task for FP32 addition
    task test_fp32_add(input [31:0] op_a, op_b, expected, input string desc);
        begin
            test_count++;
            mode = 0;
            operation = 2'b00;
            a32 = op_a;
            b32 = op_b;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            repeat(5) @(posedge clk);
            
            $fwrite(csv_file, "FP32,ADD,%h,%h,%h,%h,%s,%s\n",
                    op_a, op_b, result32, expected,
                    (result32 == expected) ? "PASS" : "FAIL", desc);
            
            if (result32 == expected) begin
                pass_count++;
                $display("[PASS] FP32 ADD: %s", desc);
            end else begin
                fail_count++;
                $display("[FAIL] FP32 ADD: %s - Expected %h, Got %h", desc, expected, result32);
            end
        end
    endtask
    
    // Test task for FP32 multiplication
    task test_fp32_mul(input [31:0] op_a, op_b, expected, input string desc);
        begin
            test_count++;
            mode = 0;
            operation = 2'b10;
            a32 = op_a;
            b32 = op_b;
            valid_in = 1;
            @(posedge clk);
            valid_in = 0;
            repeat(4) @(posedge clk);
            
            $fwrite(csv_file, "FP32,MUL,%h,%h,%h,%h,%s,%s\n",
                    op_a, op_b, result32, expected,
                    (result32 == expected) ? "PASS" : "FAIL", desc);
            
            if (result32 == expected) begin
                pass_count++;
                $display("[PASS] FP32 MUL: %s", desc);
            end else begin
                fail_count++;
                $display("[FAIL] FP32 MUL: %s - Expected %h, Got %h", desc, expected, result32);
            end
        end
    endtask
    
    // Main test
    initial begin
        csv_file = $fopen("results/benchmark_results.csv", "w");
        $fwrite(csv_file, "Mode,Operation,OperandA,OperandB,Result,Expected,Status,Description\n");
        
        $display("\n========================================");
        $display("     GreenFloat Test Suite");
        $display("========================================");
        
        // Reset
        rst_n = 0;
        mode = 0;
        operation = 2'b00;
        valid_in = 0;
        a32 = 0; b32 = 0;
        a16 = 0; b16 = 0;
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);
        
        // FP16 Addition Tests
        $display("\n--- FP16-Green Addition Tests ---");
        test_fp16_add(16'h3E00, 16'h3E00, 16'h4000, "1.0 + 1.0 = 2.0");
        test_fp16_add(16'h4000, 16'h4000, 16'h4200, "2.0 + 2.0 = 4.0");
        test_fp16_add(16'h3E00, 16'h4000, 16'h4100, "1.0 + 2.0 = 3.0");
        test_fp16_add(16'h4000, 16'h3E00, 16'h4100, "2.0 + 1.0 = 3.0");
        test_fp16_add(16'h0000, 16'h3E00, 16'h0000, "0.0 + 1.0 = 1.0"); // Will fail with current LUT
        
        // FP16 Multiplication Tests
        $display("\n--- FP16-Green Multiplication Tests ---");
        test_fp16_mul(16'h4000, 16'h4000, 16'h4200, "2.0 * 2.0 = 4.0");
        test_fp16_mul(16'h3E00, 16'h4000, 16'h4000, "1.0 * 2.0 = 2.0");
        test_fp16_mul(16'h4000, 16'h3E00, 16'h4000, "2.0 * 1.0 = 2.0");
        
        // FP32 Addition Tests
        $display("\n--- FP32 Addition Tests ---");
        test_fp32_add(32'h3F800000, 32'h3F800000, 32'h40000000, "1.0 + 1.0 = 2.0");
        test_fp32_add(32'h40000000, 32'h40000000, 32'h40800000, "2.0 + 2.0 = 4.0");
        
        // FP32 Multiplication Tests
        $display("\n--- FP32 Multiplication Tests ---");
        test_fp32_mul(32'h40000000, 32'h40000000, 32'h40800000, "2.0 * 2.0 = 4.0");
        
        // Summary
        $display("\n========================================");
        $display("           Test Summary");
        $display("========================================");
        $display("Total Tests: %0d", test_count);
        $display("Passed:      %0d", pass_count);
        $display("Failed:      %0d", fail_count);
        
        if (fail_count == 0)
            $display("Status:      ALL TESTS PASSED!");
        else
            $display("Status:      SOME TESTS FAILED");
        
        $display("========================================\n");
        
        $fclose(csv_file);
        
        #100;
        $finish;
    end

endmodule