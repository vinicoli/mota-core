---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--			   Vinicius Oliveira
-- 07/2023

-- Adder
-- generic 2-input adder
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

---------------------------------------------------------
-- Adder entity
entity adder is
	generic (
		-- generic params
		DATA_WIDTH: natural :=9	-- Width of the input data (set to 9 by default)
	);
   port (
      -- input
      A, B:  in std_logic_vector(DATA_WIDTH-1 downto 0);
--      Cin:     in std_logic;  -- Carry In
      -- output
      O:       out std_logic_vector(DATA_WIDTH-1 downto 0);
      Cout:    out std_logic  -- Carry Out
   );
end adder;

architecture dataflow of adder is

	signal O_tmp: std_logic_vector(DATA_WIDTH downto 0) := (others => '0');

begin

	sum : process(A, B)
--      variable O_tmp: std_logic_vector(DATA_WIDTH downto 0);
   begin
      O_tmp <= ('0' & A) + ('0' & B);
      O <= O_tmp(DATA_WIDTH-1 downto 0);
      Cout <= O_tmp(DATA_WIDTH);
   end process ; -- sum

end dataflow ; -- dataflow