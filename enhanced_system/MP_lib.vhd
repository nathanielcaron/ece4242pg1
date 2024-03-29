-- Library for Microprocessor example
library    ieee;
use ieee.std_logic_1164.all;  
use ieee.std_logic_arith.all;

package MP_lib is

constant ZERO 			: std_logic_vector(15 downto 0) := "0000000000000000";
constant HIRES 		: std_logic_vector(15 downto 0) := "ZZZZZZZZZZZZZZZZ";
constant mov1 			: std_logic_vector(3 downto 0) := "0000";
constant mov2 			: std_logic_vector(3 downto 0) := "0001";
constant mov3 			: std_logic_vector(3 downto 0) := "0010";
constant mov4 			: std_logic_vector(3 downto 0) := "0011";
constant mov4_12 		: std_logic_vector(3 downto 0) := "1100";
constant add  			: std_logic_vector(3 downto 0) := "0100";
constant subt 			: std_logic_vector(3 downto 0) := "0101";
constant jz  			: std_logic_vector(3 downto 0) := "0110";
constant halt  		: std_logic_vector(3 downto 0) := "1111";
constant readm  		: std_logic_vector(3 downto 0) := "0111";
constant mult			: std_logic_vector(3 downto 0) := "1000";
constant div			: std_logic_vector(3 downto 0) := "1001";
constant greater 		: std_logic_vector(3 downto 0) := "1010";
constant mov5 			: std_logic_vector(3 downto 0) := "1011";

component cache is
port(

	 rst               :     in std_logic;
	 clock_a           :     in std_logic;
    addr_a           :     in std_logic_vector(9 downto 0);
    data_in_a        :     in std_logic_vector(15 downto 0);
    ram_input        :     out std_logic_vector(31 downto 0);
    we_a             :     in std_logic;
    re_a             :     in std_logic;

	 cache_ready      :     out std_logic := '1';
	 addr_b           :     out std_logic_vector(8 downto 0);
	 we_b             :     out std_logic;
    re_b             :     out std_logic;
	 data_out_a       :     out std_logic_vector(15 downto 0);
    ram_output       :     in std_logic_vector(31 downto 0);
	 hit              :     out std_logic;
	 cachew0_db       :     out std_logic_vector(15 downto 0);
	 cachew1_db       :     out std_logic_vector(15 downto 0);
	 cachew2_db       :     out std_logic_vector(15 downto 0);
	 cachew3_db       :     out std_logic_vector(15 downto 0);
	 cachew4_db       :     out std_logic_vector(15 downto 0);
	 cachew5_db       :     out std_logic_vector(15 downto 0);
	 cachew6_db       :     out std_logic_vector(15 downto 0);
	 cachew7_db       :     out std_logic_vector(15 downto 0);
	 init_count_db : out std_logic_vector(1 downto 0);
	 c_state : out std_logic_vector(7 downto 0)
);
end component;

component ram32bus is
port(
		address     : IN STD_LOGIC_VECTOR (8 DOWNTO 0);
	   clock       : IN STD_LOGIC  := '1';
	   data        : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
	   rden        : IN STD_LOGIC  := '1';
	   wren        : IN STD_LOGIC ;
	   q           : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
	
);
end component;

component CPU is
port (    
        cpu_clk      : in std_logic;
        cpu_rst      : in std_logic;
        mdout_bus    : in std_logic_vector(15 downto 0); 
        mdin_bus     : out std_logic_vector(15 downto 0); 
        mem_addr     : out std_logic_vector(9 downto 0);
        Mre_s        : out std_logic;
        Mwe_s        : out std_logic;    
        oe_s         : out std_logic;
        -- Debug variables: output to upper level for simulation purpose only
        D_rfout_bus	: out std_logic_vector(15 downto 0);  
        D_RFwa_s, D_RFr1a_s, D_RFr2a_s: out std_logic_vector(3 downto 0);
        D_RFwe_s, D_RFr1e_s, D_RFr2e_s: out std_logic;
        D_RFs_s 		: out std_logic_vector(1 downto 0);
		  D_ALUs_s 		: out std_logic_vector(2 downto 0);
        D_PCld_s, D_jpz_s: out std_logic;
        -- end debug variables
        cache_ready  : in std_logic;
		  ctrl_state 	: out std_logic_vector(7 downto 0);
		  D_PC			: out std_logic_vector(15 downto 0);
		  D_Inst_count	: out std_logic_vector(15 downto 0)
);
end component;

component alu is
port (    
        num_A:     in std_logic_vector(15 downto 0);
        num_B:     in std_logic_vector(15 downto 0);
        jpsign:    in std_logic;
        ALUs:      in std_logic_vector(2 downto 0);
        ALUz:      out std_logic;
        ALUout:    out std_logic_vector(15 downto 0)
);
end component;

component addrmux is
port(
    Ia:        in std_logic_vector(15 downto 0);
    Ib:        in std_logic_vector(15 downto 0);      
    Ic:        in std_logic_vector(15 downto 0);
    Id:        in std_logic_vector(15 downto 0);
    Option:    in std_logic_vector(1 downto 0);
    Muxout:    out std_logic_vector(15 downto 0)
);
end component;

component controller is
port(    
    clock:        in std_logic;
    rst:          in std_logic;
    IR_word:      in std_logic_vector(15 downto 0);
	 cache_ready:  in std_logic;
    RFs_ctrl:     out std_logic_vector(1 downto 0);
    RFwa_ctrl:    out std_logic_vector(3 downto 0);
    RFr1a_ctrl:   out std_logic_vector(3 downto 0);
    RFr2a_ctrl:   out std_logic_vector(3 downto 0);
    RFwe_ctrl:    out std_logic;
    RFr1e_ctrl:   out std_logic;
    RFr2e_ctrl:   out std_logic;                         
    ALUs_ctrl:    out std_logic_vector(2 downto 0);     
    jmpen_ctrl:   out std_logic;
    PCinc_ctrl:   out std_logic;
    PCclr_ctrl:   out std_logic;
    IRld_ctrl:    out std_logic;
    Ms_ctrl:      out std_logic_vector(1 downto 0);
    Mre_ctrl:     out std_logic;
    Mwe_ctrl:     out std_logic;
    oe_ctrl:	out std_logic;
	 ctrl_state : out std_logic_vector(7 downto 0)
      
);
end component;

component IR is
port(    
    IRin:      in std_logic_vector(15 downto 0);
    IRld:      in std_logic;
    dir_addr:  out std_logic_vector(15 downto 0);
    IRout:     out std_logic_vector(15 downto 0)
);
end component;

component obuf is
port(    
    O_en:         in std_logic;
    obuf_in:      in std_logic_vector(15 downto 0);
    obuf_out:     out std_logic_vector(15 downto 0)
);
end component;

component PC is
port(    
    clock:    in std_logic;
    PCld:     in std_logic;
    PCinc:    in std_logic;
    PCclr:    in std_logic;
    PCin:     in std_logic_vector(15 downto 0);
    PCout:    out std_logic_vector(15 downto 0);
	 Inst_count: out std_logic_vector(15 downto 0)
);
end component;

component reg_file is
port (
    clock    :     in std_logic;     
    rst      :     in std_logic;
    RFwe     :     in std_logic;
    RFr1e    :     in std_logic;
    RFr2e    :     in std_logic;    
    RFwa     :     in std_logic_vector(3 downto 0);  
    RFr1a    :     in std_logic_vector(3 downto 0);
    RFr2a    :     in std_logic_vector(3 downto 0);
    RFw      :     in std_logic_vector(15 downto 0);
    RFr1     :     out std_logic_vector(15 downto 0);
    RFr2     :     out std_logic_vector(15 downto 0)
);
end component;

component datamux is
port(
    I0:       in std_logic_vector(15 downto 0);
    I1:       in std_logic_vector(15 downto 0);      
    I2:       in std_logic_vector(15 downto 0);
    Sel:      in std_logic_vector(1 downto 0);
    O:        out std_logic_vector(15 downto 0)
    );
end component;

component ctrl_unit is
port(
    clock_cu:     in      std_logic;
    rst_cu:       in      std_logic;
    PCld_cu:      in      std_logic;
    mdata_out:    in      std_logic_vector(15 downto 0);
    dpdata_out:   in      std_logic_vector(15 downto 0);
    maddr_in:     out     std_logic_vector(15 downto 0);          
    immdata:      out     std_logic_vector(15 downto 0);
    RFs_cu:       out     std_logic_vector(1 downto 0);
    RFwa_cu:      out     std_logic_vector(3 downto 0);
    RFr1a_cu:     out     std_logic_vector(3 downto 0);
    RFr2a_cu:     out     std_logic_vector(3 downto 0);
    RFwe_cu:      out     std_logic;
    RFr1e_cu:     out     std_logic;
    RFr2e_cu:     out     std_logic;
    jpen_cu:      out     std_logic;
    ALUs_cu:      out     std_logic_vector(2 downto 0);    
    Mre_cu:       out     std_logic;
    Mwe_cu:       out     std_logic;
    oe_cu:        out     std_logic;
    cache_ready:  in std_logic;
	 ctrl_state : 	out std_logic_vector(7 downto 0);
	 D_PC			: 	out std_logic_vector(15 downto 0);
	 Inst_count: 	out std_logic_vector(15 downto 0)
);
end component;

component datapath is                
port(
    clock_dp:      in     std_logic;
    rst_dp:        in     std_logic;
    imm_data:      in     std_logic_vector(15 downto 0);
    mem_data:      in     std_logic_vector(15 downto 0);
    RFs_dp:        in     std_logic_vector(1 downto 0);
    RFwa_dp:       in     std_logic_vector(3 downto 0);
    RFr1a_dp:      in     std_logic_vector(3 downto 0);
    RFr2a_dp:      in     std_logic_vector(3 downto 0);
    RFwe_dp:       in     std_logic;
    RFr1e_dp:      in     std_logic;
    RFr2e_dp:      in     std_logic;
    jp_en:         in     std_logic;
    ALUs_dp:       in     std_logic_vector(2 downto 0);
    ALUz_dp:       out    std_logic;
    RF1out_dp:     out    std_logic_vector(15 downto 0);
    ALUout_dp:     out    std_logic_vector(15 downto 0)
);
end component;

end MP_lib;



package body MP_lib is

    -- Procedure Body (optional)

end MP_lib;
