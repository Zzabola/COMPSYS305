LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

entity falling_ball is
	port (clk, vert_sync : in  std_logic;
         left_button : in  std_logic;
         pixel_row, pixel_column : in std_logic_vector(9 downto 0);
         red, green, blue : out std_logic
   );     
end falling_ball;

architecture behavior of falling_ball is

   signal ball_on : std_logic;
   signal size : std_logic_vector(9 downto 0);  
   signal ball_y_pos : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(240, 10); 
   signal ball_x_pos : std_logic_vector(10 downto 0);
   signal ball_y_motion : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10); 
   signal prev_button : std_logic := '0';

begin           

   size <= CONV_STD_LOGIC_VECTOR(8, 10);
   ball_x_pos <= CONV_STD_LOGIC_VECTOR(260, 11);

   ball_on <= '1' when (
       ('0' & ball_x_pos <= '0' & pixel_column + size) and 
       ('0' & pixel_column <= '0' & ball_x_pos + size) and
       ('0' & ball_y_pos <= pixel_row + size) and 
       ('0' & pixel_row <= ball_y_pos + size)) else '0';

   Move_Ball: process (vert_sync)
   begin
       if rising_edge(vert_sync) then
			if (left_button = '1' and prev_button = '0') then
				if (ball_y_pos > CONV_STD_LOGIC_VECTOR(50, 10)) then
					ball_y_pos <= ball_y_pos - CONV_STD_LOGIC_VECTOR(50, 10);
            else
               ball_y_pos <= CONV_STD_LOGIC_VECTOR(0, 10);
            end if;
            ball_y_motion <= CONV_STD_LOGIC_VECTOR(2, 10);
          else
				if (ball_y_pos < CONV_STD_LOGIC_VECTOR(479,10) - size) then
					ball_y_pos <= ball_y_pos + ball_y_motion;
            else
               ball_y_pos <= CONV_STD_LOGIC_VECTOR(479,10) - size;
            end if;
          end if;
          prev_button <= left_button;
		end if;
    end process;

    red <= ball_on;
    green <= '0';
    blue <= '0';

end behavior;
