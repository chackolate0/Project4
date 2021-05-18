library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.matrixPkg.all;
use IEEE.NUMERIC_STD.all;

entity padder_tb is
  --  Port ( );
end padder_tb;

architecture Behavioral of padder_tb is

  component padder(
    generic (
      n : NATURAL --size of input matrix
    );
    port (
      A : in matrix (0 to n - 1, 0 to n - 1);
      C : out matrix(0 to n + 1, 0 to n + 1)); --output is 2 elements larger
    )

  begin
  end Behavioral;