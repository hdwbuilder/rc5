`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2021 12:39:13 AM
// Design Name: 
// Module Name: tb_rc5_encoderv
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


module tb_rc5_encoderv(

    );
    reg dut_rst;
    reg dut_clk;
    wire[63:0] dut_in;
    wire[63:0] dut_out;
   
    
    rc5_encode dut(
    .rst(dut_rst),
    .clk(dut_clk),
    .din(dut_in),
    .dout(dut_out)
     );
    
    integer file_input; 
    reg[63:0] dut_file_in; 
    reg[63:0] dut_file_out;
    assign dut_in = dut_file_in;
    
    initial begin
    forever begin 
 //  10 ns duty cycle    
     dut_clk <= 1;
     #5;
     dut_clk <= 0;
     #5;
    end 
  end
     
   initial begin
   file_input = $fopen("test_cases_enc.txt","r");
    if(file_input == 0) $fatal(" file not found");
    end
        
    initial begin 
    while(!$feof(file_input)) 
 begin
 // read data from text file    
        $fscanf(file_input, "%h %h\n", dut_file_in, dut_file_out);
  // set reset       
        dut_rst <=1;
        #10
 // clear reset        
        dut_rst <=0; 
        #120
 // check for failure        
        if(dut_out != dut_file_out) $fatal("Test case failed %h != %h",dut_out,dut_file_out);          
   end
   $display("Test cases completed sucessfully");
   $finish;
  end   
endmodule









