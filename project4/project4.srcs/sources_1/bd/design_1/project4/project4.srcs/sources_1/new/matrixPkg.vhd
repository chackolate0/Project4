library ieee;
use ieee.STD_LOGIC_1164.all;

package matrixPkg is

  type matrix is array (NATURAL range <>, NATURAL range <>) of STD_LOGIC_VECTOR(15 downto 0); --type for 16 bit matrix
  type result is array (NATURAL range <>, NATURAL range <>) of STD_LOGIC_VECTOR(31 downto 0); --type for 32 bit matrix
  type bitMatrix is array (NATURAL range <>, NATURAL range <>) of STD_LOGIC;
  type row is array (NATURAL range <>) of STD_LOGIC_VECTOR(15 downto 0);

end matrixPkg;

package body matrixPkg is
end matrixPkg;