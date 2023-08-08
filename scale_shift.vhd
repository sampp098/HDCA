----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/04/2023 09:42:36 PM
-- Design Name: 
-- Module Name: scale_shift - Behavioral
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

entity scale_shift is
    generic(
        shift_num  : integer := 4;
        data_width : integer := 128;
        max_shifts : integer := 32
    );
    Port ( 
           --in
           rvalid    : in STD_LOGIC;
           clk       : in STD_LOGIC;
           data_in   : in STD_LOGIC_VECTOR (shift_num*data_width-1 downto 0);
           carry_in  : in STD_LOGIC_VECTOR (max_shifts-1 downto 0);
           bits      : in STD_LOGIC_VECTOR (31 downto 0);
           --out
           wvalid    : out STD_LOGIC;
           data_out  : out STD_LOGIC_VECTOR (shift_num*data_width-1 downto 0);
           carry_out : out STD_LOGIC_VECTOR (max_shifts-1 downto 0));
end scale_shift;

architecture Behavioral of scale_shift is

component shift is
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
end component;

begin

    u1: shift 
         generic map( data_width => data_width,
                      max_shifts => max_shifts)
                      
         port map   ( -- in
                      clk      => clk,
                      rvalid   => rvalid,
                      data_in  => data_in(data_width-1 downto 0),
                      carry_in => carry_in,
                      bits     => bits,
                      --out
                      wvalid   => wvalid,
                      data_out => data_out(data_width-1 downto 0)
                      --carry_out=> 
                      );
   lbl: FOR i IN 2 TO shift_num-1 GENERATE
      u2: shift 
         generic map( data_width => data_width,
                      max_shifts => max_shifts)
                      
         port map   ( -- in
                      clk      => clk,
                      rvalid   => rvalid,
                      data_in  => data_in(i*data_width-1 downto (i-1)*data_width),
                      carry_in => data_in(max_shifts+((i-1)*data_width)-1 downto (i-1)*data_width),
                      bits     => bits,
                      --out
                      wvalid   => wvalid,
                      data_out => data_out(i*data_width-1 downto (i-1)*data_width)
                      --carry_out=> carry_out
                      );

   END GENERATE ;
   
   u2: shift 
         generic map( data_width => data_width,
                      max_shifts => max_shifts)
                      
         port map   ( -- in
                      clk      => clk,
                      rvalid   => rvalid,
                      data_in  => data_in(shift_num*data_width-1 downto (shift_num-1)*data_width),
                      carry_in => data_in(max_shifts+((shift_num-1)*data_width)-1 downto (shift_num-1)*data_width),
                      bits     => bits,
                      --out
                      wvalid   => wvalid,
                      data_out => data_out(shift_num*data_width-1 downto (shift_num-1)*data_width),
                      carry_out=> carry_out
                      );
    
    
end Behavioral;
