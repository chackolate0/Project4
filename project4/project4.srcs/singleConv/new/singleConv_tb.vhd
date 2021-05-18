library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use ieee.std_logic_signed.all;
use work.matrixPkg.all;

entity singleConv_tb is

end entity;

architecture Behavioral of singleConv_tb is

  component singleConv
    port (
      A     : in matrix(0 to 2, 0 to 2); --16 bits * 3x3 matrix = 144 bits long
      B     : in matrix(0 to 2, 0 to 2);
      clk   : in STD_LOGIC;
      start : in STD_LOGIC;
      done  : out STD_LOGIC;
      C     : out STD_LOGIC_VECTOR (31 downto 0)); --each single convolution produces a 32 bit output
  end component;

  signal clk, start   : STD_LOGIC := '0';
  signal done         : STD_LOGIC;
  signal C            : STD_LOGIC_VECTOR(31 downto 0);
  constant clk_period : TIME := 2ns;
  signal A, B         : matrix(0 to 2, 0 to 2);
begin

  CONV0 : singleConv
  port map(
    A     => A,
    B     => B,
    clk   => clk,
    start => start,
    done  => done,
    C     => C
  );

  clocking : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  inputs : process
  begin
    for I in 0 to 2 loop
      for J in 0 to 2 loop
        A(I, J) <= STD_LOGIC_VECTOR(to_signed(I, 8) * to_signed(J, 8));
        B(I, J) <= STD_LOGIC_VECTOR(to_signed(I, 8) * to_signed(J, 8));
      end loop;
    end loop;
    wait;
  end process;

  stim : process
  begin
    start <= '0';
    wait for clk_period * 2;
    start <= '1';
    wait;
  end process;

end Behavioral;