//http://users.wpi.edu/~rjduck/Counter%20Tutorial%20Verilog.pdf
(* dont_touch = "true" *)
module counter(
	input 	clock, 
	input 	signal,
	output reg [13:0]	frequency = 14'b0
	);
	
	parameter MAX_COUNT = 100_000_000; //max count value
	reg		[26:0]	counter_100M;
	reg 	[13:0]  count;
	reg 	rise, resync;
    
	initial 
		begin
			rise <= 0;
			resync <= 0;
		end
  
	//sampling frequency must be double
	//two clock cycles from signal to get a logical high
	
	always @ (posedge clock)
		begin
			// update history shifter.
			resync <= signal;
		end
	
	always @ (posedge clock)
		if (counter_100M == MAX_COUNT)
		begin
			counter_100M <= 0;
			frequency <= count;
			count <= 0;
		end
		else
		begin
			counter_100M <= counter_100M + 1'b1;
			if (resync == 0 & signal)
				counter_100M <= counter_100M + 1'b1;
		end
endmodule

