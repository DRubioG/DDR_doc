library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity data_creator is
    Port ( 
        clk_in : in std_logic;
        rst : in std_logic;
        en_ddr : out std_logic;
        ddr_addr : out std_logic_vector(28 downto 0);
        ddr_cmd : out std_logic_vector(2 downto 0);
        -- write
        ddr_wren : out std_logic;
        ddr_wrend : out std_logic;
        ddr_wr_rdy : in std_logic;
        ddr_wr_data : out std_logic_vector(511 downto 0);
        --read
        ddr_rden : in std_logic;
        ddr_rdend : in std_logic;
        ddr_rd_rdy : in std_logic;
        ddr_rd_data : in std_logic_vector(511 downto 0)
    );
end data_creator;

architecture Behavioral of data_creator is

type fsm is (IDLE, WRITE, WRITE_END, READ, READ_END);
signal state : fsm;

begin


end Behavioral;
