 --------------------------------------------------------------------------------
-- InstituciÃ³n : Instituto PolitÃ©cnico Nacional (IPN) - UPIITA
-- Proyecto    : DOOR_DRIVER
-- Archivo     : TOP.vhd
-- DescripciÃ³n : Un circuito meramente combinacional, por lo que es inecesario
-- la implementaciÃ³n de un reloj       PENDIENTE
--
--
-- Autor       : ARREGUÃN HERNÃNDEZ JULIO DAVID
-- Fecha       : 17/05/2026
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



--********************************************************
--      Descripcion de la entidad (Entradas y salidas) 
--********************************************************
entity DOOR_DRIVER is
    Port (
        CLK : IN STD_LOGIC;
        IN_RX  : in  STD_LOGIC_VECTOR(7 downto 0);
        OUT_DRIVER  : out STD_LOGIC_VECTOR(7 downto 0));
end DOOR_DRIVER;
--

 

--********************************************************
--                      ARQUITECTURA 
--********************************************************
architecture Behavioral of DOOR_DRIVER is

----------------------------------------------------------
--          Constantes y SeÃ±ales por Proceso
----------------------------------------------------------
SIGNAL IN_RX_NOW : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL IN_RX_BEFORE : STD_LOGIC_VECTOR(7 downto 0);


begin
----------------------------------------------------------------------------------


----------------------------------------------------------
--                       PPROCESOS
----------------------------------------------------------


process(CLK)
begin

IF RISING_EDGE(CLK) THEN
    IN_RX_BEFORE <= IN_RX_NOW;
    IN_RX_NOW <= IN_RX;

    IF IN_RX_BEFORE /= IN_RX_NOW THEN
       
        OUT_DRIVER <= IN_RX_NOW;

    END IF;
END IF;
end process;


-- ASIGNACIONES DIRECTAS ASOCIADAS:


end Behavioral;