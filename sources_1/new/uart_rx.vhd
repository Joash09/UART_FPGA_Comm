----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Joash Naidoo
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_rx is
Port ( clk : in STD_LOGIC;
       rx_in : in STD_LOGIC;
       busy_out : out STD_LOGIC;
       rdy : out STD_LOGIC;
       data_out : out STD_LOGIC_VECTOR(7 downto 0));
end uart_rx;

architecture Behavioral of uart_rx is
    
    constant clks_per_bit : integer := 10417; -- 100 MHz / 9600 baud = 10417
    
    signal cnt : integer range 0 to clks_per_bit-1 := 0;
    signal rx_data : STD_LOGIC := '0';
    signal busy : STD_LOGIC := '0';
    signal num_bits : STD_LOGIC_VECTOR(3 downto 0) := (others => '0'); -- Count to 8 
    signal data_out_buf : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');

begin

-- Notes:
-- 1. Falling bit indicates start of transmission
-- 2. Asynchronous transmission. Count down to find middle of bit 
-- 3. If collected 8 bit after start bit, transmit the word back 


process(clk) begin
if rising_edge(clk) then
    rx_data <= rx_in;
    if busy = '0' then
        
        if rx_data = '0' then -- Start of transmission
            busy <= '1';
            num_bits <= X"0";
        end if;
        
        rdy <= '0'; -- Want the rdy flag to pull high one clock cycle when word complete
        cnt <= ((clks_per_bit-1)/2); -- Start Bit so only need to look half period 
    
    else -- busy = '1'. Sampling the rest of the bits in frame
    
        -- Start searching for middle of bit by counting down
        if cnt = 0 then -- Found middle
            
            if num_bits = 0 then -- first (start) bit sampled 
                busy <= not rx_data;
                num_bits <= num_bits + 1;
            elsif num_bits = 9 then -- Sampled all bits
                rdy <= '1'; -- Want the rdy flag to pull high one clock cycle when sampled word complete
                busy <= '0';
                data_out <= data_out_buf;
            else -- Still sampling
                data_out_buf(conv_integer(num_bits)-1) <= rx_data;
                busy <= '1';
                num_bits <= num_bits + 1;
            end if;
            
            cnt <= clks_per_bit-1; -- Reset. Next middle is one whole period away
        
        else -- Still finding middle (i.e. counting up)
            cnt <= cnt - 1;
        end if;    
    
    end if;

    busy_out <= busy;

end if;
end process;

end Behavioral;
