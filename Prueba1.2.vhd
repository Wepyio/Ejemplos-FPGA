library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
Port(
	Salida: out	std_logic_vector (0 to 7);
	Enable: out std_logic_vector (0 to 2);
	clk:	  in  std_logic;
	push, push1, push2, push3:	  in  std_logic;----pulsadores para ascenso
	push4, push5:	  in  std_logic;----pulsadores para descenso
	led, led1: out std_logic;
	DPSwitch: in std_logic_vector (7 downto 0)
);
end contador;

architecture Behavioral of contador is

signal tiempo: integer range 0 to 1199999;
--signal segundo: integer range 0 to 11999999;
--signal mili: 	 integer range 0 to 119999;	
signal flag, flag1, flag2, flag3: 	std_logic;
--signal unidad:  integer range 0 to 9;
--signal decena:  integer range 0 to 9;
signal numeros :  integer range 0 to 9;---Variable para case
signal numeros0, numeros1, numeros2, numeros3:  integer range 0 to 9;---Salidas de contadores
signal elegir: integer range 0 to 255;

begin	

elegir <= to_integer(unsigned(DPSwitch));
Enable <= "110";

	process(clk)
		begin
			if(rising_edge(clk)) then
				if (flag = '1') then----CONTADOR NO. 2
					if push = '0' then---ASCENSO
						flag <= '0';
						numeros0 <= numeros0 + 1;
					end if;
					if push4 = '0' then---DESCENSO
						flag <= '0';
						numeros0 <= numeros0 - 1;
					end if;
				end if;
				
					if(tiempo = 1199999) then 
					   tiempo <= 0;
						if (push = '1' and push4 = '1') then
						   flag <= '1';
					   end if;
					else
						tiempo <= tiempo+1;
						end if;
				
		if flag1 = '1' then----CONTADOR NO. 2
			if push1 = '0' then
				flag1 <= '0';
				numeros1 <= numeros1 + 1;
			end if;
			if push5 = '0' then
				flag1 <= '0';
				numeros1 <= numeros1 - 1;
			end if;
		end if;
				
					if(tiempo = 1199999) then 
					   tiempo <= 0;
						if (push1 = '1' and push5 = '1') then
						   flag1 <= '1';
						else
							tiempo <= tiempo + 1;
					   end if;
					end if;
				
		if (push2 = '0' and  flag2 = '1') then----CONTADOR NO. 3
					flag2 <= '0';
					numeros2 <= numeros2 + 1;
		end if;
				
					if(tiempo = 1199999) then 
					   tiempo <= 0;
						if push2 = '1' then
						   flag2 <= '1';
						else
							tiempo <= tiempo + 1;
					   end if;
					end if;
					
		if (push3 = '0' and  flag3 = '1') then----CONTADOR NO. 4
					flag3 <= '0';
					numeros3 <= numeros3 + 1;
		end if;
				
					if(tiempo = 1199999) then 
					   tiempo <= 0;
						if push3 = '1' then
						   flag3 <= '1';
						else
							tiempo <= tiempo + 1;
					   end if;
					end if;
					
				if numeros >= 5 then---Señales de espacio
					led <= '1';
				else
					led <= '0';
				end if;
						
				if numeros >= 6 then
					led1 <= '1';
				else
					led1 <= '0';
				end if;
				
		case elegir is---Case de selección de contador
			When 127 => numeros <= numeros0;
			When 191 => numeros <= numeros1;
			When 223 => numeros <= numeros2;
			When 239 => numeros <= numeros3;
			When others => numeros <= 0;
		end case;
		
		case numeros is---Case de selección de número
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
