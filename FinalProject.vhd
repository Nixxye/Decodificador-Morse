library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity FinalProject is
	port (
		CLK: in std_logic; -- Pin connected to P11 (N14)
		pb : in std_logic_vector (1 downto 0);
		-- Saídas sete segmentos:
		sevenOut0 : out std_logic_vector (6 downto 0) := "0000000";
		sevenOut1 : out std_logic_vector (6 downto 0) := "0000000";
		sevenOut2 : out std_logic_vector (6 downto 0) := "0000000";
		sevenOut3 : out std_logic_vector (6 downto 0) := "0000000";
		sevenOut4 : out std_logic_vector (6 downto 0) := "0000000";
		sevenOut5 : out std_logic_vector (6 downto 0) := "0000000";
		-- Saída leds para PISO e memória, led7 indica a memória ativa (desligado é a romProfessor):
		ledsOut : out std_logic_vector(7 downto 0) := "00000000"
	);
	end FinalProject;
  
architecture labArch of FinalProject is
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

	component counter is
	port (
		clock : in std_logic;
		reset : in std_logic;
		count : out std_logic_vector(7 downto 0)
	);
	end component;

	component counter7 is
		port (
			clock : in std_logic;
			reset : in std_logic;
			count : out std_logic_vector(6 downto 0)
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

	component Single_port_RAM_VHDL is
	port(
		RAM_ADDR: in std_logic_vector(6 downto 0); -- Address to write/read RAM
		RAM_DATA_IN: in std_logic_vector(7 downto 0); -- Data to write into RAM
		RAM_WR: in std_logic; -- Write enable 
		RAM_CLOCK: in std_logic; -- clock input for RAM
		RAM_DATA_OUT: out std_logic_vector(7 downto 0) -- Data output of RAM
	);
	end component;

	component SIPO is 
	port(
        pOut : out std_logic_vector (4 downto 0);
        serialIn : in std_logic;
        clk : in std_logic;
        set : in std_logic;
        clear : in std_logic
	);
 	end component;

	component morseDecoder is
	port ( 
		morse: in std_logic_vector (7 downto 0);
		sevenSegment: out std_logic_vector (6 downto 0)
	);
	end component;
	 -- Dah são os longos e dit são os curtos:
	 signal clkCont : std_logic;
	 signal pause : std_logic_vector (7 downto 0);
	 signal timeDah : std_logic_vector (7 downto 0);
	 signal endLetter : std_logic;
	 -- Não há necessidade de ter 7, fiz apenas para não ter que criar outro counter:
	 signal sizeLetter : std_logic_vector (7 downto 0);
	 signal isDah : std_logic;
	 signal sipoIn : std_logic;
	 signal state : std_logic;
	 signal letterInfo : std_logic_vector (4 downto 0);
	 signal ramADD : std_logic_vector (6 downto 0);
	 signal ramOut : std_logic_vector (7 downto 0);

	begin
		-- Debugging:
		ledsOut(0) <= isDah;
		ledsOut(1) <= endLetter; 

		toggleEstado : ffToggle port map (
			Q => state,
			Clk => (not pb(1)) or (ramADD(0) and ramADD(1) and ramADD(2) and ramADD(3) and ramADD(4) and ramADD(5) and ramADD(6)), -- Pressionamento de botão ou RAM lotada:
			Reset => '0'
		);

		tempo : Timing_Reference port map (
			clk => CLK,
			clk_2Hz => clkCont
		);
		contpause : counter port map (
			clock => clkCont,
			reset => not pb(0),
			count => pause
		);
		contsizeLetter : counter port map (
			clock => not pb(0),
			reset => endLetter,
			count => sizeLetter
		);
		-- AMBOS OS TOGGLES PRECISAM SER FALLING EDGE PARA QUE QUANDO O BOTÃO SEJA SOLTO O SISTEMA VERIFIQUE EM FALLING EDGE TODAS AS INFORMAÇÕES DO PULSO.
		togglePause : ffToggle port map (
			Q => endLetter,
			Clk => (not endLetter and pause(5)) or (endLetter and not pb(0)), --Verifica pause para o tempo
			Reset => '0'
		);
		contimeDah : counter port map (
			clock => clkCont,
			reset => pb(0),
			count => timeDah
		);
		-- Define se é ponto ou traço de acordo com o tempo de pressionamento
		toggleDah : ffToggle port map (
			Q => isDah, 
			Clk => (not isDah and timeDah(4)) or (isDah and not pb(0)),
			Reset => '0'
		);
		ditOrDah : ffD port map (
			Q => sipoIn,    
			Clk => pb(0),   
			D => isDah,
			Set => '0',
			Reset => '0'
		);
		-- Desloca quando o botão é solto:
		sp: SIPO port map(
			pOut => letterInfo,
			serialIn => isDah,
			clk => pb(0),
			set => '0',
			clear => '0'
		);
		contRamADD : counter7 port map (
			clock => endLetter and not clkCont, -- Em descida para ser depois dos outros.
			reset =>'0',
			count => ramADD 
		);
		ram : Single_port_RAM_VHDL port map(
			RAM_ADDR => ramADD,
			-- ENTRADA RAM : SIPO (5 bits) + sizeLetter (3 bits)
			RAM_DATA_IN => letterInfo & sizeLetter(2 downto 0),
			RAM_WR => not state,
			RAM_CLOCK => endLetter and not clkCont,
			RAM_DATA_OUT => ramOut
		);
		decoder : morseDecoder port map( 
			morse => letterInfo & sizeLetter(2 downto 0),
			sevenSegment => sevenOut0
		);
		-- MUX para alternar a entrada da RAM
		-- MUX PARA COLOCAR ALGUMA ANIMAÇÃO NOS DISPLAYS:
end labArch;