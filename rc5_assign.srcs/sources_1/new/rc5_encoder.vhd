----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2021 12:31:21 AM
-- Design Name: 
-- Module Name: rc5_encoder - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rc5_encode is
    Port ( rst : in STD_LOGIC;
              clk : in STD_LOGIC;
              din : in STD_LOGIC_VECTOR (63 downto 0);
              dout : out STD_LOGIC_VECTOR (63 downto 0));
end rc5_encode;

architecture Behavioral of rc5_encode is
signal i_cnt:STD_LOGIC_VECTOR(3 DOWNTO 0);

signal ab_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal a_rot: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal a: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal a_reg: STD_LOGIC_VECTOR(31 DOWNTO 0);

signal ba_xor: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal b_rot: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal b: STD_LOGIC_VECTOR(31 DOWNTO 0);
signal b_reg: STD_LOGIC_VECTOR(31 DOWNTO 0); 


TYPE rom IS ARRAY (0 TO 25) of std_logic_vector(31 DOWNTO 0);
CONSTANT skey:
rom:=rom'(X"00000000",X"00000000",X"46F8E8C5",X"460C6085",
X"70F83B8A",X"284B8303", X"513E1454", X"F621ED22",
X"3125065D",X"11A83A5D",X"D427686B", X"713AD82D",
X"4B792F99", X"2799A4DD", X"A7901C49", X"DEDE871A",
X"36C03196", X"A7EFC249", X"61A78BB8", X"3B0A1D2B",
X"4DBFCA76", X"AE162167", X"30D76B0A", X"43192304",
X"F6CC1431", X"65046380");

begin
-- updating reg a 
process(rst,clk)        
begin
    if(rst ='1') then a_reg <= din(63 downto 32);
    elsif(rising_edge (clk)) then a_reg <= a;
    end if;
end process;

-- updating reg b 
process(rst,clk)        
begin
    if(rst ='1') then b_reg <= din(31 downto 0);
    elsif(rising_edge (clk)) then b_reg <= b;
    end if;
end process;

-- set/increment  up clock count 
process(rst,clk)       
begin 
    if(rst = '1') then i_cnt <= "0001";
    elsif(rising_edge (clk)) then
        if( i_cnt= "1100") then i_cnt <= "0001";
        else  i_cnt <= i_cnt + '1';
        end if; 
    end if;
   end process;
    
    ---- perform A=((A XOR B)<<< B) + S[2*i];
  ab_xor <= a_reg XOR b_reg;
  a_rot <= std_logic_vector( unsigned(ab_xor) rol to_integer(unsigned(b_reg(4 downto 0))));
  a <= a_rot + skey(to_integer(unsigned(i_cnt &'0')));    

  -- perform B=((B XOR A) <<<A)	+ S[2*i+1]
  ba_xor <= b_reg XOR a;
  b_rot <= std_logic_vector(unsigned(ba_xor) rol to_integer(unsigned(a(4 downto 0))));
  b <= b_rot + skey(to_integer(unsigned(i_cnt &'1'))); 
  
dout <= a_reg & b_reg;
end Behavioral;

