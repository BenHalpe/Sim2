// 32X32 Multiplier test template
module mult32x32_test;

    logic clk;            // Clock
    logic reset;          // Reset
    logic start;          // Start signal
    logic [31:0] a;       // Input a
    logic [31:0] b;       // Input b
    logic busy;           // Multiplier busy indication
    logic [63:0] product; // Miltiplication product

// Put your code here
	mult32x32 mult (
				.clk(clk),
				.reset(reset),
				.start(start),
				.a(a),
				.b(b),
				.busy(busy),
				.product(product)
				);
	
	always begin
        #10 clk = ~clk;
    end 

	initial begin
	reset= 1'b1;
	start= 1'b0;
	clk= 1'b1;
	
	repeat(4) begin
            @(posedge clk);
        end

	reset= 1'b0;
	a= 314722950;
	b= 209086578;
	
	@(posedge clk);
	
	start= 1'b1;
	
	@(posedge clk);
	
	start= 1'b0;
	
	repeat(9) begin
            @(posedge clk);
        end
	$stop;
	
	end

// End of your code

endmodule
