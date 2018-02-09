//http://simplefpga.blogspot.com/2012/07/seven-segment-led-multiplexing-circuit.html
(* dont_touch = "true" *)
module display(
 input clock, 
 input reset, 
 input signal,
 output reg [6:0] seg, //the individual LED output for the seven segment along with the digital point
 output reg [3:0] an   // the 4 bit enable signal
 );
 
localparam N = 18;
 
reg [N-1:0] count; //the 18 bit counter which allows us to multiplex at 1000Hz
wire [3:0] in0, in1, in2, in3;  //the 4 inputs for each display
wire [13:0] frequency;

counter count1 (.clock(clock), .signal(signal), .frequency(frequency));

bcd bcd1 (.number(frequency), .thousands(in3), 
.hundreds(in2), .tens(in1), .ones(in0));


always @ (posedge clock or posedge reset)
 begin
  if (reset)
   count <= 0;
  else
   count <= count + 1;
 end
 
reg [6:0]sseg; //the 7 bit register to hold the data to output
 
always @ (*)
 begin
  case(count[N-1:N-2]) //using only the 2 MSB's of the counter 
    
   2'b00 :  //When the 2 MSB's are 00 enable the fourth display
    begin
     sseg = in0;
     an = 4'b1110;
    end
    
   2'b01:  //When the 2 MSB's are 01 enable the third display
    begin
     sseg = in1;
     an = 4'b1101;
    end
    
   2'b10:  //When the 2 MSB's are 10 enable the second display
    begin
     sseg = in2;
     an = 4'b1011;
    end
     
   2'b11:  //When the 2 MSB's are 11 enable the first display
    begin
     sseg = in3;
     an = 4'b0111;
    end
  endcase
 end
 
always @ (*)
 begin
  case(sseg)
   4'd0 : seg = 7'b1000000; //to display 0
   4'd1 : seg = 7'b1111001; //to display 1
   4'd2 : seg = 7'b0100100; //to display 2
   4'd3 : seg = 7'b0110000; //to display 3
   4'd4 : seg = 7'b0011001; //to display 4
   4'd5 : seg = 7'b0010010; //to display 5
   4'd6 : seg = 7'b0000010; //to display 6
   4'd7 : seg = 7'b1111000; //to display 7
   4'd8 : seg = 7'b0000000; //to display 8
   4'd9 : seg = 7'b0010000; //to display 9
   default : seg = 7'b0111111; //dash
  endcase
 end
 
endmodule