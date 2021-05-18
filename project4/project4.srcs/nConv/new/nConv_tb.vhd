library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.matrixPkg.all;

entity nConv_tb is

end entity;

architecture Behavioral of nConv_tb is

  component nConv
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
  end component;

  component nConv_padding
    generic (
      n : INTEGER; --width/length of input matrix
      k : INTEGER
    );--number of filters
    port (
      A     : in matrix(0 to n - 1, 0 to n - 1); --n*n*16bits input
      B     : in matrix(0 to 2, 0 to 2);         -- 3*3*16bits * k filters
      clk   : in STD_LOGIC;
      reset : in STD_LOGIC;
      start : in STD_LOGIC;
      done  : out STD_LOGIC;
      C     : out result(0 to n - 1, 0 to n - 1)); --n*n*32bits output
  end component;

  signal A                 : matrix (0 to 17, 0 to 17);
  signal C                 : result (0 to 17, 0 to 17);
  signal clk, reset, start : STD_LOGIC := '0';
  signal B                 : matrix(0 to 2, 0 to 2);
  signal done              : STD_LOGIC;

  constant clk_period      : TIME := 10ns;

begin

  -- NCONV0 : nConv
  -- generic map(
  --   n => 9,
  --   k => 0
  -- )
  -- port map(
  --   A     => A,
  --   B     => B,
  --   clk   => clk,
  --   reset => reset,
  --   start => start,
  --   C     => C
  -- );

  NCONV0 : nConv_padding
  generic map(
    n => 18,
    k => 0
  )
  port map(
    A     => A,
    B     => B,
    clk   => clk,
    reset => reset,
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

  -- inputs : process
  -- begin
  --   for I in 0 to 17 loop
  --     for J in 0 to 17 loop
  --       A(I, J) <= STD_LOGIC_VECTOR(to_signed(I, 8) * to_signed(J, 8));
  --     end loop;
  --   end loop;
  --   for I in 0 to 2 loop
  --     for J in 0 to 2 loop
  --       B(I, J) <= STD_LOGIC_VECTOR(to_signed(I, 8) * to_signed(J, 8));
  --     end loop;
  --   end loop;
  --   wait until reset = '1';
  --   for I in 0 to 17 loop
  --     for J in 0 to 17 loop
  --       A(I, J) <= STD_LOGIC_VECTOR(to_signed(I + J, 8) * to_signed(J - I, 8));
  --     end loop;
  --   end loop;
  --   for I in 0 to 2 loop
  --     for J in 0 to 2 loop
  --       B(I, J) <= STD_LOGIC_VECTOR(to_signed(I - J, 8) * to_signed(J + I, 8));
  --     end loop;
  --   end loop;
  --   wait;
  -- end process;

  stim : process
  begin
    for I in 0 to 17 loop
      for J in 0 to 17 loop
        A(I, J) <= STD_LOGIC_VECTOR(to_signed(I, 8) * to_signed(J, 8));
      end loop;
    end loop;
    for I in 0 to 2 loop
      for J in 0 to 2 loop
        B(I, J) <= STD_LOGIC_VECTOR(to_signed(I, 8) * to_signed(J, 8));
      end loop;
    end loop;
    start <= '0';
    wait for clk_period;

    start <= '1';
    wait for clk_period;

    start <= '0';
    reset <= '1';
    wait for clk_period;

    for I in 0 to 17 loop
      for J in 0 to 17 loop
        A(I, J) <= STD_LOGIC_VECTOR(to_signed(I + J, 8) * to_signed(J - I, 8));
      end loop;
    end loop;
    for I in 0 to 2 loop
      for J in 0 to 2 loop
        B(I, J) <= STD_LOGIC_VECTOR(to_signed(I - J, 8) * to_signed(J + I, 8));
      end loop;
    end loop;
    start <= '0';
    wait for clk_period;

    start <= '1';
    reset <= '0';
    wait for clk_period;

    start <= '0';
    reset <= '1';
    wait for clk_period;

    -- reset <= '1';
    for I in 0 to 17 loop
      for J in 0 to 17 loop
        A(I, J) <= STD_LOGIC_VECTOR(to_signed(J + 1, 8) * to_signed(I - 2, 8));
      end loop;
    end loop;
    for I in 0 to 2 loop
      for J in 0 to 2 loop
        B(I, J) <= STD_LOGIC_VECTOR(to_signed(J * 3, 8) * to_signed(I + 5, 8));
      end loop;
    end loop;
    wait for clk_period;

    reset <= '0';
    start <= '1';
    wait;
  end process;
end Behavioral;