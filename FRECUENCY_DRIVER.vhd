----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 13.03.2026 01:05:51
-- Design Name:
-- Module Name: pulseGenerator - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FRECUENCY_DRIVER is
    Port ( 	CLK : in STD_LOGIC;
			DATA_IN : in STD_LOGIC_VECTOR(7 DOWNTO 0);-- ENTRADA (BUS DE DATOS)
			SERVO_INCRE : out STD_LOGIC; 
			SERVO_DECRE : out STD_LOGIC);  
			  --DEBUGER2 : out STD_LOGIC); 
end FRECUENCY_DRIVER;


architecture Behavioral of FRECUENCY_DRIVER is
------------------------------------------------------
--			Constantes y Señales por Proceso
------------------------------------------------------


-----------------------------------------
-- 				CLOCK_GENERATOR
-----------------------------------------
--Constantes:
CONSTANT  HALF_ON_OFF_FREC : integer:= 500_000;

--Señales:
SIGNAL CONT : INTEGER := 0;
SIGNAL FLAG : STD_LOGIC:= '0';


begin



-----------------------------------------
-- 				CLOCK_GENERATOR
-----------------------------------------
CLOCK_GENERATOR:process(CLK)

    begin
        IF rising_edge(CLK) then --
            IF CONT =  HALF_ON_OFF_FREC then
            CONT <= 0;
            FLAG <= NOT FLAG;
            else
                CONT <= CONT + 1;
            end if;

        END IF;
    END process;
	 
	 
 PROC : PROCESS(CLK,DATA_IN, FLAG)
begin
IF RISING_EDGE(CLK) THEN
    case( DATA_IN ) is
    

        when "00011000" => SERVO_INCRE <= FLAG; --ARRIBA DERECHA
        when "00111000" => SERVO_DECRE <= FLAG; --ARRIBA IZQUIERDA
		  
        when others =>

        SERVO_DECRE <= '0';
        SERVO_DECRE <= '0';
    end case;
END IF;
END PROCESS;


end Behavioral;