module correct 
(
	input CLOCK_50,
	input is_S2,
	output reg [3:0] LEDnum1, 
	output reg [3:0] LEDnum2, 
	output reg [3:0] LEDnum3, 
	output reg [3:0] LEDnum4, 
	output reg [3:0] LEDnum5, 
	output reg [3:0] LEDnum6, 
	output reg [3:0] LEDnum7, 
	output reg [3:0] LEDnum8, 
	output reg [3:0] LEDnum9, 
	output reg [3:0] LEDnum10, 
	output reg [3:0] LEDnum11, 
	output reg [3:0] LEDnum12
);
	
	wire slowed_clk;
	clock_50M_toONE (CLOCK_50, slowed_clk);
	
	initial begin
		LEDnum1 = 4'b0001;
		LEDnum2 = 4'b0011;
		LEDnum3 = 4'b0101;
		LEDnum4 = 4'b0111;
		LEDnum5 = 4'b1001;
		LEDnum6 = 4'b1011;
		LEDnum7 = 1'd0;
		LEDnum8 = 1'd0;
		LEDnum9 = 1'd0;
		LEDnum10 = 1'd0;
		LEDnum11 = 1'd0;
		LEDnum12 = 1'd0;
	end
	
	reg pattern = 1'b0;
	always @ (posedge slowed_clk) begin
			pattern = ~pattern;
			if (pattern) begin
				LEDnum1 = 4'b0001;
				LEDnum2 = 4'b0011;
				LEDnum3 = 4'b0101;
				LEDnum4 = 4'b0111;
				LEDnum5 = 4'b1001;
				LEDnum6 = 4'b1011;
			end else begin
				LEDnum1 = 4'b0010;
				LEDnum2 = 4'b0100;
				LEDnum3 = 4'b0110;
				LEDnum4 = 4'b1000;
				LEDnum5 = 4'b1010;
				LEDnum6 = 4'b1100;
			end
	end
	
endmodule


module clock_50M_toONE(Clk_50MHz, Clk_1Hz);
	input Clk_50MHz;
	output Clk_1Hz;
	reg pulse_1Hz = 1; //start off high (with registering "posedge")
	reg [25:0] clock_pulses; //25 = floor(log2(25*10^6))
	always @ (posedge Clk_50MHz) begin
			//Marking the halfway point in order to simulate
			//the rising and falling edge of the 1Hz clock pulse.
			if (clock_pulses < ((25000000) - 1)) begin//((25000000) - 1)) begin
				clock_pulses <= clock_pulses + 1;
			end else begin
				clock_pulses <= 0;
				pulse_1Hz <= ~pulse_1Hz;
			end
	end
	assign Clk_1Hz = pulse_1Hz;
endmodule