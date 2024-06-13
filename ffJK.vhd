 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ffJk is
   port( J,K: in std_logic;
         PRE: in std_logic;
         CLR: in std_logic;
         CLK: in std_logic;
         Q: out std_logic);
end ffJk;

architecture Behavioral of ffJk is
   signal temp: std_logic := '0';
begin
   process (CLK) 
   begin
      if CLR='1' then   
         temp <= '0';
      elsif PRE='1' then
         temp <= '1';
      elsif rising_edge(CLK) then                 
         if (J='0' and K='0') then
            temp <= temp;
         elsif (J='0' and K='1') then
            temp <= '0';
         elsif (J='1' and K='0') then
            temp <= '1';
         elsif (J='1' and K='1') then
            temp <= not (temp);
         end if;
      end if;
   end process;
   Q <= temp;
end Behavioral;