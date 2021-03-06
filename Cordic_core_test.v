module Cordic_core_test #(parameter data_width = 16, address_width = 4,mode = 1, scaling_factor = 15'b100000000000000) //mode : 1 = Circular, 0 = Linear, -1 = Hyperbolic
(	input clk, reset, enable,
	input signed [data_width-1:0] xin, yin, zin, delta_z,
	output [address_width-1:0] address,
	output signed [data_width-1:0] xout, yout,
	output done
);
  
	reg state, nxt_state, done_reg;
  
  	parameter idle = 1'b0, calculation = 1'b1;
  
  	reg [address_width-1:0] step, nxt_step;
  
  	reg signed [data_width-1:0]x_reg, y_reg, x_next, y_next, z_reg, z_next;
  
  	always @ (posedge clk)
		begin
			if (reset)
				begin
					state <= idle;
					step <= 0;
					x_reg <= 0;
					y_reg <= 0;
					z_reg <= 0;
					//done_reg <= 0;
	  			end

			else
				begin
					state <= nxt_state;
					step <= nxt_step;
					x_reg <= x_next;
					y_reg <= y_next;
					z_reg <= z_next;
				end	
		end
	
	always @ (*)
		begin
			nxt_step = step;
			case (state)
				idle:
					begin
						if (enable)
						begin
							nxt_state = calculation;
						end
						else
						begin
							nxt_state = idle;
						end
						nxt_step = 0;
						done_reg = 0;
					end
				calculation:
					begin
						if (step == (data_width-1))
						begin
							done_reg = 1'b1;
							nxt_state = idle;
						end
						else
						begin
							nxt_step = step + 1'b1;
							nxt_state = calculation;
						end
					end
				default:
					nxt_state = idle;
			endcase
		end
	

	always @ (*)
	begin
		case (state)
			idle:
			begin
				case (mode)
					-1:
						x_next = 16'h4D48;
					0:
						x_next = xin;
					default:
						x_next = 16'h26DD;
				endcase
				y_next = 0;
				z_next = zin;
			end
			
			calculation:
			begin
				case (mode)
					-1:
					begin
						if (z_reg[data_width-1]==1'b0)
							begin
								if (step < 4) begin
									x_next = x_reg + (y_reg >>> (step+1));
									y_next = y_reg + (x_reg >>> (step+1));
								end
								else if (step >= 4 && step <= 13)begin
									x_next = x_reg + (y_reg >>> step);
									y_next = y_reg + (x_reg >>> step);
								end
								else begin
									x_next = x_reg + (y_reg >>> (step-1));
									y_next = y_reg + (x_reg >>> (step-1));
								end
								z_next = z_reg - delta_z;
							end
						else
							begin
								if (step < 4) begin
									x_next = x_reg - (y_reg >>> (step+1));
									y_next = y_reg - (x_reg >>> (step+1));
								end
								else if (step >= 4 && step <= 13)begin
									x_next = x_reg - (y_reg >>> step);
									y_next = y_reg - (x_reg >>> step);
								end
								else begin
									x_next = x_reg - (y_reg >>> (step-1));
									y_next = y_reg - (x_reg >>> (step-1));
								end
								z_next = z_reg + delta_z;
							end
					end

					0:
					begin
						if (z_reg[data_width-1]==1'b0)
							begin
								y_next = y_reg + (x_reg >>> step);
								z_next = z_reg - delta_z;
							end
						else
							begin
								y_next = y_reg - (x_reg >>> step);
								z_next = z_reg + delta_z;
							end
						x_next = x_reg;
					end

					default:
					begin
						if (z_reg[data_width-1]==1'b0)
							begin
								x_next = x_reg - (y_reg >>> step);
								y_next = y_reg + (x_reg >>> step);
								z_next = z_reg - delta_z;
							end
						else
							begin
								x_next = x_reg + (y_reg >>> step);
								y_next = y_reg - (x_reg >>> step);
								z_next = z_reg + delta_z;
							end
					end

				endcase
			end

				//don't know._.
		endcase
	end
	     
	assign address = step;
	assign done = done_reg; 
	assign xout = done? x_reg : 0;
	assign yout = done? y_reg : 0;
	
endmodule