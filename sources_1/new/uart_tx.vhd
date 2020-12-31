----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Joash Naidoo
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_tx is
Port ( clk : in STD_LOGIC;
       reset : in STD_LOGIC;
       data_in : in STD_LOGIC_VECTOR(7 downto 0);
       en : in STD_LOGIC;
       busy_out : out STD_LOGIC;
       tx_out : out STD_LOGIC
       );
end uart_tx;

architecture Behavioral of uart_tx is

    constant clks_per_bit : integer :=  10417; -- 100 MHz / 9600 baud = 10417
    
    signal cnt : integer range 0 to clks_per_bit-1 := 0;
    signal busy : STD_LOGIC := '1'; -- For stability ? 
    signal bitcnt : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal en_old : STD_LOGIC := '0';

begin

    busy_out <= busy;

process(clk) begin
if rising_edge(clk) then

    -- Logic
    if busy = '0' then
        if en = '1' then
            -- Begin transaction        
            cnt <= clks_per_bit-1; -- Hold value for whole period
            en_old <= '1';
            busy <= '1';
            tx_out <= '0';
            bitcnt <= X"0";
        else
            tx_out <= '1';
        end if;
    
    else -- Busy=1. Continuing transaction
        
        if bitcnt = 0 then -- Keep transmitting start bit
            tx_out <= '0';
        elsif bitcnt >= 1 and bitcnt < 9 then -- Transmit corresponding data bit
            tx_out <= data_in(conv_integer(bitcnt)-1);
        else -- End of transmission
            tx_out <= '1'; 
        end if;
        
        if cnt = 0 then -- Only if ready to change to the next bit, change index
            if bitcnt < 9 then -- Still have bits to transmit
                bitcnt <= bitcnt + 1; 
                if bitcnt < 8 then
                cnt <= clks_per_bit-1; -- Reset the counter
                else
                cnt <= clks_per_bit-100; -- Reset the counter
                end if;
            else -- No more bits to transmit
                busy <= '0';
                bitcnt <= X"0";
            end if;

        else 
            cnt <= cnt - 1;
        end if;
    
    end if;
    
end if;
end process;
    
end Behavioral;
