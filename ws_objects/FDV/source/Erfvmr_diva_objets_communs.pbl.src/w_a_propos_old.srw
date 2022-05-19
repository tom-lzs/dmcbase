$PBExportHeader$w_a_propos_old.srw
$PBExportComments$Fenetre d'affichage de la version et de la connection associée à l'application.
forward
global type w_a_propos_old from w_a
end type
type pb_echap from u_pba_echap within w_a_propos_old
end type
type sle_1 from u_slea within w_a_propos_old
end type
type st_serveur_remote from statictext within w_a_propos_old
end type
type st_nom_base_remote from statictext within w_a_propos_old
end type
type st_dbms_remote from statictext within w_a_propos_old
end type
type base_remote_t from statictext within w_a_propos_old
end type
type mle_description from u_mlea within w_a_propos_old
end type
type rr_2 from roundrectangle within w_a_propos_old
end type
type st_serveur from statictext within w_a_propos_old
end type
type rr_3 from roundrectangle within w_a_propos_old
end type
type st_nom_base from statictext within w_a_propos_old
end type
type base_connectee_t from statictext within w_a_propos_old
end type
type st_nom from statictext within w_a_propos_old
end type
type st_visiteur from statictext within w_a_propos_old
end type
type visiteur_connecte_t from statictext within w_a_propos_old
end type
type st_version from statictext within w_a_propos_old
end type
type version_t from statictext within w_a_propos_old
end type
type titre_appli from statictext within w_a_propos_old
end type
type application_t from statictext within w_a_propos_old
end type
type rr_1 from roundrectangle within w_a_propos_old
end type
type st_dbms from statictext within w_a_propos_old
end type
end forward

global type w_a_propos_old from w_a
string tag = "A_PROPOS"
integer width = 2158
integer height = 2004
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
boolean center = true
string i_s_microhelp = ""
boolean ib_statusbar_visible = true
pb_echap pb_echap
sle_1 sle_1
st_serveur_remote st_serveur_remote
st_nom_base_remote st_nom_base_remote
st_dbms_remote st_dbms_remote
base_remote_t base_remote_t
mle_description mle_description
rr_2 rr_2
st_serveur st_serveur
rr_3 rr_3
st_nom_base st_nom_base
base_connectee_t base_connectee_t
st_nom st_nom
st_visiteur st_visiteur
visiteur_connecte_t visiteur_connecte_t
st_version st_version
version_t version_t
titre_appli titre_appli
application_t application_t
rr_1 rr_1
st_dbms st_dbms
end type
global w_a_propos_old w_a_propos_old

event ue_init;call super::ue_init;/* <DESC>
	Recherche dans le fichier erfvmr.ini des paramètres de connection qui ont été utilisés
	pour la connexion à l'application.
	
	Recherche dans le fichier version.ini  du n° de la version de l'application exécutée
   </DESC> */
String s_default_dbms
String s_default_dbms_remote
String s_mode_portable
s_default_dbms = g_nv_ini.fnv_profile_string("DefaultDBMS","DBMS","")
s_default_dbms_remote = g_nv_ini.fnv_profile_string("DefaultDBMS","DBMS_remote","")
s_mode_portable = g_nv_ini.fnv_profile_string("Param","ModePortable","")
st_visiteur.text = g_s_visiteur
st_nom.text = g_nv_come9par.get_nom_visiteur()
st_dbms.text = sqlca.fnv_get_dbms()
st_nom_base.text = g_nv_ini.fnv_profile_string(s_default_dbms,"Database","")
st_serveur.text = g_nv_ini.fnv_profile_string(s_default_dbms,"Servername","")
if lower(s_mode_portable) = "oui" then
	st_dbms_remote.text = g_nv_ini.fnv_profile_string(s_default_dbms_remote,"DBMS","")
	st_nom_base_remote.text = g_nv_ini.fnv_profile_string(s_default_dbms_remote,"Database","")
	st_serveur_remote.text = g_nv_ini.fnv_profile_string(s_default_dbms_remote,"Servername","")
end if

st_version.text = ProfileString ( "Version.ini", "Version", "Version","" )

integer li_ficnum, l_i_statut_fic
String  ls_enreg
boolean l_b_finfic = false
boolean l_b_write = false

li_ficnum = FileOpen("Version.ini")
DO WHILE not l_b_finfic
	l_i_statut_fic = FileRead(li_ficnum,ls_enreg)
	if  l_i_statut_fic =  -100 then
		l_b_finfic = True
		FileClose(li_ficnum)
		EXIT
	end if
	
	if ls_enreg = "[Descriptif]" then
		l_b_write = true
		continue
	end if
	
	if l_b_write then
		mle_description.text = mle_description.text + ls_enreg + "~r~n"
	end if
LOOP


end event

on w_a_propos_old.create
int iCurrent
call super::create
this.pb_echap=create pb_echap
this.sle_1=create sle_1
this.st_serveur_remote=create st_serveur_remote
this.st_nom_base_remote=create st_nom_base_remote
this.st_dbms_remote=create st_dbms_remote
this.base_remote_t=create base_remote_t
this.mle_description=create mle_description
this.rr_2=create rr_2
this.st_serveur=create st_serveur
this.rr_3=create rr_3
this.st_nom_base=create st_nom_base
this.base_connectee_t=create base_connectee_t
this.st_nom=create st_nom
this.st_visiteur=create st_visiteur
this.visiteur_connecte_t=create visiteur_connecte_t
this.st_version=create st_version
this.version_t=create version_t
this.titre_appli=create titre_appli
this.application_t=create application_t
this.rr_1=create rr_1
this.st_dbms=create st_dbms
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_echap
this.Control[iCurrent+2]=this.sle_1
this.Control[iCurrent+3]=this.st_serveur_remote
this.Control[iCurrent+4]=this.st_nom_base_remote
this.Control[iCurrent+5]=this.st_dbms_remote
this.Control[iCurrent+6]=this.base_remote_t
this.Control[iCurrent+7]=this.mle_description
this.Control[iCurrent+8]=this.rr_2
this.Control[iCurrent+9]=this.st_serveur
this.Control[iCurrent+10]=this.rr_3
this.Control[iCurrent+11]=this.st_nom_base
this.Control[iCurrent+12]=this.base_connectee_t
this.Control[iCurrent+13]=this.st_nom
this.Control[iCurrent+14]=this.st_visiteur
this.Control[iCurrent+15]=this.visiteur_connecte_t
this.Control[iCurrent+16]=this.st_version
this.Control[iCurrent+17]=this.version_t
this.Control[iCurrent+18]=this.titre_appli
this.Control[iCurrent+19]=this.application_t
this.Control[iCurrent+20]=this.rr_1
this.Control[iCurrent+21]=this.st_dbms
end on

on w_a_propos_old.destroy
call super::destroy
destroy(this.pb_echap)
destroy(this.sle_1)
destroy(this.st_serveur_remote)
destroy(this.st_nom_base_remote)
destroy(this.st_dbms_remote)
destroy(this.base_remote_t)
destroy(this.mle_description)
destroy(this.rr_2)
destroy(this.st_serveur)
destroy(this.rr_3)
destroy(this.st_nom_base)
destroy(this.base_connectee_t)
destroy(this.st_nom)
destroy(this.st_visiteur)
destroy(this.visiteur_connecte_t)
destroy(this.st_version)
destroy(this.version_t)
destroy(this.titre_appli)
destroy(this.application_t)
destroy(this.rr_1)
destroy(this.st_dbms)
end on

event ue_cancel;call super::ue_cancel;/* <DESC>
   Fermeture de la fenetre lors du clique sur le bouton OK
	</DESC> */
close(this)
end event

type uo_statusbar from w_a`uo_statusbar within w_a_propos_old
end type

type pb_echap from u_pba_echap within w_a_propos_old
integer x = 855
integer y = 1716
integer taborder = 20
string picturename = "c:\appscir\Erfvmr_diva\Image\pbechap.bmp"
end type

type sle_1 from u_slea within w_a_propos_old
integer x = 498
integer y = 72
integer width = 690
integer height = 64
integer taborder = 10
integer weight = 700
long textcolor = 16711680
long backcolor = 12632256
string text = "Erfvmr"
boolean border = false
boolean displayonly = true
end type

type st_serveur_remote from statictext within w_a_propos_old
integer x = 782
integer y = 1596
integer width = 823
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean focusrectangle = false
end type

type st_nom_base_remote from statictext within w_a_propos_old
integer x = 782
integer y = 1516
integer width = 823
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean focusrectangle = false
end type

type st_dbms_remote from statictext within w_a_propos_old
integer x = 782
integer y = 1432
integer width = 823
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean focusrectangle = false
end type

type base_remote_t from statictext within w_a_propos_old
integer x = 219
integer y = 1440
integer width = 526
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Base Remote :  "
boolean focusrectangle = false
end type

type mle_description from u_mlea within w_a_propos_old
integer x = 64
integer y = 332
integer width = 1893
integer height = 508
integer taborder = 10
integer textsize = -8
fontcharset fontcharset = ansi!
boolean vscrollbar = true
boolean displayonly = true
end type

type rr_2 from roundrectangle within w_a_propos_old
integer linethickness = 4
long fillcolor = 12632256
integer x = 174
integer y = 952
integer width = 1563
integer height = 164
integer cornerheight = 40
integer cornerwidth = 46
end type

type st_serveur from statictext within w_a_propos_old
integer x = 782
integer y = 1324
integer width = 823
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean focusrectangle = false
end type

type rr_3 from roundrectangle within w_a_propos_old
integer linethickness = 4
long fillcolor = 12632256
integer x = 174
integer y = 1132
integer width = 1559
integer height = 556
integer cornerheight = 40
integer cornerwidth = 46
end type

type st_nom_base from statictext within w_a_propos_old
integer x = 782
integer y = 1248
integer width = 823
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean focusrectangle = false
end type

type base_connectee_t from statictext within w_a_propos_old
integer x = 219
integer y = 1168
integer width = 526
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Base connectée :  "
boolean focusrectangle = false
end type

type st_nom from statictext within w_a_propos_old
integer x = 928
integer y = 1000
integer width = 773
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean focusrectangle = false
end type

type st_visiteur from statictext within w_a_propos_old
integer x = 722
integer y = 996
integer width = 197
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean focusrectangle = false
end type

type visiteur_connecte_t from statictext within w_a_propos_old
integer x = 192
integer y = 992
integer width = 494
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Visiteur connecté :  "
boolean focusrectangle = false
end type

type st_version from statictext within w_a_propos_old
integer x = 471
integer y = 252
integer width = 763
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean focusrectangle = false
end type

type version_t from statictext within w_a_propos_old
integer x = 59
integer y = 256
integer width = 361
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Version : "
boolean focusrectangle = false
end type

type titre_appli from statictext within w_a_propos_old
integer x = 498
integer y = 148
integer width = 1454
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 12632256
string text = "Force de Vente : Gestion des commandes"
boolean focusrectangle = false
end type

type application_t from statictext within w_a_propos_old
integer x = 73
integer y = 72
integer width = 361
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Application : "
boolean focusrectangle = false
end type

type rr_1 from roundrectangle within w_a_propos_old
integer linethickness = 4
long fillcolor = 12632256
integer x = 37
integer y = 36
integer width = 1970
integer height = 844
integer cornerheight = 40
integer cornerwidth = 46
end type

type st_dbms from statictext within w_a_propos_old
integer x = 782
integer y = 1168
integer width = 823
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean focusrectangle = false
end type

