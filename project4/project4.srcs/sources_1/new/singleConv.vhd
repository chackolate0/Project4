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
		-- done  : out STD_LOGIC;
		C     : out STD_LOGIC_VECTOR (31 downto 0)); --each single convolution produces a 32 bit output
end singleConv;

architecture Behavioral of singleConv is

	signal mac    : signed(31 downto 0) := x"00000000"; --signed signal to pass to output
	signal start0 : STD_LOGIC;
	-- signal done0  : STD_LOGIC := '1'; --done signal
	signal C0     : signed(31 downto 0);

begin

	-- C0 <= (signed(A(0, 0)) * signed(B(0, 0))) + (signed(A(0, 1)) * signed(B(0, 1))) + (signed(A(0, 2)) * signed(B(0, 2))) + (signed(A(1, 0)) * signed(B(1, 0))) + (signed(A(1, 1)) * signed(B(1, 1))) + (signed(A(1, 2)) * signed(B(1, 2))) + (signed(A(2, 0)) * signed(B(2, 0))) + (signed(A(2, 1)) * signed(B(2, 1))) + (signed(A(2, 2)) * signed(B(2, 2)));

	-- result : process
	-- begin
	-- 	if (rising_edge(start)) then
	-- 		done0 <= '0';
	-- 		C     <= STD_LOGIC_VECTOR(C0);
	-- 	end if;
	-- end process;
	-- done <= done0;
	--this process loops through the C0 matrix and adds the elements into a single value
	convolute : process (clk, start)
		variable mac0 : signed(31 downto 0) := x"00000000"; --accumulator variable
		variable cnt  : INTEGER             := 0;
	begin
		if (rising_edge(clk)) then
			if (reset = '1') then
				mac0 := x"00000000";
				mac <= mac0;
			elsif (start = '1' and cnt /= 9) then --convolute 3x3 every rising edge as long as operation is not done
				-- done0 <= '0';
				mac0 := x"00000000";
				for I in 0 to 2 loop
					for J in 0 to 2 loop
						mac0 := signed(A(I, J)) * signed(B(I, J)) + mac0;
						cnt  := cnt + 1;
					end loop;
				end loop;
				mac <= mac0;
			elsif (cnt = 9) then
				C     <= STD_LOGIC_VECTOR(signed(mac0));
				-- done0 <= '1';
				cnt := 0;
			end if;
		end if;
	end process;
end Behavioral;