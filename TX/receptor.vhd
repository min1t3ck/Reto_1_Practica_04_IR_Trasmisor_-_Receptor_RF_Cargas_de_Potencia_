library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity receptor is
    Port (
        clk    : in  STD_LOGIC;
        rst    : in  STD_LOGIC;
        pin_ir : in  STD_LOGIC;
        boton  : out STD_LOGIC_VECTOR(7 downto 0);
        listo  : out STD_LOGIC
    );
end receptor;

architecture Behavioral of receptor is
    constant TIMEOUT_LIMITE : integer := 600000;
    -- CORRECCIÓN CRÍTICA: Umbral a 56,250 ciclos (1.125 ms) justo a la mitad del protocolo NEC
    constant MARGEN_UMBRAL  : integer := 56250;      

    type estados_ir is (REPOSO, ESPERAR_START_LOW, ESPERAR_START_HIGH, CAPTURAR_BITS, VALIDAR_OK);
    signal estado_actual : estados_ir := REPOSO;

    signal ir_sinc1, ir_sinc2, ir_limpio : STD_LOGIC := '1';
    signal ir_antiguo : STD_LOGIC := '1';
    signal contador_tiempo : integer range 0 to 1000000 := 0;
    signal indice_bit : integer range 0 to 31 := 0;
    signal registro_trama : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin
    process(clk)
    begin
        if rising_edge(clk) then
            ir_sinc1  <= pin_ir;
            ir_sinc2  <= ir_sinc1;
            ir_limpio <= ir_sinc2; 
            ir_antiguo <= ir_limpio;
        end if;
    end process;

    process(clk, rst)
    begin
        if rst = '1' then
            estado_actual   <= REPOSO;
            contador_tiempo <= 0;
            indice_bit      <= 0;
            listo           <= '0';
        elsif rising_edge(clk) then
            listo <= '0'; 

            case estado_actual is
                when REPOSO =>
                    contador_tiempo <= 0;
                    indice_bit      <= 0;
                    if ir_antiguo = '1' and ir_limpio = '0' then
                        estado_actual <= ESPERAR_START_LOW;
                    end if;

                when ESPERAR_START_LOW =>
                    if ir_limpio = '1' then
                        -- FILTRO DE RUIDO: Solo acepta el pulso si duró más de 7ms (350,000 ciclos)
                        if contador_tiempo > 350000 then 
                            contador_tiempo <= 0; 
                            estado_actual   <= ESPERAR_START_HIGH;
                        else
                            estado_actual <= REPOSO; -- Era ruido, descártalo
                        end if;
                    else
                        if contador_tiempo > TIMEOUT_LIMITE then
                            estado_actual <= REPOSO; 
                        else
                            contador_tiempo <= contador_tiempo + 1;
                        end if;
                    end if;

                when ESPERAR_START_HIGH =>
                    if ir_limpio = '0' then
                        contador_tiempo <= 0; 
                        estado_actual   <= CAPTURAR_BITS;
                    else
                        if contador_tiempo > TIMEOUT_LIMITE then
                            estado_actual <= REPOSO; 
                        else
                            contador_tiempo <= contador_tiempo + 1;
                        end if;
                    end if;

                when CAPTURAR_BITS =>
                    if ir_antiguo = '0' and ir_limpio = '1' then
                        contador_tiempo <= 0; 
                    
                    elsif ir_antiguo = '1' and ir_limpio = '0' then
                        if contador_tiempo > MARGEN_UMBRAL then
                            registro_trama(indice_bit) <= '1'; 
                        else
                            registro_trama(indice_bit) <= '0'; 
                        end if;

                        if indice_bit = 31 then
                            estado_actual <= VALIDAR_OK;
                        else
                            indice_bit <= indice_bit + 1;
                        end if;
                        contador_tiempo <= 0;
                    else
                        if contador_tiempo > TIMEOUT_LIMITE then
                            estado_actual <= REPOSO;
                        else
                            contador_tiempo <= contador_tiempo + 1;
                        end if;
                    end if;

                when VALIDAR_OK =>
                    boton(7) <= registro_trama(16);
                    boton(6) <= registro_trama(17);
                    boton(5) <= registro_trama(18);
                    boton(4) <= registro_trama(19);
                    boton(3) <= registro_trama(20);
                    boton(2) <= registro_trama(21);
                    boton(1) <= registro_trama(22);
                    boton(0) <= registro_trama(23);
                    listo         <= '1'; 
                    estado_actual <= REPOSO; 
            end case;
        end if;
    end process;
end Behavioral;