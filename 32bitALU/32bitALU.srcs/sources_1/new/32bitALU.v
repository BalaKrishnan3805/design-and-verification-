

module alu_32bit (
    input  [31:0] a,        
    input  [31:0] b,        
    input  [3:0] alu_op,    
    output reg [31:0] result, 
    output zero             
);

    always @(*) begin
        case (alu_op)
            4'b0000: result = a & b; // AND operation
            4'b0001: result = a | b; // OR operation
            4'b0010: result = a + b; // ADD operation
            4'b0110: result = a - b; // SUBTRACT operation
            
            4'b1100: result = a ^ b; // XOR operation
            default: result = 32'd0; // Default: result is 0
        endcase
    end

    

endmodule

