$PBExportHeader$w_a.srw
$PBExportComments$Ancêtre des fenêtres associatives.
forward
global type w_a from w_a_pt
end type
type uo_statusbar from u_statusbar within w_a
end type
end forward

global type w_a from w_a_pt
integer x = 769
integer y = 461
uo_statusbar uo_statusbar
end type
global w_a w_a

type variables
Boolean ib_a_traduire
boolean  ib_statusbar_visible = false
end variables

on w_a.create
int iCurrent
call super::create
this.uo_statusbar=create uo_statusbar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_statusbar
end on

on w_a.destroy
call super::destroy
destroy(this.uo_statusbar)
end on

event open;call super::open;PowerObject po

if g_b_traduction then
	po = this
	g_nv_traduction.set_traduction( po)
end if

uo_statusbar.visible = ib_statusbar_visible
end event

event resize;call super::resize;// Refresh the statusbar.
uo_statusbar.Event ue_Refresh()
end event

type uo_statusbar from u_statusbar within w_a
integer x = 18
integer y = 836
integer taborder = 10
end type

event constructor;call super::constructor;// Load icons.
il_hicons[1] = this.of_LoadIcon('server.ico')
il_hicons[2] = this.of_LoadIcon('user.ico')
end event

event size;call super::size;Constant Integer USERWIDTH = 100
Constant Integer SERVERNAMEWIDTH =350
Constant Integer SERVERNAMEREMOTEWIDTH = 350
Constant Integer VERSIONWIDTH = 130
Constant Integer PATCHWIDTH = 100

Long ll_width
Long ll_part[]


// Get the width of the window in pixels.
ll_width = UnitsToPixels(this.Width, XUnitsToPixels!)

// Determine the width remaining.
ll_width = (ll_width - (VERSIONWIDTH + SERVERNAMEWIDTH + USERWIDTH  + SERVERNAMEREMOTEWIDTH+PATCHWIDTH))

// Assign individual part sizes.
//ll_part[1] = ll_width
ll_part[1] =  VERSIONWIDTH
ll_part[2] = ll_part[1] + PATCHWIDTH
ll_part[3] = ll_part[2] + USERWIDTH
ll_part[4] = ll_part[3] + SERVERNAMEWIDTH
ll_part[5] = ll_part[4] + SERVERNAMEREMOTEWIDTH
ll_part[6] = ll_part[5] + ll_width
// Set the parts of the statusbar.
this.of_SetParts(ll_part)
end event

event ue_refreshstatusbar;call super::ue_refreshstatusbar;Long ll_hicon
String ls_text

Choose Case ai_part
 	Case 0
	      ls_text = 'Version : '  + g_s_version
	Case 1
	     ls_text = 'Patch : ' + g_s_patch
		
	Case 2
		// Get ythe user code.
		ls_text = ' User: ' + g_s_visiteur
		ll_hicon = il_hicons[2]
	Case 3
		// Refresh the current server connection.
		ls_text = 'Server: ' + g_nv_ini.fnv_profile_string( g_nv_ini.fnv_profile_string("DefaultDBMS","DBMS",""),"Servername","Unknow")
		ls_text = ls_text + '  - Db: ' + g_nv_ini.fnv_profile_string( g_nv_ini.fnv_profile_string("DefaultDBMS","DBMS",""),"Database","Unknow")
		ll_hicon = il_hicons[1]
    Case 4
		// Refresh the current server connection.
		ls_text = 'Remote: ' + g_nv_ini.fnv_profile_string( g_nv_ini.fnv_profile_string("DefaultDBMS","DBMS_remote",""),"Servername","Unknow")
		ls_text = ls_text + '  - Db: ' + g_nv_ini.fnv_profile_string( g_nv_ini.fnv_profile_string("DefaultDBMS","DBMS_remote",""),"Database","Unknow")
		ll_hicon = il_hicons[1]

	Case 5
			ls_text = 'Ready'
end choose

// Set the text for a requested segment.
this.of_SetText(ai_part, 0, ls_text)

// Set the icon for a requested segment.
If ll_hicon > 0 Then this.of_SetIcon(ai_part, ll_hicon)
end event

