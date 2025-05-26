LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

entity VGA_sel is
	port (red_out1, green_out1, blue_out1, horiz_sync_out1, vert_sync_out1	: in	std_logic;
			red_out2, green_out2, blue_out2, horiz_sync_out2, vert_sync_out2	: in	std_logic;
			Start, clk : in std_logic;
			red_out, green_out, blue_out, horiz_sync_out, vert_sync_out	: out	std_logic
	);
end entity VGA_sel;

architecture behaviour of VGA_sel is
	signal prev_button : std_logic := '0';
	signal vga_select  : std_logic := '0';
begin


	process (clk)
	begin
		if (rising_edge(clk)) then
			if (Start = '1' and prev_button = '0') then
				vga_select <= not vga_select;
			end if;
			prev_button <= Start;
		end if;
	end process;

	process (vga_select, red_out1, green_out1, blue_out1, horiz_sync_out1, vert_sync_out1,
	               red_out2, green_out2, blue_out2, horiz_sync_out2, vert_sync_out2)
	begin
		if (vga_select = '1') then
			red_out <= red_out2;
			green_out <= green_out2;
			blue_out <= blue_out2;
			horiz_sync_out <= horiz_sync_out2;
			vert_sync_out <= vert_sync_out2;
		else
			red_out <= red_out1;
			green_out <= green_out1;
			blue_out <= blue_out1;
			horiz_sync_out <= horiz_sync_out1;
			vert_sync_out <= vert_sync_out1;
		end if;
	end process;
end architecture;