---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vinicius Oliveira
-- 07/2023

-- control unit
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------
-- cpu entity
entity control_unit is
   port (
      -- input
      clk:                 in std_logic;
      rst:                 in std_logic;
      instruction:         in std_logic_vector(31 downto 0);
      ALU_flag_equal:      in std_logic;
      ALU_flag_bigger:     in std_logic;
      ALU_flag_u_bigger:   in std_logic;
      -- output
      D_rw:                out std_logic;
      M_R_sel:             out std_logic_vector(1 downto 0);
      R_W_addr:            out std_logic_vector(3 downto 0);
      R_W_wr:              out std_logic;
      R_Rp_addr:           out std_logic_vector(3 downto 0);
      R_Rp_rd:             out std_logic;
      R_Rq_addr:           out std_logic_vector(3 downto 0);
      R_Rq_rd:             out std_logic;
      M_ALU_sel:           out std_logic;
      ALU_sel:             out std_logic_vector(3 downto 0);
      IO_I_addr:           out std_logic;
      IO_I_en:             out std_logic;
      IO_O_addr:           out std_logic;
      IO_O_en:             out std_logic;
      I_rw:                out std_logic;
      PC_O:                buffer std_logic_vector(8 downto 0)
      ) ;
end control_unit ;

architecture struct of control_unit is

   -- component declaration
   component PC is
      port(	clk:	in std_logic;
            ld:	in std_logic;
            clr:	in std_logic;
            i0:	in std_logic_vector(8 downto 0);
            O:		out std_logic_vector(8 downto 0)
      );
   end component;

   component SP is
      port (
         -- inputs
         clk:        in std_logic;
         i0:         in std_logic_vector(8 downto 0);
         push:       in std_logic;
         pop:        in std_logic;
         rst:        in std_logic;
         -- output
         O:          out std_logic_vector(8 downto 0);
         flag_full:  out std_logic;
         flag_empty: out std_logic
      );
   end component;
	
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

   component adder is
      generic (
         -- generic params
         DATA_WIDTH: natural :=9	-- Width of the input data (set to 9 by default)
      );
      port (
         -- input
         A, B:    in std_logic_vector(DATA_WIDTH-1 downto 0);
         -- output
         O:       out std_logic_vector(DATA_WIDTH-1 downto 0);
         Cout:    out std_logic  -- Carry Out
      );
   end component;

   component controller is
      port (
      -- input
      ctrl_clk:           in std_logic;
      ctrl_rst:           in std_logic;
      instruction:        in std_logic_vector(31 downto 0);
      ALU_flag_equal:     in std_logic;
      ALU_flag_bigger:    in std_logic;
      ALU_flag_u_bigger:  in std_logic;
      -- output
      D_rw:               out std_logic;
      M_R_sel:            out std_logic_vector(1 downto 0);
      R_W_addr:           out std_logic_vector(3 downto 0);
      R_W_wr:             out std_logic;
      R_Rp_addr:          out std_logic_vector(3 downto 0);
      R_Rp_rd:            out std_logic;
      R_Rq_addr:          out std_logic_vector(3 downto 0);
      R_Rq_rd:            out std_logic;
      M_ALU_sel:          out std_logic;
      ALU_sel:            out std_logic_vector(3 downto 0);
      IO_I_addr:          out std_logic;
      IO_I_en:            out std_logic;
      IO_O_addr:          out std_logic;
      IO_O_en:            out std_logic;
      M_PC_sel:           out std_logic_vector(1 downto 0);
      SP_pop:             out std_logic;
      SP_push:            out std_logic;
      PC_ld:              out std_logic;
      I_rw:               out std_logic
      );
   end component ;

   -- internal signs
	constant ONE:	std_logic_vector(8 downto 0) := "000000001";
	signal M_PC_sel:  std_logic_vector(1 downto 0);
   signal SP_pop:    std_logic;
   signal SP_push:   std_logic;
   signal PC_ld:     std_logic;
   signal M_PC_O:    std_logic_vector(8 downto 0);
   signal Adder_O:   std_logic_vector(8 downto 0);
   signal SP_O:      std_logic_vector(8 downto 0);

begin

   -- component instantiation
   PC_inst: pc
      port map (
         -- input
         clk => clk,
         ld => PC_ld,
         clr => rst,
         i0 => M_PC_O,
         -- output
         O => PC_O
      );

   SP_inst: sp
      port map (
         -- input
         clk => clk,
         i0 => Adder_O,
         push => SP_push,
         pop => SP_pop,
         rst => rst,
         -- output
         O => SP_O,
         flag_full => open,
         flag_empty => open
      );

   M_PC: bigmux
      generic map (
         DATA_WIDTH => 9
      )
      port map (
         -- input
         I0 => SP_O,
         I1 => Adder_O,
         I2 => instruction(18 downto 10),
         sel => M_PC_sel,
         -- output
         O => M_PC_O
      );

   Adder_inst: adder
      port map (
         -- input
         A => PC_O,
         B => ONE,
         -- output
         O => Adder_O,
         Cout => open
      );

   Controller_inst: controller
      port map (
         -- input
         ctrl_clk => clk,
         ctrl_rst => rst,
         instruction => instruction,
         ALU_flag_equal => ALU_flag_equal,
         ALU_flag_bigger => ALU_flag_bigger,
         ALU_flag_u_bigger => ALU_flag_u_bigger,
         -- output
         D_rw => D_rw,
         M_R_sel => M_R_sel,
         R_W_addr => R_W_addr,
         R_W_wr => R_W_wr,
         R_Rp_addr => R_Rp_addr,
         R_Rp_rd => R_Rp_rd,
         R_Rq_addr => R_Rq_addr,
         R_Rq_rd => R_Rq_rd,
         M_ALU_sel => M_ALU_sel,
         ALU_sel => ALU_sel,
         IO_I_addr => IO_I_addr,
         IO_I_en => IO_I_en,
         IO_O_addr => IO_O_addr,
         IO_O_en => IO_O_en,
         M_PC_sel => M_PC_sel,
         SP_pop => SP_pop,
         SP_push => SP_push,
         PC_ld => PC_ld,
         I_rw => I_rw
      );

end struct; -- arch