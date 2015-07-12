module keypad(CLOCK_50, GPIO_0, LEDG, HEX0, HEX1, HEX2, HEX3, key_press, KeyVal);
	input CLOCK_50;	
	inout [6:0] GPIO_0; // //changing R input values
	output [3:0] LEDG;
	output [0:6] HEX0, HEX1, HEX2, HEX3;
	output key_press;
	output reg [3:0] KeyVal;
	
	wire V;
	wire N0, N1, N2, N3;
	wire dClk;
	wire C0, C1, C2;
	wire R0, R1, R2, R3;
	assign R3 = GPIO_0[6];
	assign R2 = GPIO_0[5];
	assign R1 = GPIO_0[4];
	assign R0 = GPIO_0[3];
	//assign C to output pins...
	/*
	assign GPIO_0[0] = 1'b0;
	assign GPIO_0[6] = 1'b0;
	assign GPIO_0[10] = 1'b1;
	*/
	assign GPIO_0[0] = C0;
	assign GPIO_0[1] = C1;
	assign GPIO_0[2] = C2;
	
	clock_50M_toX(CLOCK_50, dClk);
	scanner(dClk, R0, R1, R2, R3, C0, C1, C2, V, N0, N1, N2, N3);
	
	/*reg [3:0] one;
	reg [3:0] two;
	reg [3:0] three;	
	reg [3:0] four;*/
	/*wire slowed_clk;
	reg Reset;
	reg Enable; */
	
	wire timer;
	wire Reset;
	clock_50M_to1(Reset, CLOCK_50, timer);
	reg key_delay;
	reg [3:0] Key_Val_Del;
	
	
	//reg keypress_detector;
	//reg [3:0] KeyVal;
	always @ (posedge V) begin
		KeyVal[3] = N3;
		KeyVal[2] = N2;
		KeyVal[1] = N1;
		KeyVal[0] = N0;
	end
	
	assign Reset = V;
	
	always @ (posedge timer, posedge CLOCK_50) begin
		if (timer) begin
			key_delay = 1'b1;
			Key_Val_Del = KeyVal;
		end else begin
			key_delay = 1'b0;
		end
	end
	
	

	/*
	
	always @(posedge slowed_clk) begin
		if (keypress_detector) begin
			key_delay = 1'b1;
			keypress_detector = 1'b0;
		end else begin
			key_delay = 1'b0;
		end
	end*/
	
	assign LEDG = KeyVal;
	assign key_press = key_delay;
	//LEDdriver(KeyVal, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, GPIO_0[35:8]);
	seven_seg_decoder(Key_Val_Del, HEX0);
	/*seven_seg_decoder(two, HEX1);
	seven_seg_decoder(three, HEX2);
	seven_seg_decoder(four, HEX3);*/
endmodule


module clock_50M_to1(RST, Clk_50MHz, Clk_1Hz);
	input Clk_50MHz;
	input RST;
	output Clk_1Hz;
	reg pulse_1Hz;
	initial begin
		pulse_1Hz = 1'b0; //start off low
	end
	reg [50:0] clock_pulses; //25 = floor(log2(25*10^6))
	always @ (posedge Clk_50MHz or posedge RST) begin
			//Marking the halfway point in order to simulate
			//the rising and falling edge of the 1Hz clock pulse.
			if (RST) begin
				clock_pulses <= 0;
				pulse_1Hz = 1'b0;
			end else
				if (clock_pulses < ((50000000) - 1)) begin//((25000000) - 1)) begin
					clock_pulses <= clock_pulses + 1;
				end else begin
					clock_pulses <= 0;
					pulse_1Hz <= 1'b1;
				end
			end
	assign Clk_1Hz = pulse_1Hz;
endmodule


module scanner (CLK, R0, R1, R2, R3, C0, C1, C2, V, N0, N1, N2, N3);
	input R0, R1, R2, R3;
	input CLK;
	output C0, C1, C2;
	output reg V;
	output N0, N1, N2, N3;
	
	reg QA;
	wire K;
	reg Kd;
	reg[2:0] state;
	reg [2:0] nextstate;
	reg C0_tmp;
	reg C1_tmp;
	reg C2_tmp;

	assign C0 = C0_tmp;
	assign C1 = C1_tmp;
	assign C2 = C2_tmp;

	assign K = R0 | R1 | R2 | R3;
	/*assign N3 = (R2 & ~C0) | (R3 & ~C1);
	assign N2 = R1 | (R2 & C0);
	assign N1 = (R0 & ~C0) | (~R2 & C2) | (~R1 & ~R0 & C0);
	assign N0 = (R1 & C1) | (~R1 & C2) | (~R3 & ~R1 & ~C1);*/
	
	assign N3 = R3 | (R2 & ~C0);
	assign N2 = R1 | (R2 & C0) | (R3 & C2);
	assign N1 = (R0 & ~C0) | (R3 & ~C2) | (R1 & C2) | (R2 & C0);
	assign N0 = (C1 & (R1 | R3)) | (~C1 & (R0 | R2));
	

	initial
	begin
		state = 0;
		nextstate = 0;
	end

	always @(state or R0 or R1 or R2 or R3 or C0 or C1 or C2 or K or Kd or QA)
	begin
		C0_tmp = 1'b0;
		C1_tmp = 1'b0;
		C2_tmp = 1'b0;
		V = 1'b0;
		case (state)
			0 : begin
				nextstate = 1;
			end
			1 : begin
				C0_tmp = 1'b1;
				C1_tmp = 1'b1;
				C2_tmp = 1'b1;
				if ((Kd & K) == 1'b1)
				begin
					nextstate = 2;
				end
				else begin
					nextstate = 1;
				end
			end
			2 : begin
				C0_tmp = 1'b1;
				if ((Kd & K) == 1'b1)
				begin
					V = 1'b1;
					nextstate = 5;
				end
				else if (K == 1'b0)
				begin
					nextstate = 3;
				end
				else begin
					nextstate = 2;
				end
			end
			3 : begin
				C1_tmp = 1'b1;
				if ((Kd & K) == 1'b1)
				begin
					V = 1'b1;
					nextstate = 5;
				end
				else if (K == 1'b0)
				begin
					nextstate = 4;
				end
				else begin
					nextstate = 3;
				end
			end
			4 : begin
				C2_tmp = 1'b1;
				if ((Kd & K) == 1'b1)
				begin
					V <= 1'b1;
					nextstate = 5;
				end
				else begin
					nextstate = 4;
				end
			end
			5 : begin
				C0_tmp = 1'b1;
				C1_tmp = 1'b1;
				C2_tmp = 1'b1;
				if (Kd == 1'b0)
				begin
					nextstate = 1;
				end
				else begin
					nextstate = 5;
				end
			end
		endcase
	end

	always @(posedge CLK) begin
		state <= nextstate;
		QA = K;
		Kd = QA;
	end

endmodule


/* Manually adjust values here depending on bounce time */
module clock_50M_toX(Clk_50MHz, dClk);
	input Clk_50MHz;
	output dClk;
	reg pulse_XHz = 1; //start off high (w/0 registering "posedge")
	/**
	Formula for calculating bit length of counter.
	Say bounce time = Xms.
	Then num pulses of 50MgHz gone by for entire duration of Xms:
		n = (X/1000) * (50 *10^6)
	We want to simulate the rising and falling edge of the pulse,
	so we mark the halfway pulse point like so:
		n_half = n / 2
	Then the length of the counter to hold the correct pulses
	and toggle the clock is:
		c = ceil(log2(n_half)) 
		=> reg [c-1:0] clock_pulses!!
		=> if (clock_pulses < ((n_half) - 1)) begin
	**/
	reg [16:0] clock_pulses; //try ~3ms
	always @ (posedge Clk_50MHz) begin
			//Marking the halfway point in order to simulate
			//the rising and falling edge of the 1Hz clock pulse.
			//520!!!!! workd
			//950!! clock_pulses for NEW BOOL EXP!
			if (clock_pulses < ((200) - 1)) begin
				clock_pulses <= clock_pulses + 1;
			end else begin
				clock_pulses <= 0;
				pulse_XHz <= ~pulse_XHz;
			end
	end
	assign dClk = pulse_XHz;
endmodule

//hexadecimal convertor: converts any value from 0 to 15
//hexadecimal: a consequetive group of 4 binary digits can be considered independently, and converted directly
module seven_seg_decoder(V, Display);
	input [3:0] V; //input code
	output [0:6] Display; //output 7-seg code
	
	//When you want to turn on a segment, set it low
	assign Display[0] = (~V[3] & ~V[1] & (V[2] ^ V[0])) | (V[3] & V[0] & (V[2] ^ V[1]));
	assign Display[1] = (~V[3] & V[2] & ~V[1] & V[0]) | (V[3] & V[2] & ~V[0]) | (V[3] & V[1] & V[0]) | (V[2] & V[1] & ~V[0]);
	assign Display[2] = (~V[0] & ((V[3] & V[2] & ~V[1]) | (~V[3] & ~V[2] & V[1]))) | (V[3] & V[2] & V[1]);
	assign Display[3] = (~V[3] & ~V[1] & (V[2] ^ V[0])) | (V[3] & ~V[2] & V[1] & ~V[0]) | (V[2] & V[1] & V[0]);
	assign Display[4] = (~V[3] & V[2] & ~V[1]) | (V[0] & ((~V[2] & ~V[1]) | ~V[3]));
	assign Display[5] = (V[3] & V[2] & ~V[1] & V[0]) | (~V[3] & ~V[2] & (V[1] | V[0])) | (~V[3] & V[1] & V[0]);
	assign Display[6] = (V[3] & V[2] & ~V[1] & ~V[0]) | (~V[3] & V[2] & V[1] & V[0]) | (~V[3] & ~V[2] & ~V[1]);
endmodule
