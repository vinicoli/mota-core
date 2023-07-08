---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vinícius Oliveira
-- 07/2023

-- 3x1 multiplexor
-- three 16 bit inputs and one 16 bit output
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------

-- 3x1 multiplexor entity
entity bigmux is
port( I0: 	in std_logic_vector(15 downto 0);
		I1:	in std_logic_vector(15 downto 0);
		I2:	in std_logic_vector(15 downto 0);
		sel: 	in std_logic_vector(1 downto 0);
		O: 	out std_logic_vector(15 downto 0)
);
end bigmux;


-- Behavioral modeling
architecture behv of bigmux is

begin
	process(I0, I1, sel)
    begin
        case sel is
            when "00" =>	O <= I0;
            when "01" =>	O <= I1;
				when "10" =>	O <= I2;
            when others => 
        end case;
    end process;
end behv;
