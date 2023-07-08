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

---------------------------------------------------------

-- 2x1 multiplexor entity
entity smallmux is
port( I0: 	in std_logic_vector(15 downto 0);
		I1:	in std_logic_vector(15 downto 0);
		sel: 	in std_logic;
		O: 	out std_logic_vector(15 downto 0)
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
            when others => 
        end case;
    end process;
end behv;
