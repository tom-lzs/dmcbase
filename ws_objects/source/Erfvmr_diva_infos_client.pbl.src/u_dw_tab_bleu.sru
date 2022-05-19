$PBExportHeader$u_dw_tab_bleu.sru
$PBExportComments$Permet la création des onglet de la fiche client principale
forward
global type u_dw_tab_bleu from datawindow
end type
end forward

global type u_dw_tab_bleu from datawindow
integer width = 489
integer height = 464
integer taborder = 1
boolean livescroll = true
event we_dwnkey pbm_dwnkey
event ue_tabfocuschanged pbm_custom02
event ue_tabclicked pbm_custom03
end type
global u_dw_tab_bleu u_dw_tab_bleu

type variables
PROTECTED:

Boolean i_b_auto_align		// align all objects
Boolean i_b_auto_size		// size all objects to workspace

String i_s_tab_text[64]		// tab text array

Long i_l_row_size			// tab height
Long i_l_tab_width			// tab width
Long i_l_x[64]			// array of tab x values
Long i_l_y[64]			// array of tab y values

Integer i_i_tab_pointer		// active tab
Integer i_i_row_pointer		// current row
Integer i_i_old_tab_pointer		// last active tab
Integer i_i_num_tabs		// total num of tabs
Integer i_i_num_rows		// total num of rows
Integer i_i_tabs_per_row		// tabs per row
Integer i_i_text_pointers[64]		// array of text pointers

GraphicObject i_go_tab_objects[]	// array of dragobjects
Long i_l_area_x			// area x value
Long i_l_area_y			// area y value
Long i_l_area_height		// area height value
Long i_l_area_width		// area width value
end variables

forward prototypes
public subroutine fu_set_auto_size (boolean a_b_size)
public function boolean fu_get_auto_align ()
public function boolean fu_get_auto_size ()
public function integer fu_create_tabs (long a_l_num_tabs, long a_l_tabs_per_row, ref str_pass a_str_pass, boolean a_b_two_line_text)
public subroutine fu_align_objects (boolean a_b_align, boolean a_b_resize)
protected function int fu_get_clicked_tab ()
public function int fu_get_tab ()
public function string fu_get_tab_text ()
public function long fu_get_workspace_height ()
public function long fu_get_workspace_width ()
public function long fu_get_workspace_x ()
public function long fu_get_workspace_y ()
protected function string fu_make_active_tab (long a_l_x, long a_l_y, long a_l_width, long a_l_height, string a_s_text)
protected function string fu_make_one_rect (long a_l_x, long a_l_y, long a_l_w, long a_l_h, int a_i_mode, int a_i_key)
protected function string fu_make_one_tab (long a_l_x, long a_l_y, long a_l_width, long a_l_height, string a_s_text, int a_i_key)
protected function string fu_resize_active_tab ()
protected function string fu_resize_one_rect (long a_l_x, long a_l_y, long a_l_w, long a_l_h, int a_i_mode, int a_i_key)
protected function string fu_resize_one_tab (long l_x, long l_y, long l_width, long l_height, int i_key)
public function integer fu_resize_tabs ()
public function integer fu_set_active_tab (integer i_tab)
public subroutine fu_set_auto_align (boolean a_b_align)
public subroutine fu_set_tab_text (integer a_i_tab_pointer, integer a_i_text_pointer)
public subroutine fu_resize_tab_object (integer a_i_tab_num)
public subroutine fu_move_tab_object (integer a_i_tab_num)
public function graphicobject fu_get_tab_object (int a_i_tab_num)
public subroutine fu_bring_tab_object_to_top (integer a_i_tab_num)
end prototypes

event we_dwnkey;// Change Active Tab based on arrow key.

CHOOSE CASE TRUE

	// Set the next tab to the right of the current tab active.

	CASE KeyDown (keyRightArrow!)
		IF i_l_y[i_i_tab_pointer] = i_l_y[i_i_tab_pointer + 1] AND &
			i_i_tab_pointer + 1 <= i_i_num_tabs THEN
			fu_set_active_tab ( i_i_tab_pointer + 1)
		ELSEIF i_i_tab_pointer + 1 <= i_i_num_tabs THEN
				fu_set_active_tab (i_i_tab_pointer - i_i_tabs_per_row +1)
		ELSEIF i_i_tab_pointer = i_i_num_tabs AND &
	   		Mod(i_i_num_tabs,i_i_tabs_per_row) = 0 THEN
			fu_set_active_tab (i_i_tab_pointer - i_i_tabs_per_row +1)
		END IF

	// Set the next tab to the left of the current tab active.

	CASE KeyDown (keyLeftArrow!)
		IF i_i_tab_pointer - 1 = 0 THEN
			fu_set_active_tab( i_i_tabs_per_row )
		ELSEIF i_l_y[i_i_tab_pointer] = i_l_y[i_i_tab_pointer - 1] THEN
				fu_set_active_tab ( i_i_tab_pointer - 1)
		ELSEIF i_i_tab_pointer + i_i_tabs_per_row -1 <= i_i_num_tabs THEN
				fu_set_active_tab ( i_i_tab_pointer + i_i_tabs_per_row -1)
		END IF

	// Set the next tab above the current tab active.

	CASE KeyDown (keyUpArrow!)
//		SetActionCode (1)
		Return 1
		IF i_i_tab_pointer + i_i_tabs_per_row <= i_i_num_tabs THEN
			fu_set_active_tab ( i_i_tab_pointer + i_i_tabs_per_row)
		ELSEIF  i_i_tabs_per_row - (i_i_num_rows * i_i_tabs_per_row)  &
													+ i_i_tab_pointer  > 0 THEN 
			fu_set_active_tab (i_i_tabs_per_row - (i_i_num_rows * &
										i_i_tabs_per_row) + i_i_tab_pointer )
		END IF

	// Set the next tab below the current tab active.

	CASE KeyDown (keyDownArrow!)
		IF i_i_tab_pointer - i_i_tabs_per_row > 0 THEN
			fu_set_active_tab ( i_i_tab_pointer - i_i_tabs_per_row)
		ELSEIF (i_i_num_rows * i_i_tabs_per_row) - i_i_tabs_per_row &
			 							+ i_i_tab_pointer <= i_i_num_tabs THEN 
			fu_set_active_tab ((i_i_num_rows * i_i_tabs_per_row) - &
									i_i_tabs_per_row + i_i_tab_pointer)
		END IF

END CHOOSE
end event

public subroutine fu_set_auto_size (boolean a_b_size);// Sets the auto size variable to size objects upon tab creation.

i_b_auto_size = a_b_size
end subroutine

public function boolean fu_get_auto_align ();// Return value of instance variable.

RETURN i_b_auto_align
end function

public function boolean fu_get_auto_size ();// Return value of instance variable.

RETURN i_b_auto_size
end function

public function integer fu_create_tabs (long a_l_num_tabs, long a_l_tabs_per_row, ref str_pass a_str_pass, boolean a_b_two_line_text);/* <DESC>
     permet de créer les différents onglets en fonction des paramètres passés.
   </DESC> */
Integer i, i_col, i_row, i_row_pointer, i_tab_pointer, l_ubound
Long l_tab_start
String s_dwsyntax

// Create Tabs
// Set up initial values
IF a_l_num_tabs > 64 OR a_l_num_tabs < 1 THEN
	g_nv_msg_mgr.fnv_log_msg("Fiche Client","Nombre d~'onglets illégaux dans fu_create_tabs de u_dw_tab",4)
	RETURN -1
END IF

IF a_l_tabs_per_row > 32 OR a_l_tabs_per_row < 1 THEN
	g_nv_msg_mgr.fnv_log_msg("Fiche Client","Nombre d~'onglets par ligne illégaux dans fu_create_tabs de u_dw_tab",4)
	RETURN -2
END IF

IF a_l_num_tabs < a_l_tabs_per_row THEN
	g_nv_msg_mgr.fnv_log_msg("Fiche Client","Le nombre d~'onglets doit être supérieur ou égal au nombre d~'onglets par ligne dans fu_create_tabs de u_dw_tab",4)
	RETURN -3
END IF

SetPointer (HourGlass!)
SetRedraw (FALSE)

l_ubound = UpperBound (a_str_pass.po[])
i_s_tab_text[] = a_str_pass.s[]
i_i_num_tabs = a_l_num_tabs
i_i_tabs_per_row = a_l_tabs_per_row

// Build datawindow object
s_dwsyntax = "release 3;datawindow(units=1 timer_interval=0 color=12632256 processing=0 print.documentname='' print.orientation = 0 print.margin.left = 24 print.margin.right = 24 print.margin.top = 24 print.margin.bottom = 24 print.paper.source = 0 print.paper.size = 0 print.prompt=no ) " &
	+"header(height=1200 color='536870912') " &
	+"summary(height=0 color='536870912') " &
	+"footer(height=0 color='536870912')" &
	+"detail(height=14 color='536870912')" &
	+"table(column=(type=char(10) name=aaa dbname='aaa' ) ) "
Create (s_dwsyntax)

// Setup Row Size
IF a_b_two_line_text THEN
	i_l_row_size = UnitsToPixels (140, YUnitsToPixels!)
ELSE
	i_l_row_size = UnitsToPixels (80, YUnitsToPixels!)
END IF

// Calculate Num Rows & Tab Width
i_i_num_rows = Int(a_l_num_tabs/a_l_tabs_per_row)
IF Mod(a_l_num_tabs, a_l_tabs_per_row) > 0 THEN
	i_i_num_rows++
END IF
i_l_tab_width = (UnitsToPixels (this.width, XUnitsToPixels!) - (i_l_row_size / 3) - &
	(15 * i_i_num_rows)) / a_l_tabs_per_row

// Build Tabs
i_i_tab_pointer = i_i_num_rows * a_l_tabs_per_row
i_row_pointer = i_i_num_rows
s_dwsyntax = ""

FOR i_row = 0 TO i_i_num_rows - 1
	l_tab_start = (i_i_num_rows * 15) - (15 * i_row) - 15 + (i_l_row_size / 3)
	i_i_tab_pointer = (i_row_pointer * a_l_tabs_per_row) - a_l_tabs_per_row + 1
	i_tab_pointer = i_i_tab_pointer
	FOR i_col = 0 TO a_l_tabs_per_row - 1
		i_l_x[i_i_tab_pointer] = (l_tab_start + (i_col * i_l_tab_width) - (i_col))
		i_l_y[i_i_tab_pointer] = (i_row * i_l_row_size) + (i_l_row_size / 3)
		s_dwsyntax = s_dwsyntax + this.fu_make_one_tab (i_l_x[i_i_tab_pointer], &
			i_l_y[i_i_tab_pointer], i_l_tab_width, i_l_row_size, i_s_tab_text[i_i_tab_pointer], &
			i_i_tab_pointer)
		IF l_ubound >= i_i_tab_pointer THEN
			IF IsValid (a_str_pass.po[i_i_tab_pointer]) THEN
				i_go_tab_objects[i_i_tab_pointer] = a_str_pass.po[i_i_tab_pointer]
				i_go_tab_objects[i_i_tab_pointer].Hide ()
			END IF
		END IF
		i_i_tab_pointer++
	NEXT
	Modify (s_dwsyntax)
	i_row_pointer = i_row_pointer - 1
	IF i_row = i_i_num_rows - 1 THEN
		s_dwsyntax = this.fu_make_one_rect (l_tab_start, i_l_y[i_tab_pointer] + i_l_row_size, &
			(i_l_tab_width * a_l_tabs_per_row) - (1 * a_l_tabs_per_row), UnitsToPixels (this.height, &
			YUnitsToPixels!) - (i_l_row_size * i_i_num_rows) - i_l_row_size, 1, i_row_pointer + 1)
	ELSE
		s_dwsyntax = this.fu_make_one_rect (l_tab_start, i_l_y[i_tab_pointer] + i_l_row_size, &
			(i_l_tab_width * a_l_tabs_per_row) - (1 * a_l_tabs_per_row), UnitsToPixels (this.height, &
			YUnitsToPixels!) - (i_l_row_size * i_i_num_rows) - i_l_row_size, 2, i_row_pointer + 1)
	END IF
	Modify (s_dwsyntax)
	s_dwsyntax = ""
NEXT

// Align and resize all objects based on the two booleans.
this.fu_align_objects (i_b_auto_align, i_b_auto_size)

// Set active tab to one
i_i_tab_pointer = 1
i_i_row_pointer = 1
IF l_ubound >= i_i_tab_pointer THEN
	IF IsValid(a_str_pass.po[i_i_tab_pointer]) THEN
		i_go_tab_objects[i_i_tab_pointer].Show ()
//		fu_bring_tab_object_to_top (1)
	END IF
END IF
s_dwsyntax = fu_make_active_tab (i_l_x[i_i_tab_pointer], i_l_y[i_i_tab_pointer], i_l_tab_width, &
	i_l_row_size, i_s_tab_text[i_i_tab_pointer])
s_dwsyntax = s_dwsyntax + " focus.Visible='0'"
Modify (s_dwsyntax)
this.TriggerEvent ("ue_tabfocuschanged")
SetRedraw (TRUE)

// Setfocus for redraw problem
IF this.taborder = 10 THEN
	this.SetFocus ()
END IF

RETURN 1

end function

public subroutine fu_align_objects (boolean a_b_align, boolean a_b_resize);// Called when tabs are created or resized, resize and/or align each
//	DragObject in the array based on values in the instance variables.

Integer i_tab_num
Window i_w_object
WindowObject i_wo_object


// Bail out if neither alignment or resizing is required.

IF NOT a_b_align AND &
	NOT a_b_resize THEN
	RETURN
END IF


// Align and/or resize each DragObject in the array.

FOR i_tab_num = 1 TO i_i_num_tabs

	IF i_tab_num > UpperBound (i_go_tab_objects) THEN
		EXIT
	END IF

	IF IsValid (i_go_tab_objects [i_tab_num]) THEN

		IF a_b_align THEN
			this.fu_move_tab_object (i_tab_num)
		END IF

		IF a_b_resize THEN
			this.fu_resize_tab_object (i_tab_num)
		END IF

	END IF

NEXT
end subroutine

protected function int fu_get_clicked_tab ();// Return the number of the tab over which the mouse was clicked.
Long		l_point_x, l_point_y
Integer	i_row_num, i_first_tab_on_row, i_last_tab_on_row, i_clicked_tab

// Get pointer x & y in Pixels.
l_point_x = UnitsToPixels (PointerX (), XUnitsToPixels!)
l_point_y = UnitsToPixels (PointerY (), YUnitsToPixels!)

// Check if click in tab area (y- values).
IF l_point_y > i_l_y [1] + i_l_row_size OR &
		l_point_y < i_l_y [i_i_num_tabs] THEN
	RETURN -1
END IF

// Get clicked tab row number.
i_row_num = 1

i_first_tab_on_row = 1

DO WHILE i_l_y [i_first_tab_on_row] > l_point_y
	i_first_tab_on_row = i_first_tab_on_row + i_i_tabs_per_row
	i_row_num ++
LOOP

i_last_tab_on_row = i_first_tab_on_row + i_i_tabs_per_row - 1

// Check if click in tab area (x- values).
IF l_point_x > i_l_x [i_last_tab_on_row] + i_l_tab_width OR &
		l_point_x < i_l_x [i_first_tab_on_row] THEN
	RETURN -1
END IF

// Get clicked Tab.
i_clicked_tab = i_first_tab_on_row

DO UNTIL i_l_x [i_clicked_tab] <= l_point_x AND &
		i_l_x [i_clicked_tab] + i_l_tab_width > l_point_x
	i_clicked_tab++
LOOP

RETURN i_clicked_tab

end function

public function int fu_get_tab ();// Return the current tab pointer.

RETURN i_i_tab_pointer
end function

public function string fu_get_tab_text ();// Return the current tab text.

RETURN i_s_tab_text [i_i_tab_pointer]
end function

public function long fu_get_workspace_height ();// Return the active tab area height.

RETURN i_l_area_height
end function

public function long fu_get_workspace_width ();// Return the active tab area width.

RETURN i_l_area_width
end function

public function long fu_get_workspace_x ();// Return the active tab area x.

RETURN i_l_area_x
end function

public function long fu_get_workspace_y ();// Return the active tab area y.

RETURN i_l_area_y
end function

protected function string fu_make_active_tab (long a_l_x, long a_l_y, long a_l_width, long a_l_height, string a_s_text);Integer	i
String	s_dwsyntax

// Creates the Active tab (Moved by fu_set_active_tab)

s_dwsyntax = "create roundrectangle(band=header x='"+String(a_l_x+3)+"' y='"+String(a_l_y+2)+"' height='49' width='"+String(a_l_width - 6)+"' ellipseheight='15' ellipsewidth='15' name=rr_1 brush.hatch='6' brush.color='12632256' pen.style='0' pen.width='1' pen.color='12632256' background.mode='2' background.color='-2134851392') " &
	+"create line(band=header x1='"+String(a_l_x+6)+"' y1='"+String(a_l_y+2)+"' x2='"+String(a_l_x+a_l_width - 6)+"' y2='"+String(a_l_y+2)+"' name=ln_1 pen.style='0' pen.width='1' pen.color='16777215' ) " &
	+"create line(band=header x1='"+String(a_l_x+2)+"' y1='"+String(a_l_y+6)+"' x2='"+String(a_l_x+2)+"' y2='"+String(a_l_y+a_l_height+1)+"' name=ln_2 pen.style='0' pen.width='1' pen.color='16777215' ) " &
	+"create line(band=header x1='"+String(a_l_x+1)+"' y1='"+String(a_l_y+5)+"' x2='"+String(a_l_x+1)+"' y2='"+String(a_l_y+a_l_height+1)+"' name=ln_3 pen.style='0' pen.width='1' pen.color='16777215' ) " &
	+"create line(band=header x1='"+String(a_l_x+2)+"' y1='"+String(a_l_y+6)+"' x2='"+String(a_l_x+6)+"' y2='"+String(a_l_y+2)+"' name=ln_4 pen.style='0' pen.width='1' pen.color='16777215' ) " &
	+"create line(band=header x1='"+String(a_l_x+a_l_width - 6+3)+"' y1='"+String(a_l_y+3)+"' x2='"+String(a_l_x+a_l_width - 6+3)+"' y2='"+String(a_l_y+a_l_height+2)+"' name=ln_5 pen.style='0' pen.width='1' pen.color='8421504' ) " &
	+"create line(band=header x1='"+String(a_l_x+a_l_width - 6+0)+"' y1='"+String(a_l_y+0)+"' x2='"+String(a_l_x+a_l_width - 6+3)+"' y2='"+String(a_l_y+3)+"' name=ln_6 pen.style='0' pen.width='1' pen.color='8421504' ) " &
	+"create text(band=foreground color='0' alignment='2' border='0' x='"+String(a_l_x+7)+"' y='"+String(a_l_y+6)+"' height='"+String(a_l_height - 4)+"' width='"+String(a_l_width - 15)+"' text='"+a_s_text+"' name=st_1 font.face='MS Sans Serif' font.height='-8' font.weight='800' font.family='2' font.pitch='2' font.charset='0' background.mode='0' background.color='12632256') " &
	+"create rectangle(band=foreground x='"+String(a_l_x+7)+"' y='"+String(a_l_y+6)+"' height='"+String(a_l_height - 4)+"' width='"+String(a_l_width - 15)+"' name=focus brush.hatch='7' brush.color='12632256' pen.style='2' pen.width='1' pen.color='8421504' background.mode='2' background.color='553648127') "

FOR i = 1 TO i_i_num_rows * i_i_tabs_per_row
	i_i_text_pointers[i] = i
NEXT

RETURN s_dwsyntax

end function

protected function string fu_make_one_rect (long a_l_x, long a_l_y, long a_l_w, long a_l_h, int a_i_mode, int a_i_key);String s_dwsyntax, s_key
s_key = String(a_i_key)

// Support function for fu_create_tab
// Creates one rectangle

s_dwsyntax = "create rectangle(band=header x='"+String(a_l_x)+"' y='"+String(a_l_y)+"' height='"+String(a_l_h+1)+"' width='"+String(a_l_w+1)+"' name=r1_"+s_key+" brush.hatch='6' brush.color='12632256' pen.style='0' pen.width='1' pen.color='0' background.mode='2' background.color='-2147483648') " &
	+"create line(band=header x1='"+String(a_l_x+1)+"' y1='"+String(a_l_y+1)+"' x2='"+String(a_l_x+a_l_w - 1)+"' y2='"+String(a_l_y+1)+"'  name=r2_"+s_key+" pen.style='0' pen.width='1' pen.color='16777215' ) " &
	+"create line(band=header x1='"+String(a_l_x+1)+"' y1='"+String(a_l_y+1)+"' x2='"+String(a_l_x+1)+"' y2='"+String(a_l_y+a_l_h - 1)+"' name=r3_"+s_key+"  pen.style='0' pen.width='1' pen.color='16777215' ) " &
	+"create line(band=header x1='"+String(a_l_x+1)+"' y1='"+String(a_l_y+a_l_h - 1)+"' x2='"+String(a_l_x+a_l_w - 1)+"' y2='"+String(a_l_y+a_l_h - 1)+"' name=r4_"+s_key+" pen.style='0' pen.width='1' pen.color='8421504' ) " &
	+"create line(band=header x1='"+String(a_l_x+a_l_w - 1)+"' y1='"+String(a_l_y)+"' x2='"+String(a_l_x+a_l_w - 1)+"' y2='"+String(a_l_y+a_l_h - 1)+"' name=r5_"+s_key+" pen.style='0' pen.width='1' pen.color='8421504' ) "

// if rect. is top, make 3D border thicker & set Workspace parms.

IF a_i_mode = 2 THEN
	s_dwsyntax = s_dwsyntax + "create rectangle(band=header x='"+String(a_l_x+(a_l_w/2)-1)+"' y='"+String(a_l_y )+"' height='"+String(3)+"' width='"+String(a_l_w/2)+"' name=r6_"+s_key+" brush.hatch='6' brush.color='12632256' pen.style='0' pen.width='1' pen.color='12632256' background.mode='2' background.color='-2134851392') "

ELSE
	s_dwsyntax = s_dwsyntax + "create line(band=header x1='"+String(a_l_x+2)+"' y1='"+String(a_l_y+2)+"' x2='"+String(a_l_x+a_l_w - 2)+"' y2='"+String(a_l_y+2)+"' name=r7_"+s_key+" pen.style='0' pen.width='1' pen.color='16777215' ) " &
		+"create line(band=header x1='"+String(a_l_x+2)+"' y1='"+String(a_l_y+2)+"' x2='"+String(a_l_x+2)+"' y2='"+String(a_l_y+a_l_h - 2)+"' name=r8_"+s_key+" pen.style='0' pen.width='1' pen.color='16777215' ) " &
		+"create line(band=header x1='"+String(a_l_x+2)+"' y1='"+String(a_l_y+a_l_h - 2)+"' x2='"+String(a_l_x+a_l_w - 2)+"' y2='"+String(a_l_y+a_l_h - 2)+"' name=r9_"+s_key+" pen.style='0' pen.width='1' pen.color='8421504' ) " &
		+"create line(band=header x1='"+String(a_l_x+a_l_w - 2)+"' y1='"+String(a_l_y+2)+"' x2='"+String(a_l_x+a_l_w - 2)+"' y2='"+String(a_l_y+a_l_h - 2)+"' name=r10_"+s_key+" pen.style='0' pen.width='1' pen.color='8421504' ) "
	i_l_area_x = PixelsToUnits (a_l_x + 3, XPixelsToUnits!) + this.x
	i_l_area_y = PixelsToUnits (a_l_y + 3, YPixelsToUnits!) + this.y
	i_l_area_height = PixelsToUnits (a_l_h - 5, YPixelsToUnits!)
	i_l_area_width = PixelsToUnits (a_l_w - 5, XPixelsToUnits!)
END IF

RETURN s_dwsyntax
end function

protected function string fu_make_one_tab (long a_l_x, long a_l_y, long a_l_width, long a_l_height, string a_s_text, int a_i_key);String	s_dwsyntax, s_key

s_key = String (a_i_key)

// Support function for fu_create_tabs... Makes one tab

s_dwsyntax = "create rectangle(band=header x='"+String(a_l_x)+"' y='"+String(a_l_y)+"' height='"+String(a_l_height)+"' width='"+String(a_l_width)+"' name=tab_"+s_key+" brush.hatch='6' brush.color='12632256' pen.style='0' pen.width='1' pen.color='12632256' background.mode='0' background.color='12632256') " &
	+"create line(band=header x1='"+String(a_l_x)+"' y1='"+String(a_l_y+4)+"' x2='"+String(a_l_x+4)+"' y2='"+String(a_l_y)+"' name=ltab1_"+s_key+" pen.style='0' pen.width='1' pen.color='0' ) " &
	+"create line(band=header x1='"+String(a_l_x)+"' y1='"+String(a_l_y+4)+"' x2='"+String(a_l_x)+"' y2='"+String(a_l_y+a_l_height)+"' name=ltab2_"+s_key+" pen.style='0' pen.width='1' pen.color='0' ) " &
	+"create line(band=header x1='"+String(a_l_x+a_l_width - 6+5)+"' y1='"+String(a_l_y+4)+"' x2='"+String(a_l_x+a_l_width - 6+5)+"' y2='"+String(a_l_y+a_l_height)+"' name=ltab3_"+s_key+" pen.style='0' pen.width='1' pen.color='0' ) " &
	+"create line(band=header x1='"+String(a_l_x+4)+"' y1='"+String(a_l_y)+"' x2='"+String(a_l_x+a_l_width - 6+1)+"' y2='"+String(a_l_y)+"' name=ltab4_"+s_key+" pen.style='0' pen.width='1' pen.color='0' ) " &
	+"create line(band=header x1='"+String(a_l_x+a_l_width - 6+1)+"' y1='"+String(a_l_y)+"' x2='"+String(a_l_x+a_l_width - 6+5)+"' y2='"+String(a_l_y+4)+"' name=ltab5_"+s_key+" pen.style='0' pen.width='1' pen.color='0' ) " &
	+"create line(band=header x1='"+String(a_l_x+5)+"' y1='"+String(a_l_y+1)+"' x2='"+String(a_l_x+a_l_width - 6)+"' y2='"+String(a_l_y+1)+"' name=ltab6_"+s_key+" pen.style='0' pen.width='1' pen.color='16777215' ) " &
	+"create line(band=header x1='"+String(a_l_x+1)+"' y1='"+String(a_l_y+5)+"' x2='"+String(a_l_x+1)+"' y2='"+String(a_l_y+a_l_height)+"' name=ltab7_"+s_key+" pen.style='0' pen.width='1' pen.color='16777215' ) " &
	+"create line(band=header x1='"+String(a_l_x+1)+"' y1='"+String(a_l_y+5)+"' x2='"+String(a_l_x+5)+"' y2='"+String(a_l_y+1)+"' name=ltab8_"+s_key+" pen.style='0' pen.width='1' pen.color='16777215' ) " &
	+"create line(band=header x1='"+String(a_l_x+a_l_width - 6+4)+"' y1='"+String(a_l_y+4)+"' x2='"+String(a_l_x+a_l_width - 6+4)+"' y2='"+String(a_l_y+a_l_height)+"' name=ltab9_"+s_key+" pen.style='0' pen.width='1' pen.color='8421504' ) " &
	+"create line(band=header x1='"+String(a_l_x+a_l_width - 6+1)+"' y1='"+String(a_l_y+1)+"' x2='"+String(a_l_x+a_l_width - 6+4)+"' y2='"+String(a_l_y+4)+"' name=ltab10_"+s_key+" pen.style='0' pen.width='1' pen.color='8421504' ) " &
	+"create text(band=header color='0' alignment='2' border='0' x='"+String(a_l_x+3)+"' y='"+String(a_l_y+4)+"' height='"+String(a_l_height - 6)+"' width='"+String(a_l_width - 6)+"' text='"+a_s_text+"' name=stab_"+s_key+" font.face='MS Sans Serif' font.height='-8' font.weight='400' font.family='2' font.pitch='2' font.charset='0' background.mode='1' background.color='553648127') "

RETURN s_dwsyntax

end function

protected function string fu_resize_active_tab ();String	s_dwsyntax

// Resize the active tab
s_dwsyntax = "rr_1.width='"+String(i_l_tab_width - 6)+"' " &
	+"focus.height='"+String(i_l_row_size - 4)+"' focus.width='"+String(i_l_tab_width - 15)+"' " &
	+"st_1.height='"+String(i_l_row_size - 4)+"' st_1.width='"+String(i_l_tab_width - 15)+"' "

RETURN s_dwsyntax

end function

protected function string fu_resize_one_rect (long a_l_x, long a_l_y, long a_l_w, long a_l_h, int a_i_mode, int a_i_key);String	s_dwsyntax, s_key

s_key = String (a_i_key)

// Support function for fu_resize_tabs....Resize one Rect.

s_dwsyntax = "r1_"+s_key+".x='"+String(a_l_x)+"' r1_"+s_key+".y='"+String(a_l_y)+"' r1_"+s_key+".height='"+String(a_l_h+1)+"' r1_"+s_key+".width='"+String(a_l_w+1)+"' " &
	+"r2_"+s_key+".x1='"+String(a_l_x+1)+"' r2_"+s_key+".y1='"+String(a_l_y+1)+"' r2_"+s_key+".x2='"+String(a_l_x+a_l_w - 1)+"' r2_"+s_key+".y2='"+String(a_l_y+1)+"' " &
	+"r3_"+s_key+".x1='"+String(a_l_x+1)+"' r3_"+s_key+".y1='"+String(a_l_y+1)+"' r3_"+s_key+".x2='"+String(a_l_x+1)+"' r3_"+s_key+".y2='"+String(a_l_y+a_l_h - 1)+"' " &
	+"r4_"+s_key+".x1='"+String(a_l_x+1)+"' r4_"+s_key+".y1='"+String(a_l_y+a_l_h - 1)+"' r4_"+s_key+".x2='"+String(a_l_x+a_l_w - 1)+"' r4_"+s_key+".y2='"+String(a_l_y+a_l_h - 1)+"' " &
	+"r5_"+s_key+".x1='"+String(a_l_x+a_l_w - 1)+"' r5_"+s_key+".y1='"+String(a_l_y+1)+"' r5_"+s_key+".x2='"+String(a_l_x+a_l_w - 1)+"' r5_"+s_key+".y2='"+String(a_l_y+a_l_h - 1)+"' "

// If top most tab, resize the thick 3D border

IF a_i_mode = 2 THEN
	s_dwsyntax = s_dwsyntax + "r6_"+s_key+".x='"+String(a_l_x+(a_l_w/2)-1)+"' r6_"+s_key+".y='"+String(a_l_y )+"' r6_"+s_key+".height='"+String(3)+"' r6_"+s_key+".width='"+String(a_l_w/2)+"' "
ELSE
	s_dwsyntax = s_dwsyntax + "r7_"+s_key+".x1='"+String(a_l_x+2)+"' r7_"+s_key+".y1='"+String(a_l_y+2)+"' r7_"+s_key+".x2='"+String(a_l_x+a_l_w - 2)+"' r7_"+s_key+".y2='"+String(a_l_y+2)+"' " &
		+"r8_"+s_key+".x1='"+String(a_l_x+2)+"' r8_"+s_key+".y1='"+String(a_l_y+2)+"' r8_"+s_key+".x2='"+String(a_l_x+2)+"' r8_"+s_key+".y2='"+String(a_l_y+a_l_h - 2)+"' " &
		+"r9_"+s_key+".x1='"+String(a_l_x+2)+"' r9_"+s_key+".y1='"+String(a_l_y+a_l_h - 2)+"' r9_"+s_key+".x2='"+String(a_l_x+a_l_w - 2)+"' r9_"+s_key+".y2='"+String(a_l_y+a_l_h - 2)+"' " &
		+"r10_"+s_key+".x1='"+String(a_l_x+a_l_w - 2)+"' r10_"+s_key+".y1='"+String(a_l_y+2)+"' r10_"+s_key+".x2='"+String(a_l_x+a_l_w - 2)+"' r10_"+s_key+".y2='"+String(a_l_y+a_l_h - 2)+"' "
	i_l_area_x = PixelsToUnits (a_l_x + 3, XPixelsToUnits!) + this.x
	i_l_area_y = PixelsToUnits (a_l_y + 3, YPixelsToUnits!) + this.y
	i_l_area_height = PixelsToUnits (a_l_h - 5, YPixelsToUnits!)
	i_l_area_width = PixelsToUnits (a_l_w - 5, XPixelsToUnits!)
END IF

RETURN s_dwsyntax
end function

protected function string fu_resize_one_tab (long l_x, long l_y, long l_width, long l_height, int i_key);String s_dwsyntax, s_key
s_key = String(i_key)

// Support function for fu_resize_tabs.... Resize one tab

s_dwsyntax = "tab_"+s_key+".x='"+String(l_x)+"' tab_"+s_key+".y='"+String(l_y)+"' tab_"+s_key+".height='"+String(l_height)+"' tab_"+s_key+".width='"+String(l_width)+"' " &
+"ltab1_"+s_key+".x1='"+String(l_x)+"' ltab1_"+s_key+".y1='"+String(l_y+4)+"' ltab1_"+s_key+".x2='"+String(l_x+4)+"' ltab1_"+s_key+".y2='"+String(l_y)+"' " &
+"ltab2_"+s_key+".x1='"+String(l_x)+"' ltab2_"+s_key+".y1='"+String(l_y+4)+"' ltab2_"+s_key+".x2='"+String(l_x)+"' ltab2_"+s_key+".y2='"+String(l_y+l_height)+"' " &
+"ltab3_"+s_key+".x1='"+String(l_x+l_width - 6+5)+"' ltab3_"+s_key+".y1='"+String(l_y+4)+"' ltab3_"+s_key+".x2='"+String(l_x+l_width - 6+5)+"' ltab3_"+s_key+".y2='"+String(l_y+l_height)+"' " &
+"ltab4_"+s_key+".x1='"+String(l_x+4)+"' ltab4_"+s_key+".y1='"+String(l_y)+"' ltab4_"+s_key+".x2='"+String(l_x+l_width - 6+1)+"' ltab4_"+s_key+".y2='"+String(l_y)+"' " &
+"ltab5_"+s_key+".x1='"+String(l_x+l_width - 6+1)+"' ltab5_"+s_key+".y1='"+String(l_y)+"' ltab5_"+s_key+".x2='"+String(l_x+l_width - 6+5)+"' ltab5_"+s_key+".y2='"+String(l_y+4)+"' " &
+"ltab6_"+s_key+".x1='"+String(l_x+5)+"' ltab6_"+s_key+".y1='"+String(l_y+1)+"' ltab6_"+s_key+".x2='"+String(l_x+l_width - 6)+"' ltab6_"+s_key+".y2='"+String(l_y+1)+"' " &
+"ltab7_"+s_key+".x1='"+String(l_x+1)+"' ltab7_"+s_key+".y1='"+String(l_y+5)+"' ltab7_"+s_key+".x2='"+String(l_x+1)+"' ltab7_"+s_key+".y2='"+String(l_y+l_height)+"' " &
+"ltab8_"+s_key+".x1='"+String(l_x+1)+"' ltab8_"+s_key+".y1='"+String(l_y+5)+"' ltab8_"+s_key+".x2='"+String(l_x+5)+"' ltab8_"+s_key+".y2='"+String(l_y+1)+"' " &
+"ltab9_"+s_key+".x1='"+String(l_x+l_width - 6+4)+"' ltab9_"+s_key+".y1='"+String(l_y+4)+"' ltab9_"+s_key+".x2='"+String(l_x+l_width - 6+4)+"' ltab9_"+s_key+".y2='"+String(l_y+l_height)+"' " &
+"ltab10_"+s_key+".x1='"+String(l_x+l_width - 6+1)+"' ltab10_"+s_key+".y1='"+String(l_y+1)+"' ltab10_"+s_key+".x2='"+String(l_x+l_width - 6+4)+"' ltab10_"+s_key+".y2='"+String(l_y+4)+"' " &
+"stab_"+s_key+".x='"+String(l_x+3)+"' stab_"+s_key+".y='"+String(l_y+4)+"' stab_"+s_key+".height='"+String(l_height - 6)+"' stab_"+s_key+".width='"+String(l_width - 6)+"' "

RETURN s_dwsyntax

end function

public function integer fu_resize_tabs ();Int		i, i_col, i_row, i_row_pointer, i_tab_pointer, i_tab
Long		i_x_tab_start, l_tab_start
String	s_dwsyntax

// Resize Tabs
IF i_i_tab_pointer < 1 THEN
	RETURN -1
END IF

SetPointer (HourGlass!)
SetRedraw (FALSE)

i_tab = i_i_tab_pointer
i_l_tab_width = (UnitsToPixels (this.width, XUnitsToPixels!) - (i_l_row_size / 3) - &
	(15 * i_i_num_rows)) / i_i_tabs_per_row
i_i_tab_pointer = i_i_num_rows * i_i_tabs_per_row
i_row_pointer = i_i_num_rows

FOR i_row = 0 TO i_i_num_rows - 1
	l_tab_start = (i_i_num_rows * 15) - (15 * i_row) - 15 + (i_l_row_size / 3)
	i_i_tab_pointer = (i_row_pointer * i_i_tabs_per_row) - i_i_tabs_per_row + 1
	i_tab_pointer = i_i_tab_pointer
	FOR i_col = 0 TO i_i_tabs_per_row - 1
		i_l_x[i_i_tab_pointer] = (l_tab_start + (i_col * i_l_tab_width) - (i_col))
		i_l_y[i_i_tab_pointer] = (i_row * i_l_row_size) + (i_l_row_size / 3)
		s_dwsyntax = s_dwsyntax + this.fu_resize_one_tab (i_l_x[i_i_tab_pointer], &
				i_l_y[i_i_tab_pointer], i_l_tab_width, i_l_row_size, i_i_tab_pointer)
		i_i_tab_pointer ++
	NEXT
	i_row_pointer = i_row_pointer - 1
	IF i_row = i_i_num_rows - 1 THEN
		s_dwsyntax = s_dwsyntax + this.fu_resize_one_rect(l_tab_start , i_l_y[i_tab_pointer] + &
			i_l_row_size, (i_l_tab_width * i_i_tabs_per_row) - (1 * i_i_tabs_per_row), &
			UnitsToPixels (this.height, YUnitsToPixels!) - (i_l_row_size * i_i_num_rows) - &
			i_l_row_size, 1, i_row_pointer + 1)
	ELSE
		s_dwsyntax = s_dwsyntax + this.fu_resize_one_rect (l_tab_start , i_l_y[i_tab_pointer] + &
			i_l_row_size, (i_l_tab_width * i_i_tabs_per_row) - (1 * i_i_tabs_per_row), &
			UnitsToPixels (this.height, YUnitsToPixels!) - (i_l_row_size * i_i_num_rows) - &
			i_l_row_size, 2, i_row_pointer + 1)
	END IF
NEXT

s_dwsyntax = s_dwsyntax + this.fu_resize_active_tab ()

Modify (s_dwsyntax)

this.fu_set_active_tab (i_tab)

// Resize the work space items.
this.fu_align_objects (i_b_auto_align, i_b_auto_size)

SetRedraw (TRUE)

RETURN 1

end function

public function integer fu_set_active_tab (integer i_tab);String s_dwsyntax
Integer i, i_text_pointer, i_total_tabs
Long l_ubound

// Trigger the ue_tabclicked event and check to see if it should be changed.
this.TriggerEvent ("ue_tabclicked")
IF message.returnvalue < 0 THEN
	RETURN -1
END IF

// Move active tab
SetRedraw (FALSE)
SetPointer (HourGlass!)

// change all the tab text if needed
i_i_old_tab_pointer = i_i_tab_pointer
i_total_tabs = i_i_num_rows * i_i_tabs_per_row
IF i_tab > i_i_tabs_per_row * i_i_row_pointer OR i_tab <= (i_i_tabs_per_row * i_i_row_pointer) - i_i_tabs_per_row THEN
	i_i_row_pointer = Int ((i_tab - 1) / i_i_tabs_per_row) + 1
	FOR i = 1 TO i_total_tabs
		i_text_pointer = i + (i_i_row_pointer * i_i_tabs_per_row) - i_i_tabs_per_row
		IF i_text_pointer > i_total_tabs THEN
			i_text_pointer = i_text_pointer - i_total_tabs
		END IF
		i_i_text_pointers[i] = i_text_pointer
		this.fu_set_tab_text (i, i_text_pointer)
	NEXT
END IF
i_i_tab_pointer = i_tab - ((i_i_row_pointer - 1) * i_i_tabs_per_row)

// move the active tab

s_dwsyntax = "rr_1.x='"+String(i_l_x[i_i_tab_pointer]+3)+"' rr_1.y='"+String(i_l_y[i_i_tab_pointer]+2)+"' " &
	+"ln_1.x1='"+String(i_l_x[i_i_tab_pointer]+6)+"' ln_1.y1='"+String(i_l_y[i_i_tab_pointer]+2)+"' ln_1.x2='"+String(i_l_x[i_i_tab_pointer]+i_l_tab_width - 6)+"' ln_1.y2='"+String(i_l_y[i_i_tab_pointer]+2)+"' " &
	+"ln_2.x1='"+String(i_l_x[i_i_tab_pointer]+2)+"' ln_2.y1='"+String(i_l_y[i_i_tab_pointer]+6)+"' ln_2.x2='"+String(i_l_x[i_i_tab_pointer]+2)+"' ln_2.y2='"+String(i_l_y[i_i_tab_pointer]+i_l_row_size+1)+"' " &
	+"ln_3.x1='"+String(i_l_x[i_i_tab_pointer]+1)+"' ln_3.y1='"+String(i_l_y[i_i_tab_pointer]+5)+"' ln_3.x2='"+String(i_l_x[i_i_tab_pointer]+1)+"' ln_3.y2='"+String(i_l_y[i_i_tab_pointer]+i_l_row_size+1)+"' " &
	+"ln_4.x1='"+String(i_l_x[i_i_tab_pointer]+2)+"' ln_4.y1='"+String(i_l_y[i_i_tab_pointer]+6)+"' ln_4.x2='"+String(i_l_x[i_i_tab_pointer]+6)+"' ln_4.y2='"+String(i_l_y[i_i_tab_pointer]+2)+"' " &
	+"ln_5.x1='"+String(i_l_x[i_i_tab_pointer]+i_l_tab_width - 6+3)+"' ln_5.y1='"+String(i_l_y[i_i_tab_pointer]+3)+"' ln_5.x2='"+String(i_l_x[i_i_tab_pointer]+i_l_tab_width - 6+3)+"' ln_5.y2='"+String(i_l_y[i_i_tab_pointer]+i_l_row_size+2)+"' " &
	+"ln_6.x1='"+String(i_l_x[i_i_tab_pointer]+i_l_tab_width - 6+0)+"' ln_6.y1='"+String(i_l_y[i_i_tab_pointer]+0)+"' ln_6.x2='"+String(i_l_x[i_i_tab_pointer]+i_l_tab_width - 6+3)+"' ln_6.y2='"+String(i_l_y[i_i_tab_pointer]+3)+"' " &
	+"focus.x='"+String(i_l_x[i_i_tab_pointer]+7)+"' focus.y='"+String(i_l_y[i_i_tab_pointer]+6 )+"' " &
	+"st_1.x='"+String(i_l_x[i_i_tab_pointer]+7)+"' st_1.y='"+String(i_l_y[i_i_tab_pointer]+6)+"' st_1.text='"+i_s_tab_text[i_tab]+"' "

Modify (s_dwsyntax)
i_i_tab_pointer = i_tab
l_ubound = Upperbound (i_go_tab_objects[])
SetRedraw (TRUE)
SetPointer (Arrow!)

// Change the dragobject if needed
IF l_ubound >= i_i_old_tab_pointer THEN
	IF IsValid(i_go_tab_objects[i_i_old_tab_pointer]) THEN
		i_go_tab_objects[i_i_old_tab_pointer].Hide ()
	END IF
END IF
IF l_ubound >= i_i_tab_pointer THEN
	IF IsValid(i_go_tab_objects[i_i_tab_pointer]) THEN
		i_go_tab_objects[i_i_tab_pointer].Show ()
//		fu_bring_tab_object_to_top (i_i_tab_pointer)
	END IF
END IF

this.PostEvent ("ue_tabfocuschanged")

RETURN 1

end function

public subroutine fu_set_auto_align (boolean a_b_align);// Sets the auto align variable to align objects upon tab creation.

i_b_auto_align = a_b_align
end subroutine

public subroutine fu_set_tab_text (integer a_i_tab_pointer, integer a_i_text_pointer);String	s_dwsyntax

// Support function for fu_set_active_tab..... Changes the tab text
s_dwsyntax = "stab_"+String(a_i_tab_pointer)+".text='"+i_s_tab_text[a_i_text_pointer]+"' "
Modify (s_dwsyntax)

end subroutine

public subroutine fu_resize_tab_object (integer a_i_tab_num);// Resize the object associated with tab number a_i_tab_num.  This
// object may be a Window or a WindowObject.

Window i_w_object
WindowObject i_wo_object


// Extract the type of the GraphicObject associated with tab number
// a_i_tab_num and resize the object the the workspace size.

CHOOSE CASE TypeOf (i_go_tab_objects [a_i_tab_num])

	CASE Menu!			// Menus are not allowed
		RETURN

	CASE Window!		// This is a Window
		i_w_object = i_go_tab_objects [a_i_tab_num]
		i_w_object.Resize (i_l_area_width, i_l_area_height)

	CASE ELSE			// Must be a WindowObject
		i_wo_object = i_go_tab_objects [a_i_tab_num]
		i_wo_object.Resize (i_l_area_width, i_l_area_height)

END CHOOSE
end subroutine

public subroutine fu_move_tab_object (integer a_i_tab_num);// Move the object associated with tab number a_i_tab_num.  This
// object may be a Window or a WindowObject.

Window i_w_object
WindowObject i_wo_object


// Extract the type of the GraphicObject associated with tab number
// a_i_tab_num and move the object the the workspace coordinates.

CHOOSE CASE TypeOf (i_go_tab_objects [a_i_tab_num])

	CASE Menu!			// Menus are not allowed
		RETURN

	CASE Window!		// This is a Window
		i_w_object = i_go_tab_objects [a_i_tab_num]
		i_w_object.Move (i_l_area_x, i_l_area_y)

	CASE ELSE			// Must be a WindowObject
		i_wo_object = i_go_tab_objects [a_i_tab_num]
		i_wo_object.Move (i_l_area_x, i_l_area_y)

END CHOOSE
end subroutine

public function graphicobject fu_get_tab_object (int a_i_tab_num);// Returns the GraphicObject associated with the passed in tab.

RETURN i_go_tab_objects [a_i_tab_num]
end function

public subroutine fu_bring_tab_object_to_top (integer a_i_tab_num);// Bring the object associated with tab number a_i_tab_num to the
// top.  This object may be a Window or a DrawObject.

Window i_w_object
DragObject i_do_object


// Extract the type of the GraphicObject associated with tab number
// a_i_tab_num and resize the object the the workspace size.

CHOOSE CASE TypeOf (i_go_tab_objects [a_i_tab_num])

	CASE Menu!			// Menus are not allowed
		RETURN

	CASE Window!		// This is a Window
		i_w_object = i_go_tab_objects [a_i_tab_num]
		i_w_object.SetPosition (ToTop!)

	CASE MDIClient!	// MDIClients are not allowed
		RETURN

	CASE Line!, Oval!, Rectangle!, RoundRectangle!
		RETURN			// DrawObjects are not allowed

	CASE ELSE			// Must be a DragObject
		i_do_object = i_go_tab_objects [a_i_tab_num]
		i_do_object.SetPosition (ToTop!)

END CHOOSE
end subroutine

on constructor;//
//	Maintenance
//		2/28/95	#3		Added functionality for automatic resizing and
//							and orientation of DragObjects associated with
//							each tab.
//		2/28/95	#8		Miscellaneaous changes to function scope and
//							added the "ue_tabclicked" event.
//		2/28/95	#29	Reset WorkSpace variables after a resize.
//		3/30/95	#38	Changed array of object from DragObject to
//							GraphicObject so that child Windows can be
//							managed by the object.
end on

event clicked;
// Set the clicked tab to the active tab.

Integer i_tab_pointer, i_text_pointer


// Get the clicked tab and bail out if no tab is selected

i_text_pointer = fu_get_clicked_tab ( )

IF i_text_pointer < 1 THEN
	RETURN
END IF


//	Set the clicked tab as active if it isn't already active.

i_tab_pointer = i_i_text_pointers[ i_text_pointer ]

IF i_tab_pointer <> i_i_tab_pointer AND &
	i_tab_pointer <= i_i_num_tabs THEN
	fu_set_active_tab (i_tab_pointer)
END IF
end event

event losefocus;// Turn off focus rect.

this.Modify ("focus.Visible='0'")
end event

event getfocus;// Turn on the focus rect.

this.Modify ("focus.Visible='1'")
end event

on u_dw_tab_bleu.create
end on

on u_dw_tab_bleu.destroy
end on

