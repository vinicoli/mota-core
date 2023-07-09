---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vinícius Oliveira
-- 07/2023

-- 2x1 multiplexor
-- two 16 bit inputs and one 16 bit output
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------

-- 2x1 multiplexor entity
entity smallmux is
	generic(
		-- generic params
		DATA_WIDTH: natural :=16	-- Width of the input data (set to 16 by default)
	);
	
	port(
		-- inputs
		I0: 	in std_logic_vector(DATA_WIDTH-1 downto 0);
		I1:	in std_logic_vector(DATA_WIDTH-1 downto 0);
		sel: 	in std_logic;
		-- outputs
		O: 	out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end smallmux;


-- Behavioral modeling
architecture behv of smallmux is

begin
	process(I0, I1, sel)
	begin
		case sel is
			when '0' =>	O <= I0;
			when '1' =>	O <= I1;
			when others => O <= (others => '0');
		end case;
	end process;
end behv;
