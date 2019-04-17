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
// PURPOSE     : Short description of functionality
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

//Port mapping and any other logic without encapsulating between module / endmodule

  reg  [7:0] data_in ;
  wire [7:0] data_out;

  reg  [3:0] counter;
  
 //Number of windows
  reg  [4:0] w;


//Parameter override if necessary
  fir_top fir_top_u1( 
                      .clk     (clk),
                      .nrst    (nrst & (|counter) ),
		      .data_in (data_in),
		      .data_out(data_out)
                    );

  always @(posedge clk)
  begin : SAMPLE_GENERATION
    if ( !nrst )
    begin
        data_in <= 0;
        counter <= 0;
        w       <= 0;
    end
    else 
    begin
       counter <= counter + 1;
       if (!counter) 
       begin
         data_in <= 0; 
         w       <= w+1;
       end
       else
         data_in <= $random;
    end
    
    //finish simulation
    if ( w >= 30 )
      $finish;
  end 

// Local Variables:                                              
// verilog-library-directories:(".")                             
// verilog-library-flags:("-f /home/mauricio/Desktop/GIT_FIR_N/RTL/*")
// eval:(verilog-read-defines)                                   
// eval:(verilog-read-includes)                                  
// End:            
