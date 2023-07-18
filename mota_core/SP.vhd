---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vinicius Oliveira
-- 07/2023

-- Stack Point Register
-- one 9-bit in, one 9-bit out, clear, pop and push
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------
-- SP Register entity
entity SP is
   port (
      -- inputs
      clk:        in std_logic;
      i0:         in std_logic_vector(8 downto 0);
      push:       in std_logic;
      pop:        in std_logic;
      rst:        in std_logic;
      -- output
      O:          out std_logic_vector(8 downto 0);
      flag_full:  out std_logic;
      flag_empty: out std_logic
   );
end SP;

architecture rtl of SP is

   constant N: integer := 5;
   type Stack is array (0 to N) of std_logic_vector(8 downto 0);
   signal stack_data:   Stack := (others => (others => '0'));
   signal stack_top:    integer := 0;
   signal full:  			std_logic := '0';
   signal empty:  		std_logic := '1';
	signal output:			std_logic_vector(8 downto 0);

begin
   flag_full 	<= full;
   flag_empty 	<= empty;
	O 				<= output;


   process(clk, rst, push, pop)
   begin
      if rst = '1' then
         stack_top <= 0;
         stack_data <= (others => (others => '0'));
         empty <= '1';
         full <= '0';
      elsif rising_edge(clk) then
         if stack_top = 0 then
            full <= '0';
            empty <= '1';
         elsif stack_top = N then
            full <= '1';
            empty <= '0';
         else
            full <= '0';
            empty <= '0';
         end if;
			-- push operation
         if push = '1' and pop = '0' and full = '0' then
            stack_data(stack_top) <= i0;
				stack_top <= stack_top + 1;
				output <= i0;

			-- pop operation
         elsif push = '0' and pop = '1' and empty = '0' then
				output <= stack_data(stack_top-1);
            stack_top <= stack_top -1;
			else
				output <= (others => '0');
         end if;
         
      end if;
   end process;

end rtl; -- rtl