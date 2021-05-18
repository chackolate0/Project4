library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.matrixPkg.all;
use IEEE.NUMERIC_STD.all;

entity padder_tb is
  --  Port ( );
end padder_tb;

architecture Behavioral of padder_tb is

  component padder
    generic (
      n : NATURAL --size of input matrix
    );
    port (
      A : in matrix (0 to n - 1, 0 to n - 1);
      C : out matrix(0 to n + 1, 0 to n + 1)); --output is 2 elements larger
  end component;
  signal A : matrix(0 to 4, 0 to 4);
  signal C : matrix(0 to 6, 0 to 6);

begin

  PAD0 : padder
  generic map(n => 5)
  port map(
    A => A,
    C => C);

  inputs : process
  begin
    for I in 0 to 4 loop
      for J in 0 to 4 loop
        A(I, J) <= STD_LOGIC_VECTOR(to_signed(I, 8) * to_signed(J, 8));
      end loop;
    end loop;
    wait;
  end process;
end Behavioral;