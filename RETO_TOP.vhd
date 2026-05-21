--------------------------------------------------------------------------------
-- InstituciÃƒÂ³n : Instituto PolitÃƒÂ©cnico Nacional (IPN) - UPIITA
-- Proyecto    : CONTROLADOR DE UN MECANÃƒÂSMO "AZIMUT" MEDIANTE UN JOYSTICK A TRAVES DE UNA COMUINICACIÃƒâ€œN SERIAL RS232
-- Archivo     : RETO_TOP.vhd
-- DescripciÃƒÂ³n :
-- PENDIENTE
--
--
-- Autor       : ARREGUÃƒÂN HERNÃƒÂNDEZ JULIO DAVID
-- Fecha       : 17/05/2026
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



--********************************************************
--      Descripcion de la entidad (Entradas y salidas) 
--********************************************************

entity RETO_TOP is
    Port (
        CLK    : in  STD_LOGIC;
        RX_IN : in STD_LOGIC;
        SERVO_DOOR : out STD_LOGIC
    );
end RETO_TOP;



--*********************************************************
--                      Estructura 
--********************************************************
architecture Structural of RETO_TOP is

---------------------------------------
--	   DECLARACIÃƒâ€œN DE COMPONENTES
---------------------------------------

    component RX_RECEIVER
        Port (
         CLK : in STD_LOGIC;
			RX_IN : in STD_LOGIC;-- ENTRADA (BUS DE DATOS)
			E : out STD_LOGIC_VECTOR(7 DOWNTO 0)); -- REGISTRO PARA MOSTRAR LOS DATOS
			  --DEBUGER : out STD_LOGIC;
			  --DEBUGER2 : out STD_LOGIC); 
    end component;

    component DOOR_DRIVER
    Port (
        CLK : IN STD_LOGIC;
        IN_RX  : in  STD_LOGIC_VECTOR(7 downto 0);
        OUT_DRIVER  : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
--

    component FRECUENCY_DRIVER
        Port ( 	CLK : in STD_LOGIC;
                DATA_IN : in STD_LOGIC_VECTOR(7 DOWNTO 0);-- ENTRADA (BUS DE DATOS)
                SERVO_INCRE : out STD_LOGIC; 
                SERVO_DECRE : out STD_LOGIC);  
                --DEBUGER2 : out STD_LOGIC); 
    end component;

    component SERVO_DRIVER
    Port ( 	CLK : in STD_LOGIC;
			
			SERVO_INCRE : in STD_LOGIC; --
			SERVO_DECRE : in STD_LOGIC;  --
            CONTROL_POS : out STD_LOGIC);-- 
			  --DEBUGER2 : out STD_LOGIC); 
    end component;
    
----------------------------------------------------------
--          Constantes y SeÃƒÂ±ales por Proceso
----------------------------------------------------------

SIGNAL RX_TO_DOOR : STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL DOOR_TO_FREC : STD_LOGIC_VECTOR(7 DOWNTO 0);

SIGNAL FREC_TO_SERVO_UP : STD_LOGIC;
SIGNAL FREC_TO_SERVO_DOWN : STD_LOGIC;

begin

----------------------------------------------------------
--               CONEXION DE COMPONENTES
----------------------------------------------------------

    RX_UART : RX_RECEIVER
    port map (
        CLK => CLK,
		RX_IN => RX_IN, 
		E => RX_TO_DOOR	--Conectamos a SEND un Reloj para comandar en envio de datos constante
        );


    DOOR_LATCH : DOOR_DRIVER
    port map (
        CLK => CLK,
        IN_RX => RX_TO_DOOR,
        OUT_DRIVER => DOOR_TO_FREC 
    );

    FREC_CONTROLLER : FRECUENCY_DRIVER
    port map (
        CLK => CLK,
        DATA_IN => DOOR_TO_FREC,
        SERVO_INCRE => FREC_TO_SERVO_UP,
        SERVO_DECRE => FREC_TO_SERVO_DOWN
    );

    SERVO : SERVO_DRIVER
    port map (
        CLK => CLK,
        SERVO_INCRE => FREC_TO_SERVO_UP,
        SERVO_DECRE => FREC_TO_SERVO_DOWN,
        CONTROL_POS => SERVO_DOOR
    );
----------------------------------------------------------
--                       PPROCESOS
----------------------------------------------------------   
--
end Structural;