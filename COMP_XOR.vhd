----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/25/2023 09:14:51 PM
-- Design Name: 
-- Module Name: XOR - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity COMP_XOR is
    Generic(
        data_width : integer := 32
    );
    Port ( A : in STD_LOGIC_VECTOR (data_width-1 downto 0);
           B : in STD_LOGIC_VECTOR (data_width-1 downto 0);
           clk : in STD_LOGIC;
           rvalid : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (data_width-1 downto 0);
           wvalid : out STD_LOGIC);
end COMP_XOR;

architecture Behavioral of COMP_XOR is
 
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if(rvalid = '1') then
                wvalid <= '1';
                O <= A XOR B;
            else
                wvalid <= '0';
            end if;
        end if;
    
    end process;


end Behavioral;
