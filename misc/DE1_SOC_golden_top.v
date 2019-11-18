`include "../verilog_src/const.vh"
// ============================================================================
// Copyright (c) 2013 by Terasic Technologies Inc.
// ============================================================================
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// ============================================================================
//           
//  Terasic Technologies Inc
//  9F., No.176, Sec.2, Gongdao 5th Rd, East Dist, Hsinchu City, 30070. Taiwan
//  
//  
//                     web: http://www.terasic.com/  
//                     email: support@terasic.com
//
// ============================================================================
//Date:  Thu Jul 11 11:26:45 2013
// ============================================================================



module DE1_SOC_golden_top
(

      input              CLOCK_50,
      inout     [35:0]   GPIO_0,
      input       [3:0]  KEY,
      output      [9:0]  LEDR
);


//=======================================================
//  REG/WIRE declarations
//=======================================================





//=======================================================
//  Structural coding
//=======================================================

top TOP
(
 	.start(KEY[1]),
 	.rst_n(KEY[0]),
 	.clk(CLOCK_50),
 	.rx(GPIO_0[0]),
 	.tx(GPIO_0[1]),
 	.debug(LEDR[9:0])
);



endmodule
