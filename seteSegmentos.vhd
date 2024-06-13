Library IEEE;
Use IEEE.std_logic_1164.all;
Use IEEE.numeric_std.all;

-- Declaração da entidade
entity seteSegmentos is
    Port (
        V: in std_logic_vector (3 downto 0);
        S: out std_logic_vector (6 downto 0)
    );
end seteSegmentos;

-- Arquitetura do componente
architecture Behavioral of seteSegmentos is
begin
    -- Processo que realiza S(0) adição
    process(V(0), V(1), V(2), V(3))
    begin
        S(0) <= (not (V(3) or V(1)) and (V(2) xor V(0))) or (V(3) and V(0) and (V(2) xor V(1)));
        S(1) <= (not (V(3) or V(1)) and V(2) and V(0)) or (not V(0) and V(2) and (V(1) or V(3))) or (V(3) and V(1) and V(0));
        S(2) <= (not (V(3) or V(2)) and V(1) and not V(0)) or (V(3) and V(2) and (V(1) or not V(0)));
        S(3) <= (not (V(3) or V(1)) and (V(2) xor V(0))) or (V(2) and V(1) and V(0)) or (V(3) and not V(2) and V(1) and not V(0));
        S(4) <= (not V(1) and ((not V(3) and V(2)) or (not V(2) and V(0)))) or (not V(3) and V(0));
        S(5) <= (V(3) and V(2) and not V(1) and V(0)) or (not (V(3) or V(2)) and (V(0) or V(1))) or (not V(3) and V(1) and V(0));
        S(6) <= (not (V(3) or V(2)) and not V(1)) or (not V(3) and V(2) and V(1) and V(0)) or (V(3) and V(2) and not (V(1) or V(0)));
    end process;
end Behavioral;