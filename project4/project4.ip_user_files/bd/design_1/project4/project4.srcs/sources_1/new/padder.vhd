library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.matrixPkg.all;

entity padder is
	generic (
		n : NATURAL --size of input matrix
	);
	port (
		A : in matrix (0 to n - 1, 0 to n - 1);
		C : out matrix(0 to n + 1, 0 to n + 1)); --output is 2 elements larger
end padder;

architecture Behavioral of padder is

	signal M : matrix (0 to n + 1, 0 to n + 1) := (others => (others => x"0000"));

begin

	padding : process (A)
		variable K : matrix(0 to n + 1, 0 to n + 1) := (others => (others => x"0000"));
	begin
		for I in 1 to n loop
			for J in 1 to n loop
				K(I, J) := A(I - 1, J - 1);
			end loop;
		end loop;
		M <= K;
	end process;

	C <= M;

end Behavioral;