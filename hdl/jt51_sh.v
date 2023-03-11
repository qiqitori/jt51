/*  This file is part of JT51.

    JT51 is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    JT51 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with JT51.  If not, see <http://www.gnu.org/licenses/>.
    
    Author: Jose Tejada Gomez. Twitter: @topapate
    Version: 1.0
    Date: 27-10-2016
    */


module jt51_sh #(parameter width=5, stages=32, rstval=1'b0 ) (
    input                           rst,
    input                           clk,
    input                           cen,
    input       [width-1:0]         din,
    output      [width-1:0]         drop
);

reg [stages-1:0] bits[width-1:0];

genvar i;
generate
    for (i=0; i < width; i=i+1) begin: bit_shifter
        always @(posedge clk, posedge rst) begin
            if(rst)
                bits[i] <= {stages{rstval}};
            else if(cen)
                bits[i] <= {bits[i][stages-2:0], din[i]};
        end
        assign drop[i] = bits[i][stages-1];
    end
endgenerate

endmodule


module jt51_sh8 #(parameter rstval=1'b0 ) (
    input                           rst,
    input                           clk,
    input                           cen,
    input       [13:0]         din,
    output      [13:0]         drop
);

reg [7:0] bits[13:0];

genvar i;
// generate
//     for (i=0; i < 14; i=i+1) begin: bit_shifter
//         always @(posedge clk, posedge rst) begin
//             if(rst)
//                 bits[i] <= {8{rstval}};
//             else if(cen)
//                 bits[i] <= {bits[i][6:0], din[i]};
//         end
//         assign drop[i] = bits[i][7];
//     end
// endgenerate
        always @(posedge clk, posedge rst) begin
            if(rst) begin
                bits[0] <= {8{rstval}};
                bits[1] <= {8{rstval}};
                bits[2] <= {8{rstval}};
                bits[3] <= {8{rstval}};
                bits[4] <= {8{rstval}};
                bits[5] <= {8{rstval}};
                bits[6] <= {8{rstval}};
                bits[7] <= {8{rstval}};
                bits[8] <= {8{rstval}};
                bits[9] <= {8{rstval}};
                bits[10] <= {8{rstval}};
                bits[11] <= {8{rstval}};
                bits[12] <= {8{rstval}};
                bits[13] <= {8{rstval}};
            end
            else if(cen) begin
                bits[0] <= {bits[0][6:0], din[0]};
                bits[1] <= {bits[1][6:0], din[1]};
                bits[2] <= {bits[2][6:0], din[2]};
                bits[3] <= {bits[3][6:0], din[3]};
                bits[4] <= {bits[4][6:0], din[4]};
                bits[5] <= {bits[5][6:0], din[5]};
                bits[6] <= {bits[6][6:0], din[6]};
                bits[7] <= {bits[7][6:0], din[7]};
                bits[8] <= {bits[8][6:0], din[8]};
                bits[9] <= {bits[9][6:0], din[9]};
                bits[10] <= {bits[10][6:0], din[10]};
                bits[11] <= {bits[11][6:0], din[11]};
                bits[12] <= {bits[12][6:0], din[12]};
                bits[13] <= {bits[13][6:0], din[13]};
            end
        end
        assign drop[0] = bits[0][7];
        assign drop[1] = bits[0][7];
        assign drop[2] = bits[0][7];
        assign drop[3] = bits[0][7];
        assign drop[4] = bits[0][7];
        assign drop[5] = bits[0][7];
        assign drop[6] = bits[0][7];
        assign drop[7] = bits[0][7];
        assign drop[8] = bits[0][7];
        assign drop[9] = bits[0][7];
        assign drop[10] = bits[0][7];
        assign drop[11] = bits[0][7];
        assign drop[12] = bits[0][7];
        assign drop[13] = bits[0][7];
endmodule

