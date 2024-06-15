library ieee;
use ieee.std_logic_1164.all;
-- Multiplex com pIn0 ativo em switch = 0.
entity MUX7 is
    port (
        switch: in std_logic;
        pIn0, pIn1: in std_logic_vector (6 downto 0);
        pOut: out std_logic_vector (6 downto 0)
    );
end MUX7;

architecture MUX_arch of MUX7 is
begin
    pOut(0) <= (pIn0(0) and not switch) or (pIn1(0) and switch);
    pOut(1) <= (pIn0(1) and not switch) or (pIn1(1) and switch);
    pOut(2) <= (pIn0(2) and not switch) or (pIn1(2) and switch);
    pOut(3) <= (pIn0(3) and not switch) or (pIn1(3) and switch);
    pOut(4) <= (pIn0(4) and not switch) or (pIn1(4) and switch);
    pOut(5) <= (pIn0(5) and not switch) or (pIn1(5) and switch);
    pOut(6) <= (pIn0(6) and not switch) or (pIn1(6) and switch);
end MUX_arch;


