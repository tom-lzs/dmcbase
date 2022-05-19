$PBExportHeader$u_statusbar.sru
$PBExportComments$Statusbar control.
forward
global type u_statusbar from userobject
end type
type rect from structure within u_statusbar
end type
end forward

type RECT from structure
	long		left
	long		top
	long		right
	long		bottom
end type

global type u_statusbar from userobject
integer width = 1175
integer height = 84
userobjects objecttype = externalvisual!
long backcolor = 0
string classname = "msctls_statusbar32"
string libraryname = "comctl32.dll"
long style = 1174405376
event ue_timer ( )
event ue_refresh ( )
event type long ue_menuselect ( unsignedinteger aui_itemid,  unsignedinteger aui_flags,  long al_hmenu )
event doubleclicked pbm_lbuttondblclk
event rbuttonup pbm_rbuttonup
event size pbm_size
event ue_refreshstatusbar ( integer ai_part )
event ue_doubleclicked ( integer ai_part )
end type
global u_statusbar u_statusbar

type prototypes
Protected:
Function Long LoadImage(Long hInst, String lpszName, ULong uType, ULong cxDesired, ULong cyDesired, ULong fuLoad) Library 'user32' Alias for "LoadImageA;Ansi"

Function Long GetBorders(Long hWnd, UInt Msg, Int wParam, Ref Long Parts[]) Library 'user32' Alias For SendMessageA

Function Long GetIcon(Long hWnd, UInt Msg, Int wParam, Long hIcon) Library 'user32' Alias For SendMessageA
Function Long SetIcon(Long hWnd, UInt Msg, Int wParam, Long hIcon) Library 'user32' Alias For SendMessageA

Function Long GetParts(Long hWnd, UInt Msg, ULong wParam, Ref Long Parts[]) Library 'user32' Alias For SendMessageA
Function Long SetParts(Long hWnd, UInt Msg, ULong wParam, Ref Long Parts[]) Library 'user32' Alias For SendMessageA

Function Long GetRect(Long hWnd, UInt Msg, ULong wParam, Ref RECT lpRect) Library 'user32' Alias For "SendMessageA;Ansi"

Function Long GetText(Long hWnd, UInt Msg, ULong wParam, Ref String szText) Library 'user32' Alias For "SendMessageA;Ansi"
Function Long SetText(Long hWnd, UInt Msg, ULong wParam, Ref String szText) Library 'user32' Alias For "SendMessageA;Ansi"

Function Long IsSimple(Long hWnd, UInt Msg, Int wParam, Int lParam) Library 'user32' Alias For SendMessageA

Function Long SetBackgroundColor(Long hWnd, UInt Msg, ULong wParam, Long clrref) Library 'user32' Alias For SendMessageA
end prototypes

type variables
Protected:
// Statusbar styles.
Constant Long		SBT_NOBORDERS = 256
Constant Long		SBT_POPOUT = 512
Constant Long		SBT_RTLREADING = 1024
Constant Long		SBT_OWNERDRAW = 4096

// Statusbar messages.
Constant UInt		WM_NOTIFY = 78
Constant UInt		WM_USER = 1024

Constant UInt		SB_SETTEXT = (WM_USER + 1)
Constant UInt		SB_GETTEXT = (WM_USER + 2)
Constant UInt		SB_GETTEXTLENGTH = (WM_USER + 3)
Constant UInt		SB_SETPARTS = (WM_USER + 4)
Constant UInt		SB_GETPARTS = (WM_USER + 6)
Constant UInt		SB_GETBORDERS = (WM_USER + 7)
Constant UInt		SB_SETMINHEIGHT = (WM_USER + 8)
Constant UInt		SB_SIMPLE = (WM_USER + 9)
Constant UInt		SB_GETRECT = (WM_USER + 10)
Constant UInt		SB_ISSIMPLE = (WM_USER + 14)
Constant UInt		SB_SETICON = (WM_USER + 15)
Constant UInt		SB_SETTIPTEXT = (WM_USER + 16)
Constant UInt		SB_GETTIPTEXT = (WM_USER + 18)
Constant UInt		SB_GETICON = (WM_USER + 20)
Constant UInt		SB_SETBKCOLOR = (WM_USER + 7169)

Constant ULong		CLR_DEFAULT = 4278190080

n_tmg					inv_timer

Window					iw_parent

Boolean					ib_usetimer

Decimal					idc_refreshinterval

Long						il_hstatusbar
Long						il_hicons[255]
end variables

forward prototypes
public function integer of_gettextlength (readonly long al_part)
public function boolean of_settext (readonly integer ai_part, readonly integer ai_style, string as_text)
public function boolean of_issimple ()
public function boolean of_setsimple (readonly boolean ab_simple)
public function unsignedlong of_setbackgroundcolor (unsignedlong aul_color)
public function long of_getparts (ref long al_parts[])
public function boolean of_setparts (long al_parts[])
public function boolean of_seticon (integer ai_part, long al_icon)
public function boolean of_getrect (readonly long al_part, ref long al_top, ref long al_left, ref long al_right, ref long al_bottom)
public function decimal of_getrefreshinterval ()
public function integer of_setrefreshinterval (decimal adc_refreshinterval)
public function long of_geticon (integer ai_part)
public function string of_gettext (readonly integer ai_part)
public function integer of_getpart (integer ai_xpos, integer ai_ypos)
public function boolean of_settext (readonly integer ai_part, string as_text)
public function boolean of_getborders (ref long al_horizontalwidth, ref long al_verticalwidth, ref long al_seperatorwidth)
public function unsignedlong of_loadicon (string as_filename)
end prototypes

event ue_refresh();Long ll_index
Long ll_parts[]
Long ll_uperbound


// Automatically resize the statusbar.
this.Resize(0, 0)

// Get the number of defined parts.
ll_uperbound = this.of_GetParts(ll_parts[])

// Loop through and refresh each part.
For ll_index = 1 To ll_uperbound
	this.Event ue_RefreshStatusBar(ll_index - 1)
Next
end event

event type long ue_menuselect(unsignedinteger aui_itemid, unsignedinteger aui_flags, long al_hmenu);n_cst_menu lnv_menu
n_cst_numerical lnv_numerical

Menu lm_menu

String ls_menutext = Space(255)


// Check references.
If al_hmenu = 0 AND aui_itemid = 0 Then
	this.of_SetText(0, SBT_NOBORDERS, 'Ready')
Else
	// If this is the System Menu reset the MicroHelp text.
	If lnv_numerical.of_BitwiseAnd(aui_flags, lnv_menu.MF_SYSMENU) = lnv_menu.MF_SYSMENU Then
		this.of_SetText(0, SBT_NOBORDERS, 'Ready')
	Else
		// Get the name of the currently selected menu.
		If lnv_menu.of_GetMenuString(al_hmenu, aui_itemid, ls_menutext, Len(ls_menutext), lnv_menu.MF_BYCOMMAND) > 0 Then
			// Find the menu object that has this name.
			If IsValid(iw_parent.MenuID) Then
				// Set the statusbar with the microhelp value for this menu.				
				lm_menu = lnv_menu.of_FindMenu(iw_parent.MenuId, ls_menutext)
				If IsValid(lm_menu) Then
					this.of_SetText(0, this.SBT_NOBORDERS, lm_menu.MicroHelp)
				End If
			End If
		End If
	End If
End If

Return 0
end event

event doubleclicked;Integer li_part


// Determine the part clicked on.
li_part = this.of_GetPart(UnitsToPixels(xpos, XUnitsToPixels!), UnitsToPixels(ypos, YUnitsToPixels!))

// Check for valid part.
If li_part <> -1 Then
	// Trigger event for double click.
	this.Event ue_DoubleClicked(li_part)
End If
end event

public function integer of_gettextlength (readonly long al_part);Long ll_length


// This message retrieves the length, in characters, of the text from the specified part of the status window. 
ll_length = Send(il_hstatusbar, SB_GETTEXTLENGTH, al_part, 0)

Return IntLow(ll_length)
end function

public function boolean of_settext (readonly integer ai_part, readonly integer ai_style, string as_text);// This message sets the text in the specified part of a status window.
Return (SetText(il_hstatusbar, SB_SETTEXT, ai_part + ai_style, as_text ) <> 0)
end function

public function boolean of_issimple ();Long ll_result


ll_result = IsSimple(il_hstatusbar, SB_ISSIMPLE, 0, 0)

Return (ll_result <> 0)
end function

public function boolean of_setsimple (readonly boolean ab_simple);Long ll_simple


// Convert boolean to 'C' style boolean (NON-ZERO = TRUE)
If ab_simple Then ll_simple = 1 Else ll_simple = 0

// This message specifies whether a status window displays simple text or displays all window 
// parts set by a previous SB_SETPARTS message.
Return (Send(il_hstatusbar, SB_SIMPLE, ll_simple, 0) > 0)
end function

public function unsignedlong of_setbackgroundcolor (unsignedlong aul_color);// This message sets the icon for a part in a status bar.
Return SetBackgroundColor(il_hstatusbar, SB_SETBKCOLOR, 0, aul_color)
end function

public function long of_getparts (ref long al_parts[]);Long ll_index
Long ll_parts[]
Long ll_countparts
Long ll_parts128[128]


// Allocate memory for unbouded array before calling API function.
ll_parts[] = ll_parts128[]

// Get all of the parts in the status window.
ll_countparts = GetParts(il_hstatusbar, SB_GETPARTS, UpperBound(ll_parts), ll_parts)

If ll_countparts > 0 Then
	// An array assignment will copy all 128 elements, which is undesirable.
	For ll_index = 1 TO ll_countparts
		al_parts[ll_index] = ll_parts[ll_index]
	Next
End If

Return ll_countparts
end function

public function boolean of_setparts (long al_parts[]);Boolean lb_setparts

Long ll_countparts


ll_countparts = UpperBound(al_parts)

If ll_countparts > 0 Then
	// This message sets the number of parts in a status window and the coordinate of the right edge of each part.
	lb_setparts = (SetParts(il_hstatusbar, SB_SETPARTS, ll_countparts, al_parts[]) <> 0)
End If

Return lb_setparts
end function

public function boolean of_seticon (integer ai_part, long al_icon);// This message sets the icon for a part in a status bar.
Return (SetIcon(il_hstatusbar, SB_SETICON, ai_part, al_icon) <> 0)
end function

public function boolean of_getrect (readonly long al_part, ref long al_top, ref long al_left, ref long al_right, ref long al_bottom);RECT rect

Boolean lb_getrect


// Get the rectangle defined by a single part of the status window.
lb_getrect =(GetRect(il_hstatusbar, SB_GETRECT, al_part, rect) <> 0)

// Store a reference to this information.
If lb_getrect Then
	al_top = rect.Top
	al_left = rect.Left
	al_right = rect.Right
	al_bottom = rect.Bottom
End If

Return lb_getrect
end function

public function decimal of_getrefreshinterval ();Return idc_refreshinterval
end function

public function integer of_setrefreshinterval (decimal adc_refreshinterval);// Check reference.
If IsNull(adc_refreshinterval) Then Return -1

// Store a reference to the refresh interval.
idc_refreshinterval = Abs(adc_refreshinterval)

Return 1
end function

public function long of_geticon (integer ai_part);Return GetIcon(il_hstatusbar, SB_GETICON, ai_part, 0)
end function

public function string of_gettext (readonly integer ai_part);String ls_text


// Allocate space for the buffer.
ls_text = Space(255)

// This message retrieves the text from a specified part of a status window.
GetText(il_hstatusbar, SB_GETTEXT, ai_part, ls_text)

Return ls_text
end function

public function integer of_getpart (integer ai_xpos, integer ai_ypos);Long ll_top
Long ll_left
Long ll_right
Long ll_index
Long ll_parts[]
Long ll_bottom
Long ll_part = -1
Long ll_upperbound


// Get the number of parts (zero based index).
ll_upperbound = (this.of_GetParts(ll_parts) - 1)

// Loop through all parts.
For ll_index = 0 To ll_upperbound
	// Get the dimensions of each part.
	this.of_GetRect(ll_index, ll_top, ll_left, ll_right, ll_bottom)

	// Determine if co-ordinates are within part.
	If (ai_xpos >= ll_left AND ai_xpos <= ll_right) AND (ai_ypos >= ll_top AND ai_ypos <= ll_bottom) Then
		ll_part = ll_index
		Exit
	End If
Next

Return ll_part
end function

public function boolean of_settext (readonly integer ai_part, string as_text);Return this.of_SetText(ai_part, 0, as_text)
end function

public function boolean of_getborders (ref long al_horizontalwidth, ref long al_verticalwidth, ref long al_seperatorwidth);Boolean lb_getborders

Long ll_borders[]


// Dimension an unbounded array.
ll_borders[3] = 0
ll_borders[2] = 0
ll_borders[1] = 0

// Get the current widths of the horizontal and vertical borders of a status window.
lb_getborders = (GetBorders(il_hstatusbar, SB_GETBORDERS, 0, ll_borders) <> 0)

// Store a reference to the border information.
If lb_getborders Then
	al_horizontalwidth = ll_borders[1]
	al_verticalwidth = ll_borders[2]
	al_seperatorwidth = ll_borders[3]
End If

Return lb_getborders
end function

public function unsignedlong of_loadicon (string as_filename);Constant Long IMAGE_BITMAP = 0
Constant Long IMAGE_ICON = 1
Constant Long IMAGE_CURSOR	 = 2
Constant Long IMAGE_ENHMETAFILE = 3
Constant Long LR_LOADFROMFILE = 16

Long ll_null ; SetNull(ll_null)


Return LoadImage(ll_null, as_filename, IMAGE_ICON, 16, 16, LR_LOADFROMFILE)
end function

on u_statusbar.create
end on

on u_statusbar.destroy
end on

event constructor;PowerObject lpo_parent


// Store a reference to the handle.
il_hstatusbar = Handle(this)

// Set the default background color.
this.of_SetBackgroundColor(CLR_DEFAULT)

// Determine the parent window for this object.
lpo_parent = this.GetParent()
Do While IsValid(lpo_parent)
	If lpo_parent.TypeOf() <> Window! Then
		lpo_parent = lpo_parent.GetParent()
	Else
		Exit
	End If
Loop

// Store a reference to the parent window.
If NOT IsNull(lpo_parent) OR IsValid(lpo_parent) Then
	iw_parent = lpo_parent
End If

// Only create a timer when requested.
If ib_usetimer Then
	inv_timer = Create n_tmg
	inv_timer.of_SetSingle(true)
	// Establish the timer event.
	If IsValid(inv_timer.inv_single) Then
		inv_timer.inv_single.of_Register(this, 'ue_timer', 1)
	End If
End If
end event

event destructor;// Destroy the timing control.
//If IsValid(inv_timer) Then
//	If IsValid(inv_timer.inv_single) Then
//		inv_timer.inv_single.of_Unregister()
//	End If
//End If
end event

