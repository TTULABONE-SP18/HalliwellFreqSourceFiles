//http://www.deathbylogic.com/2013/12/binary-to-binary-coded-decimal-bcd-converter/
module bcd(number, thousands, hundreds, tens, ones);
   // I/O Signal Definitions
   input  [13:0] number;
   output reg [3:0] thousands;
   output reg [3:0] hundreds;
   output reg [3:0] tens;
   output reg [3:0] ones;
   
   // Internal variable for storing bits
   reg [29:0] shift;
   integer i;
   
   always @(number)
   begin
      // Clear previous number and store new number in shift register
      shift[29:14] = 0;
      shift[13:0] = number;
      
      // Loop eight times
      for (i=0; i<8; i=i+1) begin
         if (shift[17:14] >= 5)
            shift[17:14] = shift[17:14] + 3;
            
         if (shift[21:18] >= 5)
            shift[21:18] = shift[21:18] + 3;    
			
         if (shift[25:22] >= 5)
            shift[25:22] = shift[25:22] + 3;    
			
         if (shift[29:26] >= 5)
            shift[29:26] = shift[29:26] + 3;
         
         // Shift entire register left once
         shift = shift << 1;
      end
      
      // Push decimal numbers to output
	  thousands = shift[29:26];
      hundreds = shift[25:22];
      tens     = shift[21:18];
      ones     = shift[17:14];
   end
 
endmodule