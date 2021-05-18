--Component to perform a single 3x3 convolution
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_signed.all;
use work.matrixPkg.all;

entity singleConv is
	port (
		A     : in matrix(0 to 2, 0 to 2); --16 bits * 3x3 matrix = 144 bits long
		B     : in matrix(0 to 2, 0 to 2);
		clk   : in STD_LOGIC;
		start : in STD_LOGIC;
		reset : in STD_LOGIC;
		done  : out STD_LOGIC;
		C     : out STD_LOGIC_VECTOR (31 downto 0)); --each single convolution produces a 32 bit output
end singleConv;

architecture Behavioral of singleConv is

	signal mac   : signed(31 downto 0) := x"00000000"; --signed signal to pass to output
	signal done0 : STD_LOGIC           := '1';         --done signal

begin

	done <= done0;
	--this process loops through the C0 matrix and adds the elements into a single value
	convolute : process (clk, start)
		variable mac0 : signed(31 downto 0) := x"00000000"; --accumulator variable
	begin
		if (rising_edge(start)) then --turning on start will deactivate done
			done0 <= '0';
		end if;
		if (rising_edge(clk)) then
			if (reset = '1') then
				mac0 := x"00000000";
				mac <= mac0;
			elsif (done0 = '0') then --convolute 3x3 every rising edge as long as operation is not done
				mac0 := x"00000000";
				for I in 0 to 2 loop
					for J in 0 to 2 loop
						mac0 := signed(A(I, J)) * signed(B(I, J)) + mac0;
					end loop;
				end loop;
				done0 <= '1';
				mac   <= mac0;
			elsif (done0 = '1') then
				mac <= mac0;
			end if;
		end if;
	end process;

	C <= STD_LOGIC_VECTOR(mac);

end Behavioral;