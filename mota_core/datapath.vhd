---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vini­cius Oliveira
-- 07/2023

-- datapath
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;
-- use work.all;

---------------------------------------------------------
-- datapath entity
entity datapath is
   port (
      -- input 
      dp_clk:              in std_logic;
		dp_rst:		         in std_logic;
      In_data:             in std_logic_vector(15 downto 0);
      ld_mem:              in std_logic_vector(15 downto 0);
      M_R_sel:             in std_logic_vector(1 downto 0);
      R_W_addr:            in std_logic_vector(3 downto 0);
      R_W_wr:              in std_logic;
      R_Rp_addr:           in std_logic_vector(3 downto 0);
      R_Rp_rd:             in std_logic;
      R_Rq_addr:           in std_logic_vector(3 downto 0);
      R_Rq_rd:             in std_logic;
		Imm_data:	         in std_logic_vector(15 downto 0);
		M_ALU_sel:	         in std_logic;
		ALU_sel:		         in std_logic_vector(3 downto 0);
      -- output
      Out_data:            out std_logic_vector(15 downto 0);
      ALU_flag_equal:      out std_logic;
      ALU_flag_bigger:     out std_logic;
      ALU_flag_u_bigger:   out std_logic
   ) ;
end datapath ;

architecture struct of datapath is

   -- component declaration
   component bigmux is
      generic(
         -- generic params
         DATA_WIDTH: natural :=16	-- Width of the input data (set to 16 by default)
      );
      port( 
         -- inputs
         I0: 	in std_logic_vector(DATA_WIDTH-1 downto 0);
         I1:		in std_logic_vector(DATA_WIDTH-1 downto 0);
         I2:		in std_logic_vector(DATA_WIDTH-1 downto 0);
         sel: 	in std_logic_vector(1 downto 0);
         -- output
         O: 	out std_logic_vector(DATA_WIDTH-1 downto 0)
      );
   end component;

   component register_file is
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
         Rp_data:    out std_logic_vector(15 downto 0);
         Rq_data:    out std_logic_vector(15 downto 0)
      );
   end component;

   component smallmux is
      generic(
         -- generic params
         DATA_WIDTH: natural :=16	-- Width of the input data (set to 16 by default)
      );
      
      port(
         -- inputs
         I0: 	in std_logic_vector(DATA_WIDTH-1 downto 0);
         I1:		in std_logic_vector(DATA_WIDTH-1 downto 0);
         sel: 	in std_logic;
         -- outputs
         O: 	out std_logic_vector(DATA_WIDTH-1 downto 0)
      );
   end component;

   component alu is
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
   end component;

   -- internal signs
   signal R_W_data:     std_logic_vector(15 downto 0);
   signal R_Rp_data:    std_logic_vector(15 downto 0);
   signal R_Rq_data:    std_logic_vector(15 downto 0);
   signal M_ALU_O:      std_logic_vector(15 downto 0);
   signal ALU_O:        std_logic_vector(15 downto 0);

begin

   -- component instantiation
   M_R: bigmux
      generic map (
         DATA_WIDTH => 16
      )
      port map (
         I0 => In_data,
         I1 => ld_mem,
         I2 => ALU_O,
         sel => M_R_sel,
         O => R_W_data
      );
   
	R: register_file 
      port map (
         clk => dp_clk,
         W_data => R_W_data,
         W_addr => R_W_addr,
         W_wr => R_W_wr,
         Rp_addr => R_Rp_addr,
         Rp_rd => R_Rp_rd,
         Rq_addr => R_Rq_addr,
         Rq_rd => R_Rq_rd,
         rst => dp_rst,
         Rp_data => R_Rp_data,
         Rq_data => R_Rq_data
		);
   
	M_ALU: smallmux
      generic map (
         DATA_WIDTH => 16
      )
      port map (
         I0 => Imm_data,
         I1 => R_Rp_data,
         sel => M_ALU_sel,
         O => M_ALU_O
      );
	
   A_ALU: alu
      port map (
         in0 => M_ALU_O,
         in1 => R_Rq_data,
         sel => ALU_sel,
         O => ALU_O,
         flag_equal => ALU_flag_equal,
         flag_bigger => ALU_flag_bigger,
         flag_u_bigger => ALU_flag_u_bigger
      );

   -- concurrent statements
   Out_data <= R_Rp_data;

end struct; -- bhv