library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TX_TRASMITTER is
    Port ( 
        CLK      : in  STD_LOGIC;
        RESET    : in  STD_LOGIC;
        D        : in  STD_LOGIC_VECTOR(7 DOWNTO 0);
        SEND     : in  STD_LOGIC;
        BUSSY    : out STD_LOGIC := '0';
        TX_OUT   : out STD_LOGIC;
        DEBUGER  : out STD_LOGIC;
        DEBUGER2 : out STD_LOGIC
    ); 
end TX_TRASMITTER;

architecture Behavioral of TX_TRASMITTER is
    constant BAUD_RATE : integer := 9600; 
    constant N_CM_BIT_CHANGE : INTEGER := (50_000_000 + (BAUD_RATE/2)) / BAUD_RATE; 
    
    constant BIT_START_TIME : integer := 1 * N_CM_BIT_CHANGE;
    constant BIT_1_TIME     : integer := 2 * N_CM_BIT_CHANGE;
    constant BIT_2_TIME     : integer := 3 * N_CM_BIT_CHANGE;
    constant BIT_3_TIME     : integer := 4 * N_CM_BIT_CHANGE;
    constant BIT_4_TIME     : integer := 5 * N_CM_BIT_CHANGE;
    constant BIT_5_TIME     : integer := 6 * N_CM_BIT_CHANGE;
    constant BIT_6_TIME     : integer := 7 * N_CM_BIT_CHANGE;
    constant BIT_7_TIME     : integer := 8 * N_CM_BIT_CHANGE;
    -- CORRECCIÓN CRÍTICA: El bit de parada debe ser el tiempo 9, no el 10
    constant BIT_STOP_TIME  : integer := 9 * N_CM_BIT_CHANGE; 

    signal RESET_NOW    : STD_LOGIC := '0';
    signal RESET_BEFORE : STD_LOGIC := '0';
    signal SEND_NOW     : STD_LOGIC := '0';
    signal SEND_BEFORE  : STD_LOGIC := '0';

    signal TX_SIGNAL    : STD_LOGIC := '1';
    signal BUSSY_SIGNAL : STD_LOGIC := '0';
    signal CLK_CONT     : INTEGER := 0;
    signal DEBUGER_SIGNAL : STD_LOGIC := '0';
begin
    TX_SEND : PROCESS(CLK)
    begin
        IF RISING_EDGE(CLK) THEN
            RESET_BEFORE <= RESET_NOW;
            RESET_NOW    <= RESET;
            SEND_BEFORE  <= SEND_NOW;
            SEND_NOW     <= SEND;

            IF RESET_BEFORE = '0' AND RESET_NOW = '1' THEN
                TX_SIGNAL    <= '1';                 
                BUSSY_SIGNAL <= '0';                 
                CLK_CONT     <= 0;
            
            ELSIF SEND_BEFORE = '0' AND SEND_NOW = '1' AND BUSSY_SIGNAL = '0' THEN
                BUSSY_SIGNAL <= '1';                 
                TX_SIGNAL    <= '0';                 
                CLK_CONT     <= 0;                   
                
            ELSIF BUSSY_SIGNAL = '1' THEN
                CLK_CONT <= CLK_CONT + 1;            
                
                CASE CLK_CONT IS
                    WHEN BIT_START_TIME => TX_SIGNAL <= D(0);
                    WHEN BIT_1_TIME => TX_SIGNAL <= D(1);
                    WHEN BIT_2_TIME => TX_SIGNAL <= D(2);
                    WHEN BIT_3_TIME => TX_SIGNAL <= D(3);
                    WHEN BIT_4_TIME => TX_SIGNAL <= D(4);
                    WHEN BIT_5_TIME => TX_SIGNAL <= D(5);
                    WHEN BIT_6_TIME => TX_SIGNAL <= D(6);
                    WHEN BIT_7_TIME => TX_SIGNAL <= D(7);
                    WHEN BIT_STOP_TIME =>
                        TX_SIGNAL    <= '1';         
                        BUSSY_SIGNAL <= '0';         
                        DEBUGER_SIGNAL <= NOT(DEBUGER_SIGNAL);
                    WHEN OTHERS => NULL;
                END CASE;
            END IF;
        END IF;
    END PROCESS;

    TX_OUT   <= TX_SIGNAL;
    BUSSY    <= BUSSY_SIGNAL;
    DEBUGER  <= DEBUGER_SIGNAL;
    DEBUGER2 <= SEND;

end Behavioral;