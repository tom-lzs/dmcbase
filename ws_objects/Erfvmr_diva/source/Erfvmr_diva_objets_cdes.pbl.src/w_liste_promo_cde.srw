$PBExportHeader$w_liste_promo_cde.srw
$PBExportComments$Permet l'affichage du récapitulatif des promotions effectuées sur une commande
forward
global type w_liste_promo_cde from w_a_q
end type
end forward

global type w_liste_promo_cde from w_a_q
string tag = "LISTE_PROMO_COMMANDE"
integer x = 0
integer y = 0
integer width = 2784
integer height = 928
string title = "*Liste des promotions de la commande *"
boolean minbox = false
boolean maxbox = false
windowtype windowtype = response!
long backcolor = 12632256
end type
global w_liste_promo_cde w_liste_promo_cde

event ue_init;call super::ue_init;/* <DESC>
    Affichage de la fenetre en affichant les données
	 </DESC> */
if dw_1.Retrieve (i_str_pass.s[1]) = -1 then
	f_dmc_error ("Erreur Retrieve dw_1 dans ue_init de w_liste_promo_cde")
end if
end event

event open;call super::open;/* <DESC> 
    Permet de positionner la fenetre dans le cadre de l'application
	 </DESC> */
	This.X = 0
	This.Y = 600

end event

event ue_cancel;call super::ue_cancel;/* <DESC>
    Permet de fermer la fenetre 
	 </DESC> */
Close (This)
end event

event key;call super::key;/* <DESC>
     Permet de fermer la fenetre quelque soit la touche activée
   </DESC> */
// FERMETURE DE LA FENÊTRE
	Close(This)
end event

on w_liste_promo_cde.create
call super::create
end on

on w_liste_promo_cde.destroy
call super::destroy
end on

type dw_1 from w_a_q`dw_1 within w_liste_promo_cde
string tag = "A_TRADUIRE"
integer x = 0
integer y = 0
integer width = 2752
integer height = 712
integer taborder = 10
string dataobject = "d_cde_promo"
boolean vscrollbar = true
end type

event dw_1::we_dwnkey;call super::we_dwnkey;
// RENVOIE A L'EVENEMENT KEY DE LA FENÊTRE
//	f_activation_key ()
	f_key(Parent)
end event

