library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pipe_gen is
    port (
        clk           : in  std_logic;
        reset         : in  std_logic;
        enable        : in  std_logic;
        pixel_row     : in  std_logic_vector(9 downto 0);
        pixel_column  : in  std_logic_vector(9 downto 0);
        level         : in  std_logic_vector(1 downto 0);  -- 2-bit level input (00 to 11)
        rand_nums     : in  std_logic_vector(31 downto 0); -- Four 8-bit random seeds
        pipe_on       : out std_logic
    );
end entity;

architecture behaviour of pipe_gen is
    constant SCREEN_WIDTH : integer := 640;
    constant pipe_width   : integer := 20;

    type pipe_x_array is array (0 to 3) of integer range 0 to SCREEN_WIDTH;
    type gap_y_array is array (0 to 3) of integer range 0 to 479;

    signal pipe_xs : pipe_x_array := (640, 800, 960, 1120);
    signal gap_ys  : gap_y_array := (120, 200, 160, 180);

    signal gap_size : integer := 80;  -- adjustable by level
    signal col_int, row_int : integer;
    signal pipe_hits : std_logic_vector(3 downto 0);
	 
	 signal level1 : std_logic_vector(1 downto 0);
begin
	 level1 <= "01";
	 
    -- Convert coordinates
    col_int <= to_integer(unsigned(pixel_column));
    row_int <= to_integer(unsigned(pixel_row));

    -- Dynamically adjust gap size based on level
    process(level1)
    begin
        case level1 is
            when "00" => gap_size <= 100;
            when "01" => gap_size <= 80;
            when "10" => gap_size <= 60;
            when others => gap_size <= 50;  -- hardest
        end case;
    end process;

    -- Pipe animation process
    process(clk, reset)
    begin
        if reset = '1' then
            pipe_xs <= (640, 800, 960, 1120);
            gap_ys <= (
                to_integer(unsigned(rand_nums(7 downto 2))) * 4,
                to_integer(unsigned(rand_nums(15 downto 10))) * 4,
                to_integer(unsigned(rand_nums(23 downto 18))) * 4,
                to_integer(unsigned(rand_nums(31 downto 26))) * 4
            );
        elsif rising_edge(clk) then
            if enable = '1' then
                for i in 0 to 3 loop
                    if pipe_xs(i) > 0 then
                        pipe_xs(i) <= pipe_xs(i) - 1;
                    else
                        pipe_xs(i) <= SCREEN_WIDTH + i * 160;
                        gap_ys(i) <= to_integer(unsigned(rand_nums((i+1)*8-1 downto i*8))) * 4;
                    end if;
                end loop;
            end if;
        end if;
    end process;

    -- Pipe display logic
    pipe_check: for i in 0 to 3 generate
        pipe_hits(i) <= '1' when (
            col_int >= pipe_xs(i) and col_int < pipe_xs(i) + pipe_width and
            (row_int < gap_ys(i) or row_int > gap_ys(i) + gap_size)
        ) else '0';
    end generate;

    -- Final output if any pipe covers current pixel
    pipe_on <= '1' when pipe_hits /= "0000" else '0';

end architecture;
