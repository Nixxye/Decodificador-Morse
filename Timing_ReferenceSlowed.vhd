library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
-- Fonte: Material fornecido pelo professor. 
entity Timing_ReferenceSlowed is
	port ( clk: in std_logic; -- Pin connected to P11 (N14)
			clkOut: out std_logic);-- Can check it using PIN A8 - LEDR0
end Timing_ReferenceSlowed;
  
architecture freq_div of Timing_ReferenceSlowed is
  
signal count: integer:=1;
signal tmp : std_logic := '0';
  
begin
  
process(clk)
	begin
	if(clk'event and clk='1') then
		count <=count+1;
		if (count = 12000000/4) then
			tmp <= NOT tmp;
			count <= 1;
		end if;
	end if;
	clkOut <= tmp;
end process;
 
end freq_div;