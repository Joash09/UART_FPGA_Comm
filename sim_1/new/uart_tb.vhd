----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Joash Naidoo
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_tb is
end uart_tb;

architecture Behavioral of uart_tb is

    constant CLK_PERIOD : time := 10ns;
    constant UART_PERIOD : time := 104170 ns; -- 100 MHz / 9600 baud ~ 10417 * 10ns
    signal clk : STD_LOGIC := '0';

    -- TX
--    signal tx_byte_in : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
--    signal tx_en : STD_LOGIC := '0';
--    signal tx_busy : STD_LOGIC;
--    signal tx_out : STD_LOGIC;
    
--    -- RX
--    signal rx_in : STD_LOGIC;
--    signal rx_busy : STD_LOGIC;
--    signal rx_out : STD_LOGIC_VECTOR(7 downto 0);
    
--    -- Full UART Module
      signal uart_rx, uart_tx : STD_LOGIC;
      signal reset : STD_LOGIC := '0';

    procedure WRITE_BYTE( -- Simplifies testing
        byte_in : in STD_LOGIC_VECTOR(7 downto 0); 
        signal data_o : out STD_LOGIC
    ) is
    begin
        data_o <= '0'; -- Send start bit
        wait for UART_PERIOD;
        for i in 0 to 7 loop -- Acts like a software loop 
            data_o <= byte_in(i);
            wait for UART_PERIOD;
        end loop;
        data_o <= '1'; -- Send stop bit
        wait for UART_PERIOD;
    end procedure;


begin

--    uart_tx_inst : entity work.UART_tx PORT MAP(
--        clk => clk,
--        data_in => tx_byte_in,
--        en => tx_en,
--        busy_out => tx_busy,
--        tx_out => tx_out
--    );
    
--    uart_rx_inst : entity work.UART_Rx PORT MAP(
--        clk => clk,
--        rx_in => rx_in,
--        busy_out => rx_busy,
--        data_out => rx_out
--    );
    
    uart_loopback_inst : entity work.UART PORT MAP(
        clk100 => clk,
        reset_btn => reset,
        uart_rx => uart_rx,
        uart_tx => uart_tx
    );

clk_proc : process begin
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
    clk <= '0';
end process;

stim_proc : process begin

    wait until rising_edge(clk);
    wait until rising_edge(clk);

--    report "Testing Modules Separately";
--    -- Send command to receive
--    wait until rising_edge(clk);
--    WRITE_BYTE(X"55", rx_in); -- This takes a really long time
--    wait until rising_edge(clk);
    
--    -- Send command to transmit
--    wait until rising_edge(clk);
--    tx_en <= '1';
--    tx_byte_in <= X"77";
--    wait until rising_edge(clk);
--    tx_en <= '0';
--    wait until tx_busy = '0'; -- Wait until this transaction has finished
    
--    report "UART Loopback";
      wait for 10000 us;
      WRITE_BYTE(X"77", uart_rx);
      wait;
    
    
end process;

end Behavioral;
