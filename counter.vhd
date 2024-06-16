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
    -- Processo para incrementar o counter em clock de descida
    process(clock, reset)
    begin
        if reset = '1' then -- Resets the counter
            counterA <= (others => '0');
        elsif rising_edge(clock) then -- Increments the counter
            if counterA = 255 then
                counterA <= (others => '0'); -- Resets when it reaches 255
            else
                counterA <= counterA + 1; -- Increments the counter
            end if;
        end if;
        -- if reset = '1' then
        --     counterA <= (others => '0'); -- Reinicia o counter
        -- end if;
        -- if falling_edge(clock) then
        --     if counterA = 255 then
        --         counterA <= (others => '0'); -- Reinicia quando atinge 511
        --     else
        --         counterA <= counterA + 1; -- Incrementa o counter
        --     end if;
        -- end if;
    end process;

    -- Saída do counter
    count <= std_logic_vector(counterA);
end Behavioral;
