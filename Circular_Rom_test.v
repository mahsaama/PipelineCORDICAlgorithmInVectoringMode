module Circular_Rom_test #( parameter  data_width = 16, address_width = 4)
(
	input [(address_width-1):0] address,
	output[(data_width-1):0] delta_z
);

	reg [data_width-1 : 0] rom_content;
	
	always@(address)
		begin
			case(address)
				4'd0: rom_content = 16'h3244;
				4'd1: rom_content = 16'h1dac;
				4'd2: rom_content = 16'h0fae;
				4'd3: rom_content = 16'h07f5;
				4'd4: rom_content = 16'h03ff;
				4'd5: rom_content = 16'h0200;
				4'd6: rom_content = 16'h0100;
				4'd7: rom_content = 16'h0080;
				4'd8: rom_content = 16'h0040;
				4'd9: rom_content = 16'h0020;
				4'd10: rom_content = 16'h0010;
				4'd11: rom_content = 16'h0008;
				4'd12: rom_content = 16'h0004;
				4'd13: rom_content = 16'h0002;
				4'd14: rom_content = 16'h0001;
				4'd15: rom_content = 16'h0001;
			endcase
		end	

	assign delta_z = rom_content;
	
endmodule
