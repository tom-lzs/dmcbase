$PBExportHeader$w_envoi_mail.srw
forward
global type w_envoi_mail from w_a
end type
type cb_ok from u_cba within w_envoi_mail
end type
type cb_fermer from u_cba within w_envoi_mail
end type
type st_4 from statictext within w_envoi_mail
end type
type mle_memo from u_mlea within w_envoi_mail
end type
type st_3 from statictext within w_envoi_mail
end type
type sle_objet from u_slea within w_envoi_mail
end type
type sle_to from u_slea within w_envoi_mail
end type
type st_2 from statictext within w_envoi_mail
end type
type st_1 from statictext within w_envoi_mail
end type
type sle_from from u_slea within w_envoi_mail
end type
end forward

global type w_envoi_mail from w_a
integer width = 2734
integer height = 1960
string title = "DivaPrint - Envoi par Mail / Send by Mail"
long backcolor = 12632256
string icon = "C:\donnees\PowerBuilder\DivaPrint\Images\mail.ico"
cb_ok cb_ok
cb_fermer cb_fermer
st_4 st_4
mle_memo mle_memo
st_3 st_3
sle_objet sle_objet
sle_to sle_to
st_2 st_2
st_1 st_1
sle_from sle_from
end type
global w_envoi_mail w_envoi_mail

type variables

Constant string REGISTRY_KEY    = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI"
Constant string REGISTRY_NAME_EMAIL = "eMailUser"


end variables

on w_envoi_mail.create
int iCurrent
call super::create
this.cb_ok=create cb_ok
this.cb_fermer=create cb_fermer
this.st_4=create st_4
this.mle_memo=create mle_memo
this.st_3=create st_3
this.sle_objet=create sle_objet
this.sle_to=create sle_to
this.st_2=create st_2
this.st_1=create st_1
this.sle_from=create sle_from
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_ok
this.Control[iCurrent+2]=this.cb_fermer
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.mle_memo
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_objet
this.Control[iCurrent+7]=this.sle_to
this.Control[iCurrent+8]=this.st_2
this.Control[iCurrent+9]=this.st_1
this.Control[iCurrent+10]=this.sle_from
end on

on w_envoi_mail.destroy
call super::destroy
destroy(this.cb_ok)
destroy(this.cb_fermer)
destroy(this.st_4)
destroy(this.mle_memo)
destroy(this.st_3)
destroy(this.sle_objet)
destroy(this.sle_to)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_from)
end on

event ue_close;call super::ue_close;Close(this)

end event

event ue_ok;call super::ue_ok;String ls_commande
String ls_memo
String ls_car
String ls_debug
integer li_indice

if sle_from.text = "" then
	 messagebox ("Controle","Veuillez spécifier votre adresse eMail",Information!)
	 sle_from.setfocus()
	 return
end if

if sle_to.text = "" then
	 messagebox ("Controle","Veuillez spécifier l'adresse eMail du destinataire",Information!)
	 sle_from.setfocus()
	 return
end if

if sle_objet.text = "" then
	 messagebox ("Controle","Veuillez spécifier l'objet de votre eMail",Information!)
	 sle_from.setfocus()
	 return
end if

For li_indice = 1 To Len(mle_memo.text)
   	  ls_debug = Mid( mle_memo.text, li_indice, 2)
    If Mid( mle_memo.text, li_indice, 2) = "~r~n" Then
       ls_car = "\n\\"
       li_indice = li_indice + 1
     Else
       ls_car = Mid( mle_memo.text, li_indice, 1)
    End If
    ls_memo = ls_memo + ls_car
 Next


for li_indice = 1 to i_str_pass.d[1]
	ls_commande =  "C:\temp\EnvoiPdfViaMail.bat "
	ls_commande = ls_commande + ' "' + sle_from.text + '"'
	ls_commande = ls_commande + ' "' +sle_to.text + '"'
	ls_commande = ls_commande + ' "' +sle_objet.text + '"'
	ls_commande = ls_commande + ' "' + g_s_path_fichier + "\" + i_str_pass.s[li_indice] + '"'
	ls_commande = ls_commande + ' "' + g_s_serveur_smtp +  '"'
	ls_commande = ls_commande +' "' +  ls_memo + '"'
	run(ls_commande)
next


// envoi d'un mail de confirmation à l'emetteur du Mail

ls_memo = "Mail sent with the attached file "+ "\n\\" + "\n\\"
for li_indice = 1 to i_str_pass.d[1]
	ls_memo = ls_memo + "  - " +  i_str_pass.s[li_indice] + "\n\\"
next
   
ls_memo = ls_memo + "\n\\" + "\n\\"
ls_memo = ls_memo + "The user(s) which received the mail are " + "\n\\"
ls_memo = ls_memo + sle_to.text + "\n\\"
   
ls_commande =  "C:\temp\EnvoiPdfViaMail.bat "
ls_commande = ls_commande + ' "DivaPrint@dmc.fr "'
ls_commande = ls_commande + ' "' +  sle_from.text + '"'
ls_commande = ls_commande + ' "Confirmation Send PDF Document by Mail"'
ls_commande = ls_commande + ' " "'
ls_commande = ls_commande + ' "' + g_s_serveur_smtp +  '"'
ls_commande = ls_commande +' "' +  ls_memo + '"'
run(ls_commande)	
	 
RegistrySet(  REGISTRY_KEY, REGISTRY_NAME_EMAIL, RegString!,sle_from.text)	 
 
end event

event close;// overwrite script
end event

event ue_init;call super::ue_init;String ls_eMail

if RegistryGet(  REGISTRY_KEY, REGISTRY_NAME_EMAIL, RegString!, ls_eMail) = 1 then
	sle_from.text = ls_eMail
	sle_to.setfocus()
end if	

end event

type cb_ok from u_cba within w_envoi_mail
integer x = 1609
integer y = 1696
integer width = 389
integer height = 96
integer taborder = 50
string text = "Envoi / Send"
end type

event clicked;	parent.triggerEvent  ("ue_ok")
end event

type cb_fermer from u_cba within w_envoi_mail
integer x = 1097
integer y = 1696
integer width = 448
integer height = 96
integer taborder = 60
string text = "Fermer / Close"
end type

event clicked;	parent.triggerEvent ("ue_close")
end event

type st_4 from statictext within w_envoi_mail
integer x = 146
integer y = 800
integer width = 407
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Memo"
alignment alignment = right!
boolean focusrectangle = false
end type

type mle_memo from u_mlea within w_envoi_mail
integer x = 585
integer y = 800
integer width = 1938
integer height = 736
integer taborder = 40
end type

type st_3 from statictext within w_envoi_mail
integer x = 146
integer y = 512
integer width = 407
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "Objet / Titel"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_objet from u_slea within w_envoi_mail
integer x = 585
integer y = 512
integer width = 1938
integer height = 96
integer taborder = 30
integer textsize = -10
end type

type sle_to from u_slea within w_envoi_mail
integer x = 585
integer y = 256
integer width = 1938
integer height = 96
integer taborder = 20
integer textsize = -10
end type

type st_2 from statictext within w_envoi_mail
integer x = 183
integer y = 256
integer width = 407
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "A  /To  "
alignment alignment = right!
boolean focusrectangle = false
end type

type st_1 from statictext within w_envoi_mail
integer x = 183
integer y = 128
integer width = 407
integer height = 96
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 12632256
string text = "De / From  "
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_from from u_slea within w_envoi_mail
integer x = 585
integer y = 128
integer width = 1938
integer height = 96
integer taborder = 10
end type

