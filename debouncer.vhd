library ieee;
use ieee.std_logic_1164.all;

entity debouncer is
    port (
        clk : in std_logic;
        button : in std_logic;
        debounced_button : out std_logic
    );
end entity debouncer;

architecture rtl of debouncer is
    component ffD is 
    port(
        Q : out std_logic;    
        Clk :in std_logic;   
        D :in  std_logic;
        Set : in std_logic;
        Reset : in std_logic 
    );
    end component;
    signal Q1, Q2 : std_logic;
begin
    -- Synchronize button input to the clock
    ff1 : ffD port map(Q1, clk, button, '0', '0');
    ff2 : ffD port map(Q2, clk, Q1, '0', '0');
    ff3 : ffD port map(debounced_button, clk, Q2, '0', '0');
end architecture rtl;