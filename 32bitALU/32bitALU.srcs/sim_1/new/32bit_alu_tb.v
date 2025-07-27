module tb_alu_32bit;

    // Inputs
    reg [31:0] a;
    reg [31:0] b;
    reg [3:0] alu_op;

    // Outputs
    wire [31:0] result;
    wire zero;

    // Instantiate the ALU
    alu_32bit uut (
        .a(a),
        .b(b),
        .alu_op(alu_op),
        .result(result),
        .zero(zero)
    );

    // Assign zero flag based on result
    assign zero = (result == 32'd0) ? 1'b1 : 1'b0;

    initial begin
        // Print header
        $display("Time\tALU_OP\tA\t\t\tB\t\t\tRESULT\t\t\tZERO");

        // Test AND (a & b)
        a = 32'hFFFFFFFF;
        b = 32'h0F0F0F0F;
        alu_op = 4'b0000;
        #10;

        // Test OR (a | b)
        a = 32'h00000000;
        b = 32'h12345678;
        alu_op = 4'b0001;
        #10;

        // Test ADD (a + b)
        a = 32'd10;
        b = 32'd15;
        alu_op = 4'b0010;
        #10;

        // Test SUBTRACT (a - b)
        a = 32'd20;
        b = 32'd5;
        alu_op = 4'b0110;
        #10;

        // Test XOR (a ^ b)
        a = 32'hFFFF0000;
        b = 32'h00FF00FF;
        alu_op = 4'b1100;
        #10;

        // Test Default case (invalid op)
        a = 32'd5;
        b = 32'd5;
        alu_op = 4'b1111;
        #10;

        // Finish simulation
        $finish;
    end

    // Display values during simulation
    always @(*) begin
        $display("%0t\t%b\t%h\t%h\t%h\t%b", $time, alu_op, a, b, result, zero);
    end

endmodule

