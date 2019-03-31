library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity main is

Generic(
	minuto: natural := 720000000;
	segundo: natural := 12000000;
	periodo: natural := 120000;
	resolucion: natural := 4095;
	soggy: natural := 300;
	wet: natural := 240;
	damp: natural := 180
);

Port(
	Clk: in std_logic;
	led1, led2, led3: out std_logic;
	rotar: out std_logic; 
	fan: out std_logic;
	salida: out std_logic_vector(0 to 7);
	Enable: out std_logic_vector(2 downto 0);
	calor: out std_logic;
	push1, push2, push3, play: in std_logic;
	door, stop: in std_logic
);

end main;

architecture Behavioral of main is

signal flag, flag1, flag2, flag3, flag4, pausa: std_logic;
signal crotar, cfan, ccalor: std_logic;
signal orotar, ofan, ocalor: std_logic;
signal ciclo1, ciclo2, ciclo3: std_logic;
signal cont1, cont2, cont3, cont: natural range 0 to resolucion;
signal numeros, unidad, decena, centena: natural range 0 to 9;
signal continuo: natural range 0 to segundo;
signal mux: natural range 0 to periodo;
signal tiempo: natural range 0 to soggy;

begin

	process(clk)
	
		begin
			if(rising_edge(clk))then
				if (push1 = '1' and flag1 = '1' and flag = '0')then
					flag1 <= '0';
					ciclo1 <= '1';
					tiempo <= 300;
					unidad <= 0;
					decena <= 0;
					centena <= 3;
					flag <= '1';
				end if;
				
				if push1 = '0' then
					flag1 <= '1';
				end if;

				if (push2 = '1' and flag2 = '1' and flag = '0')then
					flag2 <= '0';
					ciclo2 <= '1';
					tiempo <= 240;
					unidad <= 0;
					decena <= 4;
					centena <= 2;
					flag <= '1';
				end if;
				
				if push2 = '0' then
					flag2 <= '1';
				end if;
				
				if (push3 = '1' and flag3 = '1' and flag = '0')then
					flag3 <= '0';
					ciclo3 <= '1';
					tiempo <= 180;
					unidad <= 0;
					decena <= 8;
					centena <= 1;
					flag <= '1';
				end if;
				
				if push3 = '0' then
					flag3 <= '1';
				end if;

				--continuar
				if play = '0' then
					pausa <= '0';
				end if;
				
				--detener temporalmente
				if door = '0' then
					pausa <= '1';
				end if;
				
				if stop = '0' then
					flag4 <= '1';
				end if;
					
				if (stop = '1' and flag4 = '1') then
					pausa <= '1';
					flag4 <= '0';
				end if;
				
				--detener todo
				if (stop = '0' and pausa = '1' and flag4 <= '1')then
					ciclo1 <= '0';
					ciclo2 <= '0';
					ciclo3 <= '0';
					tiempo <= 0;
					unidad <= 0;
					decena <= 0;
					centena <= 0;
					flag <= '0';
					flag4 <= '0';
					pausa <= '0';
				end if;
				
				--contador mux
				if mux < periodo then
					mux <= mux + 1;
				else
					mux <= 1;
				end if;
					
				--contador continuo
				if (tiempo > 0 and pausa = '0') then
					if continuo < segundo then
						continuo <= continuo + 1;
					else
						continuo <= 1;
					end if;
				else
					continuo <= 0;
				end if;
				
				--conteo descendente
				if pausa = '0' then
					if (tiempo > 0 and continuo = segundo)then
						tiempo <= tiempo - 1;
						if unidad = 0 then
							unidad <= 9;
							if decena = 0 then
								decena <= 9;
								if centena > 0 then
									centena <= centena - 1;
								end if;
							else
								decena <= decena - 1;
							end if;
						else 
							unidad <= unidad - 1;
						end if;						
					end if;
				end if;

				--control de activacion
				if (pausa  = '0' and ciclo1 = '1') then
					case tiempo is
						when 300 => crotar <= '1';
						when 240 => cfan <= '1';
						when 180 => ccalor <= '1';
						when others => null;
					end case;
				end if;

				if (pausa  = '0' and ciclo2 = '1') then
					case tiempo is
						when 240 => crotar <= '1';
						when 180 => cfan <= '1';
						when 120 => ccalor <= '1';
						when others => null;
					end case;
				end if;

				if (pausa  = '0' and ciclo3 = '1') then
					case tiempo is
						when 180 => crotar <= '1';
						when 120 => cfan <= '1';
						when 60 => ccalor <= '1';
						when others => null;
					end case;
				end if;

				--fin de ciclo
				if tiempo = 0 then
					crotar <= '0';
					cfan <= '0';
					ccalor <= '0';
				end if;
				
				--revision de puerta abierta
				if pausa = '1' then
					orotar <= '0';
					ofan <= '0';
					ocalor <= '0';
				else
					orotar <= crotar;
					ofan <= cfan;
					ocalor <= ccalor;
				end if;
				
				led1 <= orotar;
				led2 <= ofan;
				led3 <= ocalor;
				
				rotar <= orotar;
				fan <= ofan;
				calor <= ocalor;
				
				--mux para seleccion de display
				case mux is
					when 0 => Enable <= "111";
					when 1 => Enable <= "011";
					when 40000 => Enable <= "101";
					when 80000 => Enable <= "110";
					when others => null;
				end case;
				
				--mux para seleccion de digito
				case mux is
					when 0 => numeros <= 0;
					when 1 => numeros <= centena;
					when 40000 => numeros <= decena;
					when 80000 => numeros <= unidad;
					when others => null;
				end case;

				--seleccion de numero
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

