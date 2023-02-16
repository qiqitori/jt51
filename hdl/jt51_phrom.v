

/* This file is part of JT51.

 
	JT51 program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	JT51 program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with JT51.  If not, see <http://www.gnu.org/licenses/>.

	Based on Sauraen VHDL version of OPN/OPN2, which is based on die shots.

	Author: Jose Tejada Gomez. Twitter: @topapate
	Version: 1.0
	Date: 14-4-2017	

*/

module jt51_phrom
(
	input [4:0] addr,
	input clk,
	input cen,
	input [1:0] phaselo_XI_76,
	output reg [18:0] ph,
);

	reg [18:0] stb[3:0][31:0];
	initial
	begin
		stb[0][5'd0] = 19'b0000000000000000001;
		stb[0][5'd1] = 19'b0000000000100000001;
		stb[0][5'd2] = 19'b0000000000000000001;
		stb[0][5'd3] = 19'b0000000000100000001;
		stb[0][5'd4] = 19'b0000000000100010001;
		stb[0][5'd5] = 19'b0000000000000010001;
		stb[0][5'd6] = 19'b0000000000100010001;
		stb[0][5'd7] = 19'b0000000000100000001;
		stb[0][5'd8] = 19'b0000000000000000001;
		stb[0][5'd9] = 19'b0000000000100000001;
		stb[0][5'd10] = 19'b0000000000100010001;
		stb[0][5'd11] = 19'b0000000000000010001;
		stb[0][5'd12] = 19'b0000000000000000000;
		stb[0][5'd13] = 19'b0000000000100000000;
		stb[0][5'd14] = 19'b0000000000110000000;
		stb[0][5'd15] = 19'b0000000000100010000;
		stb[0][5'd16] = 19'b0000000000000010000;
		stb[0][5'd17] = 19'b0000000000000000000;
		stb[0][5'd18] = 19'b0000000000000000000;
		stb[0][5'd19] = 19'b0000000000010010000;
		stb[0][5'd20] = 19'b0000000000000010000;
		stb[0][5'd21] = 19'b0000000000110010000;
		stb[0][5'd22] = 19'b0000000000110000001;
		stb[0][5'd23] = 19'b0000000000110000001;
		stb[0][5'd24] = 19'b0000000000010010001;
		stb[0][5'd25] = 19'b0000000000010000001;
		stb[0][5'd26] = 19'b0000000000010001001;
		stb[0][5'd27] = 19'b0000000000010011000;
		stb[0][5'd28] = 19'b0000000000110011000;
		stb[0][5'd29] = 19'b0000000000110000010;
		stb[0][5'd30] = 19'b0000000000010011011;
		stb[0][5'd31] = 19'b0000000000010010000;

		stb[1][5'd0] = 19'b0000000100100011100;
		stb[1][5'd1] = 19'b0000001000000001100;
		stb[1][5'd2] = 19'b0000001000000001100;
		stb[1][5'd3] = 19'b0000001000100000000;
		stb[1][5'd4] = 19'b0000001000100000000;
		stb[1][5'd5] = 19'b0000001100000001000;
		stb[1][5'd6] = 19'b0000001000000001000;
		stb[1][5'd7] = 19'b0000001100100001000;
		stb[1][5'd8] = 19'b0000001000100000100;
		stb[1][5'd9] = 19'b0000000000010010100;
		stb[1][5'd10] = 19'b0000000000110011100;
		stb[1][5'd11] = 19'b0000000000110011100;
		stb[1][5'd12] = 19'b0000000100010010000;
		stb[1][5'd13] = 19'b0000001100110011000;
		stb[1][5'd14] = 19'b0000001100110011000;
		stb[1][5'd15] = 19'b0000001100010000100;
		stb[1][5'd16] = 19'b0000000000110001100;
		stb[1][5'd17] = 19'b0000000000010001100;
		stb[1][5'd18] = 19'b0000000100010000000;
		stb[1][5'd19] = 19'b0000001100110001000;
		stb[1][5'd20] = 19'b0000001000010010100;
		stb[1][5'd21] = 19'b0000001000100011100;
		stb[1][5'd22] = 19'b0000001000000010001;
		stb[1][5'd23] = 19'b0000000000100011001;
		stb[1][5'd24] = 19'b0000000000010001101;
		stb[1][5'd25] = 19'b0000000000110000001;
		stb[1][5'd26] = 19'b0000001100000000101;
		stb[1][5'd27] = 19'b0000000100110000001;
		stb[1][5'd28] = 19'b0000000000000011101;
		stb[1][5'd29] = 19'b0000001000110011101;
		stb[1][5'd30] = 19'b0000000100010010001;
		stb[1][5'd31] = 19'b0000001100100010111;

		stb[2][5'd0] = 19'b0001001000000000000;
		stb[2][5'd1] = 19'b0000001100000000000;
		stb[2][5'd2] = 19'b0000001100010000000;
		stb[2][5'd3] = 19'b0001001100010000010;
		stb[2][5'd4] = 19'b0000001000000000010;
		stb[2][5'd5] = 19'b0001001000000000010;
		stb[2][5'd6] = 19'b0001001100000000010;
		stb[2][5'd7] = 19'b0011001000010001010;
		stb[2][5'd8] = 19'b0011001000010001010;
		stb[2][5'd9] = 19'b0010001100010001010;
		stb[2][5'd10] = 19'b0001001000010001010;
		stb[2][5'd11] = 19'b0011001100110001010;
		stb[2][5'd12] = 19'b0011001000110000101;
		stb[2][5'd13] = 19'b0000001100100000101;
		stb[2][5'd14] = 19'b0010000000100000101;
		stb[2][5'd15] = 19'b0001001000110000101;
		stb[2][5'd16] = 19'b0010001100100000101;
		stb[2][5'd17] = 19'b0001001100010101101;
		stb[2][5'd18] = 19'b0011001000000101111;
		stb[2][5'd19] = 19'b0000000000010101111;
		stb[2][5'd20] = 19'b0001001000110101111;
		stb[2][5'd21] = 19'b0010000100110101111;
		stb[2][5'd22] = 19'b0011000100100100001;
		stb[2][5'd23] = 19'b0001000100110100001;
		stb[2][5'd24] = 19'b0001000000000010001;
		stb[2][5'd25] = 19'b0001000000010011011;
		stb[2][5'd26] = 19'b0000000000100011011;
		stb[2][5'd27] = 19'b0001000100110011000;
		stb[2][5'd28] = 19'b0001000000100011000;
		stb[2][5'd29] = 19'b0000000100000110110;
		stb[2][5'd30] = 19'b0000000000010110110;
		stb[2][5'd31] = 19'b0010000100100110111;

		stb[3][5'd0] = 19'b0100100101101000010;
		stb[3][5'd1] = 19'b1000100000100101010;
		stb[3][5'd2] = 19'b0001100101110101010;
		stb[3][5'd3] = 19'b0101100000110001010;
		stb[3][5'd4] = 19'b1011100101100101010;
		stb[3][5'd5] = 19'b0111100000111001010;
		stb[3][5'd6] = 19'b0110100100111101010;
		stb[3][5'd7] = 19'b0011110001101101010;
		stb[3][5'd8] = 19'b1101100111111001010;
		stb[3][5'd9] = 19'b0101011011010101010;
		stb[3][5'd10] = 19'b0111100011000001010;
		stb[3][5'd11] = 19'b1101100101010101010;
		stb[3][5'd12] = 19'b1101011001001001010;
		stb[3][5'd13] = 19'b0111001000001001010;
		stb[3][5'd14] = 19'b0100100111011101010;
		stb[3][5'd15] = 19'b1011100110000000110;
		stb[3][5'd16] = 19'b1111110010110000110;
		stb[3][5'd17] = 19'b1001011000101100110;
		stb[3][5'd18] = 19'b1111011100111100110;
		stb[3][5'd19] = 19'b1000011111101000110;
		stb[3][5'd20] = 19'b1001100101110000110;
		stb[3][5'd21] = 19'b1110001001010010110;
		stb[3][5'd22] = 19'b1100011010001110100;
		stb[3][5'd23] = 19'b1111011010111110100;
		stb[3][5'd24] = 19'b1010001001010011100;
		stb[3][5'd25] = 19'b0100011010100111100;
		stb[3][5'd26] = 19'b1101001000011101100;
		stb[3][5'd27] = 19'b0110011000001101101;
		stb[3][5'd28] = 19'b1011001010110111101;
		stb[3][5'd29] = 19'b0001011001000001101;
		stb[3][5'd30] = 19'b1001011010101011101;
		stb[3][5'd31] = 19'b1101011000111011101;
	end

	always @ (posedge clk) if(cen)
		ph <= stb[phaselo_XI_76][addr];

endmodule
