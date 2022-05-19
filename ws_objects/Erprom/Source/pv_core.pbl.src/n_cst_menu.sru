$PBExportHeader$n_cst_menu.sru
$PBExportComments$* Extension Menu service
forward
global type n_cst_menu from nonvisualobject
end type
end forward

global type n_cst_menu from nonvisualobject autoinstantiate
end type

type prototypes
Protected:
Function Long GetMenuString(ULong hMenu, ULong uIDItem, Ref String lpString, Long nMaxCount, ULong uFlag) Library 'user32.dll' Alias For "GetMenuStringA;Ansi"
end prototypes

type variables
Public:
Constant Long		MF_BYCOMMAND = 0
Constant Long		MF_SYSMENU = 8192
Constant Long		MF_BYPOSITION = 1024
end variables

forward prototypes
public function menu of_findmenu (menu am_menu, string as_menutext)
public function long of_getmenustring (unsignedlong aul_hmenu, unsignedlong aul_uiditem, ref string as_lpstring, long al_nmaxcount, unsignedlong aul_uflag)
end prototypes

public function menu of_findmenu (menu am_menu, string as_menutext);Menu lm_menu; SetNull(lm_menu)

Integer li_index
Integer li_submenucount


// Check reference.
If IsValid(am_menu) Then
	If (am_menu.Text = as_menutext) Then
		lm_menu = am_menu
	Else
		li_submenucount = UpperBound(am_menu.Item[])
		If (li_submenucount > 0) Then
			li_index = 1
			Do While (li_index <= li_submenucount)
				lm_menu = this.of_FindMenu(am_menu.Item[li_index], as_menutext)
				If IsValid(lm_menu) Then
					Exit
				Else
					li_index++
				End If
			Loop
		Else
			SetNull(lm_menu)
		End If
	End If
End If

Return lm_menu
end function

public function long of_getmenustring (unsignedlong aul_hmenu, unsignedlong aul_uiditem, ref string as_lpstring, long al_nmaxcount, unsignedlong aul_uflag);Return this.GetMenuString(aul_hmenu, aul_uiditem, as_lpstring, al_nmaxcount, aul_uflag)
end function

on n_cst_menu.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_menu.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

