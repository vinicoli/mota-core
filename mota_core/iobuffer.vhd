---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vinicius Oliveira
-- 07/2023

-- iobuffer I/O
-- two 16-bit data input and two 16-bit data output
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------
-- iobuffer entity
entity iobuffer is
port (
   -- input
   ibuf_in0:   in std_logic_vector(15 downto 0);
   ibuf_in1:   in std_logic_vector(15 downto 0);
   obuf_in:    in std_logic_vector(15 downto 0);
   I_addr:     in std_logic;
   I_en:       in std_logic;
   O_addr:     in std_logic;
   O_en:       in std_logic;
   -- output
   ibuf_out:   out std_logic_vector(15 downto 0);
   obuf_out0:  out std_logic_vector(15 downto 0);
   obuf_out1:  out std_logic_vector(15 downto 0)

) ;
end iobuffer ;

architecture dataflow of iobuffer is

	constant NULL_DATA: 		std_logic_vector(15 downto 0) := (others => '0');

begin

   i: process(I_en, ibuf_in0, ibuf_in1, I_addr)
   begin
      if I_en = '1' then
         case I_addr is
            when '0' => ibuf_out <= ibuf_in0;
				when '1' => ibuf_out <= ibuf_in1;
            when others => null;
         end case;
      else
         ibuf_out <= NULL_DATA;
      end if;
   end process i;

   o: process(O_en, obuf_in, O_addr)
   begin
      if O_en = '1' then
         case O_addr is
            when '0' =>
               obuf_out0 <= obuf_in;
               obuf_out1 <= NULL_DATA;
               when '1' => 
               obuf_out0 <= NULL_DATA;
               obuf_out1 <= obuf_in;
            when others => null;
         end case;
		else
         obuf_out0 <= NULL_DATA;
         obuf_out1 <= NULL_DATA;
      end if;
   end process o;
	
end dataflow; -- arch