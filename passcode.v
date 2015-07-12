module passcode 
(
	input is_S3, //is_S3?
	input [3:0] key_val,
	input key_press, 
	output P, /* Signal that the passcode circuit is finished (1 if true). */
	output [3:0] PassCodeDigit1,
	output [3:0] PassCodeDigit2,
	output [3:0] PassCodeDigit3,
	output [3:0] PassCodeDigit4,
	output [3:0] PassCodeDigit5,
	output [3:0] PassCodeDigit6,
	output [3:0] PassCodeDigit7,
	output [3:0] PassCodeDigit8,
	output [3:0] PassCodeDigit9,
	output [3:0] PassCodeDigit10,
	output [3:0] PassCodeDigit11,
	output [3:0] PassCodeDigit12,
	output [3:0] LEDnum1, 
	output [3:0] LEDnum2, 
	output [3:0] LEDnum3, 
	output [3:0] LEDnum4, 
	output [3:0] LEDnum5, 
	output [3:0] LEDnum6, 
	output [3:0] LEDnum7, 
	output [3:0] LEDnum8, 
	output [3:0] LEDnum9, 
	output [3:0] LEDnum10, 
	output [3:0] LEDnum11, 
	output [3:0] LEDnum12
	//output is_unique
);

	wire entry_save; /* Signal to load entry code into Passcode regs,
							  and reset all other circuit components. */

	//wire is_unique; /* Signal to confirm current key pressed hasn't been 'registered' (<-pun) before. */
	wire full_code; /* Signal to confirm all 12 different keys have been pressed and registered. */
	wire [3:0] key_select; /* Key value to validate and load if validation successful. */
	/*wire [3:0] passd1, passd2, passd3, passd4, passd5, passd6, passd7, passd8, passd9, passd10, passd11, passd12;
	
	assign PassCodeDigit1 = passd1;
	assign PassCodeDigit2 = passd2;
	assign PassCodeDigit3 = passd3;
	assign PassCodeDigit4 = passd4;
	assign PassCodeDigit5 = passd5;
	assign PassCodeDigit6 = passd6;
	assign PassCodeDigit7 = passd7;
	assign PassCodeDigit8 = passd8;
	assign PassCodeDigit9 = passd9;
	assign PassCodeDigit10 = passd10;
	assign PassCodeDigit11 = passd11;
	assign PassCodeDigit12 = passd12;*/
	
	wire enable_s3;
	assign enable_s3 = is_S3 & ~P;
	wire is_unique;
	
	Key_registers u1(
	.Clk(key_press),
	.EN(enable_s3),
	.Reset(entry_save),
	.is_unique(is_unique),
	.key_val(key_val),
	.passd1(PassCodeDigit1),
	.passd2(PassCodeDigit2),
	.passd3(PassCodeDigit3),
	.passd4(PassCodeDigit4),
	.passd5(PassCodeDigit5),
	.passd6(PassCodeDigit6),
	.passd7(PassCodeDigit7),
	.passd8(PassCodeDigit8),
	.passd9(PassCodeDigit9),
	.passd10(PassCodeDigit10),
	.passd11(PassCodeDigit11),
	.passd12(PassCodeDigit12),
	.current_key(key_select));
	
	
	//wire [11:0] delayed_tracker;
	key_tracker(key_press, is_S3, entry_save, key_select,key_val, is_unique, full_code, 
					LEDnum1, LEDnum2, LEDnum3, LEDnum4, LEDnum5, LEDnum6,
					LEDnum7, LEDnum8, LEDnum9, LEDnum10, LEDnum11, LEDnum12);//, delayed_tracker);
					
	DFF_entry_success(full_code, entry_save, key_press);
	
	assign P = entry_save; //is entry valid?
	//assign dtrack = delayed_tracker;
	
	
endmodule 

/* Holds valid key presses/values and loads them 
 * into the Passcode registers when ready to reset */
module Key_registers
(
	input Clk, EN, Reset, is_unique,
	input [3:0] key_val,
	output reg [3:0] passd1, passd2, passd3, passd4, passd5, passd6, passd7, passd8, passd9, passd10, passd11, passd12,
	output reg [3:0] current_key
);
	initial begin
		current_key = 4'b0000;
		/* SET inital puzzle code to anything */
		passd1 = 4'd12;
		passd2 = 4'd11;
		passd3 = 4'd10;
		passd4 = 4'd9;
		passd5 = 4'd8;
		passd6 = 4'd7;
		passd7 = 4'd6;
		passd8 = 4'd5;
		passd9 = 4'd4;
		passd10 = 4'd3;
		passd11 = 4'd2;
		passd12 = 4'd1;
	end
	reg [3:0] Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12;
	
	always @ (posedge Clk) begin
		if (Reset) begin
			current_key <= 4'b0000;
			Q2 <= 4'b0000;
			Q3 <= 4'b0000;
			Q4 <= 4'b0000;
			Q5 <= 4'b0000;
			Q6 <= 4'b0000;
			Q7 <= 4'b0000;
			Q8 <= 4'b0000;
			Q9 <= 4'b0000;
			Q10 <= 4'b0000;
			Q11 <= 4'b0000;
			Q12 <= 4'b0000;
		end else if (EN && is_unique) begin
				//Shift operation
				//need to avoid race conditions (blocking)!
				Q12 = Q11;
				Q11 = Q10;
				Q10 = Q9;
				Q9 = Q8;
				Q8 = Q7; 
				Q7 = Q6;
				Q6 = Q5;
				Q5 = Q4;
				Q4 = Q3;
				Q3 = Q2;
				Q2 = current_key;
				current_key = key_val;
			end else if (EN) begin
				current_key = key_val;
			end
	end	
	
	
			/* Load shift reg values into Passcode regs when
										* circuit detects valid entry (Reset=HIGH)*/
		always @ (posedge Reset) begin	
			passd1 <= current_key; 
			passd2 <= Q2;
			passd3 <= Q3;
			passd4 <= Q4;
			passd5 <= Q5;
			passd6 <= Q6;
			passd7 <= Q7;
			passd8 <= Q8;
			passd9 <= Q9;
			passd10 <= Q10;
			passd11 <= Q11;
			passd12 <= Q12;
		end
	
	/*
	assign passd1 = Q1 & Reset;
	assign passd2 = Q2 & Reset;
	assign passd3 = Q3 & Reset;
	assign passd4 = Q4 & Reset;
	assign passd5 = Q5 & Reset;
	assign passd6 = Q6 & Reset;
	assign passd7 = Q7 & Reset;
	assign passd8 = Q8 & Reset;
	assign passd9 = Q9 & Reset;
	assign passd10 = Q10 & Reset;
	assign passd11 = Q11 & Reset;
	assign passd12 = Q12 & Reset;*/
	
endmodule

/* Special FF used to save the event of a passcode entry
 * success until the next key press. This way it removes 
 * race conditions.
 * Clk=KeyPress, c=full, q=entry_success */
module DFF_entry_success(c, q, clk);
   input c;
   input clk;
   output q;
   reg q;
	initial begin
     q = 1'b0;
   end
   always @(posedge clk or posedge c) begin
      if (c) begin
        q = 1'b1;
      end else begin
        q = 1'b0;
      end
   end
endmodule


/* Controls immediate and delayed tracking registers. 
 * 'full' indicates all values have been seen 
 * (entry of 12-digit code successful). Reset is active-high.*/
module key_tracker(
	input Clk, Enable, Clear,
	input [3:0] load_val,
	input [3:0] key,
	output is_unique,
	output full,
	output [3:0] LEDnum1, 
	output [3:0] LEDnum2, 
	output [3:0] LEDnum3, 
	output [3:0] LEDnum4, 
	output [3:0] LEDnum5, 
	output [3:0] LEDnum6, 
	output [3:0] LEDnum7, 
	output [3:0] LEDnum8, 
	output [3:0] LEDnum9, 
	output [3:0] LEDnum10, 
	output [3:0] LEDnum11, 
	output [3:0] LEDnum12
	//output reg [11:0] immediate_tracker
);	
	
	reg [11:0] delayed_tracker;
	reg [11:0] immediate_tracker;
	 
	initial begin
		delayed_tracker = 12'd0;
		immediate_tracker = 12'd0;
	end
	
	assign full = (&immediate_tracker);
	//updates LED key registers.
	assign LEDnum1 = (immediate_tracker[0]) ? 4'b0001 : 4'b0000;
	assign LEDnum2 = (immediate_tracker[1]) ? 4'b0010 : 4'b0000;
	assign LEDnum3 = (immediate_tracker[2]) ? 4'b0011 : 4'b0000;
	assign LEDnum4 = (immediate_tracker[3]) ? 4'b0100 : 4'b0000;
	assign LEDnum5 = (immediate_tracker[4]) ? 4'b0101 : 4'b0000;
	assign LEDnum6 = (immediate_tracker[5]) ? 4'b0110 : 4'b0000;
	assign LEDnum7 = (immediate_tracker[6]) ? 4'b0111 : 4'b0000;
	assign LEDnum8 = (immediate_tracker[7]) ? 4'b1000 : 4'b0000;
	assign LEDnum9 = (immediate_tracker[8]) ? 4'b1001 : 4'b0000;
	assign LEDnum10 = (immediate_tracker[9]) ? 4'b1010 : 4'b0000;
	assign LEDnum11 = (immediate_tracker[10]) ? 4'b1011 : 4'b0000; //used to be 1011
	assign LEDnum12 = (immediate_tracker[11]) ? 4'b1100 : 4'b0000; //used to be 1100
	
	//Controls immediate_tracker
	always @(posedge Clk or posedge Clear) begin
		if (Clear) begin
			immediate_tracker = 12'd0;
		end else if (Enable) begin
			case (key) //CHANGED TO 'key' since the always block 
						  //activates only on 
			4'b0001: immediate_tracker[0] <= 1'b1;
			4'b0010: immediate_tracker[1] <= 1'b1;
			4'b0011: immediate_tracker[2] <= 1'b1;
			4'b0100: immediate_tracker[3] <= 1'b1;
			4'b0101: immediate_tracker[4] <= 1'b1;
			4'b0110: immediate_tracker[5] <= 1'b1;
			4'b0111: immediate_tracker[6] <= 1'b1;
			4'b1000: immediate_tracker[7] <= 1'b1;
			4'b1001: immediate_tracker[8] <= 1'b1;
			4'b1010: immediate_tracker[9] <= 1'b1;
			4'b1011: immediate_tracker[10] <= 1'b1; //used to be: 1011 (11)
			4'b1100: immediate_tracker[11] <= 1'b1; //used to be: 1100 (12)
		endcase
		end
	end
	
	assign is_unique = ~delayed_tracker[load_val - 1];
	
	//Controls delayed_tracker
	always @ (posedge Clk or posedge Clear) begin
		if (Clear) begin
			delayed_tracker = 12'd0;
		end else begin
			delayed_tracker[11:0] = immediate_tracker[11:0];
			//is_unique = ~delayed_tracker[key - 1];
		end
	end
	
endmodule



