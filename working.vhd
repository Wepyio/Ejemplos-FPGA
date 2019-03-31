library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador is
Port(
Salida: out	std_logic_vector (0 to 7);
Enable: out std_logic_vector (0 to 2);
clk:	  in  std_logic;
push:	  in  std_logic;
led, led1: out std_logic;
DPSwitch: in std_logic_vector (7 downto 0)
);
end contador;

architecture Behavioral of contador is

signal tiempo: integer range 0 to 1199999;
--signal segundo: integer range 0 to 11999999;
--signal mili: 	 integer range 0 to 119999;	
signal flag: 	std_logic;
--signal unidad:  integer range 0 to 9;
--signal decena:  integer range 0 to 9;
signal numeros:  integer range 0 to 9;
signal elegir: integer range 0 to 255;

begin	

elegir <= to_integer(unsigned(DPSwitch));

	process(clk)
		begin
			if(rising_edge(clk)) then
				if (push = '0' and  flag = '1') then
					flag <= '0';
					numeros<= numeros +1;
				end if;
				
					if(tiempo=1199999) then 
					   tiempo<=0;
						if push = '1' then
						   flag<='1';
					   end if;
					else
						tiempo<=tiempo+1;
						end if;
						
				if numeros >= 5 then
					led <= '1';
				else
					led <= '0';
				end if;
						
				if numeros >= 6 then
					led1 <= '1';
				else
					led1 <= '0';
				end if;
				
		case numeros is
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

		case elegir is
			When 127 => Enable <= "110";
			When 191 => Enable <= "101";
			When 223 => Enable <= "011";
			When others => Enable <= "111";
		end case;
		
			end if;	
			
	end process;
end Behavioral;
