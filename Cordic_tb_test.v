`timescale 1ns/10ps

module Cordic_tb_test;

	parameter mode = 1;
	parameter clock_period = 20;
	parameter data_width = 16;
	parameter address_width = 4;
	parameter scaling_factor = 15'b100000000000000;
	reg clk, reset, enable;
	reg signed  [data_width-1:0] xin, zin;
	reg signed  [data_width-1:0] yin;
	wire signed [data_width-1:0] xout, yout;
	wire done;

	Cordic_test
	#(
	.data_width(data_width),
	.address_width(address_width),
	.scaling_factor(scaling_factor),
	.mode(mode)
	)
	cordic(
	.clk(clk),
	.reset(reset),
	.enable(enable),
	.done(done),
	.xin(xin),
	.yin(yin),
	.zin(zin),
	.xout(xout),
	.yout(yout)
	);
	//linear_tb
	//defparam cordic.mode = 0;

	//hyperbolic_tb
	//defparam cordic.mode = -1;

	integer out;

	initial
	begin
		clk = 0;
		forever #(clock_period/2) clk <= ~clk;
	end


	initial
	begin
	  	out = $fopen("simulation_output.txt", "w");  
	  	$timeformat(-9, 4, " ns", 20);

	 	$fdisplay(out, "DSD_Project");
	  	$fdisplay(out, "------------------------------------------------------");  
	  	$fdisplay(out, "The current module name is = %m");
      		$printtimescale;
	  	$fdisplay(out, "Clock period is: %g in the mentioned time unit", clock_period);
	  	$fdisplay(out, "Clock frequency is: %g MHz", (1000/clock_period));
	   	$fdisplay(out, "Simulation started...\n");
      		$fmonitor(out, "@%t", $realtime, ":  xin = %d,  zin = %d , xout = %d, yout = %d", 
	             	cordic.cordic_core.xin, 
			cordic.cordic_core.zin, 
			cordic.cordic_core.xout, 
			cordic.cordic_core.yout);


		enable = 0;
		zin = 0;
		yin = 0;
		reset = 1;

		// circular_tb
		#(clock_period) zin = 16'h6488; enable = 1; reset = 0;
		#400 enable = 0; reset = 1;
		#(clock_period) zin = 16'h3244; enable = 1; reset = 0;
		#400 enable = 0; reset = 1;
		//#(clock_period) zin = 16'h1922; enable = 1; reset = 0;
		//#400 enable = 0; reset = 1;
		//#(clock_period) zin = 0; enable = 1; reset = 0;
		//#400 enable = 0; reset = 1;
		//#(clock_period) zin = -16'h1922; enable = 1; reset = 0;
		//#400 enable = 0; reset = 1;
		//#(clock_period) zin = -16'h3244; enable = 1; reset = 0;
		//#400 enable = 0; reset = 1;
		//#(clock_period) zin = -16'h6488; enable = 1; reset = 0;
		//#400 enable = 0;

		//linear_tb
		// #(clock_period) zin = 16384; xin = 3277; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;
		// #(clock_period) zin = 3277; xin = 6553; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;
		// #(clock_period) zin = 4915; xin = 1638; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;
		// #(clock_period) zin = 13107; xin = 13107; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;
		// #(clock_period) zin = 14746; xin = 9830; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;

		//hyperbolic_tb
		// #(clock_period) zin = 16384; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;
		// #(clock_period) zin = 8192; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;
		// #(clock_period) zin = 0; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;
		// #(clock_period) zin = -8192; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;
		// #(clock_period) zin = 5407; enable = 1; reset = 0;
		// #400 enable = 0; reset = 1;
		
		$fclose(out);
	  	$stop;
	end
endmodule

