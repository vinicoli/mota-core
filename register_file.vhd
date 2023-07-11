---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vinicius Oliveira
-- 07/2023

-- 16 x 16bits register_file
-- one 16-bit write data input and two 16-bit read data output
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

---------------------------------------------------------
--register file entity
entity register_file is
   port (
      -- input
      clk:        in std_logic;
      W_data:     in std_logic_vector(15 downto 0);
      W_addr:     in std_logic_vector(3 downto 0);
      W_wr:       in std_logic;
      Rp_addr:    in std_logic_vector(3 downto 0);
      Rp_rd:      in std_logic;
      Rq_addr:    in std_logic_vector(3 downto 0);
      Rq_rd:      in std_logic;
      rst:        in std_logic;
      
      -- output
--    test_Wdata: out std_logic_vector(15 downto 0);
--		test_Waddr:	out std_logic_vector(3 downto 0);
		Rp_data:    out std_logic_vector(15 downto 0);
      Rq_data:    out std_logic_vector(15 downto 0)
   );
end entity register_file;

architecture rtl of register_file is

   type rf_type is array (0 to 15) of std_logic_vector(15 downto 0);
   constant NULL_ADDR: std_logic_vector(15 downto 0) := (others => '0');
   signal rf_tmp:    rf_type := (others => NULL_ADDR);
   signal rpdata_tmp:   std_logic_vector(15 downto 0);
   signal rqdata_tmp:   std_logic_vector(15 downto 0);
--	signal out_test: std_logic_vector(15 downto 0) := (others => '0');
--	signal addr_test: std_logic_vector(3 downto 0);

begin

   write: process(clk, rst)
   begin
      if rst = '1' then
         rf_tmp <= (others => NULL_ADDR);
      elsif rising_edge(clk) then
         if W_wr = '1' and W_addr /= "0000" then
            rf_tmp(to_integer(unsigned(W_addr))) <= W_data;
--				out_test <= W_data;
--				addr_test <= W_addr;
         end if;
      end if;
   end process write;

   read_p: process(clk, rst)
   begin
      if rst = '1' then
         rpdata_tmp <= NULL_ADDR;
      elsif rising_edge(clk) then
         if Rp_rd = '1' then
            rpdata_tmp <= rf_tmp(to_integer(unsigned(Rp_addr)));
         end if;
      end if;
   end process read_p;

   read_q: process(clk, rst)
   begin
      if rst = '1' then
         rqdata_tmp <= NULL_ADDR;
      elsif rising_edge(clk) then
         if Rq_rd = '1' then
            rqdata_tmp <= rf_tmp(to_integer(unsigned(Rq_addr)));
         end if;
      end if;
   end process read_q;
	
   Rp_data <= rpdata_tmp;
   Rq_data <= rqdata_tmp;
--	test_Wdata <= out_test;
--	test_Waddr <= addr_test;

end rtl; -- rtl