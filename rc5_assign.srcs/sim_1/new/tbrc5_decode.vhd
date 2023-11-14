----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/15/2021 04:34:58 AM
-- Design Name: 
-- Module Name: tbrc5_decode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.TEXTIO.ALL;
use IEEE.std_logic_textio.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tbrc5_decode is
--  Port ( );
end tbrc5_decode;

architecture Behavioral of tbrc5_decode is
    file dut_file: TEXT;
    signal dut_rst: std_logic;
    signal dut_clk: std_logic;
    signal dut_in: std_logic_vector (63 downto 0);
    signal dut_out: std_logic_vector (63 downto 0);
    
    component rc5_decode 
        port (
            rst: in std_logic;
            clk: in std_logic;
            din: in std_logic_vector (63 downto 0);
            dout: out std_logic_vector (63 downto 0));
    end component;
begin 
DUT: entity work.rc5_decode port map( rst=> dut_rst,  clk=> dut_clk, din=>dut_in ,dout=>dut_out);
    
    process begin 
        dut_clk <= '1';
        wait for 5ns;
        dut_clk <= '0';
        wait for 5ns;
    end process;
    
    process
        variable dut_line: LINE;
        variable dut_file_in: std_logic_vector(63 downto 0);
        variable dut_file_out: std_logic_vector(63 downto 0);
        variable dut_blank: character; 
    
    begin
        file_open (dut_file, "test_cases_enc.txt", READ_MODE);
        
        while (not(endfile(dut_file))) loop
            dut_rst <= '1';     
            readline(dut_file, dut_line);   
            hread(dut_line, dut_file_out);
            read(dut_line, dut_blank);
            hread(dut_line, dut_file_in);          
            dut_in <= dut_file_in;
            wait for 10ns;
            dut_rst<='0';
            wait for 120ns;
            assert (dut_out = dut_file_out) report "Test Case failed" severity FAILURE;
        end loop;
        
        report "Test cases completed sucessfully";
        std.env.stop;
    end process;
end Behavioral;





