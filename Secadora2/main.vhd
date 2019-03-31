library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is

Generic(
	minuto: natural := 720000000;
	segundo: natural := 12000000;
	periodo: natural := 4095;
	soggy: natural := 300;
	wet: natural := 240;
	damp: natural := 180
);

Port(
	Clk: in std_logic;
	led1: out std_logic;
	rotar: out std_logic; 
	fan: out std_logic;
	salida: out std_logic_vector(0 to 7);
	Enable: out std_logic_vector(2 downto 0);
	calor: out std_logic;
	push1: in std_logic;
	stop: in std_logic
);

end main;

architecture Behavioral of main is

signal flag, pausa, parar: std_logic;
signal ciclo1, ciclo2, ciclo3: std_logic;
signal cont1, cont2, cont3, cont: natural range 0 to periodo;
signal numeros, unidad, decena, centena: natural range 0 to 9;
signal continuo: natural range 0 to segundo;
signal tiempo: natural range 0 to soggy;

begin

	process(clk)
	
		begin
			if(rising_edge(clk))then
				if (push1 = '1' and flag = '1')then
					flag <= '0';
					led1 <= '1';
					ciclo1 <= '1';
					tiempo <= 9;
					parar <= '0';
				end if;
				
				if push1 = '0' then
					flag <= '1';
				end if;
				
				if stop = '0' then
					parar <= '1';
					led1 <= '0';
				end if;
								
				--contador continuo
				if (tiempo > 0 and parar = '0') then
					if continuo < segundo then
						continuo <= continuo + 1;
					else
						continuo <= 1;
					end if;
				else
					continuo <= 0;
				end if;
				
				--conteo descendente y revision de puerta abierta
				if (pausa = '0' and ciclo1 = '1') then
					if (tiempo > 0 and continuo = segundo)then
						tiempo <= tiempo - 1;
					else
						rotar <= '0';
						fan <= '0';
						calor <= '0';
					end if;
				end if;

				if (pausa = '0' and ciclo2 = '1') then
					if tiempo > 0 then
						tiempo <= tiempo - 1;
					else
						rotar <= '0';
						fan <= '0';
						calor <= '0';
					end if;
				end if;

				if (pausa = '0' and ciclo3 = '1') then
					if tiempo > 0 then
						tiempo <= tiempo - 1;
					else
						rotar <= '0';
						fan <= '0';
						calor <= '0';
					end if;
				end if;
				
				numeros <= tiempo;
				
				case continuo is
					when 0 => Enable <= "111";
					when 1 => Enable <= "011";
					when 4000000 => Enable <= "101";
					when 8000000 => Enable <= "110";
					when others => null;
				end case;
				
				case numeros is
					when 0 => salida <= "11000000";
					when 1 => salida <= "11111001";
					when 2 => salida <= "10100100";
					when 3 => salida <= "10110000";
					when 4 => salida <= "10011001";
					when 5 => salida <= "10010010";
					when 6 => salida <= "10000010";
					when 7 => salida <= "11111000";
					when 8 => salida <= "10000000";
					when 9 => salida <= "10011000";
					when others => salida <= "11111111";
				end case;
				
			end if;
			
		end process;
		
end Behavioral;

