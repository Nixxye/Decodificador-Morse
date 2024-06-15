library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- counter de 9 bits ativo em clock de subida.
entity counter is
    port (
        clock : in std_logic;
        reset : in std_logic;
        count : out std_logic_vector(7 downto 0)
    );
end counter;

architecture Behavioral of counter is
    signal counterA : unsigned(7 downto 0);
begin
    -- Processo para incrementar o counter
    process(clock, reset)
    begin
        if reset = '1' then
            counterA <= (others => '0'); -- Reinicia o counter
        elsif falling_edge(clock) then
            if counterA = 255 then
                counterA <= (others => '0'); -- Reinicia quando atinge 511
            else
                counterA <= counterA + 1; -- Incrementa o counter
            end if;
        end if;
    end process;

    -- Saída do counter
    count <= std_logic_vector(counterA);
end Behavioral;
