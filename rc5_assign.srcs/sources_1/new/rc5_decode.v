`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2021 01:05:54 AM
// Design Name: 
// Module Name: rc5_decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module rc5_decode(
    input rst,
    input clk,
    input [63:0] din,
    output [63:0] dout
    );
    
reg [3:0] i_cnt;

wire [31:0] a_temp;
wire [31:0] a_rot;
wire [31:0] a;
reg [31:0] a_reg;

wire [31:0] b_temp;
wire [31:0] b_rot;
wire [31:0] b;
reg [31:0] b_reg;

reg [31:0] rom [2:25];
initial begin
rom[2] = 32'h46F8E8C5;
rom[3] = 32'h460C6085;
rom[4] = 32'h70F83B8A;
rom[5] = 32'h284B8303;
rom[6] = 32'h513E1454;
rom[7] = 32'hF621ED22;
rom[8] = 32'h3125065D;
rom[9] = 32'h11A83A5D;
rom[10] = 32'hD427686B;
rom[11] = 32'h713AD82D;
rom[12] = 32'h4B792F99;
rom[13] = 32'h2799A4DD;
rom[14] = 32'hA7901C49;
rom[15] = 32'hDEDE871A;
rom[16] = 32'h36C03196;
rom[17] = 32'hA7EFC249;
rom[18] = 32'h61A78BB8;
rom[19] = 32'h3B0A1D2B;
rom[20] = 32'h4DBFCA76;
rom[21] = 32'hAE162167;
rom[22] = 32'h30D76B0A;
rom[23] = 32'h43192304;
rom[24] = 32'hF6CC1431;
rom[25] = 32'h65046380;
end

// updating a_reg 
always @(posedge rst or posedge clk) begin
    if(rst==1) a_reg <= din[63:32];
    else a_reg <= a;
end

// updating b_reg 
always @(posedge rst or posedge clk) begin
    if(rst==1) b_reg<=din[31:0];
    else b_reg <= b;
end

// set/decrement  clock count 
always @(posedge rst or posedge clk)
begin 
    if (rst==1) begin
        i_cnt <= 4'b1100;
    end 
    else begin
        if(i_cnt==4'b0001)
            i_cnt<=4'b1100;
        else
            i_cnt<=i_cnt-4'b1;
        end
    end
    
// B = ((B - S[2*i +1]) >>> A) xor A;
assign b_temp = b_reg - rom[$unsigned({i_cnt,1'b1})];
assign b_rot = {b_temp,b_temp} >> a_reg[4:0];
assign b = b_rot ^ a_reg;

//A = ((A - S[2×i]) >>> B) xor B;
assign a_temp = a_reg - rom[$unsigned({i_cnt,1'b0})];
assign a_rot = {a_temp,a_temp} >> b[4:0];
assign a = a_rot^ b;

assign dout= {a_reg, b_reg};
endmodule
