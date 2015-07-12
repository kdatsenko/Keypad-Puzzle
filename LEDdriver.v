/* All input & output pins are VCC +3.3V*/
//http://majsta.com/downloads/Electronics/Altera_DE2_Schematics.pdf#page=16
module LEDdriver
(
	//11x4: 11 register sets containing 4 bit nums each.
	input [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12,
	output [19:8] GPIO_0 //input pins for DE2 Expansion Header
);
	wire [11:0] GPout;
	assign GPIO_0[19] = GPout[11];
	assign GPIO_0[18] = GPout[10];
	assign GPIO_0[17] = GPout[9];
	assign GPIO_0[16] = GPout[8];
	assign GPIO_0[15] = GPout[7];
	assign GPIO_0[14] = GPout[6];
	assign GPIO_0[13] = GPout[5];
	assign GPIO_0[12] = GPout[4];
	assign GPIO_0[11] = GPout[3];
	assign GPIO_0[10] = GPout[2];
	assign GPIO_0[9] = GPout[1];
	assign GPIO_0[8] = GPout[0];
	
	//wire DLY_RST; <- in case need delay between loading values.
	//reset_delay(CLOCK_50, DLY_RST);
	LEDdecoder(num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12, GPout);
endmodule


/***********
Pin Connection Map:
Wire	Pin	GPout		Keypad 	
				[index]	Number
A1		A0 	0			1
A2		A2		1			4
A3		A4		2			7
A4		A6		3			10
--------------------------
B1		A8		4			2
B2		A10	5			5
B3		A12	6			8
B4		A14	7			11
--------------------------
C1		A16	8			3
C2		A18	9			6
C3		A20	10			9
C4		A22	11			12
***********/

module LEDdecoder(num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12, lights);
	input [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12;
	output [11:0] lights;
	
	//Combinational circuit translating numerical values in the 'num' registers to their 
	//corresponding LED in the keypad matrix. Turns off all lights that do not have a numerical signal
	//via 'num' by default.
	MagicDecoder(4'b0001, lights[0], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b0100, lights[1], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b0111, lights[2], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b1010, lights[3], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b0010, lights[4], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b0101, lights[5], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b1000, lights[6], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b1011, lights[7], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b0011, lights[8], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b0110, lights[9], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b1001, lights[10], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	MagicDecoder(4'b1100, lights[11], num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	
	/*always @ (negedge Reset) begin
		if (~Reset) begin
			lights = 12'b0;
		end
	end*/
	
endmodule

module MagicDecoder(key, onoff, num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12);
	input [3:0] key; //corresponding key code to LED onoff
	output reg onoff; //LED
	input [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12;
	always @(*) begin
		case (key)
			num1: onoff <= 1'b1;
			num2: onoff <= 1'b1;
			num3: onoff <= 1'b1;
			num4: onoff <= 1'b1;
			num5: onoff <= 1'b1;
			num6: onoff <= 1'b1;
			num7: onoff <= 1'b1;
			num8: onoff <= 1'b1;
			num9: onoff <= 1'b1;
			num10: onoff <= 1'b1;
			num11: onoff <= 1'b1;
			num12: onoff <= 1'b1;
			default: onoff <= 1'b0;
		endcase
	end
endmodule
