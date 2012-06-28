`timescale 1ns / 10ps
/************************************************************************
* Date: 
* File: 
*
* Testbench to generate some stimulus and display the results 
* 
************************************************************************/
//*********************************************************
module spike_cnt_tb;
//*********************************************************
wire [31:0] int_cnt_out, cnt; //use wire data type for outputs from instantiated module
wire t1, t2, read; 
wire [1:0] wait_for_one_more_spike;
reg spike, reset;
reg slow_clk, clk; 


//spikecnt DUT(spike, int_cnt_out, fast_clk, slow_clk, reset, clear_out, cnt, t1, t2, read);
spike_counter DUT1(spike, int_cnt_out, slow_clk, reset, clear_out, cnt, read, wait_for_one_more_spike);

//This block generates a clock pulse with a 20 ns period

    //This initial block will provide values for the inputs
    // of the mux so that both inputs/outputs can be displayed
initial begin
    $timeformat(-9, 1, " ns", 6);
	 #1000
    slow_clk = 1'b0; clk = 1'b0; reset = 1; spike = 0;
    #1000 reset = 0; 

    #30000000
    $finish; // to shut down the simulation
	end //initial
// this block is sensitive to changes on ANY of the inputs and will
// then display both the inputs and corresponding output

always
	#5 clk = ~clk;  // 200Mhz base clk

always
  #1000000 slow_clk = ~slow_clk; // 1ms slow clock

always 
    begin
        #1789 spike = 1;  // spike rate in Mhz range
        #1000   spike = 0;
    end

always @(posedge slow_clk)
     $display("At t=%t int_cnt_out=%d", $time, int_cnt_out);

endmodule


module spikecnt(spike, int_cnt_out, fast_clk, slow_clk, reset, clear_out, cnt, t1, t2, read);
    input   spike, slow_clk, fast_clk, reset;
    output  reg [31:0] int_cnt_out, cnt;
    output  clear_out;
          
    //reg     [31:0]  cnt;
    output reg t1, t2;
	 output read;
	 
    always @(posedge reset or posedge slow_clk) begin
        if (reset) begin
            //t1 <= t2;
				t1 <= 1;
        end
        else begin
            if (~read) t1 <= ~t1;
				//else t1 <= t1;
        end
    end
    
    always @(negedge spike or posedge reset) begin
        if (reset) begin
            //t2 <= t1;
				t2 <= 0;
        end
        else begin
            if (read) t2 <= ~t2;
				//else t2 <= t2;
        end
    end
    
    wire    read = t1 ^ t2;
    wire    out_flag = read && slow_clk;
    
    always @(posedge spike) begin
        if (read) begin
            cnt <= 32'd1;
        end
        else begin
            cnt <= cnt + 32'd1;
        end
    end
         
    always @(posedge slow_clk or posedge reset) begin
        if (reset || read) begin
            int_cnt_out <= 32'd0;
        end
        else begin
            int_cnt_out <= cnt;
        end
    end
    
    assign clear_out = out_flag;

endmodule


module spike_counter(spike, int_cnt_out, slow_clk, reset, clear_out, cnt, read, wait_for_one_more_spike);
    input   spike, slow_clk, reset;
    output  reg    [31:0]  int_cnt_out;
    output reg     [31:0]  cnt;
	 reg slow_clk_up; 
    output clear_out, read;
	 output reg [1:0] wait_for_one_more_spike;
    assign clear_out = slow_clk_up;
	 
    always @(posedge reset or posedge slow_clk or posedge spike) begin
        if (reset) begin 
            slow_clk_up <= 1'b0;
				wait_for_one_more_spike <= 2'd0;
        end 
		  else if (slow_clk) begin 
			   slow_clk_up <= 1'b1;
				wait_for_one_more_spike <= 2'd2;
		  end
		  else begin//if (spike) begin
				slow_clk_up <= 1'b0;
				if (wait_for_one_more_spike > 0) 
					wait_for_one_more_spike <= (wait_for_one_more_spike - 1'b1);
		  end
    end 
	 
	 wire read;
    assign read = slow_clk ^ slow_clk_up;
	 
	 
	 // spike and slow_clk_up are not mutually exclusive in ISIM env. 
	 // Try make intermediate variable to wait for two spikes (lose one spike count) 

	 
    always @(posedge reset or posedge spike) begin
	  if (reset) begin
			cnt <= 32'd0;
			int_cnt_out <= 32'd0;
						
	  end
	  else if (wait_for_one_more_spike == 2'd1) begin
	  		int_cnt_out <= cnt;
			cnt <= 32'd0;     
	  end
	  else begin //if (spike) begin //   SPIKE HIGH ONLY
			int_cnt_out <= int_cnt_out;
			cnt <= cnt + 32'd1;
	  end

//	  else if (!slow_clk_up && (spike == 1'b0)) begin  // SLOW CLK UP, NO SPIKE
//			int_cnt_out <= cnt;
//			cnt <= 32'd0;    // count being renewed at every posedge of slow clock = read.
//	  end

  end  

endmodule	 
   