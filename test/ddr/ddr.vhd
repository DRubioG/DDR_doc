library ieee;
use ieee.std_logic_1164.all;

entity ddr is
    port(
        -- DDR3 Physical Interface Signals
        --Inouts
        ddr3_dq : inout std_logic_vector(15 downto 0);
        ddr3_dqs_n : inout std_logic_vector(1 downto 0);
        ddr3_dqs_p : inout std_logic_vector(1 downto 0);
        -- Outputs
        ddr3_addr : out std_logic_vector(13 downto 0);
        ddr3_ba : out std_logic_vector(2 downto 0);
        ddr3_ras_n : out std_logic;
        ddr3_cas_n : out std_logic;
        ddr3_we_n : out std_logic;
        ddr3_reset_n : out std_logic;
        ddr3_ck_p : out std_logic;
        ddr3_ck_n : out std_logic;
        ddr3_cke : out std_logic;
        ddr3_cs_n : out std_logic;
        ddr3_dm : out std_logic_vector(1 downto 0);
        ddr3_odt : out std_logic;
       
        -- LEDs to signal pass/fail
        led_pass : out std_logic;
        led_fail : out std_logic;
        led_calib : out std_logic
    );
end entity;

architecture arch_ddr of ddr is

type fsm is (IDLE, WRITE, WRITE_DONE, READ, READ_DONE, PARK);
signal state : fsm;

begin

    process(ui_clk, ui_clk_sync_rst)
    begin
        if rst = '1' then
            state <= IDLE;
            app_en <= 0;
            app_wdf_wren <= 0;
        elsif rising_edge(clk) then
            case state is
                when IDLE =>
                    if calib_done = '1' then
                        state <= WRITE;
                    end if;    
                when WRITE =>
                    if app_rdy = '1' and app_wdf_rdy = '1' then
                        state <= WRITE_DONE;
                        app_en <= '1';
                        app_wdf_wren <= '1';
                        app_addr <= '0';
                        app_cmd <= CMD_WRITE;
                        app_wdf_data <= data_to_write;
                    end if;
                when WRITE_DONE =>
                    if app_rdy = '1' and app_en = '1' then
                        app_en <= '0';
                    end if;

                    if app_wdf_rdy = '1' and app_wdf_wren = '1' then
                        app_wdf_wren <= '0';
                    end if;

                    if app_en = '0' and app_wdf_wren = '0' then
                        state <= READ;
                    end if;
                when READ =>
                    if app_rdy = '1' then
                        app_en <= '1';
                        app_addr <= '0';
                        app_cmd <= CMD_READ;
                        state < READ_DONE;
                    end if;
                when READ_DONE =>
                    if app_rdy = '1' and app_en = '1' then
                        app_en <= '0';
                    end if;

                    if app_rd_data_valid = '1' then
                        data_read_from_memory <= app_rd_data;
                        state <= PARK;
                    end if;
                when PARK =>
                    if data_to_write = data_read_from_memory then
                        led_pass <= '0';
                    elsif data_to_write /= data_read_from_memory then
                        led_fail <= '0';
                    end if;
                when others =>
                    state <= IDLE;
            end case;
        end if;
    end process;

end architecture;