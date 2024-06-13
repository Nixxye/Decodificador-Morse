Library IEEE;
USE IEEE.Std_logic_1164.all;
-- Flip Flopt toggle inicializado em 0 e ativo em borda de subida.
entity ffToggle is 
   port(
      Q : out std_logic;    
      Clk : in std_logic;
      Reset : in std_logic
   );
end ffToggle;
architecture Behavioral of ffToggle is  

signal temp : std_logic := '0';

begin  
 process(Clk)
 begin 
    if(rising_edge(Clk)) then
      if(Reset = '1') then
         Q <= '0';
         temp <= '0';
      else
         temp <= not temp;
         Q <= temp;
      end if;
    end if;       
 end process;  
end Behavioral; 