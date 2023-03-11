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

// `define debug_manexp_mode 1'b1

module jt51(
    input               rst,    // reset //23
    input               clk,    // main clock //25
    (* direct_enable *) input cen,    // clock enable //26
    (* direct_enable *) input cen_p1, // clock enable at half the speed //27
    input               cs_n,   // chip select //32
    input               wr_n,   // write //35
    input               rd_n,   // read //31
    input               a0, //37
    inout       [7:0]   data, // data in and out //12,21,13,19,18,11,9,6
//     output      [7:0]   dout, // data out
    // peripheral control
    output              ct1, //34
    output              ct2, //43
    output              irq_n,  // I do not synchronize this signal //36
    // Low resolution output (same as real chip)
    output              sample, // marks new output sample //42
//     output  signed  [15:0] left,
//     output  signed  [15:0] right,
    // Full resolution output
//     output  signed  [15:0] xleft,
//     output  signed  [15:0] xright
    output reg             so, //44
    output reg             sh1, //4
    output reg             sh2, //3
    output reg             half_clk //48
//     output wire led_red  , // Red
//     output wire led_blue , // Blue
//     output wire led_green  // Green

);

reg signed  [15:0] xleft;
reg [15:0] left;
// wire [15:0] fake_left;
// assign fake_left = 16'b1001011010010110;

wire [7:0] data_in;
wire [7:0] data_out;
wire bus_read = !cs_n && !rd_n && wr_n;
wire bus_write = !cs_n && !wr_n;
assign data = (!bus_write && bus_read) ? data_out : 8'bZ;
assign data_in = (!bus_read && bus_write) ? data : 8'hFF;

// Timers
wire [9:0]  value_A;
wire [7:0]  value_B;
wire        load_A, load_B;
wire        enable_irq_A, enable_irq_B;
wire        clr_flag_A, clr_flag_B;
wire        flag_A, flag_B, overflow_A;
wire        zero, half;
wire [4:0]  cycles;

jt51_timers u_timers(
    .clk        ( clk           ),
    .cen        ( cen_p1        ),
    .rst        ( rst           ),
    .zero       ( zero          ),
    .value_A    ( value_A       ),
    .value_B    ( value_B       ),
    .load_A     ( load_A        ),
    .load_B     ( load_B        ),
    .enable_irq_A( enable_irq_A ),
    .enable_irq_B( enable_irq_B ),
    .clr_flag_A ( clr_flag_A    ),
    .clr_flag_B ( clr_flag_B    ),
    .flag_A     ( flag_A        ),
    .flag_B     ( flag_B        ),
    .overflow_A ( overflow_A    ),
    .irq_n      ( irq_n         )
);

/*verilator tracing_on*/

`ifndef JT51_ONLYTIMERS
`define YM_TIMER_CTRL 8'h14

wire    [1:0]   rl_I;
wire    [2:0]   fb_II;
wire    [2:0]   con_I;
wire    [6:0]   kc_I;
wire    [5:0]   kf_I;
wire    [2:0]   pms_I;
wire    [1:0]   ams_VII;
wire    [2:0]   dt1_II;
wire    [3:0]   mul_VI;
wire    [6:0]   tl_VII;
wire    [1:0]   ks_III;
wire    [4:0]   arate_II;
wire            amsen_VII;
wire    [4:0]   rate1_II;
wire    [1:0]   dt2_I;
wire    [4:0]   rate2_II;
wire    [3:0]   d1l_I;
wire    [3:0]   rrate_II;

wire    [1:0]   cur_op;
wire            keyon_II;

wire    [7:0]   lfo_freq;
wire    [1:0]   lfo_w;
wire            lfo_up;
wire    [7:0]   am;
wire    [7:0]   pm;
wire    [6:0]   amd, pmd;
// wire    [7:0]   test_mode;
wire            noise;

wire m1_enters, m2_enters, c1_enters, c2_enters;
wire use_prevprev1,use_internal_x,use_internal_y, use_prev2,use_prev1;

assign  sample = zero & cen_p1; // single strobe

jt51_lfo u_lfo(
    .rst        ( rst       ),
    .clk        ( clk       ),
    .cen        ( cen_p1    ),
    .cycles     ( cycles    ),

    // Configuration
    .lfo_freq   ( lfo_freq  ),
    .lfo_w      ( lfo_w     ),
    .lfo_amd    ( amd       ),
    .lfo_pmd    ( pmd       ),
    .lfo_up     ( lfo_up    ),
    .noise      ( noise     ),

    // Test
//     .test       ( test_mode ),
    .lfo_clk    (           ),

    .am         ( am        ),
    .pm         ( pm        )
);

wire    [ 4:0]  keycode_III;
wire    [ 9:0]  ph_X;
wire            pg_rst_III;

/*verilator tracing_on*/


jt51_pg u_pg(
    .rst        ( rst       ),
    .clk        ( clk       ),              // P1
    .cen        ( cen_p1    ),
    .zero       ( zero      ),
    // Channel frequency
    .kc_I       ( kc_I      ),
    .kf_I       ( kf_I      ),
    // Operator multiplying
    .mul_VI     ( mul_VI    ),
    // Operator detuning
    .dt1_II     ( dt1_II    ),
    .dt2_I      ( dt2_I     ),
    // phase modulation from LFO
    .pms_I      ( pms_I     ),
    .pm         ( pm        ),
    // phase operation
    .pg_rst_III ( pg_rst_III    ),
    .keycode_III( keycode_III   ),
    .pg_phase_X ( ph_X          )
);

`ifdef TEST_SUPPORT
wire        test_eg, test_op0;
`endif
wire [9:0]  eg_XI;

jt51_eg u_eg(
    `ifdef TEST_SUPPORT
    .test_eg    ( test_eg   ),
    `endif
    .rst        ( rst       ),
    .clk        ( clk       ),
    .cen        ( cen_p1    ),
    .zero       ( zero      ),
    // envelope configuration
    .keycode_III(keycode_III),  // used in stage III
    .arate_II   ( arate_II  ),
    .rate1_II   ( rate1_II  ),
    .rate2_II   ( rate2_II  ),
    .rrate_II   ( rrate_II  ),
    .d1l_I      ( d1l_I     ),
    .ks_III     ( ks_III    ),
    // envelope operation
    .keyon_II   ( keyon_II  ),
    .pg_rst_III ( pg_rst_III),
    // envelope number
    .tl_VII     ( tl_VII    ),
    .am         ( am        ),
    .ams_VII    ( ams_VII   ),
    .amsen_VII  ( amsen_VII ),
    .eg_XI      ( eg_XI )
);

/*verilator tracing_off*/
wire signed [13:0] op_out;

jt51_op u_op(
    `ifdef TEST_SUPPORT
    .test_eg        ( test_eg           ),
    .test_op0       ( test_op0          ),
    `endif
    .rst            ( rst               ),
    .clk            ( clk               ),
    .cen            ( cen_p1            ),
    .pg_phase_X     ( ph_X              ),
    .con_I          ( con_I             ),
    .fb_II          ( fb_II             ),
    // volume
    .eg_atten_XI    ( eg_XI             ),
    // modulation
    .m1_enters      ( m1_enters         ),
    .c1_enters      ( c1_enters         ),
    // Operator
    .use_prevprev1  ( use_prevprev1     ),
    .use_internal_x ( use_internal_x    ),
    .use_internal_y ( use_internal_y    ),
    .use_prev2      ( use_prev2         ),
    .use_prev1      ( use_prev1         ),
    .test_214       ( 1'b0              ),
    `ifdef SIMULATION
    .zero           ( zero              ),
    `endif
    // output data
    .op_XVII        ( op_out            )
);

wire [ 4:0] nfrq;
wire [11:0] noise_mix;
wire        ne, op31_acc, op31_no;

jt51_noise u_noise(
    .rst    ( rst       ),
    .clk    ( clk       ),
    .cen    ( cen_p1    ),
    .cycles ( cycles    ),
    .nfrq   ( nfrq      ),
    .eg     ( eg_XI     ),
    .op31_no( op31_no   ),
    .out    ( noise     ),
    .mix    ( noise_mix )
);

jt51_acc u_acc(
    .rst        ( rst           ),
    .clk        ( clk           ),
    .cen        ( cen_p1        ),
    .m1_enters  ( m1_enters     ),
    .m2_enters  ( m2_enters     ),
    .c1_enters  ( c1_enters     ),
    .c2_enters  ( c2_enters     ),
    .op31_acc   ( op31_acc      ),
    .rl_I       ( rl_I          ),
    .con_I      ( con_I         ),
    .op_out     ( op_out        ),
    .ne         ( ne            ),
    .noise_mix  ( noise_mix     ),
    .xleft      ( xleft         )
//     .xright     ( xright        )
);
`else
assign left   = 16'd0;
// assign right  = 16'd0;
// assign xleft  = 16'd0;
// assign xright = 16'd0;
`endif

wire    busy;
wire    write = !cs_n && !wr_n;

assign  data_out = { busy, 5'h0, flag_B, flag_A };

/*verilator tracing_on*/

jt51_mmr u_mmr(
    .rst        ( rst           ),
    .clk        ( clk           ),
    .cen        ( cen_p1        ),
    .a0         ( a0            ),
    .write      ( write         ),
    .din        ( data_in       ),
    .busy       ( busy          ),

//     .test_mode  ( test_mode     ),
    // CT
    .ct1        ( ct1           ), // the LFO clock can be outputted via CT1 -not implemented-
    .ct2        ( ct2           ),
    // LFO
    .lfo_freq   ( lfo_freq      ),
    .lfo_w      ( lfo_w         ),
    .lfo_amd    ( amd           ),
    .lfo_pmd    ( pmd           ),
    .lfo_up     ( lfo_up        ),

    // Noise
    .ne         ( ne            ),
    .nfrq       ( nfrq          ),

    // Timers
    .value_A    ( value_A       ),
    .value_B    ( value_B       ),
    .load_A     ( load_A        ),
    .load_B     ( load_B        ),
    .enable_irq_A( enable_irq_A ),
    .enable_irq_B( enable_irq_B ),
    .clr_flag_A ( clr_flag_A    ),
    .clr_flag_B ( clr_flag_B    ),
    .overflow_A ( overflow_A    ),
    `ifdef TEST_SUPPORT
    // Test
    .test_eg    ( test_eg       ),
    .test_op0   ( test_op0      ),
    `endif
    // REG
    .rl_I       ( rl_I          ),
    .fb_II      ( fb_II         ),
    .con_I      ( con_I         ),
    .kc_I       ( kc_I          ),
    .kf_I       ( kf_I          ),
    .pms_I      ( pms_I         ),
    .ams_VII    ( ams_VII       ),
    .dt1_II     ( dt1_II        ),
    .mul_VI     ( mul_VI        ),
    .tl_VII     ( tl_VII        ),
    .ks_III     ( ks_III        ),
    .arate_II   ( arate_II      ),
    .amsen_VII  ( amsen_VII     ),
    .rate1_II   ( rate1_II      ),
    .dt2_I      ( dt2_I         ),
    .rate2_II   ( rate2_II      ),
    .d1l_I      ( d1l_I         ),
    .rrate_II   ( rrate_II      ),
    .keyon_II   ( keyon_II      ),

    .cur_op     ( cur_op        ),
    .op31_no    ( op31_no       ),
    .op31_acc   ( op31_acc      ),
    .zero       ( zero          ),
    .half       ( half          ),
    .cycles     ( cycles        ),
    .m1_enters  ( m1_enters     ),
    .m2_enters  ( m2_enters     ),
    .c1_enters  ( c1_enters     ),
    .c2_enters  ( c2_enters     ),
    // Operator
    .use_prevprev1  ( use_prevprev1     ),
    .use_internal_x ( use_internal_x    ),
    .use_internal_y ( use_internal_y    ),
    .use_prev2      ( use_prev2         ),
    .use_prev1      ( use_prev1         )
);

reg [3:0] count;
// reg half_clk;
// reg sh1_reg;
// reg sh2_reg;
// reg so;

// assign half_clk = half_clk;
// assign sh1 = count[4];
// assign sh2 = !count[4];
// assign so = so;

`ifdef debug_manexp_mode
reg [1:0] dac; // DEBUG // store(ch1) ignore(ch2) recall(ch1) ignore(ch2)
`endif

initial begin
    sh1 = 1'b0; // active low
    sh2 = 1'b1;
    left[2:0] = 3'd0;
`ifdef debug_manexp_mode
    dac = 2'b00;
`endif
end

`ifdef debug_manexp_mode
reg signed  [15:0] xleft_latched;
reg [15:0] prev_xleft; // DEBUG // actually not prev_xleft but man and exp of previous sample

always @(posedge sample) begin
    xleft_latched = xleft;
end
`endif

always @(posedge sample) begin
  casez( xleft[15:9] )
    // negative numbers
    7'b10?????: begin
        left[12:3] <= xleft[15:6];
        left[15:13] <= 3'd7;
      end
    7'b110????: begin
        left[12:3] <= xleft[14:5];
        left[15:13] <= 3'd6;
      end
    7'b1110???: begin
        left[12:3] <= xleft[13:4];
        left[15:13] <= 3'd5;
      end
    7'b11110??: begin
        left[12:3] <= xleft[12:3];
        left[15:13] <= 3'd4;
      end
    7'b111110?: begin
        left[12:3] <= xleft[11:2];
        left[15:13] <= 3'd3;
      end
    7'b1111110: begin
        left[12:3] <= xleft[10:1];
        left[15:13] <= 3'd2;
      end
    7'b1111111: begin
        left[12:3] <= xleft[ 9:0];
        left[15:13] <= 3'd1;
      end
    // positive numbers
    7'b01?????: begin
        left[12:3] <= xleft[15:6];
        left[15:13] <= 3'd7;
      end
    7'b001????: begin
        left[12:3] <= xleft[14:5];
        left[15:13] <= 3'd6;
      end
    7'b0001???: begin
        left[12:3] <= xleft[13:4];
        left[15:13] <= 3'd5;
      end
    7'b00001??: begin
        left[12:3] <= xleft[12:3];
        left[15:13] <= 3'd4;
      end
    7'b000001?: begin
        left[12:3] <= xleft[11:2];
        left[15:13] <= 3'd3;
      end
    7'b0000001: begin
        left[12:3] <= xleft[10:1];
        left[15:13] <= 3'd2;
      end
    7'b0000000: begin
        left[12:3] <= xleft[ 9:0];
        left[15:13] <= 3'd1;
      end

    default: begin
        left[12:3] <= xleft[9:0];
        left[15:13] <= 3'd1;
      end
  endcase
end

always @(posedge clk) begin
    if(sample) begin
        count = 4'b0;
`ifdef debug_manexp_mode
        dac = dac + 1;
`endif
        half_clk <= 1'b0;
        sh1 <= ~sh1; // actually sh1 and sh2 should be kept low for a little longer, not switch instantly when it's time for the other channel
        sh2 <= ~sh2;
    end
    else if(!half_clk) begin
        half_clk <= 1'b1;
    end
    else begin
        count = count + 1;
        half_clk <= 1'b0;
    end

`ifdef debug_manexp_mode
    if (dac == 2'b00) // ch2
        so <= 1'b0;
    else if (dac == 2'b01) begin
        so <= xleft_latched[count];
        prev_xleft[count] <= left[count]; // store
    end else if (dac == 2'b10) // ch2
        so <= 1'b0;
    else if (dac == 2'b11)
        so <= prev_xleft[count]; // recall
`else
    if(sh1)
        so <= left[count];
    else
        so <= 1'b0;
`endif

end

// SB_RGBA_DRV RGB_DRIVER (
//     .RGBLEDEN(1'b1                                            ),
//     .RGB0PWM (!count),
//     .CURREN  (1'b1                                            ),
//     .RGB0    (led_green                                       ), //Actual Hardware connection
// );
// defparam RGB_DRIVER.RGB0_CURRENT = "0b000001";
// defparam RGB_DRIVER.RGB1_CURRENT = "0b000001";
// defparam RGB_DRIVER.RGB2_CURRENT = "0b000001";

`ifdef SIMULATION
`ifndef VERILATOR
integer fsnd;
initial begin
    fsnd=$fopen("jt51.raw","wb");
end

always @(posedge zero) begin
    $fwrite(fsnd,"%u", {xleft, xright});
end
`endif
`endif

endmodule

