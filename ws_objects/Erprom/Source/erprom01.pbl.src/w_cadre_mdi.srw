$PBExportHeader$w_cadre_mdi.srw
$PBExportComments$Cadre MDI de l'application
forward
global type w_cadre_mdi from w_fa
end type
end forward

global type w_cadre_mdi from w_fa
integer height = 1068
string title = "Gestion des promotions"
string menuname = "m_cadre_mdi"
boolean toolbarvisible = false
end type
global w_cadre_mdi w_cadre_mdi

event ue_init;call super::ue_init;this.title = this.title + " - V" +  g_s_version

CHOOSE Case g_s_profil

	Case CODE_ADMINISTRATEUR
		m_cadre_mdi.m_item1.Visible	=	True
		m_cadre_mdi.m_item5.Visible	=	True
		m_cadre_mdi.m_item2.Visible	=	False		
			
	Case Else
		m_cadre_mdi.m_item1.Visible	=	False
		m_cadre_mdi.m_item5.Visible	=	False

END CHOOSE
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

