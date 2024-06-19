library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- counter de 7 bits ativo em clock de subida.
entity counter7 is
    port (
        clock : in std_logic;
        reset : in std_logic;
        count : out std_logic_vector(6 downto 0);
        upDown : in std_logic
    );
end counter7;

architecture Behavioral of counter7 is
    signal counterA : unsigned(6 downto 0);
begin
    -- Processo para incrementar o counter
    process(clock, reset)
    begin
        if reset = '1' then
            counterA <= (others => '0'); -- Reinicia o counter
        elsif rising_edge(clock) then
            if upDown = '1' then
                if counterA = 0 then
                    counterA <= (others => '0'); -- Mantém em 0
                else
                    counterA <= counterA - 1; -- Decrementa o counter
                end if;
            else 
                if counterA = 127 then
                    counterA <= (others => '0'); -- Reinicia quando atinge 127
                else
                    counterA <= counterA + 1; -- Incrementa o counter
                end if;
            end if;
        end if;
    end process;

    -- Saída do counter
    count <= std_logic_vector(counterA);
end Behavioral;
