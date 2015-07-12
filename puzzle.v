module puzzle 
(
	input is_S1, //is_S1?
	input [3:0] key_val,
	input key_press,
	input [3:0] passd1,
	input [3:0] passd2,
	input [3:0] passd3,
	input [3:0] passd4,
	input [3:0] passd5,
	input [3:0] passd6,
	input [3:0] passd7,
	input [3:0] passd8,
	input [3:0] passd9,
	input [3:0] passd10,
	input [3:0] passd11,
	input [3:0] passd12,
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
	output [3:0] LEDnum12,
	/* Signal that the entry circuit is finished (1 if true). */
	output E, //entry success. 
	output Ib //secret code entered - 1 if true.
);
	
	secret_code (is_S1, key_press, key_val, Ib);
		
	Entry e1(
	.enable(is_S1),
	.key_press(key_press),
	.key_val(key_val),
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
	.E(E),
	.LEDnum1(LEDnum1),
	.LEDnum2(LEDnum2),
	.LEDnum3(LEDnum3),
	.LEDnum4(LEDnum4),
	.LEDnum5(LEDnum5),
	.LEDnum6(LEDnum6),
	.LEDnum7(LEDnum7),
	.LEDnum8(LEDnum8),
	.LEDnum9(LEDnum9),
	.LEDnum10(LEDnum10),
	.LEDnum11(LEDnum11),
	.LEDnum12(LEDnum12));

endmodule

/* INVARIANT: has at least one pair of repeating digits */
module secret_code (enable, key_press, key_val, Ib);
	input enable, key_press;
	input [3:0] key_val;
	output reg Ib; //input bit 2
	parameter code_d1 = 7; //TYPE: 117
	parameter code_d2 = 1;
	parameter code_d3 = 1;
	reg [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12;
	reg Clear;
	always @ (posedge key_press) begin
		if (enable) begin
			num12 = num11;
			num11 = num10;
			num10 = num9;
			num9 = num8;
			num8 = num7;
			num7 = num6;
			num6 = num5;
			num5 = num4;
			num4 = num3;
			num3 = num2;
			num2 = num1;
			num1 = key_val;
			if (code_d1 == num1 & code_d2 == num2 & code_d3 == num3) begin
				Ib = 1'b1;
			end
		end else begin
			Ib = 1'b0;
			num1 = 4'd0;
			num2 = 4'd0;
			num3 = 4'd0;
			num4 = 4'd0;
			num5 = 4'd0;
			num6 = 4'd0;
			num7 = 4'd0;
			num8 = 4'd0;
			num9 = 4'd0;
			num10 = 4'd0;
			num11 = 4'd0;
			num12 = 4'd0;
		end
	end
endmodule

module Entry 
(
	input enable,
	input key_press,
	input [3:0] key_val,
	input [3:0] passd1, passd2, passd3, passd4, passd5, passd6, passd7, passd8, passd9, passd10, passd11, passd12,
	output reg E,
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
);
	
	reg [3:0] num1, num2, num3, num4, num5, num6, num7, num8, num9, num10, num11, num12;
	reg [3:0] counter;
	reg [3:0] pass_digit;
	
	assign LEDnum1 = num1;
	assign LEDnum2 = num2;
	assign LEDnum3 = num3; 
	assign LEDnum4 = num4;
	assign LEDnum5 = num5;
	assign LEDnum6 = num6;
	assign LEDnum7 = num7;
	assign LEDnum8 = num8;
	assign LEDnum9 = num9;
	assign LEDnum10 = num10;
	assign LEDnum11 = num11;
	assign LEDnum12 = num12;
	
	/* Shift REG */
	always @ (posedge key_press) begin
		if (enable) begin
			num12 = num11;
			num11 = num10;
			num10 = num9;
			num9 = num8;
			num8 = num7;
			num7 = num6;
			num6 = num5;
			num5 = num4;
			num4 = num3;
			num3 = num2;
			num2 = num1;
			num1 = key_val;
			case (counter) /* Reversed because number are shifted RIGHT */
				4'b0000: pass_digit = passd12;
				4'b0001: pass_digit = passd11;
				4'b0010: pass_digit = passd10;
				4'b0011: pass_digit = passd9;
				4'b0100: pass_digit = passd8;
				4'b0101: pass_digit = passd7;
				4'b0110: pass_digit = passd6;
				4'b0111: pass_digit = passd5;
				4'b1000: pass_digit = passd4;
				4'b1001: pass_digit = passd3;
				4'b1010: pass_digit = passd2;
				4'b1011: pass_digit = passd1;
			endcase
			if (num1 == pass_digit) begin
				if (counter == 4'b1011) begin //counter at last pass digit
					E = 1'b1;
				end else begin
					counter = counter + 1;
				end
			end else begin
				num1 = 4'd0;
				num2 = 4'd0;
				num3 = 4'd0;
				num4 = 4'd0;
				num5 = 4'd0;
				num6 = 4'd0;
				num7 = 4'd0;
				num8 = 4'd0;
				num9 = 4'd0;
				num10 = 4'd0;
				num11 = 4'd0;
				num12 = 4'd0;
				counter = 4'd0;
				E = 1'b0;
			end
		end else begin //is_S1 == false
			num1 = 4'd0;
			num2 = 4'd0;
			num3 = 4'd0;
			num4 = 4'd0;
			num5 = 4'd0;
			num6 = 4'd0;
			num7 = 4'd0;
			num8 = 4'd0;
			num9 = 4'd0;
			num10 = 4'd0;
			num11 = 4'd0;
			num12 = 4'd0;
			counter = 4'd0;
			E = 1'b0;
		end
	end
endmodule









