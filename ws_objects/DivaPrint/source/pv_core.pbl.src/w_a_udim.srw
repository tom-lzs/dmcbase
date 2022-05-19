$PBExportHeader$w_a_udim.srw
$PBExportComments$[MAIN] Ancêtre des fenêtres de Gestion Multi-lignes.
forward
global type w_a_udim from w_a_udim_pt
end type
type uo_statusbar from u_statusbar within w_a_udim
end type
end forward

global type w_a_udim from w_a_udim_pt
integer x = 769
integer y = 461
integer width = 1499
integer height = 1000
uo_statusbar uo_statusbar
end type
global w_a_udim w_a_udim

on w_a_udim.create
int iCurrent
call super::create
this.uo_statusbar=create uo_statusbar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_statusbar
end on

on w_a_udim.destroy
call super::destroy
destroy(this.uo_statusbar)
end on

event resize;call super::resize;// Refresh the statusbar.
uo_statusbar.Event ue_Refresh()
end event

type dw_1 from w_a_udim_pt`dw_1 within w_a_udim
end type

type uo_statusbar from u_statusbar within w_a_udim
integer x = 41
integer y = 848
integer taborder = 11
boolean bringtotop = true
end type

event constructor;call super::constructor;// Load icons.
il_hicons[1] = this.of_LoadIcon('server.ico')

end event

event size;call super::size;Constant Integer ACTIVITYWIDTH = 125
Constant Integer DATETIMEWIDTH = 135
Constant Integer SERVERNAMEWIDTH = 185


Long ll_width
Long ll_part[]


// Get the width of the window in pixels.
ll_width = UnitsToPixels(this.Width, XUnitsToPixels!)

// Determine the width remaining.
ll_width = (ll_width - (ACTIVITYWIDTH + SERVERNAMEWIDTH + DATETIMEWIDTH))

// Assign individual part sizes.
ll_part[1] = ll_width
ll_part[2] = ll_part[1] + ACTIVITYWIDTH + SERVERNAMEWIDTH
ll_part[3] = ll_part[2] + DATETIMEWIDTH
//ll_part[4] = ll_part[3] + DATETIMEWIDTH

// Set the parts of the statusbar.
this.of_SetParts(ll_part)
end event

event ue_refreshstatusbar;call super::ue_refreshstatusbar;
Long ll_hicon

String ls_text


Choose Case ai_part
	Case 0
		// Get the current microhelp.
		ls_text = this.of_GetText(0)
		
		// If the microhelp is empty then use the default.
		If IsNull(ls_text) OR Len(Trim(ls_text)) = 0 Then
			ls_text = 'Ready'
		End If

//	Case 1
		// Refresh the current accumulated case time.
//		ls_text = '       '
//		ll_hicon = il_hicons[1]

	Case 1
		// Refresh the current server connection.
		ls_text = 'Server: ' + g_nv_ini.fnv_profile_string( g_nv_ini.fnv_profile_string("DefaultDBMS","DBMS",""),"Servername","Unknow")
		ls_text = ls_text + '  - Database: ' + g_nv_ini.fnv_profile_string( g_nv_ini.fnv_profile_string("DefaultDBMS","DBMS",""),"Database","Unknow")
		ll_hicon = il_hicons[1]

	Case 2
	     ls_text = 'Version : '  + g_s_version

End Choose

// Set the text for a requested segment.
this.of_SetText(ai_part, 0, ls_text)

// Set the icon for a requested segment.
If ll_hicon > 0 Then this.of_SetIcon(ai_part, ll_hicon)
end event

