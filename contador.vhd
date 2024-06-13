library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Contador de 8 bits ativo em clock de subida.
entity contador is
    port (
        clock : in std_logic;
        reset : in std_logic;
        count : out std_logic_vector(7 downto 0)
    );
end contador;

architecture Behavioral of contador is
    signal counter : unsigned(8 downto 0);
begin
    -- Processo para incrementar o contador
    process(clock, reset)
    begin
        if reset = '1' then
            counter <= (others => '0'); -- Reinicia o contador
        elsif rising_edge(clock) then
            if counter = 256 then
                counter <= (others => '0'); -- Reinicia quando atinge 511
            else
                counter <= counter + 1; -- Incrementa o contador
            end if;
        end if;
    end process;

    -- Saída do contador
    count <= std_logic_vector(counter);
end Behavioral;
