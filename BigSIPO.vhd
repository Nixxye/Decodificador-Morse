library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity BigSIPO is
    port (
        clk         : in  std_logic;                -- Sinal de clock
        reset       : in  std_logic;                -- Sinal de reset assíncrono
        serial_in   : in  std_logic_vector(7 downto 0);                -- Dado serial de entrada
        parallel_out0 : out std_logic_vector(7 downto 0);  -- Saída paralela
        parallel_out1 : out std_logic_vector(7 downto 0);
        parallel_out2 : out std_logic_vector(7 downto 0);
        parallel_out3 : out std_logic_vector(7 downto 0);
        parallel_out4 : out std_logic_vector(7 downto 0);
        parallel_out5 : out std_logic_vector(7 downto 0)
        );
    end BigSIPO;
        
architecture Behavioral of BigSIPO is
    signal shift_register0 : std_logic_vector(7 downto 0);
    signal shift_register1 : std_logic_vector(7 downto 0);
    signal shift_register2 : std_logic_vector(7 downto 0);
    signal shift_register3 : std_logic_vector(7 downto 0);
    signal shift_register4 : std_logic_vector(7 downto 0);
    signal shift_register5 : std_logic_vector(7 downto 0);

begin
    parallel_out5 <= shift_register5; 
    parallel_out4 <= shift_register4;
    parallel_out3 <= shift_register3;
    parallel_out2 <= shift_register2;
    parallel_out1 <= shift_register1;
    parallel_out0 <= shift_register0;
    process (clk, reset)
    begin
        if reset = '1' then
            shift_register5 <= (others => '0');  -- Resetando o registrador
            shift_register4 <= (others => '0');
            shift_register3 <= (others => '0');
            shift_register2 <= (others => '0');
            shift_register1 <= (others => '0');
            shift_register0 <= (others => '0');
        elsif rising_edge(clk) then
            -- Deslocamento do registrador serial
            shift_register5 <= shift_register4;
            shift_register4 <= shift_register3;
            shift_register3 <= shift_register2;
            shift_register2 <= shift_register1;
            shift_register1 <= shift_register0;
            shift_register0 <= serial_in;
        end if;
    end process;

end Behavioral;
