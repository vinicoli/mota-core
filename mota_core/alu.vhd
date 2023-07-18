---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--			   Vinicius Oliveira
-- 07/2023

-- Arithmetic and Logic Unit
-- two 16-bit data input and one 16-bit data output
-- flags: flag_zero, flag_equal
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

---------------------------------------------------------
-- ALU entity
entity alu is
   port (
      -- input
      in0:           in std_logic_vector(15 downto 0);
      in1:           in std_logic_vector(15 downto 0);
      sel:           in std_logic_vector(3 downto 0);
      -- output
      O:             out std_logic_vector(15 downto 0);
      flag_equal:    out std_logic;
      flag_bigger:   out std_logic;
      flag_u_bigger: out std_logic
   );
end alu;

architecture dataflow of alu is

   constant NULL_DATA: std_logic_vector(15 downto 0) := (others => '0');

begin

   p: process(in0, in1, sel)
   begin
      case sel is
         when "0000" =>       -- AND
            O <= in0 and in1;
         when "0001" =>       -- XOR
            O <= in0 xor in1;
         when "0010" =>       -- SLL
            O <= std_logic_vector(shift_left(unsigned(in0), to_integer(unsigned(in1))));
         when "0011" =>       -- ADD
            O <= in0 + in1;
         when "0100" =>       -- DIV
            O <= std_logic_vector(signed(in0) / signed(in1));
         when "0101" =>       -- SRA
            O <= std_logic_vector(shift_right(signed(in0), to_integer(unsigned(in1))));
         when "0110" =>       -- DEC
            O <= in0 - 1;
         when "0111" =>       -- SUB
            O <= in0 - in1;
         when "1000" =>       -- OR
            O <= in0 or in1;
         when "1001" =>       -- SRL
            O <= std_logic_vector(shift_right(unsigned(in0), to_integer(unsigned(in1))));
         when "1010" =>       -- SLA
            O <= std_logic_vector(shift_left(signed(in0), to_integer(unsigned(in1))));
         when "1011" =>       -- COP (buffer)
            O <= in1;
      
         when others => O <= NULL_DATA;
      
      end case;
		
		if in0 = in1 then
			flag_equal <= '1';
		else
         flag_equal <= '0';
		end if;

      if signed(in0) > signed(in1) then
			flag_bigger <= '1';
		else
         flag_bigger <= '0';
		end if;

      if unsigned(in0) > unsigned(in1) then
			flag_u_bigger <= '1';
		else
         flag_u_bigger <= '0';
		end if;
		
   end process;

end dataflow ; -- arch