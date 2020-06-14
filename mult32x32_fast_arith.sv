// 32X32 Multiplier arithmetic unit template
module mult32x32_fast_arith (
    input logic clk,             // Clock
    input logic reset,           // Reset
    input logic [31:0] a,        // Input a
    input logic [31:0] b,        // Input b
    input logic [1:0] a_sel,     // Select one byte from A
    input logic b_sel,           // Select one 2-byte word from B
    input logic [2:0] shift_sel, // Select output from shifters
    input logic upd_prod,        // Update the product register
    input logic clr_prod,        // Clear the product register
    output logic a_msb_is_0,     // Indicates MSB of operand A is 0
    output logic b_msw_is_0,     // Indicates MSW of operand B is 0
    output logic [63:0] product  // Miltiplication product
);

// Put your code here
// ------------------
	logic [7:0] mux_a_out;
	logic [15:0] mux_b_out;
	logic [23:0] mult16x8_out;
	logic [63:0] shifter0;
	logic [63:0] shifter8;
	logic [63:0] shifter16;
	logic [63:0] shifter24;
	logic [63:0] shifter32;
	logic [63:0] shifter40;
	logic [63:0] mux8to1_out;
	logic [63:0] adder_out;
	
	always_ff @ (posedge clk, posedge reset) begin
		if(clr_prod == 1'b1) begin
			product <= 0;
		end
		else begin if(upd_prod == 1'b1) begin
					product <= adder_out;
					end
		end
	end
	
	
	always_comb begin
		
		if(a[31:24] == 8'b0) begin
			a_msb_is_0 = 1'b1;
		end
		else begin
			a_msb_is_0 = 1'b0;
		end
		
		if(b[31:16] == 16'b0) begin
			b_msw_is_0 = 1'b1;
		end
		else begin
			b_msw_is_0 = 1'b0;
		end
		
		
		case (a_sel)
		2'b00: mux_a_out= a[7:0];
		2'b01: mux_a_out= a[15:8];
		2'b10: mux_a_out= a[23:16];
		2'b11: mux_a_out= a[31:24];
		default: mux_a_out= a[7:0];
		endcase
		
		if(b_sel== 1'b0) mux_b_out= b[15:0];
		else mux_b_out= b[31:16];
		
		mult16x8_out = mux_a_out*mux_b_out;
		
		shifter0= mult16x8_out;
		shifter8= mult16x8_out << 8;
		shifter16= mult16x8_out << 16;
		shifter24= mult16x8_out << 24;
		shifter32= mult16x8_out << 32;
		shifter40= mult16x8_out << 40;
		
		case(shift_sel)
		3'b000: mux8to1_out= shifter0;
		3'b001:	mux8to1_out= shifter8;
		3'b010:	mux8to1_out= shifter16;
		3'b011:	mux8to1_out= shifter24;
		3'b100:	mux8to1_out= shifter32;
		3'b101:	mux8to1_out= shifter40;
		default: mux8to1_out=0;
		endcase
		
		adder_out= product + mux8to1_out;
		
	end

// End of your code

endmodule
