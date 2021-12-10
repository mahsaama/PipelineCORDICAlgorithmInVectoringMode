module Cordic_test #(parameter data_width = 16, address_width = 4, scaling_factor = 15'b100000000000000, mode = 1)(
	input  clk, reset, enable,
	input  signed [data_width-1:0] xin, yin, zin,
	output done,
	output signed [data_width-1:0] xout, yout
);

	wire [address_width-1:0] address;
	wire [data_width-1:0] delta_z;

	Cordic_core_test #(.data_width(data_width),.address_width(address_width),.mode(mode),.scaling_factor(scaling_factor)) cordic_core
	(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.xin(xin),
		.yin(yin),
		.zin(zin), 
		.delta_z(delta_z),
		.address(address),
		.xout(xout),
		.yout(yout),
		.done(done)
	);

	
	generate
		case(mode)
			1:
				Circular_Rom_test #(.data_width(data_width), .address_width(address_width)) rom(
					.address(address),
					.delta_z(delta_z)
				);
			-1:
				Hyperbolic_Rom_test #(.data_width(data_width), .address_width(address_width)) rom(
					.address(address),
					.delta_z(delta_z)
				);
			0:
				Linear_Rom_test #(.data_width(data_width), .address_width(address_width)) rom(
					.address(address),
					.delta_z(delta_z)
				);
		endcase
	endgenerate
	

endmodule

