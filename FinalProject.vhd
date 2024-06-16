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
		ledsOut : out std_logic_vector(9 downto 0) := "0000000000"
	);
	end FinalProject;
  
architecture labArch of FinalProject is
	-- COMPONENTES UTILIZADOS:
	type std_logic_vector_array is array (NATURAL range <>) of std_logic_vector(7 downto 0);

	component Timing_Reference is
	port ( 
		clk: in std_logic;
		clk_2Hz: out std_logic
	);
	end component;

	component Timing_ReferenceSlowed is
	port ( 
		clk: in std_logic;
		clkOut: out std_logic
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
	component BigSIPO is
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
	end component;
	-- Apenas para debugar:
	component seteSegmentos is
		Port (
			V: in std_logic_vector (3 downto 0);
			S: out std_logic_vector (6 downto 0)
		);
	end component;

	component morseDecoder is
	port ( 
		morse: in std_logic_vector (7 downto 0);
		sevenSegment: out std_logic_vector (6 downto 0)
	);
	end component;

	component myMUX is
		port (
			switch: in std_logic;
			pIn0, pIn1: in std_logic_vector (7 downto 0);
			pOut: out std_logic_vector (7 downto 0)
		);
	end component;

	component MUX7 is
		port (
			switch: in std_logic;
			pIn0, pIn1: in std_logic_vector (6 downto 0);
			pOut: out std_logic_vector (6 downto 0)
		);
	end component;
		-- Dah são os longos e dit são os curtos:
		signal clkCont : std_logic;
		signal clkContSlowed : std_logic;
		signal pause : std_logic_vector (7 downto 0);
		signal timeDah : std_logic_vector (7 downto 0);
		signal endLetter : std_logic;
		-- Não há necessidade de ter 7, fiz apenas para não ter que criar outro counter:
		signal sizeLetter : std_logic_vector (7 downto 0);
		signal isDah : std_logic;
		signal sipoIn : std_logic;
		signal state : std_logic := '0';
		signal letterInfo : std_logic_vector (4 downto 0);
		signal ramADD : std_logic_vector (6 downto 0);
		signal ramADD1 : std_logic_vector (6 downto 0);
		signal ramADD2 : std_logic_vector (6 downto 0);
		signal ramOut : std_logic_vector (7 downto 0);
		

		signal sevenLetterSize : std_logic_vector(6 downto 0);
		signal letter : std_logic_vector (6 downto 0);

		signal decoderOut0 : std_logic_vector(6 downto 0);
		signal decoderOut1 : std_logic_vector(6 downto 0);
		signal decoderOut2 : std_logic_vector(6 downto 0);
		signal decoderOut3 : std_logic_vector(6 downto 0);
		signal decoderOut4 : std_logic_vector(6 downto 0);
		signal decoderOut5 : std_logic_vector(6 downto 0);

		signal decoderIn0 : std_logic_vector(7 downto 0);
		signal decoderIn1 : std_logic_vector(7 downto 0);
		signal decoderIn2 : std_logic_vector(7 downto 0);
		signal decoderIn3 : std_logic_vector(7 downto 0);
		signal decoderIn4 : std_logic_vector(7 downto 0);
		signal decoderIn5 : std_logic_vector(7 downto 0);

	begin
		-- Debugging:
		ledsOut(0) <= isDah;
		ledsOut(1) <= endLetter; 
		ledsOut(2) <= state;

		sevenOut5(6 downto 0) <= decoderOut5(6 downto 0) when state ='1' else (others => '0');
		sevenOut4(6 downto 0) <= decoderOut4(6 downto 0) when state ='1' else (others => '0');
		sevenOut3(6 downto 0) <= decoderOut3(6 downto 0) when state ='1' else (others => '0');
		sevenOut2(6 downto 0) <= decoderOut2(6 downto 0) when state ='1' else (others => '0');
		
		muxSeven1 : MUX7 port map (
			switch => state,
			pIn0 => sevenLetterSize,
			pIn1 => decoderOut1,
			pOut => sevenOut1
		);

		muxSeven0 : MUX7 port map (
			switch => state,
			pIn0 => letter,
			pIn1 => decoderOut0,
			pOut => sevenOut0
		);

		toggleEstado : ffToggle port map (
			Q => state,
			Clk => (not pb(1)) or (ramADD1(0) and ramADD1(1) and ramADD1(2) and ramADD1(3) and ramADD1(4) and ramADD1(5) and ramADD1(6)), -- Pressionamento de botão ou RAM lotada:
			Reset => '0'
		);

		time : Timing_Reference port map (
			clk => CLK,
			clk_2Hz => clkCont
		);
		slowTime :  Timing_ReferenceSlowed port map ( 
			clk => CLK,
			clkOut => clkContSlowed
		);
		contpause : counter port map (
			clock => clkCont,
			reset => not pb(0),
			count => pause
		);
		contsizeLetter : counter port map (
			clock => pb(0), --Clock de descida
			reset => endLetter and not state,
			count => sizeLetter
		);
		-- AMBOS OS TOGGLES PRECISAM SER FALLING EDGE PARA QUE QUANDO O BOTÃO SEJA SOLTO O SISTEMA VERIFIQUE EM FALLING EDGE TODAS AS INFORMAÇÕES DO PULSO.
		togglePause : ffToggle port map (
			Q => endLetter,
			Clk => (not endLetter and pause(5)) or (endLetter and not pb(0)), --Verifica pause para o tempo
			Reset => '0'
		);
		contimeDah : counter port map (
			clock => clkCont and not state,
			reset => pb(0),
			count => timeDah
		);
		-- Define se é ponto ou traço de acordo com o tempo de pressionamento
		toggleDah : ffToggle port map (
			Q => isDah, 
			Clk => (not isDah and timeDah(4)) or (isDah and not pb(0)),
			Reset => '0'
		);
		-- Desloca quando o botão é solto:
		sp1: SIPO port map(
			pOut => letterInfo,
			serialIn => isDah,
			clk => pb(0),
			set => '0',
			clear => '0'
		);
		sp2 : BigSIPO port map (
            clk => clkContSlowed,
            reset => '0',
            serial_in => ramOut,
			parallel_out0 => decoderIn0,
			parallel_out1 => decoderIn1,
			parallel_out2 => decoderIn2,
			parallel_out3 => decoderIn3,
			parallel_out4 => decoderIn4,
			parallel_out5 => decoderIn5
		);
		-- Contador para o primeiro estado:
		contRamADD1 : counter7 port map (
			clock => (endLetter) and not state, -- Em descida para ser depois dos outros.
			reset =>'0',
			count => ramADD1 
		);
		contRamADD2 : counter7 port map (
			clock => clkContSlowed and state, -- Em descida para ser depois dos outros.
			reset => (ramADD1(6) xnor ramADD2(6)) and
					 (ramADD1(5) xnor ramADD2(5)) and
					 (ramADD1(4) xnor ramADD2(4)) and
					 (ramADD1(3) xnor ramADD2(3)) and
					 (ramADD1(2) xnor ramADD2(2)) and
					 (ramADD1(1) xnor ramADD2(1)) and
					 (ramADD1(0) xnor ramADD2(0)),
			count => ramADD2 
		);
		ram : Single_port_RAM_VHDL port map(
			RAM_ADDR => ramADD,
			-- ENTRADA RAM : SIPO (5 bits) + sizeLetter (3 bits)
			RAM_DATA_IN => letterInfo & sizeLetter(2 downto 0),
			RAM_WR => not state,
			RAM_CLOCK => (clkCont and endLetter and not clkCont and not state) or (clkContSlowed and state),--endLetter and not clkCont,
			RAM_DATA_OUT => ramOut
		);
		decoder : morseDecoder port map( 
			morse => letterInfo & sizeLetter(2 downto 0),
			sevenSegment => letter
		);
		-- Apenas para debugar:
		seteD : seteSegmentos port map (
			V => sizeLetter (3 downto 0),--ramADD1(3 downto 0),
			S => sevenLetterSize
		);

		ramInput : MUX7 port map (
			switch => state,
			pIn0 => ramADD1,
			pIn1 => ramADD2,
			pOut => ramADD
		);
		-- Decoders para o segundo estado:
		decoder0 : morseDecoder port map( 
			morse => decoderIn0,
			sevenSegment => decoderOut0
		); 
		decoder1 : morseDecoder port map( 
			morse => decoderIn1,
			sevenSegment => decoderOut1
		); 
		decoder2 : morseDecoder port map( 
			morse => decoderIn2,
			sevenSegment => decoderOut2
		); 
		decoder3 : morseDecoder port map( 
			morse => decoderIn3,
			sevenSegment => decoderOut3
		); 
		decoder4 : morseDecoder port map( 
			morse => decoderIn4,
			sevenSegment => decoderOut4
		); 
		decoder5 : morseDecoder port map( 
			morse => decoderIn5,
			sevenSegment => decoderOut5
		); 
		-- myMUX PARA COLOCAR ALGUMA ANIMAÇÃO NOS DISPLAYS:
end labArch;
-- CRIAR UM BOTÃO PARA APAGAR A ÚLTIMA LETRA?
