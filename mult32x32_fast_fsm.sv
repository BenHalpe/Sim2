// 32X32 Multiplier FSM
module mult32x32_fast_fsm (
    input logic clk,              // Clock
    input logic reset,            // Reset
    input logic start,            // Start signal
    input logic a_msb_is_0,       // Indicates MSB of operand A is 0
    input logic b_msw_is_0,       // Indicates MSW of operand B is 0
    output logic busy,            // Multiplier busy indication
    output logic [1:0] a_sel,     // Select one byte from A
    output logic b_sel,           // Select one 2-byte word from B
    output logic [2:0] shift_sel, // Select output from shifters
    output logic upd_prod,        // Update the product register
    output logic clr_prod         // Clear the product register
);

// Put your code here
// ------------------

typedef enum { idle_st, a00b0_st, a01b0_st, a10b0_st, a11b0_st, a00b1_st, a01b1_st, a10b1_st, a11b1_st } sm_type;

	sm_type current_state;
	sm_type next_state;
	
	
	always_ff @ (posedge clk, posedge reset) begin
		if(reset == 1'b1) begin
			current_state <= idle_st;
		end
		else begin
			current_state <= next_state;
		end
	end
	
	always_comb begin
		next_state = current_state;
		busy = 1'b1;
		a_sel = 2'b00;
		b_sel = 1'b0;
		shift_sel = 3'b000;
		upd_prod = 1'b1;
		clr_prod = 1'b0;
		case(current_state)
		idle_st: begin
			if(start == 1'b0) begin
				busy = 1'b0;
				upd_prod = 1'b0;
			end
			else begin
				next_state = a00b0_st;
				busy = 1'b0;
				clr_prod = 1'b1;
			end
		end
		a00b0_st: begin
			next_state = a01b0_st;
			a_sel = 2'b00;
			b_sel = 1'b0;
			shift_sel = 3'b000;
		end
		a01b0_st: begin
			next_state = a10b0_st;
			a_sel = 2'b01;
			b_sel = 1'b0;
			shift_sel = 3'b001;
		end
		a10b0_st: begin
			a_sel = 2'b10;
			b_sel = 1'b0;
			shift_sel = 3'b010;
			if(a_msb_is_0 == 1 && b_msw_is_0 == 1) begin
			
				next_state = idle_st;
			end
			else if(a_msb_is_0 == 1) begin
				next_state = a00b1_st;
			end
			else begin
				next_state = a11b0_st;
			end
			
				
		end
		a11b0_st: begin
			a_sel = 2'b11;
			b_sel = 1'b0;
			shift_sel = 3'b011;
			
			if (a_msb_is_0 == 0 && b_msw_is_0 == 1) begin
				
				next_state = idle_st;
			end
			else begin
				next_state = a00b1_st;
			end
		end
		a00b1_st: begin
			next_state = a01b1_st;
			a_sel = 2'b00;
			b_sel = 1'b1;
			shift_sel = 3'b010;
		end
		a01b1_st: begin
			next_state = a10b1_st;
			a_sel = 2'b01;
			b_sel = 1'b1;
			shift_sel = 3'b011;
		end
		a10b1_st: begin
			a_sel = 2'b10;
			b_sel = 1'b1;
			shift_sel = 3'b100;
			if(a_msb_is_0 == 1 && b_msw_is_0 == 0) begin
				next_state = idle_st;
			end
			else begin
				next_state = a11b1_st;
			end
		end
		a11b1_st: begin
			next_state = idle_st;
			a_sel = 2'b11;
			b_sel = 1'b1;
			shift_sel = 3'b101;
		end
		endcase
	end
		
		
// End of your code

endmodule
