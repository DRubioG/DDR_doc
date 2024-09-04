library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity data_creator is
    Port ( 
        clk_in : in std_logic;
        rst : in std_logic;
        en_ddr : out std_logic;
        ddr_rdy : in std_logic;
        calib_complete : in std_logic;
        ddr_addr : out std_logic_vector(28 downto 0);
        ddr_cmd : out std_logic_vector(2 downto 0);
        -- write
        ddr_wren : out std_logic;
        ddr_wrend : out std_logic;
        ddr_wr_rdy : in std_logic;
        ddr_wr_data : out std_logic_vector(511 downto 0);
        --read
        ddr_rd_data_valid : in std_logic;
        ddr_rdend : in std_logic;
        ddr_rd_data : in std_logic_vector(511 downto 0)
    );
end data_creator;

architecture Behavioral of data_creator is

type fsm is (IDLE, WRITE, WRITE_END, READ, READ_END);
signal state : fsm;

signal cont : unsigned(ddr_addr'length-1 downto 0);
signal change_state : std_logic;

COMPONENT ila_0

PORT (
	clk : IN STD_LOGIC;

	probe0 : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
	probe1 : IN STD_LOGIC_VECTOR(28 DOWNTO 0); 
	probe2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	probe3 : IN STD_LOGIC;
	probe4 : in std_logic_vector(15 downto 0);
	probe5 : in std_logic_vector(28 downto 0)
);
END COMPONENT  ;
signal ddr_addr_s : std_logic_vector(ddr_addr'length-1 downto 0);
signal ddr_wr_data_s : std_logic_vector(511 downto 0);
signal ddr_cmd_s : std_logic_vector(2 downto 0);

begin

your_instance_name : ila_0
PORT MAP (
	clk => clk_in,

	probe0 => ddr_wr_data_s(15 downto 0), 
	probe1 => ddr_addr_s, 
	probe2 => ddr_cmd_s,
	probe3 => ddr_rdy,
	probe4 => ddr_rd_data(15 downto 0),
	probe5 => std_logic_vector(cont)
);

    ddr_addr <= ddr_addr_s;
    ddr_wr_data <= ddr_wr_data_s;
    ddr_cmd <= ddr_cmd_s;

    process(clk_in, rst, change_state)
    begin
        if rst = '1' then
            state <= IDLE;
            ddr_cmd_s <= "000";
            ddr_addr_s <= (others=>'0');
            en_ddr <= '0';
        elsif rising_edge(clk_in) then
            case state is
                when IDLE =>
                    ddr_addr_s <= (others=>'0');
                    ddr_cmd_s <= "000";
                    en_ddr <= '0';
                    if calib_complete = '1' then
                        state <= WRITE;
                    end if;
                when WRITE =>
                    ddr_cmd_s <= (others=>'0');
                    en_ddr <= '1';
                    ddr_wren <= '1';
                    if ddr_wr_rdy = '1' then
                        if ddr_rdy = '1' then
                            ddr_addr_s <= std_logic_vector(to_unsigned(0, ddr_addr_s'length-cont'length)) & std_logic_vector(cont);
                        end if;
                        ddr_wr_data_s <= std_logic_vector(to_unsigned(0, ddr_wr_data_s'length-cont'length)) & std_logic_vector(cont);
                        ddr_wrend <= '1';
--                    else
                    
                    end if;
                    if change_state = '1' then
                        state <= WRITE_END;
                    end if;
                when WRITE_END =>
                    en_ddr <= '0';
                    ddr_cmd_s <= "000";
                    if change_state = '1' then
                        state <= READ;
                    end if;
                when READ =>
                    en_ddr <= '1';
                    ddr_cmd_s <= (0=>'1',others=>'0');
                    if ddr_rd_data_valid = '1' then
                        ddr_addr_s <= std_logic_vector(to_unsigned(0, ddr_addr_s'length-cont'length)) & std_logic_vector(cont);
                    end if;
                    if change_state = '1' then
                        state <= READ_END;
                    end if;
                when READ_END =>
                    en_ddr <= '0';
                    ddr_addr_s <= (others=>'0');
                    ddr_cmd_s <= (0=>'1',others=>'0');
                    if change_state = '1' then
                        state <= IDLE;
                    end if;
                when others =>
                    en_ddr <= '0';
                    ddr_addr_s <= (others=>'0');
                    ddr_cmd_s <= "000";
                    state <= IDLE;
            end case;
        end if;
    end process;
    
    
    process(clk_in, rst, state)
    begin
        if rst = '1' then
            cont <= (others=>'0');
            change_state <= '0';
        elsif rising_edge(clk_in) then
            if state = WRITE then
                if ddr_wr_rdy = '1'then
                    change_state <= '0';
                    if cont >= to_unsigned(1000, ddr_addr'length) then --(0=>'0',cont'range=>'1') then
                        cont <= (others=>'0');
                        change_state <= '1';
                    else
                        cont <= cont +8;
                        
                    end if;
                 end if;
            elsif state = READ then 
                if ddr_rd_data_valid = '1'then
                    change_state <= '0';
                    if cont >= to_unsigned(1000, ddr_addr'length)  then --(0=>'0',cont'range=>'1') then
                        cont <= (others=>'0');
                        change_state <= '1';
                    else
                        cont <= cont +8;
                        
                    end if;
                 end if;
            else 
                change_state <= '0';
                if cont >= to_unsigned(1000, ddr_addr'length)  then --(0=>'0',cont'range=>'1') then
                    cont <= (others=>'0');
                    change_state <= '1';
                else
                    cont <= cont +8;
                end if;
             end if;
        end if;
    end process;

end Behavioral;
