Library IEEE;
USE IEEE.Std_logic_1164.all;

entity ffD is 
   port(
      Q : out std_logic;    
      Clk :in std_logic;   
      D :in  std_logic;
      Set : in std_logic;
      Reset : in std_logic 
   );
end ffD;
architecture Behavioral of ffD is  
begin  
 process(Clk)
 begin 
    if(rising_edge(Clk)) then
        if (Reset = '1') then
            Q <= '0';
        elsif (Set = '1') then
            Q <= '1';
        else
            Q <= D; 
        end if;
    end if;       
 end process;  
end Behavioral; 