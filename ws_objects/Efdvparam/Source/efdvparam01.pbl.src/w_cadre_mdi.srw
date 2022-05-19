$PBExportHeader$w_cadre_mdi.srw
$PBExportComments$Fenetre principale de l'application (MDI)
forward
global type w_cadre_mdi from w_fa
end type
end forward

global type w_cadre_mdi from w_fa
integer width = 2011
integer height = 1712
string menuname = "m_cadre_mdi"
boolean resizable = true
windowtype windowtype = mdi!
arrangeopen i_e_style = original!
end type
global w_cadre_mdi w_cadre_mdi

event open;call super::open;/* <DESC>
     Ouverture de la fenetre.
   </DESC> */
// Initialisation de la variable globale
	g_w_frame = This
	this.Toolbarvisible = False
end event

on w_cadre_mdi.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_cadre_mdi" then this.MenuID = create m_cadre_mdi
end on

on w_cadre_mdi.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

