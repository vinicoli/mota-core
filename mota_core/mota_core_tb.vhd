
---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vinicius Oliveira
-- 07/2023

-- mota-core testbench
---------------------------------------------------------
-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;
-- use work.all;
---------------------------------------------------------
entity mota_core_tb is
end mota_core_tb;

architecture testbench of mota_core_tb is

	component mota_core is
		port (
			-- input
			clk:	in std_logic;
			rst:	in std_logic;
			in0:	in std_logic_vector(15 downto 0);
			in1:	in std_logic_vector(15 downto 0);
			-- output
			out0:	out std_logic_vector(15 downto 0);
			out1:	out std_logic_vector(15 downto 0)
		);
	end component;
    
	signal clk_tb:	std_logic;
	signal rst_tb:	std_logic;
	signal in0_tb:	std_logic_vector(15 downto 0);
	signal in1_tb:	std_logic_vector(15 downto 0);
	-- output
	signal out0_tb:	std_logic_vector(15 downto 0);
	signal out1_tb:	std_logic_vector(15 downto 0);

begin
    
	DUT: mota_core
		port map (
			-- input
			clk => clk_tb,
			rst => rst_tb,
			in0 => in0_tb,
			in1 => in1_tb,
			-- output
			out0 => out0_tb,
			out1 => out1_tb
		);

	clk_tb <= not clk_tb after 10 ns;
    
end architecture testbench;