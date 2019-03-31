library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity main is
Port(
	Clk: in std_logic;
	led1: out std_logic;
	--led2: out std_logic;
	push1: in std_logic;
	stop: in std_logic
);

end main;

architecture Behavioral of main is

signal flag: std_logic;

begin

	process(clk)
	
		begin
			if(rising_edge(clk))then
				if (push1 = '1' and flag = '1')then
					flag <= '0';
					led1 <= '0';
				end if;
				if push1 = '0' then
					flag <= '1';
				end if;
				if stop = '0' then
					led1 <= '1';
				end if;
				
			end if;
			
		end process;
		
end Behavioral;

