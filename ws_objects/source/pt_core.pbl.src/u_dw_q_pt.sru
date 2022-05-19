$PBExportHeader$u_dw_q_pt.sru
$PBExportComments$Contrôle DataWindow pour les consultations
forward
global type u_dw_q_pt from u_dwa
end type
end forward

global type u_dw_q_pt from u_dwa
end type
global u_dw_q_pt u_dw_q_pt

type variables
PROTECTED:

Boolean i_b_sort_on_label	// allow sorting on label click
String i_s_original_sort	// data object's initial sort string
end variables

forward prototypes
public subroutine fu_selection (integer a_i_selection_mode)
public function boolean fu_get_sort_on_label ()
public subroutine fu_set_sort_on_label (boolean a_b_sort_on_label)
end prototypes

public subroutine fu_selection (integer a_i_selection_mode);// This OBSOLETE function is here for compatibility only.

fu_set_selection_mode (a_i_selection_mode)
end subroutine

public function boolean fu_get_sort_on_label ();// Return value of instance variable.

RETURN i_b_sort_on_label
end function

public subroutine fu_set_sort_on_label (boolean a_b_sort_on_label);// Set value of instance variable to passed value.

i_b_sort_on_label = a_b_sort_on_label
end subroutine

event clicked;call u_dwa::clicked;// Add the column whose label was clicked on (as identified by
// <column name> + _t) to the sort criteria and sort.

String s_object, s_col_name


IF i_b_sort_on_label THEN
	IF Left (this.GetBandAtPointer ( ), 7) = "header~t" THEN
		s_object = this.GetObjectAtPointer ()
		s_object = Left (s_object, Pos (s_object, "~t") - 1)
		s_col_name = Left (s_object,Len (s_object) - 2)

		// 3d lowered border
		this.Modify (s_object + ".border='5'")
		this.SetSort (s_col_name + " A, " + i_s_original_sort)
		this.Sort ()
		this.PostEvent (RowFocusChanged!)
		// 3d raised border
		this.Modify (s_object + ".border='6'")
	END IF
END IF
end event

on constructor;call u_dwa::constructor;// Get the original sort criteria from the data object.

i_s_original_sort = this.Describe ('datawindow.table.sort')
end on

on we_dwnkey;call u_dwa::we_dwnkey;// Jump to the first or last row in the datawindow if the home or end
// keys are depressed, respectively.

Long l_row_num, l_row_cnt


CHOOSE CASE TRUE
	CASE KeyDown (KeyHome!)
		l_row_cnt = this.RowCount ()
		l_row_num = 1
	CASE KeyDown (KeyEnd!)
		l_row_cnt = this.RowCount ()
		l_row_num = l_row_cnt
	CASE ELSE
		RETURN
END CHOOSE


// Set and scroll to the new row

IF this.RowCount () > 0 THEN
	this.SetRow (l_row_num)
	this.ScrollToRow (l_row_num)
END IF
end on

