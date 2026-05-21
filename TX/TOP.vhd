----------------------------------------------------------------------------------
-- Módulo Principal: top (Versión Transmisora para el Compañero)
-- Descripción: Enlaza estructuralmente la lógica del sensor óptico infrarrojo
--              con el motor de serialización UART hacia el exterior.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    Port (
        clk_50mhz   : in  STD_LOGIC;  -- Señal de reloj global (PIN_23)
        pin_ir      : in  STD_LOGIC;  -- Entrada física del sensor Infrarrojo (PIN_100)
        pin_cable_tx: out STD_LOGIC   -- Puerto de salida serie hacia tu FPGA (PIN_114)
    );
end TOP;

architecture Behavioral of TOP is

    -- Componente 1: Decodificador Infrarrojo (Mide silencios ópticos)
    component receptor
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            pin_ir : in  STD_LOGIC;
            boton  : out STD_LOGIC_VECTOR(7 downto 0);
            listo  : out STD_LOGIC
        );
    end component;

    -- Componente 2: Transmisor Serie UART diseñado por tu compañero
    component TX_TRASMITTER
        Port ( 
            CLK     : in  STD_LOGIC;
            RESET   : in  STD_LOGIC;
            D       : in  STD_LOGIC_VECTOR(7 DOWNTO 0);
            SEND    : in  STD_LOGIC;
            BUSSY   : out STD_LOGIC;
            TX_OUT  : out STD_LOGIC;
            DEBUGER : out STD_LOGIC;
            DEBUGER2: out STD_LOGIC
        );
    end component;

    -- Cables lógicos internos para interconexión modular
    signal ir_data_bus : STD_LOGIC_VECTOR(7 downto 0);
    signal ir_strobe   : STD_LOGIC;
    signal tx_bussy    : STD_LOGIC;

begin

    -- Instancia estructural de la etapa de decodificación óptica (Entrada)
    U_DECODIFICADOR_IR : receptor
        port map (
            clk    => clk_50mhz,
            rst    => '0',            -- Forzado a reposo operativo permanente
            pin_ir => pin_ir,
            boton  => ir_data_bus,    -- Interconecta el bus de datos paralelo
            listo  => ir_strobe       -- Interconecta la bandera de sincronización
        );

    -- Instancia estructural de la etapa de serialización por cable (Salida)
    U_CAPA_FISICA_TX : TX_TRASMITTER
        port map (
            CLK      => clk_50mhz,
            RESET    => '0',
            D        => ir_data_bus,  -- Lee directamente el byte capturado del aire
            SEND     => ir_strobe,    -- El pulso del IR dispara de inmediato el envío UART
            BUSSY    => tx_bussy,
            TX_OUT   => pin_cable_tx, -- Envía los bits directos hacia tu FPGA receptor
            DEBUGER  => open,
            DEBUGER2 => open
        );

end Behavioral;