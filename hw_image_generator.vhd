LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY hw_image_generator IS
GENERIC(
pixels_y : INTEGER := 478;    --row that first color will persist until
pixels_x : INTEGER := 33);   --column that first color will persist until
PORT(
disp_ena : IN STD_LOGIC; --display enable ('1' = display time, '0' = blanking time)
row : IN INTEGER; --row pixel coordinate
column : IN INTEGER; --column pixel coordinate
clk      : IN STD_LOGIC; 
led      : OUT STD_LOGIC;
button_l  : IN STD_LOGIC;
button_r   :IN STD_LOGIC; 
red : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
green : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
blue : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')); --blue magnitude output to DAC
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
signal ball_horizontal  :INTEGER :=1500;
signal ball_vertical    :INTEGER :=450;
constant ball_width     :INTEGER :=25;
constant ball_height    :INTEGER :=25;
signal ball_counter     :STD_LOGIC_VECTOR(25 downto 0); 
signal paddle_counter     :STD_LOGIC_VECTOR(25 downto 0);
signal paddle_horizontal  : INTEGER :=1850;
signal paddle_vertical  : INTEGER :=665;
constant paddle_width   : INTEGER :=25;
constant paddle_height  : INTEGER  :=250;
signal v_increment : integer :=1;
signal h_increment : integer :=1; 
signal end_game         : STD_LOGIC; 
signal down : STD_LOGIC;
signal moveright : STD_LOGIC;
BEGIN
PROCESS(disp_ena, row, column)
BEGIN

IF(disp_ena = '1') THEN --display time 
	IF(row <= 200 AND 100<=row) THEN
	red <= (OTHERS => '1');
	green <= (OTHERS => '0');
	blue <= (OTHERS => '1');
	ELSIF (row <=paddle_horizontal and paddle_horizontal-paddle_width<=row and column<=paddle_vertical and paddle_vertical-paddle_height<=column) THEN
	red <= (OTHERS => '1');
	green <= (OTHERS => '0');
	blue <= (OTHERS => '1');
	ELSIF (row <=ball_horizontal and ball_horizontal-ball_width<=row and column<=ball_vertical and ball_vertical-ball_height<=column) THEN
	red <= (OTHERS => '1');
	green <= (OTHERS => '0');
	blue <= (OTHERS => '1');
	ELSE
	red <= (OTHERS => '0');
	green <= (OTHERS => '0');
	blue <= (OTHERS => '1');
	END IF;
ELSE --blanking time
red <= (OTHERS => '0');
green <= (OTHERS => '0');
blue <= (OTHERS => '0');
END IF;

END PROCESS;


PROCESS (clk)
BEGIN
	IF (clk'event AND clk='1') THEN 
		IF ball_counter<="00000001011111010111100001" THEN 
			ball_counter<=ball_counter+'1'; 
		ELSE 
		ball_counter<=(OTHERS => '0');
			IF (1055<=ball_vertical) THEN
			down<='0';
			ELSIF (ball_vertical<=25) THEN 
			down<='1';
			END IF;
				IF (ball_horizontal<=225) THEN 
				moveright<='1';
				ELSIF (paddle_horizontal-ball_width<=ball_horizontal AND ball_vertical<=paddle_vertical AND paddle_vertical-paddle_height<=ball_vertical) THEN
				moveright<='0';
					END IF;
					IF (down='0' AND moveright='0') THEN 
					ball_horizontal<=ball_horizontal-h_increment;
					ball_vertical<=ball_vertical-v_increment;
					ELSIF (down='1' AND moveright='0') THEN 
					ball_horizontal<=ball_horizontal-h_increment;
					ball_vertical<=ball_vertical+v_increment;
					ELSIF (down='0' AND moveright='1') THEN 
					ball_horizontal<=ball_horizontal+h_increment;
					ball_vertical<=ball_vertical-v_increment;
					ELSIF (down='1' AND moveright='1') THEN 
					ball_horizontal<=ball_horizontal+h_increment;
					ball_vertical<=ball_vertical+v_increment;
					END IF;
				IF (button_l<='0') THEN 
				paddle_vertical<=paddle_vertical-1;
					IF (paddle_vertical-paddle_height<= 5) THEN 
					paddle_vertical<= paddle_vertical;
					END IF;
				ELSIF (button_r<='0') THEN 
				paddle_vertical<=paddle_vertical+1;
					IF (1075 <= paddle_vertical) Then
					paddle_vertical<= paddle_vertical;
			END IF;
			END IF;
					
--			
--			led<='1';
--			ELSE end_game<=end_game;
--			END IF; 
				
		END IF;
		
	END IF; 
END PROCESS; 

		
END behavior;