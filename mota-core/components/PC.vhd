---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vinícius Oliveira
-- 07/2023

-- Program Counter Register
-- one 9-bit in, one 9-bit out, clear and load
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------
-- PC Register entity
entity PC is
port(	ld:	in std_logic;
		clr:	in std_logic;
		i0:	in std_logic_vector(8 downto 0);
		O:		out std_logic_vector(8 downto 0)
);
end PC;

architecture behv of PC is

begin				
	process(ld, clr, i0)
	begin
			if (clr='1') then
				O <= (others => '0');
			elsif (rising_edge(ld)) then
				O <= i0;
			end if;
	end process;

end behv;
