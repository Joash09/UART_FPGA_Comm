----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Joash Naidoo
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity UART is
Port ( clk100 : in STD_LOGIC; -- Mapped to 100 Mhz system clock
       reset_btn : in STD_LOGIC; -- Map to user button
       uart_rx : in STD_LOGIC;
       uart_tx : out STD_LOGIC );
end UART;

architecture Behavioral of UART is

    type CHAR_ARRAY is array (integer range<>) of std_logic_vector(7 downto 0);
    constant WELCOME_STRING : CHAR_ARRAY(0 to 6) := (
                                                    X"48", -- H
                                                    X"65", -- e
                                                    X"6C", -- l
                                                    X"6C", -- l
                                                    X"6F", -- o
                                                    X"0A", -- \n
                                                    X"0D"  -- \r
                                                  );

    -- UART RX
    signal rx_busy : STD_LOGIC := '0';
    signal received_word : STD_LOGIC_VECTOR(7 downto 0);
    signal rdy : STD_LOGIC;

    -- UART Tx
    signal tx_en : STD_LOGIC:='0';
    signal tx_busy : STD_LOGIC;
    signal tx_data_in : STD_LOGIC_VECTOR(7 downto 0);
    signal reset : STD_LOGIC := '1';
    
    -- Send constant string
    signal str_index : integer range 0 to 7 := 0;
    
    -- Control
    -- '0'. First send constant pattern
    -- '1'. Echo user input from terminal
    signal cntrl : STD_LOGIC := '0';

begin

-- Notes: 
-- 1. Top Level Module to send constant pattern initially
-- 2. Then transmit received characters back to the terminal (echo input)

-- UART Rx
uart_rx_inst : entity work.uart_rx PORT MAP(
    clk => clk100,
    rx_in => uart_rx,
    busy_out => rx_busy,
    rdy => rdy,
    data_out => received_word
);

-- UART Tx
uart_tx_inst : entity work.uart_tx PORT MAP(
    clk => clk100,
    reset => reset,
    data_in => tx_data_in,
    en => tx_en,
    busy_out => tx_busy,
    tx_out => uart_tx
);

-- Print string to constant
process(clk100) begin
if rising_edge(clk100) then

    case (cntrl) is
    
        when '0' => if tx_en = '0' and tx_busy = '0' and str_index < 7 then -- Ready to transmit
                        tx_en <= '1';
                        tx_data_in <= WELCOME_STRING(str_index);
                        str_index <= str_index + 1;
                    elsif str_index = 7 then
                        cntrl <= '1'; -- Switch to echo 
                    else
                        tx_en <= '0';
                    end if;
        
        when '1' => if rdy = '1' then
                        tx_en <= '1';
                        tx_data_in <= received_word;
                    else
                        tx_en <= '0';
                    end if;
        when others =>
    end case;

end if;
end process;

end Behavioral;
