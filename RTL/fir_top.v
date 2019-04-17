// -----------------------------------------------------------------------------
// Copyright (c) Neochip LTD, Inc. All rights reserved
// Confidential Proprietary
// -----------------------------------------------------------------------------
// FILE NAME      : 
// AUTHOR         : $Author$
// AUTHOR’S EMAIL : mauricio.carvalho@neochip.co.uk
// -----------------------------------------------------------------------------
// RELEASE HISTORY 
// VERSION DATE        AUTHOR  DESCRIPTION
// $Rev$     $Date$  name $Author$       
// -----------------------------------------------------------------------------
// KEYWORDS    : General file searching keywords, leave blank if none.
// -----------------------------------------------------------------------------
// PURPOSE     : Nth-order FIR FILTER
// -----------------------------------------------------------------------------
// PARAMETERS
//     PARAM NAME      RANGE    : DESCRIPTION       : DEFAULT : UNITS
// e.g.DATA_WIDTH     [32,16]   : width of the data : 32      :
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Reset Strategy        :
//   Clock Domains         :
//   Critical Timing       :
//   Test Features         :
//   Asynchronous I/F      :
//   Scan Methodology      :
//   Instantiations        :
//   Synthesizable (y/n)   :
//   Other                 :
// -----------------------------------------------------------------------------

// Local Variables:
// verilog-library-flags:("-y ./ ")
// verilog-library-extensions:(".v" ".h" ".sv" ".vs")
// eval:(verilog-read-defines)
// eval:(verilog-read-includes)
// eval:(setq verilog-auto-read-includes t)
// End:


module fir_top ( 
                 clk,
                 nrst,
                 data_in,
                 data_out
               );

  //Parameters can be overriden at test.sv
  parameter N         = 8;
  parameter WIDTH_IN  = 8;           
  parameter WIDTH_OUT = 2 * WIDTH_IN + 2;            
  
  //Filter coeficients: Implements lowpass gaussian
  parameter B0        = 8'd7 ;
  parameter B1        = 8'd17;
  parameter B2        = 8'd32;
  parameter B3        = 8'd46;
  parameter B4        = 8'd52;
  parameter B5        = 8'd46;
  parameter B6        = 8'd32;
  parameter B7        = 8'd17;
  parameter B8        = 8'd7 ;
  
  input     [WIDTH_IN -1:0] data_in  ; 
  input                     clk, nrst;
  output    [WIDTH_OUT-1:0] data_out ;
  
  //Structure composed of a shift register (with length N and bitwidth WIDTH_IN) and Multiply and Accumulate blocks
  
  //Samples
  reg       [WIDTH_IN -1:0] samples [1:N] ;
  
  //Loop variable
  integer   k;
  
  //High level MAC implementation (leave it with synthesis to create ADD and MULT blocks for now
  assign    data_out = B0 * data_in    + 
                       B1 * samples[1] +
                       B2 * samples[2] +
                       B3 * samples[3] +
                       B4 * samples[4] +
                       B5 * samples[5] +
                       B6 * samples[6] +
                       B7 * samples[7] +
                       B8 * samples[8]  ;

  //Shift register implementation
  always @(posedge clk)
  begin : SHIFT_REGISTER
    if(!nrst)
    begin
     for ( k = 0; k<= N; k=k+1 ) 
       samples[k]<=0;
    end
    else
    begin
      samples[1] <= data_in;
      for ( k = 2; k <= N; k=k+1 )
        samples[k] <= samples[k-1];
    end
  end
  
  
endmodule

// Local Variables:
// verilog-library-directories:(".")
// verilog-library-flags:("-f /home/mauricio/Desktop/GIT_FIR_N/RTL/*")
// eval:(verilog-read-defines)
// eval:(verilog-read-includes)
// End:
