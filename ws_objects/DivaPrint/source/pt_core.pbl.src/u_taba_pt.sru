$PBExportHeader$u_taba_pt.sru
$PBExportComments$Ancêtre des Onglets
forward
global type u_taba_pt from tab
end type
end forward

global type u_taba_pt from tab
int Width=1152
int Height=864
int TabOrder=1
boolean MultiLine=true
boolean FixedWidth=true
boolean RaggedRight=true
Alignment Alignment=Right!
int SelectedTab=1
long BackColor=78164112
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type
global u_taba_pt u_taba_pt

type variables
PROTECTED:
Boolean		i_b_fixed_width	// Specifies whether tabs have a fixed width, meaning they do not shrink to the length of their text labels. Values are:·	True — Tab width is fixed. The width is determined by the longest text label.·	False — Tab width adjusts to the length of the text labels.
Boolean		i_b_auto_align	//Align all objects
Boolean		i_b_auto_size	//Size all objects to workspace
Boolean		i_b_clear_tabs_on_create  = true //Reset the tab array on create
Integer		i_i_height		// Specifies the height of the control, in PowerBuilder units.
Integer		i_i_selected_tab // The index number of the selected tab.
Integer		i_i_num_tabs	//Number of tabs
Long		i_l_area_x	//Position of tab page - used to map position of associated window controls
Long		i_l_area_y	//Position of tab page
Long		i_l_area_height	//Height of Tab page
Long		i_l_area_width	//Width of tab page

PUBLIC:
userobject	iuo_tabpage[]	// Array of Tabpages
str_tab		i_str_tab[]                 //Array of Tabs
end variables

forward prototypes
public function integer fu_create_tabs (integer a_i_nbr_tabs, str_tab a_str_tab[])
public function integer fu_get_tab ()
public function integer fu_set_tab_text (integer a_i_tabpage, string a_s_text)
public function integer fu_create_tabs (integer a_i_nbr_tabs, integer a_i_tabs_per_row, str_pass a_str_pass, boolean a_b_fixed_width)
public subroutine fu_align_objects (boolean a_b_align, boolean a_b_resize)
public subroutine fu_move_tab_object (integer a_i_tab_num)
public subroutine fu_resize_tab_object (integer a_i_tab_num)
public subroutine fu_set_work_area ()
public subroutine fu_set_auto_align (boolean a_b_auto_align)
public subroutine fu_set_auto_size (boolean a_b_auto_size)
public function integer fu_set_tab_picture (integer a_i_tabpage, string a_s_picture_name)
public function integer fu_close_tab (integer a_i_tab_num)
public function integer fu_clear_all_tabs ()
public subroutine fu_set_powertips (boolean a_b_show_powertips)
public subroutine fu_set_fixedwidth (boolean a_b_fixedwidth)
public subroutine fu_set_showtext (boolean a_b_showtext)
public subroutine fu_set_showpicture (boolean a_b_showpicture)
public subroutine fu_set_multiline (boolean a_b_multiline)
public subroutine fu_set_tabposition (TabPosition a_TabPosition)
public subroutine fu_set_clear_tabs_on_create (boolean a_b_clear_tabs_on_create)
public subroutine fu_set_raggedright (boolean a_b_raggedright)
public function integer fu_set_tab_powertip_text (integer a_i_tabpage, string a_s_powertiptext)
public function string fu_get_tab_text ()
end prototypes

public function integer fu_create_tabs (integer a_i_nbr_tabs, str_tab a_str_tab[]);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_create_tabs  		
//
//	Access:  		public
//
//	Arguments:		
//	ARG1				The .ini file.
//	
//
//	Returns:  		Integer
//						 1	success
//
//	Description:  Create the tabpage objects based on the a_str_tab structure.
//
//////////////////////////////////////////////////////////////////////////////

Integer i_indx, i_tot_tabs, i_arg_indx

str_tab	str_tab
u_tabpage	u_new

//  Clear Existing tab pages if not to be retained
if i_b_clear_tabs_on_create then
	this.fu_clear_all_tabs()
end if

i_indx = UpperBound(i_str_tab[])			// In case we already have tab pages
i_tot_tabs = i_indx + a_i_nbr_tabs  
i_indx ++
i_arg_indx = 1


//fu_get_ini_values() 

DO WHILE i_indx <= i_tot_tabs
	
	IF (this.OpenTabWithParm (iuo_tabpage[i_indx], a_str_tab[i_arg_indx], a_str_tab[i_arg_indx].object, 0) < 0) THEN
	 	 MessageBox('Tab error', 'Tab Error')
		 RETURN -1
	END IF
	i_str_tab[i_indx] = a_str_tab[i_arg_indx]
	if a_str_tab[i_arg_indx].text <> '' then
	 	fu_set_tab_text(i_indx, a_str_tab[i_arg_indx].text)
	end if
	if a_str_tab[i_arg_indx].picture <> '' then
	 	fu_set_tab_picture(i_indx, a_str_tab[i_arg_indx].picture)
	end if
	if a_str_tab[i_arg_indx].powertiptext <> '' then
	 	fu_set_tab_powertip_text(i_indx, a_str_tab[i_arg_indx].powertiptext)
	end if
	
	i_arg_indx ++
	i_indx ++
LOOP

i_i_num_tabs = i_tot_tabs

this.fu_align_objects(i_b_auto_align, i_b_auto_size)

this.selecttab(1)

RETURN 1
end function

public function integer fu_get_tab ();
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_get_tab	
//
//	Access:  		public
//
//	Arguments:		none
//	
//	Returns:  		Integer
//						 
//	Description:   Return the currently selected tab
//
//////////////////////////////////////////////////////////////////////////////
// 
RETURN this.selectedtab

end function

public function integer fu_set_tab_text (integer a_i_tabpage, string a_s_text);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_set_tab_text  		
//
//	Access:  		public
//
//	Arguments:		
//	integer			a_i_tabpage - The tabpage index number
//	string			a_s_text - The text to be displayed on the tab page.	
//
//	Returns:  		Integer
//					1 -	success
//					-1 - Tab page not found
//
//	Description: 	Sets the text for the specified tabpage.
//
//////////////////////////////////////////////////////////////////////////////

IF a_i_tabpage > UpperBound(iuo_tabpage[])  THEN
	RETURN -1
END IF

iuo_tabpage[a_i_tabpage].text = a_s_text

RETURN 1

end function

public function integer fu_create_tabs (integer a_i_nbr_tabs, integer a_i_tabs_per_row, str_pass a_str_pass, boolean a_b_fixed_width);//Overloaded function to use Obsolete PT DW tab object style.
// map str pass to str_tab and call the 'real' fu_create_tabs 

str_tab str_tabs[]
integer i_idx

for i_idx = 1 to a_i_nbr_tabs
	str_tabs[i_idx].text = a_str_pass.s[i_idx]
	str_tabs[i_idx].picture = ''
	str_tabs[i_idx].object = 'u_tabpage'
	str_tabs[i_idx].assoc_object = a_str_pass.po[i_idx]
next

return this.fu_create_tabs(a_i_nbr_tabs, str_tabs) 


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

fu_set_work_area()

// Align and/or resize each DragObject in the array.

FOR i_tab_num = 1 TO i_i_num_tabs

	IF i_tab_num > UpperBound (i_str_tab) THEN
		EXIT
	END IF

	IF IsValid (i_str_tab[i_tab_num].assoc_object) THEN

		IF a_b_align THEN
			this.fu_move_tab_object (i_tab_num)
		END IF

		IF a_b_resize THEN
			this.fu_resize_tab_object (i_tab_num)
		END IF

	END IF

NEXT
end subroutine

public subroutine fu_move_tab_object (integer a_i_tab_num);// Move the object associated with tab number a_i_tab_num.  This
// object may be a Window or a WindowObject.

Window i_w_object
WindowObject i_wo_object


// Extract the type of the GraphicObject associated with tab number
// a_i_tab_num and move the object the the workspace coordinates.

CHOOSE CASE TypeOf (i_str_tab[a_i_tab_num].assoc_object)

	CASE Menu!			// Menus are not allowed
		RETURN

	CASE Window!		// This is a Window
		i_w_object = i_str_tab[a_i_tab_num].assoc_object
		i_w_object.Move (i_l_area_x, i_l_area_y)

	CASE ELSE			// Must be a WindowObject
		i_wo_object = i_str_tab[a_i_tab_num].assoc_object
		i_wo_object.Move (i_l_area_x, i_l_area_y)

END CHOOSE
end subroutine

public subroutine fu_resize_tab_object (integer a_i_tab_num);// Resize the object associated with tab number a_i_tab_num.  This
// object may be a Window or a WindowObject.

Window i_w_object
WindowObject i_wo_object


// Extract the type of the GraphicObject associated with tab number
// a_i_tab_num and resize the object the the workspace size.

CHOOSE CASE TypeOf (i_str_tab [a_i_tab_num].assoc_object)

	CASE Menu!			// Menus are not allowed
		RETURN

	CASE Window!		// This is a Window
		i_w_object = i_str_tab [a_i_tab_num].assoc_object
		i_w_object.Resize (i_l_area_width, i_l_area_height)

	CASE ELSE			// Must be a WindowObject
		i_wo_object = i_str_tab [a_i_tab_num].assoc_object
		i_wo_object.Resize (i_l_area_width, i_l_area_height)

END CHOOSE
end subroutine

public subroutine fu_set_work_area ();//This funciton will determine the assoc_object size and position
//based on the tab configuration and tab object size

if upperbound(iuo_tabpage) > 0 then
	if isvalid(iuo_tabpage[1]) then
		i_l_area_x = iuo_tabpage[1].x + 5
		i_l_area_y = iuo_tabpage[1].y + 10
		i_l_area_height =  iuo_tabpage[1].height - 10
		i_l_area_width =  iuo_tabpage[1].width
	end if
end if

end subroutine

public subroutine fu_set_auto_align (boolean a_b_auto_align);//Set the auto align boolean

i_b_auto_align = a_b_auto_align
end subroutine

public subroutine fu_set_auto_size (boolean a_b_auto_size);//Set auto size boolean

i_b_auto_size = a_b_auto_size
end subroutine

public function integer fu_set_tab_picture (integer a_i_tabpage, string a_s_picture_name);
//////////////////////////////////////////////////////////////////////////////
//
//	Function:		fu_set_tab_picture 		
//
//	Access:  		public
//
//	Arguments:		
//	integer			a_i_tabpage - The tabpage index number
//	string			a_s_text - The text to be displayed on the tab page.	
//
//	Returns:  		Integer
//					1 -	success
//					-1 - Tab page not found
//
//	Description: 	Sets the picture for the specified tabpage.
//
//////////////////////////////////////////////////////////////////////////////

IF a_i_tabpage > UpperBound(iuo_tabpage[])  THEN
	RETURN -1
END IF

iuo_tabpage[a_i_tabpage].picturename = a_s_picture_name

RETURN 1

end function

public function integer fu_close_tab (integer a_i_tab_num);//  This function will close a dynamically opened tab

str_tab str_tab

if isvalid(i_str_tab[a_i_tab_num].assoc_object) then
	i_str_tab[a_i_tab_num].assoc_object.visible = false
end if

this.closetab(iuo_tabpage[a_i_tab_num])
i_str_tab[a_i_tab_num] = str_tab

return 1
end function

public function integer fu_clear_all_tabs ();// This function will close all the tab pages. And clear the 
// instance arrays of tabs and associated properties

int i_indx
str_tab str_tab[]
userobject uo_tabpage[]

i_indx = upperbound(iuo_tabpage)
if i_indx = 0 then
	return 1
end if

do while i_indx > 0
	fu_close_tab(i_indx)
	i_indx --
loop

i_str_tab = str_tab
iuo_tabpage = uo_tabpage

return 1
	
	
	
end function

public subroutine fu_set_powertips (boolean a_b_show_powertips);This.PowerTips = a_b_show_powertips
end subroutine

public subroutine fu_set_fixedwidth (boolean a_b_fixedwidth);this.FixedWidth = a_b_fixedwidth
end subroutine

public subroutine fu_set_showtext (boolean a_b_showtext);This.ShowText = a_b_showtext
end subroutine

public subroutine fu_set_showpicture (boolean a_b_showpicture);This.ShowPicture = a_b_showpicture
end subroutine

public subroutine fu_set_multiline (boolean a_b_multiline);This.MultiLine = a_b_multiline
end subroutine

public subroutine fu_set_tabposition (TabPosition a_TabPosition);This.TabPosition = a_TabPosition
end subroutine

public subroutine fu_set_clear_tabs_on_create (boolean a_b_clear_tabs_on_create);// Sets boolean that will cause existing Tabs to be destroyed before
// creating new ones if true - or add new tabs to existing tab array
// if false
i_b_clear_tabs_on_create = a_b_clear_tabs_on_create
end subroutine

public subroutine fu_set_raggedright (boolean a_b_raggedright);//Set boolean that indicated whether tabs should be flush to control edge
// or should only use the room they need

this.RaggedRight = a_b_raggedright
end subroutine

public function integer fu_set_tab_powertip_text (integer a_i_tabpage, string a_s_powertiptext);//

IF a_i_tabpage > UpperBound(iuo_tabpage[])  THEN
	RETURN -1
END IF

iuo_tabpage[a_i_tabpage].powertiptext = a_s_powertiptext

RETURN 1
end function

public function string fu_get_tab_text ();
// Return the text of the current tab

if ( selectedtab > 0 ) and ( selectedtab <= upperbound(iuo_tabpage) )then
	return iuo_tabpage[selectedtab].text
else
	return ''
end if
	



end function

event selectionchanged;integer i_tab

if upperbound(i_str_tab) = 0 then
	return
end if

for i_tab = 1 to upperbound(i_str_tab)
	if isvalid(i_str_tab[i_tab].assoc_object) then
		i_str_tab[i_tab].assoc_object.visible = false
	end if
next

i_tab = this.selectedtab 

if isvalid (i_str_tab[i_tab].assoc_object) then
	i_str_tab[i_tab].assoc_object.visible = true
end if









end event

event constructor;//Populate the tab array with the any existing tabs

int i_idx, i_limit

i_limit = upperbound(control)

if i_limit > 0 then
	for i_idx = 1 to i_limit
		iuo_tabpage[i_idx] = control[i_idx]
		i_str_tab[i_idx].text = iuo_tabpage[i_idx].text
		i_str_tab[i_idx].picture = iuo_tabpage[i_idx].picturename
		i_str_tab[i_idx].powertiptext = iuo_tabpage[i_idx].powertiptext
		i_str_tab[i_idx].object = iuo_tabpage[i_idx].classname
	next
end if

end event

