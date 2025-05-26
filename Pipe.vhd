library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Pipe is 
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;
        enable        : in  std_logic;
        pixel_row     : in  std_logic_vector(9 downto 0);
        pixel_column  : in  std_logic_vector(9 downto 0);
        rand_num      : in  std_logic_vector(7 downto 0);
        pipe_on       : out std_logic
    );
end entity Pipe;

architecture behaviour of Pipe is
    constant pipe_width : integer := 20;
    constant gap_size   : integer := 80;

    signal pipe_x : integer range 0 to 640 := 640;
    signal gap_y  : integer range 0 to 479 := 120;

    signal col_int : integer;
    signal row_int : integer;
begin

    col_int <= to_integer(unsigned(pixel_column));
    row_int <= to_integer(unsigned(pixel_row));

    process(clk, reset)
    begin
        if reset = '1' then
            pipe_x <= 640;
            gap_y  <= 120;
        elsif rising_edge(clk) then
            if enable = '1' then
                if pipe_x > 0 then
                    pipe_x <= pipe_x - 1;
                else
                    pipe_x <= 640;
                    gap_y  <= to_integer(unsigned(rand_num(6 downto 2))) * 4;  -- ~0–124*4 = 0–496
                end if;
            end if;
        end if;
    end process;

    pipe_on <= '1' when (
        col_int >= pipe_x and col_int < pipe_x + pipe_width and
        (row_int < gap_y or row_int > gap_y + gap_size)
    ) else '0';

end architecture behaviour;
