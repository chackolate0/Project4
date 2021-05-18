library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.matrixPkg.all;

entity nConv_padding is
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
		C     : out result(0 to n - 1, 0 to n - 1)); --n*n*32bits output
end nConv_padding;

architecture Behavioral of nConv_padding is

	component padder
		generic (
			n : NATURAL --size of input matrix
		);
		port (
			A : in matrix (0 to n - 1, 0 to n - 1);
			C : out matrix(0 to n + 1, 0 to n + 1)); --output is 2 elements larger
	end component;

	component nConv
		generic (
			n : INTEGER; --width/length of input matrix (n-2 of padded output)
			k : INTEGER);--number of filters
		port (
			A     : in matrix(0 to n - 1, 0 to n - 1); --n*n*16bits input
			B     : in matrix(0 to 2, 0 to 2);         -- 3*3*16bits * k filters
			clk   : in STD_LOGIC;
			reset : in STD_LOGIC;
			start : in STD_LOGIC;
			done  : out STD_LOGIC;
			C     : out result(0 to n - 3, 0 to n - 3)); --n*n*32bits output
	end component;

	signal Cbuf  : result(0 to n - 1, 0 to n - 1) := (others => (others => x"00000000"));
	signal done0 : STD_LOGIC;
	signal A0    : matrix(0 to n + 1, 0 to n + 1); --output of padder block

begin

	PAD0 : padder
	generic map(n => n)
	port map(
		A => A,
		C => A0
	);

	CONV0 : nConv
	generic map(
		n => n + 2,
		k => 0
	)
	port map(
		A     => A0,
		B     => B,
		clk   => clk,
		reset => reset,
		start => start,
		done  => done0,
		C     => Cbuf
	);

	C    <= Cbuf;
	done <= done0;

	-- done : process (done0)
	-- if

end Behavioral;