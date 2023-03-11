

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

    Based on hardware measurements and Sauraen VHDL version of OPN/OPN2,
    which is based on die shots.

    Author: Jose Tejada Gomez. Twitter: @topapate
    Version: 1.0
    Date: 14-4-2017 

*/

module jt51_exprom
(
    input [4:0]         addr,
    input               clk,
    input               cen,
    input [1:0]         totalatten_XII_76,
    output reg [9:0]        etf,
    output reg [2:0]        etg
);
    reg [4:0] addr_latched;
    reg [9:0] explut_etf[31:0];
    reg [2:0] explut_etg[31:0];
    initial
    begin
        explut_etf[0][5'd0] = 10'b1110110111;
        explut_etf[0][5'd1] = 10'b1110101011;
        explut_etf[0][5'd2] = 10'b1110011101;
        explut_etf[0][5'd3] = 10'b1110000101;
        explut_etf[0][5'd4] = 10'b1110100001;
        explut_etf[0][5'd5] = 10'b1110110110;
        explut_etf[0][5'd6] = 10'b1001001010;
        explut_etf[0][5'd7] = 10'b1110011100;
        explut_etf[0][5'd8] = 10'b1110000100;
        explut_etf[0][5'd9] = 10'b1110010000;
        explut_etf[0][5'd10] = 10'b1110110111;
        explut_etf[0][5'd11] = 10'b1110101011;
        explut_etf[0][5'd12] = 10'b1110111101;
        explut_etf[0][5'd13] = 10'b1110100101;
        explut_etf[0][5'd14] = 10'b1110110001;
        explut_etf[0][5'd15] = 10'b1110101110;
        explut_etf[0][5'd16] = 10'b1110111010;
        explut_etf[0][5'd17] = 10'b1110100010;
        explut_etf[0][5'd18] = 10'b1110110100;
        explut_etf[0][5'd19] = 10'b1110101000;
        explut_etf[0][5'd20] = 10'b1110111111;
        explut_etf[0][5'd21] = 10'b1110100111;
        explut_etf[0][5'd22] = 10'b1110110011;
        explut_etf[0][5'd23] = 10'b1110101101;
        explut_etf[0][5'd24] = 10'b1010000101;
        explut_etf[0][5'd25] = 10'b1110010001;
        explut_etf[0][5'd26] = 10'b1110001110;
        explut_etf[0][5'd27] = 10'b1110011010;
        explut_etf[0][5'd28] = 10'b1110100010;
        explut_etf[0][5'd29] = 10'b1110110100;
        explut_etf[0][5'd30] = 10'b1010011000;
        explut_etf[0][5'd31] = 10'b1110000000;
        explut_etf[1][5'd0] = 10'b0010000010;
        explut_etf[1][5'd1] = 10'b1101001100;
        explut_etf[1][5'd2] = 10'b0011000100;
        explut_etf[1][5'd3] = 10'b0011001000;
        explut_etf[1][5'd4] = 10'b0011000000;
        explut_etf[1][5'd5] = 10'b0010101111;
        explut_etf[1][5'd6] = 10'b0010100111;
        explut_etf[1][5'd7] = 10'b0011101011;
        explut_etf[1][5'd8] = 10'b0011100011;
        explut_etf[1][5'd9] = 10'b0010011101;
        explut_etf[1][5'd10] = 10'b0010010101;
        explut_etf[1][5'd11] = 10'b0011011001;
        explut_etf[1][5'd12] = 10'b1100110001;
        explut_etf[1][5'd13] = 10'b0010111110;
        explut_etf[1][5'd14] = 10'b0011110110;
        explut_etf[1][5'd15] = 10'b0010000110;
        explut_etf[1][5'd16] = 10'b1101001010;
        explut_etf[1][5'd17] = 10'b1100100010;
        explut_etf[1][5'd18] = 10'b1101101100;
        explut_etf[1][5'd19] = 10'b1100010100;
        explut_etf[1][5'd20] = 10'b0010011000;
        explut_etf[1][5'd21] = 10'b1100110000;
        explut_etf[1][5'd22] = 10'b1101111111;
        explut_etf[1][5'd23] = 10'b1100001111;
        explut_etf[1][5'd24] = 10'b1101000111;
        explut_etf[1][5'd25] = 10'b1100101011;
        explut_etf[1][5'd26] = 10'b0011100011;
        explut_etf[1][5'd27] = 10'b0010011101;
        explut_etf[1][5'd28] = 10'b1100110101;
        explut_etf[1][5'd29] = 10'b1101111001;
        explut_etf[1][5'd30] = 10'b0010001001;
        explut_etf[1][5'd31] = 10'b1100100001;
        explut_etf[2][5'd0] = 10'b0101000110;
        explut_etf[2][5'd1] = 10'b0100001010;
        explut_etf[2][5'd2] = 10'b0110111100;
        explut_etf[2][5'd3] = 10'b0111010100;
        explut_etf[2][5'd4] = 10'b0110011000;
        explut_etf[2][5'd5] = 10'b0111100000;
        explut_etf[2][5'd6] = 10'b0110101111;
        explut_etf[2][5'd7] = 10'b0111000111;
        explut_etf[2][5'd8] = 10'b0110001011;
        explut_etf[2][5'd9] = 10'b0111111101;
        explut_etf[2][5'd10] = 10'b0101110101;
        explut_etf[2][5'd11] = 10'b0100111001;
        explut_etf[2][5'd12] = 10'b0101010001;
        explut_etf[2][5'd13] = 10'b0110011110;
        explut_etf[2][5'd14] = 10'b0100010110;
        explut_etf[2][5'd15] = 10'b0111101010;
        explut_etf[2][5'd16] = 10'b0101100010;
        explut_etf[2][5'd17] = 10'b0100101100;
        explut_etf[2][5'd18] = 10'b0100100100;
        explut_etf[2][5'd19] = 10'b0111001000;
        explut_etf[2][5'd20] = 10'b0101000000;
        explut_etf[2][5'd21] = 10'b0101001111;
        explut_etf[2][5'd22] = 10'b0010000111;
        explut_etf[2][5'd23] = 10'b0000001011;
        explut_etf[2][5'd24] = 10'b0000000011;
        explut_etf[2][5'd25] = 10'b0000001101;
        explut_etf[2][5'd26] = 10'b0000000101;
        explut_etf[2][5'd27] = 10'b0000001001;
        explut_etf[2][5'd28] = 10'b0000000001;
        explut_etf[2][5'd29] = 10'b0000001110;
        explut_etf[2][5'd30] = 10'b0000000110;
        explut_etf[2][5'd31] = 10'b0000001010;
        explut_etf[3][5'd0] = 10'b0010101011;
        explut_etf[3][5'd1] = 10'b0010010101;
        explut_etf[3][5'd2] = 10'b0010111110;
        explut_etf[3][5'd3] = 10'b0001001010;
        explut_etf[3][5'd4] = 10'b0001100100;
        explut_etf[3][5'd5] = 10'b0010111111;
        explut_etf[3][5'd6] = 10'b0010001011;
        explut_etf[3][5'd7] = 10'b0010100101;
        explut_etf[3][5'd8] = 10'b0010111110;
        explut_etf[3][5'd9] = 10'b0010001010;
        explut_etf[3][5'd10] = 10'b0010010100;
        explut_etf[3][5'd11] = 10'b0010111111;
        explut_etf[3][5'd12] = 10'b0010101011;
        explut_etf[3][5'd13] = 10'b0001010101;
        explut_etf[3][5'd14] = 10'b0010000001;
        explut_etf[3][5'd15] = 10'b0010011010;
        explut_etf[3][5'd16] = 10'b0010001100;
        explut_etf[3][5'd17] = 10'b0010010000;
        explut_etf[3][5'd18] = 10'b0010000111;
        explut_etf[3][5'd19] = 10'b0010011101;
        explut_etf[3][5'd20] = 10'b0010001001;
        explut_etf[3][5'd21] = 10'b0010010110;
        explut_etf[3][5'd22] = 10'b0010000010;
        explut_etf[3][5'd23] = 10'b0010011000;
        explut_etf[3][5'd24] = 10'b0010101111;
        explut_etf[3][5'd25] = 10'b0010110011;
        explut_etf[3][5'd26] = 10'b0010100101;
        explut_etf[3][5'd27] = 10'b0010000001;
        explut_etf[3][5'd28] = 10'b0010011010;
        explut_etf[3][5'd29] = 10'b0010101100;
        explut_etf[3][5'd30] = 10'b0000001000;
        explut_etf[3][5'd31] = 10'b0010010111;
        explut_etg[0][5'd0] = 3'b101;
        explut_etg[0][5'd1] = 3'b101;
        explut_etg[0][5'd2] = 3'b101;
        explut_etg[0][5'd3] = 3'b101;
        explut_etg[0][5'd4] = 3'b101;
        explut_etg[0][5'd5] = 3'b101;
        explut_etg[0][5'd6] = 3'b101;
        explut_etg[0][5'd7] = 3'b101;
        explut_etg[0][5'd8] = 3'b101;
        explut_etg[0][5'd9] = 3'b101;
        explut_etg[0][5'd10] = 3'b110;
        explut_etg[0][5'd11] = 3'b110;
        explut_etg[0][5'd12] = 3'b110;
        explut_etg[0][5'd13] = 3'b110;
        explut_etg[0][5'd14] = 3'b110;
        explut_etg[0][5'd15] = 3'b110;
        explut_etg[0][5'd16] = 3'b110;
        explut_etg[0][5'd17] = 3'b110;
        explut_etg[0][5'd18] = 3'b110;
        explut_etg[0][5'd19] = 3'b110;
        explut_etg[0][5'd20] = 3'b100;
        explut_etg[0][5'd21] = 3'b100;
        explut_etg[0][5'd22] = 3'b100;
        explut_etg[0][5'd23] = 3'b100;
        explut_etg[0][5'd24] = 3'b100;
        explut_etg[0][5'd25] = 3'b100;
        explut_etg[0][5'd26] = 3'b100;
        explut_etg[0][5'd27] = 3'b100;
        explut_etg[0][5'd28] = 3'b100;
        explut_etg[0][5'd29] = 3'b100;
        explut_etg[0][5'd30] = 3'b100;
        explut_etg[0][5'd31] = 3'b100;
        explut_etg[1][5'd0] = 3'b101;
        explut_etg[1][5'd1] = 3'b101;
        explut_etg[1][5'd2] = 3'b101;
        explut_etg[1][5'd3] = 3'b101;
        explut_etg[1][5'd4] = 3'b101;
        explut_etg[1][5'd5] = 3'b100;
        explut_etg[1][5'd6] = 3'b100;
        explut_etg[1][5'd7] = 3'b100;
        explut_etg[1][5'd8] = 3'b100;
        explut_etg[1][5'd9] = 3'b100;
        explut_etg[1][5'd10] = 3'b100;
        explut_etg[1][5'd11] = 3'b100;
        explut_etg[1][5'd12] = 3'b100;
        explut_etg[1][5'd13] = 3'b100;
        explut_etg[1][5'd14] = 3'b100;
        explut_etg[1][5'd15] = 3'b100;
        explut_etg[1][5'd16] = 3'b100;
        explut_etg[1][5'd17] = 3'b100;
        explut_etg[1][5'd18] = 3'b100;
        explut_etg[1][5'd19] = 3'b100;
        explut_etg[1][5'd20] = 3'b100;
        explut_etg[1][5'd21] = 3'b100;
        explut_etg[1][5'd22] = 3'b101;
        explut_etg[1][5'd23] = 3'b101;
        explut_etg[1][5'd24] = 3'b101;
        explut_etg[1][5'd25] = 3'b101;
        explut_etg[1][5'd26] = 3'b101;
        explut_etg[1][5'd27] = 3'b101;
        explut_etg[1][5'd28] = 3'b101;
        explut_etg[1][5'd29] = 3'b101;
        explut_etg[1][5'd30] = 3'b101;
        explut_etg[1][5'd31] = 3'b101;
        explut_etg[2][5'd0] = 3'b101;
        explut_etg[2][5'd1] = 3'b101;
        explut_etg[2][5'd2] = 3'b101;
        explut_etg[2][5'd3] = 3'b101;
        explut_etg[2][5'd4] = 3'b101;
        explut_etg[2][5'd5] = 3'b101;
        explut_etg[2][5'd6] = 3'b001;
        explut_etg[2][5'd7] = 3'b001;
        explut_etg[2][5'd8] = 3'b001;
        explut_etg[2][5'd9] = 3'b001;
        explut_etg[2][5'd10] = 3'b001;
        explut_etg[2][5'd11] = 3'b001;
        explut_etg[2][5'd12] = 3'b001;
        explut_etg[2][5'd13] = 3'b001;
        explut_etg[2][5'd14] = 3'b001;
        explut_etg[2][5'd15] = 3'b001;
        explut_etg[2][5'd16] = 3'b001;
        explut_etg[2][5'd17] = 3'b001;
        explut_etg[2][5'd18] = 3'b001;
        explut_etg[2][5'd19] = 3'b001;
        explut_etg[2][5'd20] = 3'b001;
        explut_etg[2][5'd21] = 3'b110;
        explut_etg[2][5'd22] = 3'b110;
        explut_etg[2][5'd23] = 3'b110;
        explut_etg[2][5'd24] = 3'b110;
        explut_etg[2][5'd25] = 3'b110;
        explut_etg[2][5'd26] = 3'b110;
        explut_etg[2][5'd27] = 3'b110;
        explut_etg[2][5'd28] = 3'b110;
        explut_etg[2][5'd29] = 3'b110;
        explut_etg[2][5'd30] = 3'b110;
        explut_etg[2][5'd31] = 3'b110;
        explut_etg[3][5'd0] = 3'b111;
        explut_etg[3][5'd1] = 3'b111;
        explut_etg[3][5'd2] = 3'b111;
        explut_etg[3][5'd3] = 3'b111;
        explut_etg[3][5'd4] = 3'b111;
        explut_etg[3][5'd5] = 3'b011;
        explut_etg[3][5'd6] = 3'b011;
        explut_etg[3][5'd7] = 3'b011;
        explut_etg[3][5'd8] = 3'b011;
        explut_etg[3][5'd9] = 3'b011;
        explut_etg[3][5'd10] = 3'b011;
        explut_etg[3][5'd11] = 3'b101;
        explut_etg[3][5'd12] = 3'b101;
        explut_etg[3][5'd13] = 3'b101;
        explut_etg[3][5'd14] = 3'b101;
        explut_etg[3][5'd15] = 3'b101;
        explut_etg[3][5'd16] = 3'b101;
        explut_etg[3][5'd17] = 3'b101;
        explut_etg[3][5'd18] = 3'b001;
        explut_etg[3][5'd19] = 3'b001;
        explut_etg[3][5'd20] = 3'b001;
        explut_etg[3][5'd21] = 3'b001;
        explut_etg[3][5'd22] = 3'b001;
        explut_etg[3][5'd23] = 3'b001;
        explut_etg[3][5'd24] = 3'b110;
        explut_etg[3][5'd25] = 3'b110;
        explut_etg[3][5'd26] = 3'b110;
        explut_etg[3][5'd27] = 3'b110;
        explut_etg[3][5'd28] = 3'b110;
        explut_etg[3][5'd29] = 3'b110;
        explut_etg[3][5'd30] = 3'b110;
        explut_etg[3][5'd31] = 3'b010;
    end

    always @ (posedge clk) // only update addr on clock edge
        addr_latched <= addr;

    always @(*) begin // allow etf and etg updates whenever totalatten_XII_76 changes
        etf <= explut_etf[totalatten_XII_76][clk ? addr : addr_latched]; // addr_latched might be stale on clk edge
        etg <= explut_etg[totalatten_XII_76][clk ? addr : addr_latched]; // addr_latched might be stale on clk edge
    end

endmodule
