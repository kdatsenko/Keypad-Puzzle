module controller (CLOCK_50, GPIO_0, LEDG, HEX0, HEX1, HEX2, HEX3);//, LEDR);
	
	input CLOCK_50;
	inout [35:0] GPIO_0;
	output [3:0] LEDG;
	//output [17:0] LEDR;
	output [0:6] HEX0, HEX1, HEX2, HEX3;
	
	wire P;
	wire E;
	wire Ib;
	wire is_S1, is_S2, is_S3;
	//reg F0, F1;
	wire [3:0] passd1, passd2, passd3, passd4, passd5, passd6, passd7, passd8, passd9, passd10, passd11, passd12;
	//reg [3:0] passd1, passd2, passd3, passd4, passd5, passd6, passd7, passd8, passd9, passd10, passd11, passd12;
	
	wire [3:0] ledE1, ledE2, ledE3, ledE4, ledE5, ledE6, ledE7, ledE8, ledE9, ledE10, ledE11, ledE12;
	wire [3:0] ledP1, ledP2, ledP3, ledP4, ledP5, ledP6, ledP7, ledP8, ledP9, ledP10, ledP11, ledP12;
	wire [3:0] ledC1, ledC2, ledC3, ledC4, ledC5, ledC6, ledC7, ledC8, ledC9, ledC10, ledC11, ledC12;
	
	wire key_press;
	wire [3:0] key_value;

	
	keypad(CLOCK_50, GPIO_0[6:0], LEDG, HEX0, HEX1, HEX2, HEX3, key_press, key_value);
	//assign LEDR[3:0] = ledE2;
	
	reg [3:0] LEDnum1;
	reg [3:0] LEDnum2; 
	reg [3:0] LEDnum3; 
	reg [3:0] LEDnum4; 
	reg [3:0] LEDnum5; 
	reg [3:0] LEDnum6; 
	reg [3:0] LEDnum7; 
	reg [3:0] LEDnum8; 
	reg [3:0] LEDnum9; 
	reg [3:0] LEDnum10; 
	reg [3:0] LEDnum11; 
	reg [3:0] LEDnum12;	
	
	LEDdriver driver(
	.num1(LEDnum1),
	.num2(LEDnum2), 
	.num3(LEDnum3), 
	.num4(LEDnum4),  
	.num5(LEDnum5), 
	.num6(LEDnum6), 
	.num7(LEDnum7),  
	.num8(LEDnum8),  
	.num9(LEDnum9), 
	.num10(LEDnum10), 
	.num11(LEDnum11), 
	.num12(LEDnum12),
	.GPIO_0(GPIO_0[19:8]));
	
	initial begin 
		state = 2'b00;
		nextstate = 2'b00;
	end
	
	reg[1:0] state;
	reg [1:0] nextstate;
	
	//STATE_MACHINE
	always @ (posedge CLOCK_50) begin
			case (state)
				2'b10: begin
					if (key_press) begin
						state = 2'b00;
					end
				end
				2'b00: begin
					if (E) begin
						state = 2'b10;
					end
					else if (Ib) begin
						state = 2'b01;
					end
				end
				2'b01: begin
					if (P) begin
						state = 2'b00;
					end
				end
			endcase
		end
	
	
	//always @ (posedge CLOCK_50) begin
	//	state <= nextstate;
	//end
	
	
	assign is_S1 = ~state[1] & ~state[0];
	assign is_S2 = state[1];
	assign is_S3 = state[0];
	

			//F1 <= (F1 & ~Ia) | (~F1 & ~F0 & Ia);
			//F0 <= Ib | (F0 & ~Ia);

	
	/*always @ (E or key_press or P) begin
		if (is_S1) begin
			Ia <= E;
		end else if (is_S2) begin
			Ia <= key_press;
		end else if (is_S3) begin
			Ia <= P;
		end
	end*/
	
	

	//RESET THE PASSCODE
	passcode P_circuit(
	.is_S3(is_S3), //is_S3?
	.key_val(key_value),
	.key_press(key_press), 
	.P(P), /* Signal that the passcode circuit is finished (1 if true). */
	.PassCodeDigit1(passd1),
	.PassCodeDigit2(passd2),
	.PassCodeDigit3(passd3),
	.PassCodeDigit4(passd4),
	.PassCodeDigit5(passd5),
	.PassCodeDigit6(passd6),
	.PassCodeDigit7(passd7),
	.PassCodeDigit8(passd8),
	.PassCodeDigit9(passd9),
	.PassCodeDigit10(passd10),
	.PassCodeDigit11(passd11),
	.PassCodeDigit12(passd12),
	.LEDnum1(ledP1), 
	.LEDnum2(ledP2), 
	.LEDnum3(ledP3), 
	.LEDnum4(ledP4), 
	.LEDnum5(ledP5), 
	.LEDnum6(ledP6), 
	.LEDnum7(ledP7), 
	.LEDnum8(ledP8), 
	.LEDnum9(ledP9), 
	.LEDnum10(ledP10), 
	.LEDnum11(ledP11), 
	.LEDnum12(ledP12));

	//PUZZLE
	puzzle E_circuit(
	.is_S1(is_S1), //is_S1?
	.key_val(key_value),
	.key_press(key_press),
	.passd1(passd1),
	.passd2(passd2),
	.passd3(passd3),
	.passd4(passd4),
	.passd5(passd5),
	.passd6(passd6),
	.passd7(passd7),
	.passd8(passd8),
	.passd9(passd9),
	.passd10(passd10),
	.passd11(passd11),
	.passd12(passd12),
	.LEDnum1(ledE1), 
	.LEDnum2(ledE2), 
	.LEDnum3(ledE3), 
	.LEDnum4(ledE4), 
	.LEDnum5(ledE5), 
	.LEDnum6(ledE6), 
	.LEDnum7(ledE7), 
	.LEDnum8(ledE8), 
	.LEDnum9(ledE9), 
	.LEDnum10(ledE10), 
	.LEDnum11(ledE11), 
	.LEDnum12(ledE12),
	/* Signal that the entry circuit is finished (1 if true). */
	.E(E), //entry success. 
	.Ib(Ib)); //secret code entered - 1 if true.

	//WHEN ENTRY IS CORRECT
	correct C_circuit(
	.CLOCK_50(CLOCK_50),
	.is_S2(is_S2),
	.LEDnum1(ledC1), 
	.LEDnum2(ledC2), 
	.LEDnum3(ledC3), 
	.LEDnum4(ledC4), 
	.LEDnum5(ledC5), 
	.LEDnum6(ledC6), 
	.LEDnum7(ledC7), 
	.LEDnum8(ledC8), 
	.LEDnum9(ledC9), 
	.LEDnum10(ledC10), 
	.LEDnum11(ledC11), 
	.LEDnum12(ledC12));

	always @* begin
		if (is_S1) begin
			LEDnum1 = ledE1;
			LEDnum2 = ledE2;
			LEDnum3 = ledE3;
			LEDnum4 = ledE4;
			LEDnum5 = ledE5;
			LEDnum6 = ledE6;
			LEDnum7 = ledE7;
			LEDnum8 = ledE8;
			LEDnum9 = ledE9;
			LEDnum10 = ledE10;
			LEDnum11 = ledE11;
			LEDnum12 = ledE12;
		end else if (is_S2) begin
			LEDnum1 = ledC1;
			LEDnum2 = ledC2;
			LEDnum3 = ledC3;
			LEDnum4 = ledC4;
			LEDnum5 = ledC5;
			LEDnum6 = ledC6;
			LEDnum7 = ledC7;
			LEDnum8 = ledC8;
			LEDnum9 = ledC9;
			LEDnum10 = ledC10;
			LEDnum11 = ledC11;
			LEDnum12 = ledC12;
		end else begin // if (is_S3) begin
			LEDnum1 = ledP1;
			LEDnum2 = ledP2;
			LEDnum3 = ledP3;
			LEDnum4 = ledP4;
			LEDnum5 = ledP5;
			LEDnum6 = ledP6;
			LEDnum7 = ledP7;
			LEDnum8 = ledP8;
			LEDnum9 = ledP9;
			LEDnum10 = ledP10;
			LEDnum11 = ledP11;
			LEDnum12 = ledP12;
		end
	end


	//LEDdriver: TODO

endmodule
