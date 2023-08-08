----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/30/2023 12:45:10 PM
-- Design Name: 
-- Module Name: shift - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift is
    generic(
        data_width : integer := 128;
        max_shifts : integer := 8
    );
    Port ( 
           --in
           rvalid    : in STD_LOGIC;
           clk       : in STD_LOGIC;
           data_in   : in STD_LOGIC_VECTOR (data_width-1 downto 0);
           carry_in  : in STD_LOGIC_VECTOR (max_shifts-1 downto 0);
           bits      : in STD_LOGIC_VECTOR (31 downto 0);
           --out
           wvalid    : out STD_LOGIC;
           data_out  : out STD_LOGIC_VECTOR (data_width-1 downto 0);
           carry_out : out STD_LOGIC_VECTOR (max_shifts-1 downto 0));
end shift;



architecture Behavioral of shift is
signal temp: STD_LOGIC_VECTOR (max_shifts+data_width-1 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if(rvalid = '1') then
                wvalid <= '1';
                if (to_integer(unsigned(bits)) = 0) then
                    data_out  <= data_in;
                    carry_out <= (others => '0');
                elsif (to_integer(unsigned(bits)) > max_shifts) then
                    data_out <= carry_in(max_shifts-1 downto 0) & data_in(data_width-1 downto max_shifts);
                    carry_out(max_shifts-1 downto 0) <= data_in(max_shifts-1 downto 0);
                else
                    for i in 1 to max_shifts loop
                        if(i = to_integer(unsigned(bits))) then
                            data_out <= carry_in(i-1 downto 0) & data_in(data_width-1 downto i); 
                            carry_out(i-1 downto 0) <= data_in(i-1 downto 0);
                        end if;
                    end loop;
                end if;
                
            else
                wvalid <= '0';
            end if;
        end if;
    
    end process;
    
    temp <= carry_in & data_in;

end Behavioral;
