$PBExportHeader$w_frame_erfvmr.srw
$PBExportComments$Fenetre principale de l'application (MDI)
forward
global type w_frame_erfvmr from w_fa
end type
end forward

global type w_frame_erfvmr from w_fa
string tag = "TITRE_APPLI"
integer width = 2217
integer height = 2056
string menuname = "m_menu_principal"
boolean resizable = true
windowtype windowtype = mdi!
long backcolor = 16777215
boolean toolbarvisible = false
end type
global w_frame_erfvmr w_frame_erfvmr

forward prototypes
public subroutine fw_init_fenetre ()
end prototypes

public subroutine fw_init_fenetre ();String ls_mode_portable
String  ls_profil

g_b_traduction = true

ls_mode_portable = g_nv_ini.fnv_profile_string("Param","ModePortable","NON")
ls_profil = g_nv_ini.fnv_profile_string("Param","Profil",BLANK)

if upper(ls_mode_portable) = "OUI" then
	m_menu_principal.m_item5.visible = true
	m_menu_principal.m_item5.m_maj_portable.visible = true
	m_menu_principal.m_item5.m_transfertcde.visible = true
	if  g_nv_come9par.is_relation_clientele( ) then
   	   m_menu_principal.m_item5.m_recup_cde.visible = true
   	   m_menu_principal.m_item5.m_intervention.visible= true			
	end if
end if

IF not  g_nv_come9par.is_relation_clientele( ) THEN 				
	m_menu_principal.m_item1.m_operatrice.Visible	=	False				
	m_menu_principal.m_item2.m_dern_cde.Visible			=	False
	m_menu_principal.m_item4.m_valide_modif.Visible	=	False
    m_menu_principal.m_item4.m_compterenduvisite.Visible	=	True
	m_menu_principal.m_item4.m_consultationvisite.Visible	=	False
else
	m_menu_principal.m_item1.m_operatrice.Visible	=	True				
	m_menu_principal.m_item2.m_dern_cde.Visible			=	True
	m_menu_principal.m_item4.m_valide_modif.Visible	=	True
    m_menu_principal.m_item4.m_compterenduvisite.Visible	=	False
	 	m_menu_principal.m_item4.m_consultationvisite.Visible	=	true
End if

if g_nv_come9par.is_filiale( ) then
    m_menu_principal.m_item5.m_transferordermanually.visible = true
end if

PowerObject po
po = this
g_nv_traduction.set_traduction( po)

if upper(ls_mode_portable) = "OUI" then
		this.title = "Mode Portable -  " + this.title 
end if

end subroutine

event ue_init;/* <DESC>
   	Une fois afficher, cette fenetre va afficher la fenetre de connection à l'application.
   	A partir du profil du visisteur, les options du menu seront rendus accessible ou non.

	Si une nouvelle version de l'application est mise en place, le fichier version.ini peut contenir les informations des evolutions
	effectuees et précisé si ces informations doivent être affichées ou non. Si elles doivent être affichées, affichage de la fenetre
	de consultation des evolutions
 </DESC> */
 
//String ls_mode_portable
//String ls_profil
//
 str_pass  l_str_pass
OpenWithParm (w_erfvmr_login,l_str_pass)

l_str_pass = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

if l_str_pass.s_action <> ACTION_OK then
	HALT CLOSE
end if
fw_set_max_sheets(-1)

fw_init_fenetre()


this.show( )
this.windowstate = maximized!

open  (w_a_propos)
end event

on w_frame_erfvmr.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_menu_principal" then this.MenuID = create m_menu_principal
end on

on w_frame_erfvmr.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;this.hide( )
end event

