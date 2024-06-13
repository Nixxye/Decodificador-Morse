library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Contador de 8 bits ativo em clock de subida.
entity counter is
    port (
        clock : in std_logic;
        reset : in std_logic;
        count : out std_logic_vector(7 downto 0)
    );
end counter;

architecture Behavioral of counter is
    signal count : unsigned(8 downto 0);
begin
    -- Processo para incrementar o counter
    process(clock, reset)
    begin
        if reset = '1' then
            count <= (others => '0'); -- Reinicia o counter
        elsif rising_edge(clock) then
            if count = 256 then
                count <= (others => '0'); -- Reinicia quando atinge 511
            else
                count <= count + 1; -- Incrementa o counter
            end if;
        end if;
    end process;

    -- Saída do counter
    count <= std_logic_vector(count);
end Behavioral;
