----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/25/2023 09:34:36 PM
-- Design Name: 
-- Module Name: XOR_Array - Behavioral
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

entity XOR_Array is
    Generic(
        num_of_XORs : integer := 4;
        array_width : integer := 32
        
    );
    Port ( clk : in STD_LOGIC;
           rvalid : in STD_LOGIC;
           DATA_A : in STD_LOGIC_VECTOR (array_width-1 downto 0);
           DATA_B : in STD_LOGIC_VECTOR (array_width-1 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (array_width-1 downto 0);
           wvalid : out STD_LOGIC);
end XOR_Array;

architecture Behavioral of XOR_Array is

component COMP_XOR is
    Generic(
        data_width : integer := 32
    );
    Port ( A : in STD_LOGIC_VECTOR (data_width-1 downto 0);
           B : in STD_LOGIC_VECTOR (data_width-1 downto 0);
           clk : in STD_LOGIC;
           rvalid : in STD_LOGIC;
           O : out STD_LOGIC_VECTOR (data_width-1 downto 0);
           wvalid : out STD_LOGIC);
end component;

constant data_width  : integer := array_width / num_of_XORs;

begin
    
    u1: COMP_XOR 
         generic map( data_width => data_width)
         port map   ( A => DATA_A  (data_width-1 downto 0),
                      B => DATA_B  (data_width-1 downto 0),
                      O => DATA_OUT(data_width-1 downto 0),
                      rvalid => rvalid,
                      wvalid => wvalid,
                      clk => clk);
   lbl: FOR i IN 2 TO num_of_XORs GENERATE
      u2: COMP_XOR 
         generic map( data_width => data_width)
         port map   ( A => DATA_A  ((i*data_width)-1 downto ((i-1)*data_width)),
                      B => DATA_B  ((i*data_width)-1 downto ((i-1)*data_width)),
                      O => DATA_OUT((i*data_width)-1 downto ((i-1)*data_width)),
                      rvalid => rvalid,
                      clk => clk);

   END GENERATE ;

end Behavioral;
