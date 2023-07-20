---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--				Vinicius Oliveira
-- 07/2023

-- mota-core processor
-- top-level entity
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;
use work.iobuffer;

---------------------------------------------------------
entity mota_core is
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
end entity mota_core;

architecture structure of mota_core is

   -- component declaration
   component instruction_memory is
      port
      (
         address		: IN STD_LOGIC_VECTOR (8 DOWNTO 0);
         clock		: IN STD_LOGIC  := '1';
         q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
      );
   end component;

   component data_memory is
      port
         (
            address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
            clock		: IN STD_LOGIC  := '1';
            data		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            wren		: IN STD_LOGIC ;
            q		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
         );
   end component;

   component control_unit is
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
   end component;

   component datapath is
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
   end component;

   component iobuffer is
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
      end component;

   -- internal signs
   signal I_addr_tmp:				std_logic_vector(8 downto 0);
   signal I_rw_tmp:					std_logic;
   signal instruction_tmp:			std_logic_vector(31 downto 0);
   signal D_rw_tmp:					std_logic;
   signal DP_Out_data:           std_logic_vector(15 downto 0);
   signal D_R_data_tmp:				std_logic_vector(15 downto 0);
   signal ALU_flag_equal_tmp:		std_logic;
   signal ALU_flag_bigger_tmp:	std_logic;
   signal ALU_flag_u_bigger_tmp:	std_logic;
   signal M_R_sel_tmp:				std_logic_vector(1 downto 0);
   signal R_W_addr_tmp:				std_logic_vector(3 downto 0);
   signal R_W_wr_tmp:				std_logic;
   signal R_Rp_addr_tmp:			std_logic_vector(3 downto 0);
   signal R_Rp_rd_tmp:				std_logic;
   signal R_Rq_addr_tmp:			std_logic_vector(3 downto 0);
   signal R_Rq_rd_tmp:				std_logic;
   signal M_ALU_sel_tmp:			std_logic;
   signal ALU_sel_tmp:				std_logic_vector(3 downto 0);
   signal IO_I_addr_tmp:			std_logic;
   signal IO_I_en_tmp:				std_logic;
   signal IO_O_addr_tmp:			std_logic;
   signal IO_O_en_tmp:				std_logic;
   signal DP_In_data:            std_logic_vector(15 downto 0);

begin

   -- component instantiation
   inst_mem: instruction_memory
      port map (
         -- input
         address	 => I_addr_tmp,
         clock	 => I_rw_tmp,
         -- output
         q	 => instruction_tmp
      );

   data_mem: data_memory
      port map (
         -- input
         address	 => instruction_tmp(22 downto 13),
         clock	 => clk,
         data	 => DP_Out_data,
         wren	 => D_rw_tmp,
         -- output
         q	 => D_R_data_tmp
      );

   ctrl_unit: control_unit
      port map (
         -- input
         clk => clk,
         rst => rst,
         instruction => instruction_tmp,
         ALU_flag_equal => ALU_flag_equal_tmp,
         ALU_flag_bigger => ALU_flag_bigger_tmp,
         ALU_flag_u_bigger => ALU_flag_u_bigger_tmp,
         -- output
         D_rw => D_rw_tmp,
         M_R_sel => M_R_sel_tmp,
         R_W_addr => R_W_addr_tmp,
         R_W_wr => R_W_wr_tmp,
         R_Rp_addr => R_Rp_addr_tmp,
         R_Rp_rd => R_Rp_rd_tmp,
         R_Rq_addr => R_Rq_addr_tmp,
         R_Rq_rd => R_Rq_rd_tmp,
         M_ALU_sel => M_ALU_sel_tmp,
         ALU_sel => ALU_sel_tmp,
         IO_I_addr => IO_I_addr_tmp,
         IO_I_en => IO_I_en_tmp,
         IO_O_addr => IO_O_addr_tmp,
         IO_O_en => IO_O_en_tmp,
         I_rw => I_rw_tmp,
         PC_O => I_addr_tmp
      );

   datapath_inst: datapath
      port map (
         --input
         dp_clk => clk,
         dp_rst => rst,
         In_data => DP_In_data,
         ld_mem => D_R_data_tmp,
         M_R_sel => M_R_sel_tmp,
         R_W_addr => R_W_addr_tmp,
         R_W_wr => R_W_wr_tmp,
         R_Rp_addr => R_Rp_addr_tmp,
         R_Rp_rd => R_Rp_rd_tmp,
         R_Rq_addr => R_Rq_addr_tmp,
         R_Rq_rd => R_Rq_rd_tmp,
         Imm_data => instruction_tmp(15 downto 0),
         M_ALU_sel => M_ALU_sel_tmp,
         ALU_sel => ALU_sel_tmp,
         -- output
         Out_data => DP_Out_data,
         ALU_flag_equal => ALU_flag_equal_tmp,
         ALU_flag_bigger => ALU_flag_bigger_tmp,
         ALU_flag_u_bigger => ALU_flag_u_bigger_tmp
      );

   io_interface: iobuffer
      port map (
         -- input
         ibuf_in0 => in0,
         ibuf_in1 => in1,
         obuf_in => DP_Out_data,
         I_addr => IO_I_addr_tmp,
         I_en => IO_I_en_tmp,
         O_addr => IO_O_addr_tmp,
         O_en => IO_O_en_tmp,
         -- output
         ibuf_out => DP_In_data,
         obuf_out0 => out0,
         obuf_out1 => out1
      );

end architecture structure;