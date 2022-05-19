$PBExportHeader$w_fenetre_attente.srw
$PBExportComments$Effectue la mise à jour des lignes de commande en affichant une barre de progression
forward
global type w_fenetre_attente from w_a
end type
type st_2 from statictext within w_fenetre_attente
end type
type patienter_maj_en_cours from statictext within w_fenetre_attente
end type
type r_1 from rectangle within w_fenetre_attente
end type
type r_2 from rectangle within w_fenetre_attente
end type
end forward

global type w_fenetre_attente from w_a
string tag = "VALIDATION_LIGNES"
boolean visible = false
integer width = 1989
integer height = 528
string title = "Validation des lignes de commande"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
long backcolor = 12632256
st_2 st_2
patienter_maj_en_cours patienter_maj_en_cours
r_1 r_1
r_2 r_2
end type
global w_fenetre_attente w_fenetre_attente

type variables
 nv_commande_object i_nv_commande_object
nv_ligne_cde_object i_nv_ligne_cde_object
 integer ii_nbr_total_ligne
 decimal ii_multiplicateur
 decimal  ii_nbr_ligne_traitée =  0.0
 

end variables

forward prototypes
public function boolean fw_validation_normale (ref datawindow as_dw)
public function boolean fw_validation_operatrice (ref datawindow as_dw)
end prototypes

public function boolean fw_validation_normale (ref datawindow as_dw);/* <DESC>
     Permet la mise à jour de toutes les lignes en fin de saisie des lignes en mode normal et met à jour la
	  barre de progression en fonction du nombre de ligne mise à jour
	  
	Lecture de la datawindow contenant les lignes de commande à contrôler.
	Pour chaque ligne non validée (code mise à jour = mode rapide)
		- appel de la fonction de mise à jour
		- Calcul du % d'avancement et de la taille du rectangle bleu à afficher
		- Affichage du %
		- Si la longeur de la barre de progression atteint la zone contenant la valeur du %,
		 	mise à jour de la couleur en blanc et le fond en bleu
	en fin de mise à jour, validation des blocages et de la valorisation de l'entête
   </DESC> */
this.visible = true
boolean lb_invert = false
setPointer(HourGlass!)
ii_nbr_total_ligne = as_dw.RowCount()
ii_multiplicateur = 100 / ii_nbr_total_ligne

Long    l_row
long	ll_color
for l_row = 1 to as_dw.RowCount()
	if as_dw.getItemString(l_row, DBNAME_CODE_MAJ) = CODE_MODE_RAPIDE  then
          i_nv_ligne_cde_object.fu_controle_et_maj_ligne_cde(l_row, as_dw,false,  true)
		r_2.width = l_row /as_dw.RowCount()* r_1.width
		r_2.visible = true
	
		st_2.text = String (l_row / as_dw.RowCount(), "##0%")
		if not lb_invert then
			if ( r_2.width +  r_2.x) >= st_2.x then
				lb_invert = true
				ll_color = st_2.textcolor
				st_2.TextColor = st_2.BackColor
				st_2.BackColor = ll_color
			end if
		end if	  
	end if
next
as_dw.update()
i_nv_commande_object.fu_validation_commande_par_lignes_cde()
setPointer(Arrow!)

return true
end function

public function boolean fw_validation_operatrice (ref datawindow as_dw);/* <DESC>
     Permet la mise à jour de toutes les lignes en fin de saisie en mode opératrice et met à jour la
	  barre de progression en fonction du nombre de ligne mise à jour
	  
	Lecture de la datawindow contenant les lignes de commande à contrôler.
	Pour chaque ligne non validée (code mise à jour = mode rapide)
		- appel de la fonction de mise à jour en mode opératrice
		- Calcul du % d'avancement et de la taille du rectangle bleu à afficher
		- Affichage du %
		- Si la longeur de la barre de progression atteint la zone contenant la valeur du %,
		 	mise à jour de la couleur en blanc et le fond en bleu
   </DESC> */
this.visible = true
boolean lb_invert = false
boolean lb_ok
setPointer(HourGlass!)
ii_nbr_total_ligne = as_dw.RowCount()
ii_multiplicateur = 100 / ii_nbr_total_ligne

Long    l_row
long	ll_color
lb_ok = true

datastore  lds_toutes_lignes_cde
lds_toutes_lignes_cde = create datastore
lds_toutes_lignes_cde.Dataobject  = "d_object_ligne_cde_par_type"
lds_toutes_lignes_cde.Settransobject(sqlca)
if lds_toutes_lignes_cde.retrieve(i_str_pass.s[1], CODE_SAISIE_OPERATRICE) = -1 then
	f_dmc_error ("Ligne cde Object" + BLANK + DB_ERROR_MESSAGE)
end if

for l_row = 1 to as_dw.RowCount()
	if as_dw.getItemString(l_row, DBNAME_CODE_MAJ) = CODE_MODE_RAPIDE  then
          if not i_nv_ligne_cde_object.fu_controle_saisie_operatrice(as_dw,i_str_pass.s[1],l_row, lds_toutes_lignes_cde) then
				lb_ok = false
		 end if
		r_2.width = l_row /as_dw.RowCount()* r_1.width
		r_2.visible = true
	
		st_2.text = String (l_row / as_dw.RowCount(), "##0%")
		if not lb_invert then
			if ( r_2.width +  r_2.x) >= st_2.x then
				lb_invert = true
				ll_color = st_2.textcolor
				st_2.TextColor = st_2.BackColor
				st_2.BackColor = ll_color
			end if
		end if	  
	end if
next
as_dw.update()
//i_nv_commande_object.fu_update_entete( )
setPointer(Arrow!)

return lb_ok
end function

on w_fenetre_attente.create
int iCurrent
call super::create
this.st_2=create st_2
this.patienter_maj_en_cours=create patienter_maj_en_cours
this.r_1=create r_1
this.r_2=create r_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.patienter_maj_en_cours
this.Control[iCurrent+3]=this.r_1
this.Control[iCurrent+4]=this.r_2
end on

on w_fenetre_attente.destroy
call super::destroy
destroy(this.st_2)
destroy(this.patienter_maj_en_cours)
destroy(this.r_1)
destroy(this.r_2)
end on

event ue_init;call super::ue_init;/* <DESC>
      Execute la fonction de mise à jour en fonction du code passé du paramètre
	 en fin de mise à jour, fermeture de la fenêtre
   </DESC> */
Datawindow l_dw
i_nv_commande_object = i_str_pass.po[1]
i_nv_ligne_cde_object = i_str_pass.po[2]
l_dw = i_str_pass.po[3]


if l_dw.RowCount() = 0 then
	close(this)
	return
end if

if i_str_pass.s[2] = CODE_MODE_SIMPLE then
	fw_validation_normale(l_dw)
else
	i_str_pass.b[01] = fw_validation_operatrice(l_dw)
	Message.fnv_set_str_pass(i_str_pass)
end if
 
close(this)


end event

type uo_statusbar from w_a`uo_statusbar within w_fenetre_attente
end type

type st_2 from statictext within w_fenetre_attente
string tag = "0%"
integer x = 955
integer y = 260
integer width = 123
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 16777215
string text = "0%"
long bordercolor = 16711680
boolean focusrectangle = false
end type

type patienter_maj_en_cours from statictext within w_fenetre_attente
integer x = 155
integer y = 152
integer width = 1760
integer height = 88
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Veuillez patienter , validation des lignes de la commande en cours"
alignment alignment = center!
boolean focusrectangle = false
boolean disabledlook = true
end type

type r_1 from rectangle within w_fenetre_attente
integer linethickness = 4
long fillcolor = 16777215
integer x = 411
integer y = 256
integer width = 1248
integer height = 76
end type

type r_2 from rectangle within w_fenetre_attente
integer linethickness = 4
long fillcolor = 16711680
integer x = 411
integer y = 256
integer width = 41
integer height = 72
end type

