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

entity SERVO_DRIVER is
    Port ( 	CLK : in STD_LOGIC;
			
			SERVO_INCRE : in STD_LOGIC; --
			SERVO_DECRE : in STD_LOGIC;  --
            CONTROL_POS : out STD_LOGIC);-- 
			  --DEBUGER2 : out STD_LOGIC); 
end SERVO_DRIVER;


architecture Behavioral of SERVO_DRIVER is
------------------------------------------------------
--			Constantes y Señales por Proceso
------------------------------------------------------


-----------------------------------------
-- 				CLOCK_GENERATOR
-----------------------------------------
--Constantes:
CONSTANT STEP: INTEGER:= 1000;

--Señales:                                       MIN: 2ms    MAX: 20ms
SIGNAL  HALF_ON_OFF_FREC : integer:= 50_000; -- MIN: 100_000 MAX: 1_000_000
SIGNAL CONT : INTEGER := 0;
SIGNAL FLAG : STD_LOGIC:= '1';




-----------------------------------------
-- 				SERVO_PWM
-----------------------------------------
SIGNAL SERVO_INCRE_NOW : STD_LOGIC := '0';
SIGNAL SERVO_INCRE_BEFORE : STD_LOGIC := '0';

SIGNAL SERVO_DECRE_NOW : STD_LOGIC := '0';
SIGNAL SERVO_DECRE_BEFORE : STD_LOGIC := '0';


begin



-----------------------------------------
-- 				CLOCK_GENERATOR
-----------------------------------------
CLOCK_GENERATOR:process(CLK)

begin

    IF RISING_EDGE(CLK) THEN
        --ACTUALIZAMOS FFP DE SERVO_INCRE:
        SERVO_INCRE_BEFORE <= SERVO_INCRE_NOW;
        SERVO_INCRE_NOW <= SERVO_INCRE;

        --ACTUALIZAMOS FFP DE SERVO_DECRE:
        SERVO_DECRE_BEFORE <= SERVO_DECRE_NOW;
        SERVO_DECRE_NOW <= SERVO_DECRE;

        IF SERVO_INCRE_BEFORE = '0' AND SERVO_INCRE_NOW = '1' THEN
            IF  HALF_ON_OFF_FREC <= 100_000 - STEP THEN
                HALF_ON_OFF_FREC <= HALF_ON_OFF_FREC + STEP;
            ELSE
                NULL;
            END IF;

        ELSIF SERVO_DECRE_BEFORE = '0' AND SERVO_DECRE_NOW = '1' THEN
            IF  HALF_ON_OFF_FREC >= 5_000 + STEP THEN
                HALF_ON_OFF_FREC <= HALF_ON_OFF_FREC - STEP;
            ELSE
                NULL;
            END IF;
        ELSE
            NULL;
        END IF;
    END IF;



    IF rising_edge(CLK) then --

CONT <= CONT + 1;

        IF CONT = 1_000_000 THEN
        CONT <= 0;
        FLAG <= '1';
        ELSIF CONT =  HALF_ON_OFF_FREC then
        FLAG <= '0';
        
        else
            NULL;
        end if;

    END IF;
END process;
    -- ASIGNACIONES DIRECTAS ASOCIADAS:
CONTROL_POS <= FLAG;



end Behavioral;