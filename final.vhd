library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
Port(
	Salida: out	std_logic_vector (0 to 7);----Vector de segmentos
	Enable: out std_logic_vector (0 to 2);----Vector de display
	clk:	  in  std_logic;
	push, push1, push2, push3:	  in  std_logic;----pulsadores para ascenso
	push4, push5:	  in  std_logic;----pulsadores para contador general
	led, led1, led2, led3: out std_logic;----indicadores de salas llenas
	DPSwitch: in std_logic_vector (7 downto 0)----selección de contador
);
end contador;

architecture Behavioral of contador is

signal tiempo: integer range 0 to 1199999;
--signal segundo: integer range 0 to 11999999;
signal mili: 	 integer range 0 to 239999;	
signal flag, flag1, flag2, flag3, flag4: 	std_logic;
signal unidad:  integer range 0 to 9;---
signal decena:  integer range 0 to 9;---Para el contador general
signal numero :  integer range 0 to 9;---Variable para case
signal numeros :  integer range 0 to 9;---Variable para case 2
signal numeros0, numeros1, numeros2, numeros3:  integer range 0 to 9;---Salidas de contadores
signal elegir: integer range 0 to 255;----Elige contador
signal digito: integer range 0 to 7;

begin	

elegir <= to_integer(unsigned(DPSwitch));---Conversion a entero de los DIP switch

	process(clk)
		begin
			if(rising_edge(clk)) then
			
				if flag4 = '1' then---Contador de sala de espera 30
					if push4 = '0' then---ascenso
						flag4 <= '0';				
						if unidad = 9 then 	
							unidad <= 0;
							if decena = 3 then
								decena <= 0;
							else
								decena<=decena + 1;
							end if;	
						else
							unidad <= unidad + 1;	
						end if;		
					end if;
					
					if push5 = '0' then---descenso
						flag4 <= '0';				
						if unidad = 0 then 	
							unidad <= 9;
								if decena = 0 then
									decena <= 3;
								else
									decena <= decena - 1;
								end if;	
						else
							unidad <= unidad - 1;	
						end if;	
					end if;
				end if;
					
--				if (push4 = '0' and  flag = '1') then
--					flag <= '0';				
--					if unidad = 9 then 	
--						unidad <= 0;
--						if decena = 3 then
--							decena <= 0;
--						else
--							decena<=decena+1;
--						end if;	
--					else
--						unidad<= unidad+1;	
--					end if;		
--				end if;
-------------------------------------------------------------------------------------
--				if (push5 = '0' and  flag2 = '1') then
--					flag2 <= '0';				
--						if unidad = 0 then 	
--							unidad <= 9;
--								if decena = 0 then
--									decena <= 3;
--								else
--									decena<=decena-1;
--								end if;	
--						else
--							unidad<= unidad-1;	
--						end if;		
--				end if;
				
				if flag = '1' then----CONTADOR NO. 1
					if push = '0' then---ASCENSO
						flag <= '0';
						if numeros0 = 9 then
							numeros0 <= 0;
						else
							numeros0 <= numeros0 + 1;
						end if;
					end if;
--					if push4 = '0' then---DESCENSO
--						flag <= '0';
--						numeros0 <= numeros0 - 1;
--					end if;
				end if;
								
				if flag1 = '1' then----CONTADOR NO. 2
					if push1 = '0' then
						flag1 <= '0';
						if numeros1 = 9 then
							numeros1 <= 0;
						else
							numeros1 <= numeros1 + 1;
						end if;
					end if;
--					if push5 = '0' then
--						flag1 <= '0';
--						numeros1 <= numeros1 - 1;
--					end if;
				end if;
				
			if (push2 = '0' and  flag2 = '1') then----CONTADOR NO. 3
				flag2 <= '0';
				if numeros2 = 9 then
					numeros2 <= 0;
				else
					numeros2 <= numeros2 + 1;
				end if;
			end if;
						
			if (push3 = '0' and  flag3 = '1') then----CONTADOR NO. 4
				flag3 <= '0';
				if numeros3 = 9 then
					numeros3 <= 0;
				else
					numeros3 <= numeros3 + 1;
				end if;
			end if;
		
---Reset de banderas

					if(tiempo = 1199999) then 
					   tiempo <= 0;
						if (push = '1') then
						   flag <= '1';
						end if;
						if (push1 = '1') then
							flag1 <= '1';
						end if;
						if (push2 = '1') then
							flag2 <= '1';
						end if;
						if (push3 = '1') then
							flag3 <= '1';
						end if;
						if (push4 = '1' and push5 = '1') then
							flag4 <= '1';
					   end if;
					else
						tiempo <= tiempo + 1;
					end if;
						
---Señales de espacio en salas
									
				if numeros >= 5 then---Led
					led <= '1';
				else
					led <= '0';
				end if;
						
				if numeros >= 6 then---Buzzer
					led1 <= '1';
				else
					led1 <= '0';
				end if;
				
				if decena >= 3 then---Led
					led2 <= '1';
				else
					led2 <= '0';
				end if;
						
				if (decena >= 3 and unidad >= 1) then---Buzzer
					led3 <= '1';
				else
					led3 <= '0';
				end if;
---Muestreo de display
	
		if mili = 0 then
			Enable <= "110";
			digito <= 6;
		elsif mili = 79999 then
			Enable <= "101";
			digito <= 5;
		elsif mili = 159999 then
			Enable <= "011";
			digito <= 3;
		end if;
		
---Reinicio de la variable mili

		if mili = 239999 then
			mili <= 0;
		else
			mili <= mili + 1;
		end if;
		
		case elegir is---Case de selección de contador
			When 127 => numeros <= numeros0;
			When 191 => numeros <= numeros1;
			When 223 => numeros <= numeros2;
			When 239 => numeros <= numeros3;
			When others => numeros <= 0;
		end case;
		
		case digito is---Case de selección de digito
			When 6 => numero <= unidad;
			When 5 => numero <= decena;
			When 3 => numero <= numeros;
			When others => numeros <= 0;
		end case;
		
		case numero is---Case de selección de número
			When 0 => salida <= "11000000";
			When 1 => salida <= "11111001";
			When 2 => salida <= "10100100";
			When 3 => salida <= "10110000";
			When 4 => salida <= "10011001";
			When 5 => salida <= "10010010";
			When 6 => salida <= "10000010";
			When 7 => salida <= "11111000";
			When 8 => salida <= "10000000";
			When 9 => salida <= "10011000";
			When others => salida <="11111111";
		end case;

			end if;	
			
	end process;
end Behavioral;
