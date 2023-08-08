----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/05/2023 08:34:29 PM
-- Design Name: 
-- Module Name: popc - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity popc is
    Generic(
        popc_count   : integer := 4;
        input_depth  : integer := 4;
        output_depth : integer := 3
        
    );
    Port ( clk : in STD_LOGIC;
           rvalid : in STD_LOGIC;
           DATA_IN  : in  STD_LOGIC_VECTOR (popc_count*input_depth-1 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (popc_count*output_depth-1 downto 0);
           wvalid : out STD_LOGIC);
end popc;

architecture Behavioral of popc is

function sumb (input_depth, num: integer) return integer is
    variable sum: integer :=0;
    constant number: std_logic_vector(input_depth-1 downto 0) := std_logic_vector(to_unsigned(num,input_depth));
begin
    sum := 0;
    for i in 0 to input_depth-1 loop
        sum := sum + to_integer(unsigned(number(i downto i)));
    end loop;
    return sum;
end;
type RAM_ARRAY is array (2**input_depth-1 downto 0) of std_logic_vector (output_depth-1 downto 0);

function initMem (input_depth, output_depth : integer) return RAM_ARRAY is            
	 	variable depth  : integer := input_depth;
	 	variable output: RAM_ARRAY;                                                
	 begin                                                                   
	 	 for i in 0 to 2**input_depth-1 loop  -- Works for up to 32 bit integers
	           output(i) := std_logic_vector(to_unsigned(sumb( input_depth, i),output_depth));                          
	     end loop;                                                             
	   return(output);                                      
	 end;                                                                    



signal mem: RAM_ARRAY := initMem(input_depth, output_depth);

begin

    process(clk)
    variable index: integer;
    begin
        if rising_edge (clk) then
            if(rvalid = '1') then
                for i in 1 to popc_count loop
                    index := to_integer(unsigned(DATA_IN(i*input_depth-1 downto (i-1)*input_depth)));
                    DATA_OUT(i*output_depth-1 downto (i-1)*output_depth) <= mem(index);
                end loop;
                wvalid <= '1';
            else
                wvalid <= '0';
            end if;
            
        
        end if;
    end process;
    
end Behavioral;
