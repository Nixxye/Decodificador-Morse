-- SIPO 5 bits
Library IEEE;
USE IEEE.Std_logic_1164.all;

entity SIPO is 
   port(
        pOut : std_logic_vector (4 downto 0);
        serialIn : std_logic;
        clk : std_logic;
        set : std_logic;
        clear : std_logic
   );
end SIPO;
architecture Behavioral of SIPO is  
    component ffD is 
    port(
        Q : out std_logic;    
        Clk :in std_logic;   
        D :in  std_logic;
        Set : in std_logic;
        Reset : in std_logic 
    );
    end component;
    -- Conecta os flip flops:
    signal ffOut : std_logic_vector (3 downto 0)
begin  
    -- Mais significativos nos primeiros flip flops: 
    pOut(4) => ffOut(0);
    pOut(3) => ffOut(1);
    pOut(2) => ffOut(2);
    pOut(1) => ffOut(3);
    
    ff0 : ffD port map(
        Q => ffOut(0),  
        Clk => clk,  
        D => serialIn,
        Set => set,
        Reset => clear
    );
    ff1 : ffD port map(
        Q => ffOut(1),  
        Clk => clk,  
        D => ffOut(0),
        Set => set,
        Reset => clear
    );
    ff2 : ffD port map(
        Q => ffOut(2),  
        Clk => clk,  
        D => ffOut(1),
        Set => set,
        Reset => clear
    );   
    ff3 : ffD port map(
        Q => ffOut(3),  
        Clk => clk,  
        D => ffOut(2),
        Set => set,
        Reset => clear
    );
    ff4 : ffD port map(
        Q => pOut(0),  
        Clk => clk,  
        D => ffOut(3),
        Set => set,
        Reset => clear
    );
end Behavioral; 