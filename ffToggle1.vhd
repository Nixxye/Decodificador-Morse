library IEEE;
use IEEE.Std_logic_1164.all;
-- Flip Flopt toggle inicializado em 1 e ativo em borda de subida.
entity ffToggle1 is 
   port(
      Q : out std_logic;    
      Clk : in std_logic;
      Reset : in std_logic
   );
end ffToggle1;

architecture Behavioral of ffToggle1 is  
   signal temp : std_logic := '1'; -- Inicializado com '1' em vez de '0'
   signal Q_init : std_logic := '0'; -- Variável para controlar a inicialização de Q
begin  
   process(Clk)
   begin 
      if rising_edge(Clk) then
         if Reset = '1' then
            Q_init <= '1'; -- Marca que a inicialização de Q foi feita
            Q <= '1'; -- Quando Reset é acionado, Q é definido como '1'
            temp <= '1'; -- E temp também é definido como '1'
         elsif Q_init = '0' then
            Q <= '1'; -- Inicializa Q como '1' na primeira borda de subida após o reset
            Q_init <= '1'; -- Marca que a inicialização de Q foi feita
            temp <= '1'; -- Inicializa temp como '1' também
         else
            temp <= not temp;
            Q <= temp;
         end if;
      end if;       
   end process;  
end Behavioral;
