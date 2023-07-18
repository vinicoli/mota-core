---------------------------------------------------------
-- ELE0517 - SISTEMAS DIGITAIS - T01 (2023.1 - 35N34)
-- Professor: VICTOR ARAUJO FERRAZ
-- Alunos:	Cintia Mafra
--          Vinicius Oliveira
-- 07/2023

-- controller (FSM)
---------------------------------------------------------

-- Declaring libraries
library ieee;
use ieee.std_logic_1164.all;

---------------------------------------------------------

-- controller entity
entity controller is
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
   IO_I_addr:          out std_logic_vector(1 downto 0);
   IO_I_en:            out std_logic;
   IO_O_addr:          out std_logic_vector(1 downto 0);
   IO_O_en:            out std_logic;
   M_PC_sel:           out std_logic_vector(1 downto 0);
   SP_pop:             out std_logic;
   SP_push:            out std_logic;
   PC_ld:              out std_logic;
   I_rw:               out std_logic
   );
end controller ;

architecture fsm of controller is

   type State_type is (RESET, FETCH, DECODE, ANDX, XORX, SLLX, ADDX, DIV, SRAX, DEC, SUBI, ORI, SRLI, SLAI, LD, ST, COP, BEQ, BGE, BGEU, JMP, CALL, RET, INX, OUTX);
   signal actual_state, future_state: State_type;
   signal opcode:  std_logic_vector(4 downto 0) := instruction(31 downto 27);

begin

   p1: process(ctrl_clk, ctrl_rst)
   begin
      if ctrl_rst = '1' then
         actual_state <= RESET;
      elsif rising_edge(ctrl_clk) then
         actual_state <= future_state;
      end if;
   end process p1;

   p2: process(actual_state, instruction)
   begin
      case actual_state is
         when RESET =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "01";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '0';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(18 downto 15);
            R_Rq_rd <= '0';
            M_ALU_sel <= '0';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when FETCH =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '1';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "01";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '0';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(18 downto 15);
            R_Rq_rd <= '0';
            M_ALU_sel <= '0';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= DECODE;

         when DECODE =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "01";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '0';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(18 downto 15);
            R_Rq_rd <= '0';
            M_ALU_sel <= '0';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
				
            -- next state
            if opcode = "00000" then future_state <= ANDX;
            elsif opcode = "00001" then future_state <= XORX;
            elsif opcode = "00010" then future_state <= SLLX;
            elsif opcode = "00011" then future_state <= ADDX;
            elsif opcode = "00100" then future_state <= DIV;
            elsif opcode = "00101" then future_state <= SRAX;
            elsif opcode = "00110" then future_state <= DEC;
            elsif opcode = "00111" then future_state <= SUBI;
            elsif opcode = "01000" then future_state <= ORI;
            elsif opcode = "01001" then future_state <= SRLI;
            elsif opcode = "01010" then future_state <= SLAI;
            elsif opcode = "01011" then future_state <= LD;
            elsif opcode = "01100" then future_state <= ST;
            elsif opcode = "01101" then future_state <= COP;
            elsif opcode = "01110" then future_state <= BEQ;
            elsif opcode = "01111" then future_state <= BGE;
            elsif opcode = "10000" then future_state <= BGEU;
            elsif opcode = "10001" then future_state <= JMP;
            elsif opcode = "10010" then future_state <= CALL;
            elsif opcode = "10011" then future_state <= RET;
            elsif opcode = "10100" then future_state <= INX;
            elsif opcode = "10101" then future_state <= OUTX;
            else future_state <= FETCH;
            end if;
				
         when ANDX =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);
            R_Rq_rd <= '1';
            M_ALU_sel <= '1';
            ALU_sel <= "0000";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when XORX =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);
            R_Rq_rd <= '1';
            M_ALU_sel <= '1';
            ALU_sel <= "0001";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when SLLX =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);
            R_Rq_rd <= '1';
            M_ALU_sel <= '1';
            ALU_sel <= "0010";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when ADDX =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);
            R_Rq_rd <= '1';
            M_ALU_sel <= '1';
            ALU_sel <= "0011";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when DIV =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);
            R_Rq_rd <= '1';
            M_ALU_sel <= '1';
            ALU_sel <= "0100";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when SRAX =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);
            R_Rq_rd <= '1';
            M_ALU_sel <= '1';
            ALU_sel <= "0101";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when DEC =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);   -- dont care
            R_Rq_rd <= '0';
            M_ALU_sel <= '1';
            ALU_sel <= "0110";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when SUBI =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);   -- dont care
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(22 downto 19);
            R_Rq_rd <= '1';
            M_ALU_sel <= '0';
            ALU_sel <= "0111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when ORI =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);   -- dont care
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(22 downto 19);
            R_Rq_rd <= '1';
            M_ALU_sel <= '0';
            ALU_sel <= "1000";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when SRLI =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);   -- dont care
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(22 downto 19);
            R_Rq_rd <= '1';
            M_ALU_sel <= '0';
            ALU_sel <= "1001";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when SLAI =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);   -- dont care
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(22 downto 19);
            R_Rq_rd <= '1';
            M_ALU_sel <= '0';
            ALU_sel <= "1010";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when LD =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "01";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);   -- dont care
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(18 downto 15);   -- dont care
            R_Rq_rd <= '0';
            M_ALU_sel <= '0';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when ST =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '1';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);    -- dont care
            R_W_wr <= '0';
            R_Rp_addr <= instruction(26 downto 23);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);   -- dont care
            R_Rq_rd <= '0';
            M_ALU_sel <= '0';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when COP =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "10";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);   -- dont care
            R_Rq_rd <= '0';
            M_ALU_sel <= '1';
            ALU_sel <= "1011";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when BEQ =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);    -- dont care
            R_W_wr <= '0';
            R_Rp_addr <= instruction(26 downto 23);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(22 downto 19);
            R_Rq_rd <= '1';
            M_ALU_sel <= '1';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            if ALU_flag_equal = '1' then
               future_state <= JMP;
            else
               future_state <= FETCH;
            end if;

         when BGE =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);    -- dont care
            R_W_wr <= '0';
            R_Rp_addr <= instruction(26 downto 23);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(22 downto 19);
            R_Rq_rd <= '1';
            M_ALU_sel <= '1';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            if ALU_flag_equal = '1' or ALU_flag_bigger = '1' then
               future_state <= JMP;
            else
               future_state <= FETCH;
            end if;

         when BGEU =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);    -- dont care
            R_W_wr <= '0';
            R_Rp_addr <= instruction(26 downto 23);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(22 downto 19);
            R_Rq_rd <= '1';
            M_ALU_sel <= '1';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            if ALU_flag_equal = '1' or ALU_flag_u_bigger = '1' then
               future_state <= JMP;
            else
               future_state <= FETCH;
            end if;

         when JMP =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '1';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "10";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);    -- dont care
            R_W_wr <= '0';
            R_Rp_addr <= instruction(22 downto 19);    -- dont care
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(18 downto 15);   -- dont care
            R_Rq_rd <= '0';
            M_ALU_sel <= '1';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when CALL =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '1';
            SP_push <= '1';
            SP_pop <= '0';
            M_PC_sel <= "10";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);    -- dont care
            R_W_wr <= '0';
            R_Rp_addr <= instruction(22 downto 19);    -- dont care
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(18 downto 15);   -- dont care
            R_Rq_rd <= '0';
            M_ALU_sel <= '1';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when RET =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '1';
            SP_push <= '0';
            SP_pop <= '1';
            M_PC_sel <= "00";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);    -- dont care
            R_W_wr <= '0';
            R_Rp_addr <= instruction(22 downto 19);    -- dont care
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(18 downto 15);   -- dont care
            R_Rq_rd <= '0';
            M_ALU_sel <= '1';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= "00";
            IO_I_en <= '0';
            IO_O_addr <= "00";
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when INX =>
            -- related to pc/instruction memory
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "00";
            R_W_addr <= instruction(26 downto 23);
            R_W_wr <= '1';
            R_Rp_addr <= instruction(22 downto 19);    -- dont care
            R_Rp_rd <= '0';
            R_Rq_addr <= instruction(18 downto 15);   -- dont care
            R_Rq_rd <= '0';
            M_ALU_sel <= '1';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= instruction(22 downto 21);
            IO_I_en <= '1';
            IO_O_addr <= instruction(22 downto 21);
            IO_O_en <= '0';
            
				-- next state
            future_state <= FETCH;

         when OUTX =>
            I_rw <= '0';
            PC_ld <= '0';
            SP_push <= '0';
            SP_pop <= '0';
            M_PC_sel <= "11";
            -- related to register file/data memory
            D_rw <= '0';
            M_R_sel <= "11";
            R_W_addr <= instruction(26 downto 23);    -- dont care
            R_W_wr <= '0';
            R_Rp_addr <= instruction(26 downto 23);
            R_Rp_rd <= '1';
            R_Rq_addr <= instruction(18 downto 15);   -- dont care
            R_Rq_rd <= '0';
            M_ALU_sel <= '1';
            ALU_sel <= "1111";
            -- related to In/Out
            IO_I_addr <= instruction(22 downto 21);
            IO_I_en <= '0';
            IO_O_addr <= instruction(22 downto 21);
            IO_O_en <= '1';
            
            -- next state
            future_state <= FETCH;


         when others => future_state <= FETCH;

      end case;
   end process p2;

end fsm; -- arch