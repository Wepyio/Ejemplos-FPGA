library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity p21 is
	Port ( 
		dysp : out std_logic_vector (1 downto 0); --Elige un display
		clok, reset, stop : in std_logic; --Reloj, reset y stop del conteo
		salida_a_display : out std_logic_vector (6 downto 0) --Salida a los display
	); 

end p21;

architecture Behavioral of p21 is

signal S: std_logic; -- señal para controlar parar la cuenta
signal clk: std_logic; --señal frecuencia despues del divisor
signal cont: std_logic_vector(7 downto 0);--se utilza para controlar el divisor de frecuencia
signal unidades: std_logic_vector(3 downto 0);--manejo de las unidades
signal decenas: std_logic_vector(3 downto 0);--manejo de las decenas

begin
	process(stop)--proceso que controla el evento de pare
		begin
			if stop'event and stop='1' then
			S <= not S; 
			end if; 	
		end process; 

	process(clok)-- divisor de frecuencia 
	
	begin 
	
	if clok'event and clok = '0' and S = '0' then 
	
		if cont < reset =" '1'" clk =" '0'">
	
		case unidades is
			when "0000" =>
				salida_a_display <= "0000001"; --0 
			When "0001" =>
				salida_a_display <= "1001111"; --1 
			When "0010" =>
				salida_a_display <= "0010010"; --2 
			When "0011" =>
				salida_a_display <= "0000110"; --3 
			When "0100" =>
				salida_a_display <= "1001100"; --4
			When "0101" =>
				salida_a_display <= "0100100"; --5 
			When "0110" =>
				salida_a_display <= "0100000"; --6 
			When "0111" =>
				salida_a_display <= "0001111"; --7 
			When "1000" =>
				salida_a_display <= "0000000"; --8 
			When "1001" =>
				salida_a_display <= "0001100"; --9 
			When others =>
				salida_a_display <= "1111110"; 
			
		end case; 
		
		dysp <= "01";--activa el primer display 
			
		when '1' =>
		
		case decenas is
			when "0000" =>
				salida_a_display <= "0000001"; --0 
			When "0001" =>
				salida_a_display <= "1001111"; --1 
			When "0010" =>
				salida_a_display <= "0010010"; --2 
			When "0011" =>
				salida_a_display <= "0000110"; --3 
			When "0100" =>
				salida_a_display <= "1001100"; --4 
			When "0101" =>
				salida_a_display <= "0100100"; --5 
			When "0110" =>
				salida_a_display <= "0100000"; --6 
			When "0111" =>
				salida_a_display <= "0001111"; --7 
			When "1000" =>
				salida_a_display <= "0000000"; --8 
			When "1001" =>
				salida_a_display <= "0001100"; --9 
			When others =>
				salida_a_display <= "1111110"; 
				
		end case; 
			
		dysp <= "10";--activa el segundo dysplay 
				
		when others =>
			salida_a_display <= "1111111"; 
				
		end case; 
	end process; 
end Behavioral;
