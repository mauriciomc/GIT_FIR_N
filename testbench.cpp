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

#include <verilated.h>                   // Defines common routines
#include <iostream>                      
#include <string>                        
#include <cstdlib>                       
#include <cstdio>                        
                                         
#include "Vtestbench.h"                   
#include "verilated_vcd_c.h"         


#define STRINGIZE(x) #x
#define STRINGIZE_VALUE_OF(x) STRINGIZE(x)
                                        
Vtestbench *uut;                         // Instantiation of module
vluint64_t main_time = 0;                // Current simulation time
                                         
double sc_time_stamp () {                // Called by $time in Verilog
    return main_time;                    // converts to double, to match
    // what SystemC does
}

int main(int argc, char** argv)
{

    char module[] = STRINGIZE_VALUE_OF(MODULE);
    printf("Testing module: %s\n",module);
    
    // turn on trace or not?
    bool vcdTrace = true;
    VerilatedVcdC* tfp = NULL;

    Verilated::commandArgs(argc, argv);   // Remember args
    uut = new Vtestbench;                 // Create instance

    uut->eval();
    uut->eval();

    if (vcdTrace)
    {
        Verilated::traceEverOn(true);

        tfp = new VerilatedVcdC;
        uut->trace(tfp, 99);

        std::string vcdname = argv[0];
        vcdname += ".vcd";
        std::cout << vcdname << std::endl;
        tfp->open(vcdname.c_str());
    }

    uut->clk  = 0;
    uut->nrst = 0;
    uut->eval();

    while (!Verilated::gotFinish())
    {
        uut->clk = uut->clk ? 0 : 1;      // Toggle clock
        
        if(main_time > 10)                // Release reset
            uut->nrst = 1;
        
        uut->eval();       		  // Evaluate model

        if (tfp != NULL)
        {
            tfp->dump (main_time);
        }

        main_time++;                      // Time passes...
    }

    uut->final();                         // Done simulating

    if (tfp != NULL)
    {
        tfp->close();
        delete tfp;
    }

    delete uut;

    printf("Testbench finished with xx errors: \n");
    
    return 0;
}                         
