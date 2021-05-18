--n*n matrix convolution with k filters
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.matrixPkg.all;

entity nConv is
	generic (
		n : INTEGER; --width/length of input matrix
		k : INTEGER);--number of filters
	port (
		A     : in matrix(0 to n - 1, 0 to n - 1); --n*n*16bits input
		B     : in matrix(0 to 2, 0 to 2);         -- 3*3*16bits * k filters
		clk   : in STD_LOGIC;
		reset : in STD_LOGIC;
		start : in STD_LOGIC;
		done  : out STD_LOGIC;
		C     : out result(0 to n - 3, 0 to n - 3)); --n*n*32bits output
end nConv;

architecture Behavioral of nConv is

	component singleConv
		port (
			A     : in matrix(0 to 2, 0 to 2); --16 bits * 3x3 matrix = 144 bits long
			B     : in matrix(0 to 2, 0 to 2);
			clk   : in STD_LOGIC;
			start : in STD_LOGIC;
			reset : in STD_LOGIC;
			done  : out STD_LOGIC;
			C     : out STD_LOGIC_VECTOR (31 downto 0)); --each single convolution produces a 32 bit output
	end component;

	signal done0 : bitMatrix(0 to n - 3, 0 to n - 3);
	signal Cout  : result(0 to n - 3, 0 to n - 3); --buffer matrix holds combinational result, Cout is only updated when done
	signal cnt   : INTEGER := 0;
	-- signal done1 : bitMatrix(0 to n - 3, 0 to n - 3) := (others => (others => '1'));

begin

	CONV : for I in 0 to n - 3 generate
		CONV0 : for J in 0 to n - 3 generate
			CONVX : singleConv port map(
				A(0, 0) => A(I, J),
				A(0, 1) => A(I, J + 1),
				A(0, 2) => A(I, J + 2),
				A(1, 0) => A(I + 1, J),
				A(1, 1) => A(I + 1, J + 1),
				A(1, 2) => A(I + 1, J + 2),
				A(2, 0) => A(I + 2, J),
				A(2, 1) => A(I + 2, J + 1),
				A(2, 2) => A(I + 2, J + 2),
				B       => B,
				clk     => clk,
				start   => start,
				reset   => reset,
				done    => done0(I, J),
				C       => Cout(I, J)
			);
		end generate CONV0;
	end generate CONV;

	-- finished : process (done0, start) --checks done signals of all components to see if full operation is complete
	-- 	variable valid : STD_LOGIC := '0';
	-- begin
	-- 	if()
	-- end process;

	done <= done0(0, 0);
	C    <= Cout;

	-- done <= done0;

end Behavioral;