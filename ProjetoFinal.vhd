library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity ProjetoFinal is
	port (
		CLK: in std_logic; -- Pin connected to P11 (N14)
		pb : in std_logic_vector (1 downto 0);
		-- Saídas sete segmentos:
		saidaSete0 : out std_logic_vector (6 downto 0) := "0000000";
		saidaSete1 : out std_logic_vector (6 downto 0) := "0000000";
		saidaSete2 : out std_logic_vector (6 downto 0) := "0000000";
		saidaSete3 : out std_logic_vector (6 downto 0) := "0000000";
		saidaSete4 : out std_logic_vector (6 downto 0) := "0000000";
		saidaSete5 : out std_logic_vector (6 downto 0) := "0000000";
		-- Saída leds para PISO e memória, led7 indica a memória ativa (desligado é a romProfessor):
		ledsOut : out std_logic_vector(7 downto 0) := "00000000"
	);
	end ProjetoFinal;
  
architecture labArch of ProjetoFinal is
	-- COMPONENTES UTILIZADOS:
	component seteSegmentos is 
    port (
        V: in std_logic_vector (3 downto 0);
        S: out std_logic_vector (6 downto 0)
    );
	end component;

	component Timing_Reference is
	port ( 
		clk: in std_logic;
		clk_2Hz: out std_logic
	);
	end component;

	component contador is
	port (
		clock : in std_logic;
		reset : in std_logic;
		count : out std_logic_vector(7 downto 0)
	);
	end component;

	component ffToggle is 
	port(
		Q : out std_logic;    
		Clk : in std_logic;
		Reset : in std_logic
	);
	end component;

	component ffD is 
	port(
		Q : out std_logic;    
		Clk :in std_logic;   
		D :in  std_logic;
		Set : in std_logic;
		Reset : in std_logic 
	);
	end component;

	signal clkCont : std_logic;
	signal tPausa : std_logic_vector (7 downto 0);
	signal tTraco : std_logic_vector (7 downto 0);
	signal letraFinalizada : std_logic;
	-- Não há necessidade de ter 7, fiz apenas para não ter que criar outro contador:
	signal tamanhoLetra : std_logic_vector (7 downto 0);
	signal ehTraco : std_logic;
	signal sipoIn : std_logic;

	begin
		-- Debugging:
		ledsOut(0) => ehTraco;
		ledsOut(1) => letraFinalizada; 

		tempo : Timing_Reference port map (
			clk => CLK,
			clk_2Hz => clkCont
		);
		contPausa : contador port map (
			clock => clkCont,
			reset => pb(0),
			count => tPausa
		);
		contTamanhoLetra : contador port map (
			clock => not pb(0),
			reset => letraFinalizada,
			count => tamanhoLetra
		);
		-- AMBOS OS TOGGLES PRECISAM SER FALLING EDGE PARA QUE QUANDO O BOTÃO SEJA SOLTO O SISTEMA VERIFIQUE EM FALLING EDGE TODAS AS INFORMAÇÕES DO PULSO.
		togglePausa : ffToggle port map (
			Q => letraFinalizada,
			Clk => (not letraFinalizada and tPausa(6)) or (letraFinalizada and pb(0)), --Verifica tPausa para o tempo
			Reset => '0'
		);
		contTraco : contador port map (
			clock => clkCont,
			reset => not pb(0),
			count => tTraco
		);
		-- Define se é ponto ou traço de acordo com o tempo de pressionamento
		toggleTraco : ffToggle port map (
			Q => ehTraco, 
			Clk => (not ehTraco and tTraco(4)) or (ehTraco and not pb(0)),
			Reset => '0'
		);

		passaPontoTraco : ffD port map (
			Q => sipoIn,    
			Clk => pb(0),   
			D => ehTraco,
			Set => '0',
			Reset => '0'
		)
		-- SIPO
		-- ENTRADA RAM : SIPO (5 bits) + tamanhoLetra (3 bits)
end labArch;