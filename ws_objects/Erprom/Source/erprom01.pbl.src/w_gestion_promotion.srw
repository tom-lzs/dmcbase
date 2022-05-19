$PBExportHeader$w_gestion_promotion.srw
$PBExportComments$Fenetre de gestion des infos générales, des articles gratuits, des références offertes et des conditions de la promotion
forward
global type w_gestion_promotion from w_a_mas_det
end type
type r_1 from rectangle within w_gestion_promotion
end type
type dw_gratuit from u_dw_udim within w_gestion_promotion
end type
type dw_offert from u_dw_udim within w_gestion_promotion
end type
type cb_ok from u_cb_ok within w_gestion_promotion
end type
type cb_fermer from u_cb_close within w_gestion_promotion
end type
type cb_delete from u_cba within w_gestion_promotion
end type
type cb_changer from u_cba within w_gestion_promotion
end type
type dw_print from u_dw_udim within w_gestion_promotion
end type
type dw_marche from u_dw_udim within w_gestion_promotion
end type
type cbx_marche from checkbox within w_gestion_promotion
end type
end forward

global type w_gestion_promotion from w_a_mas_det
integer x = 769
integer y = 461
integer width = 3419
integer height = 1744
boolean titlebar = false
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = child!
long backcolor = 12632256
boolean toolbarvisible = false
event ue_change_selection pbm_custom50
event ue_suppression_promo pbm_custom54
event ue_workflow ( )
r_1 r_1
dw_gratuit dw_gratuit
dw_offert dw_offert
cb_ok cb_ok
cb_fermer cb_fermer
cb_delete cb_delete
cb_changer cb_changer
dw_print dw_print
dw_marche dw_marche
cbx_marche cbx_marche
end type
global w_gestion_promotion w_gestion_promotion

type variables
Boolean	i_b_gratuit_ok,       &
              i_b_offert_ok,	&
	i_b_condition_ok,	&
	i_b_entete_ok, 	&
	i_b_marche_ok
String	i_s_appel_selection,	&
	i_s_dw_focus
	

end variables

event ue_change_selection;/* **************************************************
		Changer de promotion 
	************************************ */
OpenWithParm ( w_liste_promo, i_str_pass )

i_str_pass = Message.fnv_get_str_pass()
Message.fnv_clear_str_pass()

If i_str_pass.s_action = ACTION_OK then
	TriggerEvent("ue_retrieve")
	return
end if

 if i_s_appel_selection			=	"ini"	 then
	Close(this)
end if

end event

event ue_suppression_promo;Datetime	dt_date_jour

OpenWithParm(w_confirmation_suppression,i_str_pass)

//IF Not IsValid (message.powerobjectparm) THEN
//   f_dmc_error("Erreur retour paramètre dans ue_suppression_promo")
//End if
//
//i_str_pass = message.powerobjectparm

	i_str_pass = Message.fnv_get_str_pass()
	Message.fnv_clear_str_pass()


CHOOSE CASE i_str_pass.s_action
	Case ACTION_OK
	  dt_date_jour	=	SQLCA.fnv_get_datetime()
	  dw_mas.SetItem(1,DBNAME_CODE_MAJ,"A")
	  dw_mas.Update()
	  Close(this)

	Case Else
		Return

END CHOOSE

end event

event ue_workflow();if i_str_pass.s[02] = MODE_CREATION then
	messageBox(This.title,"Une promotion est encours de création",information!, ok!)
	return
end if

triggerEvent("ue_change_selection")
end event

event ue_init;call super::ue_init;dw_gratuit.SetTransObject							(Sqlca)
dw_offert.SetTransObject							(Sqlca)
dw_print.SetTransObject							(Sqlca)
dw_marche.SetTransObject						(Sqlca)

i_s_appel_selection	=	"ini"

If i_str_pass.s[02]	=	MODE_CREATION then
	dw_mas.InsertRow(0)
	dw_mas.SetFocus()
	cb_ok.visible = true	
	Return
End if

cb_changer.visible = true
	
If i_str_pass.s[02]	=	MODE_MODIFICATION then
	cb_delete.visible = true
	cb_ok.visible = true
end if	

PostEvent("ue_change_selection")
end event

event ue_retrieve;call super::ue_retrieve;dw_mas.Retrieve    (i_str_pass.s[01])
dw_1.Retrieve		 (i_str_pass.s[01])
dw_gratuit.Retrieve(i_str_pass.s[01])
dw_offert.Retrieve (i_str_pass.s[01])
dw_print.retrieve(i_str_pass.s[1])
dw_marche.retrieve(i_str_pass.s[1])


if dw_marche.Rowcount() = 1 then
		if dw_marche.getitemstring(1,DBNAME_MARCHE) = 'ALL' then
			cbx_marche.checked = true
		end if
end if

If i_str_pass.s[02]	=	MODE_CONSULTATION	then
	dw_mas.Enabled			=	False
	dw_1.Enabled			=	False
	dw_gratuit.Enabled	=	False
	dw_offert.Enabled		=	False
	dw_marche.Enabled		=	False
End if

end event

event ue_save;// OverWrite le script 
/*  ************************************************************
	  Objectif :
     -----------

		Mettre à jour les différentes tables pour la promotion

	  Principe :
	  ----------
		
			1- Controle de la saisie des données (ue_presave)
			2- Si des anomalies ont été détectées
					Arrêt du traitement 
			3- Mise à jour de la table des conditions
					- On renumérotre à chaque fois les lignes
					- Alimentation du time stamp de mise à jour
					- En cas de création initialisation des zones non
							saisissables

  *********************************************************************** */
Datetime		dt_date_jour
Long			l_row
String		s_numseq,		&
				s_num_promo
Integer		i_num_promo,	&
				i_nbrligne

DwItemStatus	dw_status

DataStore ds_max_num_promo

TriggerEvent("ue_presave")

If message.ReturnValue < 0 then
  Return
End if

dt_date_jour	=	SQLCA.fnv_get_datetime()

/*  Mise à jour de l'entete de promo
	 ===============================  */
	 
ds_max_num_promo = CREATE DATASTORE	 
ds_max_num_promo.dataobject = 'd_max_num_promo'
ds_max_num_promo.SetTransObject(SQLCA)

If i_str_pass.s[02] = MODE_CREATION then
	ds_max_num_promo.Retrieve()
	If IsNull(ds_max_num_promo.GetItemString(1,2)) 	then
		s_num_promo = VALEUR_PREMIERE_PROMO
	Else
		s_num_promo	=	ds_max_num_promo.GetItemString(1,2)
		i_num_promo	=	Integer(Mid(s_num_promo,2,3))
		if i_num_promo = 999 then
			i_num_promo = 0
		end if
		i_num_promo ++
		CHOOSE CASE Len(string(i_num_promo))
			CASE 1
				s_num_promo	=	Mid(s_num_promo,1,1) + "00" + String(i_num_promo)
			CASE 2
				s_num_promo	=	Mid(s_num_promo,1,1) + "0" + String(i_num_promo)
			CASE 3
				s_num_promo	=	Mid(s_num_promo,1,1) + String(i_num_promo)
		END CHOOSE
	End if
	dw_mas.SetItem(1,DBNAME_CODE_PROMO,s_num_promo)
    dw_mas.Setitem(1,DBNAME_DATE_CREATION,dt_date_jour)	
End if

dw_mas.SetItem(1,DBNAME_CODE_MAJ,i_str_pass.s[02])

i_str_pass.s[01]	=	dw_mas.GetItemString(1,DBNAME_CODE_PROMO)

If dw_mas.update() = -1 then
	error.fnv_process_error ()
End if
	
DESTROY ds_max_num_promo

/*  Mise à jour des conditions de la promotion
    ==========================================   */
If i_b_condition_ok then

	For l_row	=	1	to dw_1.RowCount()
		dw_status	=	dw_1.GetItemStatus(l_row,0,Primary!)
		dw_1.SetItem(l_row,DBNAME_DATE_CREATION,dt_date_jour)
		s_numseq	=	String(l_row)
		If len(s_numseq) = 1 then
			s_numseq = "0" + s_numseq
		End if

		dw_1.SetItem(l_row,"nseef002",s_numseq)

		If dw_status	=	NewModified! then
			dw_1.SetItem(l_row,DBNAME_CODE_PROMO,i_str_pass.s[01])
			dw_1.SetItem(l_row,DBNAME_CODE_MAJ,MODE_CREATION)
		End if

	Next
	If dw_1.update() = -1 then
		error.fnv_process_error ()
	End if
End if

/*   Mise à jour des articles gratuits  */
If i_b_gratuit_ok then
	For l_row	=	1	to dw_gratuit.RowCount()
		dw_status	= dw_gratuit.GetItemStatus(l_row,0, Primary!)
		If dw_status = DataModified! then
			dw_gratuit.SetItem(l_row,DBNAME_DATE_CREATION,dt_date_jour)
		End if

		If dw_status	=	NewModified! then
			dw_gratuit.SetItem(l_row,DBNAME_DATE_CREATION,dt_date_jour)
			dw_gratuit.SetItem(l_row,DBNAME_CODE_PROMO,i_str_pass.s[01])
			dw_gratuit.SetItem(l_row,DBNAME_CODE_MAJ,MODE_CREATION)
		End if
	Next

	If dw_gratuit.update() = -1 then
		error.fnv_process_error ()
	End if
End if

/* Mise à jour des references offertes  */
If i_b_offert_ok then
	For l_row	=	1	to dw_offert.RowCount()
		dw_status	= dw_offert.GetItemStatus(l_row,0, Primary!)
		If dw_status = DataModified! then
			dw_offert.SetItem(l_row,DBNAME_DATE_CREATION,dt_date_jour)
		End if

		If dw_status	=	NewModified! then
			dw_offert.SetItem(l_row,DBNAME_DATE_CREATION,dt_date_jour)
			dw_offert.SetItem(l_row,DBNAME_CODE_PROMO,i_str_pass.s[01])
			dw_offert.SetItem(l_row,DBNAME_CODE_MAJ,MODE_CREATION)
		End if
	Next
	If dw_offert.update() =-1 then
		error.fnv_process_error ()
	End if
End if 

/*   Mise à jour des marches */
If i_b_marche_ok then
	For l_row	=	1	to dw_marche.RowCount()
		dw_status	= dw_marche.GetItemStatus(l_row,0, Primary!)
		If dw_status = DataModified! then
			dw_marche.SetItem(l_row,DBNAME_DATE_CREATION,dt_date_jour)
		End if

		If dw_status	=	NewModified! then
			dw_marche.SetItem(l_row,DBNAME_DATE_CREATION,dt_date_jour)
			dw_marche.SetItem(l_row,DBNAME_CODE_PROMO,i_str_pass.s[01])
			dw_marche.SetItem(l_row,DBNAME_CODE_MAJ,MODE_CREATION)
		End if
	Next

	If dw_marche.update() = -1 then
		error.fnv_process_error ()
	End if
End if

dw_print.retrieve(i_str_pass.s[1])
end event

event ue_presave;call super::ue_presave;
/*  **************************************************************
     Controle des différentes informations
			- Description de la promo
					Intitulé obligatoire
					Date de validation Obligatoire
					Validation des dates
					Si Date de lancement renseignée, doit être dans la période de validation
			- Les Conditions :
		   - Les articles gratuits
					Article doit être existant dans le fichier des références
					Controler que l'article n'a été saisie qu'une seule fois
			- Les Produits offerts
				   Réference doit être existante dans le fichier des références
					Quantité Obligatoire
					Controler que la référence n'a été saisie qu'une seule fois
		     - Les marchés
			  		Marché doit etre existant dans le fichier des marches
					
	 ****************************************************************  */
Integer	i_nbr_row,	&
			i_row,		&
			i_nbr_identique
Long		l_doublon
String	s_article,	&
			s_dimension,	&
			s_texte,		&
			s_debut,		&
			s_fin,		&
			s_marche , &
			s_lct
DateTime dt_debut,	&
			dt_fin,			&
			dt_lct
Decimal	d_qteuni

Datastore ds_ctrl_article, &
			 ds_ctrl_reference, &
			 ds_ctrl_marche

i_b_condition_ok	=	False
i_b_gratuit_ok		=	False
i_b_offert_ok		=	False
i_b_marche_ok = False

dw_mas.AcceptText()

/*  Controle de la description de la promo (entete)  
	 =============================================== */
If IsNull(dw_mas.GetItemString(1,DBNAME_INTITULE_PROMO)) then
	MessageBox (This.title,"Intitulé de la promotion obligatoire" , StopSign!, Ok! ,0)
	dw_mas.SetFocus()
 	dw_mas.SetColumn (DBNAME_INTITULE_PROMO)
	Message.ReturnValue = -1
	Return
End if

dt_debut = dw_mas.GetItemDateTime(1,DBNAME_DATE_DEBUT)
dt_fin   = dw_mas.GetItemDateTime(1,DBNAME_DATE_FIN)
s_debut	= String(dt_debut)
s_fin		= String(dt_fin)

If IsNull(s_debut) then
	MessageBox (This.title,"date de début de validité obligatoire" , StopSign!, Ok! ,0)
	dw_mas.SetFocus()
 	dw_mas.SetColumn (DBNAME_DATE_DEBUT)
	Message.ReturnValue = -1
	Return
End if

If IsNull(s_fin) then
	dw_mas.setItem(1,DBNAME_DATE_FIN,date(DATE_SYBASE_MAX))
	dt_fin = datetime(DATE_SYBASE_MAX)
End if

If dt_debut > dt_fin then
	MessageBox(This.title,"Date début validité > Date fin validité",StopSign!,ok!,0)
	dw_mas.SetFocus()
 	dw_mas.SetColumn (DBNAME_DATE_DEBUT)
	Message.ReturnValue = -1
	Return
End if

If dt_debut = dt_fin then
	MessageBox(This.title,"Date fin validité = Date début validité",StopSign!,ok!,0)
	dw_mas.SetFocus()
 	dw_mas.SetColumn (DBNAME_DATE_FIN)
	Message.ReturnValue = -1
	Return
End if

dt_lct   = dw_mas.GetItemDateTime(1,DBNAME_DATE_LANCEMENT)
s_lct	= String(dt_lct)

/*  Controle des conditions de la promo 
    =================================== */
dw_1.AcceptText()
If dw_1.RowCount() = 0 then
	goto Articles_gratuits
End if

i_nbr_row	=	dw_1.RowCount()

DO WHILE i_nbr_row > 0
	s_texte	=	dw_1.GetItemString(i_nbr_row,DBNAME_CONDITION)
	If IsNull (s_texte) or s_texte = DONNEE_VIDE then
		dw_1.DeleteRow(i_nbr_row)
		i_nbr_row --
		Continue
	End If
	i_nbr_row --
LOOP

If dw_1.RowCount() > 0 then
	i_b_condition_ok	=	True
End if


/*  Controle des articles gratuits  
    ============================== */
Articles_gratuits :

dw_gratuit.AcceptText()
If dw_gratuit.RowCount() = 0 then
	goto References_offertes
End if

ds_ctrl_article = CREATE DATASTORE
ds_ctrl_article.dataobject = 'd_ctrl_article'
ds_ctrl_article.settransobject(SQLCA)

i_nbr_row	=	dw_gratuit.RowCount()
i_b_gratuit_ok = true

DO WHILE i_nbr_row > 0
	s_article	=	dw_gratuit.GetItemString(i_nbr_row,DBNAME_ARTICLE)
	s_article	=	RightTrim (s_article)
	If IsNull (s_article) or len(s_article) = 0  then
		dw_gratuit.DeleteRow(i_nbr_row)
		i_nbr_row --
		Continue
	End If

	If ds_ctrl_article.Retrieve(s_article) < 1 then
		MessageBox(This.title,"Article inexistant",StopSign!,Ok!,0)
		dw_gratuit.SetFocus()
		dw_gratuit.SetColumn(DBNAME_ARTICLE)
		dw_gratuit.SetRow(i_nbr_row)
		Message.ReturnValue = -1
		Return
	End if
	
	i_nbr_row --
LOOP

If dw_gratuit.RowCount() = 0 then
	goto References_offertes
End if

i_nbr_row	=	dw_gratuit.RowCount()

DO WHILE i_nbr_row > 0
	s_article	=	dw_gratuit.GetItemString(i_nbr_row,DBNAME_ARTICLE)
	l_doublon =	dw_gratuit.Find (	DBNAME_ARTICLE + " = '"+ s_article + "'", 1, i_nbr_row - 1)
	If l_doublon > 0 and l_doublon <> i_nbr_row then
		dw_gratuit.DeleteRow(i_nbr_row)
	End if
	i_nbr_row --
LOOP

i_b_gratuit_ok	=	True

DESTROY ds_ctrl_article


/* Controle des references offertes
    =========================    */
References_offertes :

dw_offert.AcceptText()

If dw_offert.RowCount() = 0 then
	goto Marches
End if

ds_ctrl_reference = CREATE DATASTORE
ds_ctrl_reference.dataobject = 'd_ctrl_reference'
ds_ctrl_reference.settransobject(SQLCA)
i_b_offert_ok = true
i_nbr_row	=	dw_offert.RowCount()

DO WHILE i_nbr_row > 0
	s_article	=	RightTrim(dw_offert.GetItemString(i_nbr_row,DBNAME_ARTICLE))
	s_dimension	=	RightTrim(dw_offert.GetItemString(i_nbr_row,DBNAME_DIMENSION))

	d_qteuni		=	dw_offert.GetItemDecimal(i_nbr_row,DBNAME_QUANTITE)

	If (IsNull (s_article)  Or len(s_article)  = 0)  And	&
		(IsNull (s_dimension) Or len(s_dimension) = 0)  And	&
		(IsNull(d_qteuni)  	Or d_qteuni = 0 or d_qteuni = 1 )    Then
		dw_offert.DeleteRow(i_nbr_row)
		i_nbr_row --
		Continue
	End if

	If IsNull (s_article) then
		MessageBox(This.title,"Article Obligatoire",StopSign!,ok!,0)
		dw_offert.SetFocus()
		dw_offert.SetColumn(DBNAME_ARTICLE)
		dw_offert.SetRow(i_nbr_row)
		Message.ReturnValue = -1
		Return
	End if

	If IsNull (s_dimension) then
		dw_offert.SetItem(i_nbr_row,DBNAME_DIMENSION, " ")
		s_dimension = " "
	End if

	If d_qteuni = 0 Or IsNull(d_qteuni) then
		MessageBox(This.title,"Qté Obligatoire",StopSign!,ok!,0)
		dw_offert.SetFocus()
		dw_offert.SetColumn(DBNAME_QUANTITE)
		dw_offert.SetRow(i_nbr_row)
		Message.ReturnValue	=	-1
		Return
	End if

     ds_ctrl_reference.Retrieve(s_article, s_dimension)
	If ds_ctrl_reference.RowCount() = 0 then
		MessageBox(This.title,"Référence inexistante",StopSign!,Ok!,0)
		dw_offert.SetFocus()
		dw_offert.SetColumn(DBNAME_ARTICLE)
		dw_offert.SetRow(i_nbr_row)
		Message.ReturnValue = -1
		Return
	End if
	
	i_nbr_row --
LOOP

If dw_offert.RowCount() = 0 then
	goto Marches
End if

i_nbr_row	=	dw_Offert.RowCount()

DO WHILE i_nbr_row > 0
	s_article	=	dw_offert.GetItemString(i_nbr_row,DBNAME_ARTICLE)
	s_dimension	=	dw_offert.GetItemString(i_nbr_row,DBNAME_DIMENSION)

	l_doublon =	dw_offert.Find (DBNAME_ARTICLE + " = '" + s_article + &
										 "' And " + DBNAME_DIMENSION + " = '" + s_dimension + &
										 "'", 1, i_nbr_row - 1)

	If l_doublon > 0 and l_doublon <> i_nbr_row then
		dw_offert.DeleteRow(i_nbr_row)
	End if
	
	i_nbr_row --
LOOP

i_b_offert_ok	=	True

DESTROY ds_ctrl_reference


/*  Controle des marches
    ============================== */
Marches :

dw_marche.AcceptText()
If dw_marche.RowCount() = 0 then
	MessageBox(This.title,"Marché obligatoire",StopSign!,Ok!,0)
	dw_marche.insertRow(0)
	dw_marche.SetFocus()
	dw_marche.SetColumn(1)

	dw_marche.SetRow(1)
	Message.ReturnValue = -1
	Return
End if

ds_ctrl_marche = CREATE DATASTORE
ds_ctrl_marche.dataobject = 'd_ctrl_marche'
ds_ctrl_marche.settransobject(SQLCA)

i_nbr_row	=	dw_marche.RowCount()

DO WHILE i_nbr_row > 0
	s_marche	=	dw_marche.GetItemString(i_nbr_row,DBNAME_MARCHE)
	s_marche	=	RightTrim (s_marche)
	If IsNull (s_marche) or len(s_marche) = 0  then
		dw_marche.DeleteRow(i_nbr_row)
		i_nbr_row --
		Continue
	End If

	if s_marche = 'ALL'  then
		i_nbr_row --
		Continue
	end if
	
	If ds_ctrl_marche.Retrieve(s_marche) < 1 then
		MessageBox(This.title,"Marché inexistant",StopSign!,Ok!,0)
		dw_marche.SetFocus()
		dw_marche.SetColumn(DBNAME_MARCHE)
		dw_marche.SetRow(i_nbr_row)
		Message.ReturnValue = -1
		Return
	End if
	
	i_nbr_row --
LOOP

If dw_marche.RowCount() = 0 then
	MessageBox(This.title,"Marché obligatoire",StopSign!,Ok!,0)
	dw_marche.insertRow(0)
	dw_marche.SetFocus()
	dw_marche.SetColumn(1)
	dw_marche.SetRow(1)
	Message.ReturnValue = -1
	Return
End if

i_nbr_row	=	dw_marche.RowCount()

DO WHILE i_nbr_row > 0
	s_marche	=	dw_marche.GetItemString(i_nbr_row,DBNAME_MARCHE)
	l_doublon =	dw_marche.Find (	DBNAME_MARCHE + " = '"+ s_marche + "'", 1, i_nbr_row - 1)
	If l_doublon > 0 and l_doublon <> i_nbr_row then
		dw_marche.DeleteRow(i_nbr_row)
	End if
	i_nbr_row --
LOOP

i_b_marche_ok	=	True

DESTROY ds_ctrl_marche
end event

event ue_delete;/*  *********************************************************
		Objectif :
      ------------

			Supprimer la ligne de la datawindow sur laquelle
			l'utilisateur s'est positionnée
	********************************************************** */
long l_row

CHOOSE CASE i_s_dw_focus

/* Datawindow contenant les conditions de la promotion */
	Case "dw_1"

		l_row = dw_1.GetRow ()
		IF l_row > 0 THEN
			dw_1.fu_delete (l_row)
		END IF
 
/* Datawindow contenant les articles gratuits */
	Case "dw_gratuit"

		l_row = dw_gratuit.GetRow ()
		IF l_row > 0 THEN
			dw_gratuit.fu_delete (l_row)
		END IF

/* Datawindow contenant les références offertes */
	Case "dw_offert"

		l_row = dw_offert.GetRow ()
		IF l_row > 0 THEN
			dw_offert.fu_delete (l_row)
		END IF

END CHOOSE


end event

event ue_ok;// Overwrite
TriggerEvent("ue_save")

If Message.REturnValue < 0 then
	Return
End if

i_str_pass.s[02]	=	MODE_MODIFICATION
cb_changer.visible = true
end event

on w_gestion_promotion.create
int iCurrent
call super::create
this.r_1=create r_1
this.dw_gratuit=create dw_gratuit
this.dw_offert=create dw_offert
this.cb_ok=create cb_ok
this.cb_fermer=create cb_fermer
this.cb_delete=create cb_delete
this.cb_changer=create cb_changer
this.dw_print=create dw_print
this.dw_marche=create dw_marche
this.cbx_marche=create cbx_marche
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.r_1
this.Control[iCurrent+2]=this.dw_gratuit
this.Control[iCurrent+3]=this.dw_offert
this.Control[iCurrent+4]=this.cb_ok
this.Control[iCurrent+5]=this.cb_fermer
this.Control[iCurrent+6]=this.cb_delete
this.Control[iCurrent+7]=this.cb_changer
this.Control[iCurrent+8]=this.dw_print
this.Control[iCurrent+9]=this.dw_marche
this.Control[iCurrent+10]=this.cbx_marche
end on

on w_gestion_promotion.destroy
call super::destroy
destroy(this.r_1)
destroy(this.dw_gratuit)
destroy(this.dw_offert)
destroy(this.cb_ok)
destroy(this.cb_fermer)
destroy(this.cb_delete)
destroy(this.cb_changer)
destroy(this.dw_print)
destroy(this.dw_marche)
destroy(this.cbx_marche)
end on

event closequery;// Override ancestor script

Integer 	i_rep
		
IF dw_mas.fu_changed() THEN
	i_rep = MessageBox(THIS.title, "Enregistrer les modifications?", &
						Question!, YesNo!)
						
	IF i_rep = 1 THEN
		this.TriggerEvent ("ue_save")
	END IF
	
END IF
end event

event ue_print;if dw_print.AcceptText() < 1 then
	return
end if

dw_print.print()
end event

type dw_1 from w_a_mas_det`dw_1 within w_gestion_promotion
integer x = 306
integer y = 336
integer width = 2295
integer height = 392
integer taborder = 40
string dataobject = "d_promo_condition"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event dw_1::getfocus;call super::getfocus;i_s_dw_focus	=	"dw_condition_promo"

If this.RowCount() = 0 then
	this.fu_insert (0)
	this.SetColumn ("lpraeac1")
End if
end event

event dw_1::we_dwnprocessenter;call super::we_dwnprocessenter;
// --------------------------------------------------------------------------------
// EN FIN DE LIGNE INSERTION D'UNE NOUVELLE LIGNE SI LA LIGNE PRECEDENTE EST SAISIE
// --------------------------------------------------------------------------------
	IF	this.GetRow () = this.RowCount () then
		this.insertrow(0)
		this.SetColumn(DBNAME_CONDITION)
	ELSE
		Send(Handle(This),256,9,Long(0,0))
		return 1
	END IF
end event

type uo_statusbar from w_a_mas_det`uo_statusbar within w_gestion_promotion
integer taborder = 20
end type

type dw_mas from w_a_mas_det`dw_mas within w_gestion_promotion
integer x = 27
integer width = 2734
integer height = 240
integer taborder = 10
string dataobject = "d_promo_entete"
borderstyle borderstyle = styleshadowbox!
end type

on dw_mas::itemchanged;call w_a_mas_det`dw_mas::itemchanged;i_b_update_status	=	True
end on

on dw_mas::getfocus;call w_a_mas_det`dw_mas::getfocus;i_s_dw_focus	=	"dw_mas"
end on

type r_1 from rectangle within w_gestion_promotion
integer linethickness = 4
long fillcolor = 12632256
integer x = 453
integer y = 1496
integer width = 2313
integer height = 160
end type

type dw_gratuit from u_dw_udim within w_gestion_promotion
integer x = 105
integer y = 776
integer width = 727
integer height = 472
integer taborder = 50
string dataobject = "d_promo_gratuit"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;call super::getfocus;i_s_dw_focus	=	"dw_gratuit"

If this.RowCount() = 0 then
	this.fu_insert (0)
	this.SetColumn (DBNAME_ARTICLE)
End if
end event

event we_dwnprocessenter;call super::we_dwnprocessenter;
// --------------------------------------------------------------------------------
// EN FIN DE LIGNE INSERTION D'UNE NOUVELLE LIGNE SI LA LIGNE PRECEDENTE EST SAISIE
// --------------------------------------------------------------------------------
	IF	 this.GetRow () = this.RowCount () then
		this.fu_insert (0)
		this.SetColumn (DBNAME_ARTICLE)
	ELSE
		Send(Handle(This),256,9,Long(0,0))
		return 1
	END If
end event

event we_dwnkey;call super::we_dwnkey;IF not KeyDown(KeyF2!) THEN
	return
END IF


Str_pass l_str_work
openwithparm(w_liste_article,l_str_work)
l_str_work = Message.fnv_get_str_pass()

if l_str_work.s_action = ACTION_CANCEL then
	return
end if

this.setItem(this.getRow(), DBNAME_ARTICLE, l_str_work.s[1])
end event

type dw_offert from u_dw_udim within w_gestion_promotion
integer x = 891
integer y = 776
integer width = 1330
integer height = 472
integer taborder = 60
boolean bringtotop = true
string dataobject = "d_promo_offert"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event we_dwnprocessenter;call super::we_dwnprocessenter;
// --------------------------------------------------------------------------------
// EN FIN DE LIGNE INSERTION D'UNE NOUVELLE LIGNE SI LA LIGNE PRECEDENTE EST SAISIE
// --------------------------------------------------------------------------------
	IF	 this.GetRow () = this.RowCount () and &
	   this.GetColumnName()	=	DBNAME_QUANTITE then
		this.fu_insert (0)
		this.SetColumn (DBNAME_ARTICLE)
		this.Modify (DBNAME_QUANTITE + "Initial ='1'")
	ELSE
		Send(Handle(This),256,9,Long(0,0))
		return 1
	END If
end event

event getfocus;call super::getfocus;i_s_dw_focus	=	"dw_offert"

If this.RowCount() = 0 then
	this.fu_insert (0)
	this.SetColumn (DBNAME_ARTICLE)
	this.Modify (DBNAME_QUANTITE + ".Initial ='1'")
End if
end event

event we_dwnkey;call super::we_dwnkey;IF not KeyDown(KeyF2!) THEN
	return
END IF


Str_pass l_str_work
openwithparm(w_liste_reference,l_str_work)
l_str_work = Message.fnv_get_str_pass()

if l_str_work.s_action = ACTION_CANCEL then
	return
end if

this.setItem(this.getRow(), DBNAME_ARTICLE, l_str_work.s[1])
this.setItem(this.getRow(), DBNAME_DIMENSION, l_str_work.s[2])
end event

type cb_ok from u_cb_ok within w_gestion_promotion
boolean visible = false
integer x = 617
integer y = 1524
integer width = 352
integer height = 96
integer taborder = 80
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&OK"
boolean default = false
end type

type cb_fermer from u_cb_close within w_gestion_promotion
integer x = 1115
integer y = 1528
integer width = 352
integer height = 96
integer taborder = 110
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
boolean cancel = true
end type

type cb_delete from u_cba within w_gestion_promotion
boolean visible = false
integer x = 1577
integer y = 1524
integer width = 494
integer height = 96
integer taborder = 120
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Supprimer la Promo"
end type

on clicked;call u_cba::clicked;Parent.TriggerEvent("ue_suppression_promo")
end on

type cb_changer from u_cba within w_gestion_promotion
boolean visible = false
integer x = 2144
integer y = 1524
integer width = 571
integer height = 96
integer taborder = 100
boolean bringtotop = true
integer textsize = -8
fontcharset fontcharset = ansi!
string facename = "MS Sans Serif"
string text = "&Changer sélection"
end type

event clicked;i_s_appel_selection	=	"changer"
Parent.TriggerEvent("ue_change_selection")
end event

on constructor;call u_cba::constructor;i_s_event = "ue_selection"
end on

type dw_print from u_dw_udim within w_gestion_promotion
boolean visible = false
integer x = 91
integer y = 1484
integer width = 201
integer height = 136
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_impression_promo"
end type

type dw_marche from u_dw_udim within w_gestion_promotion
integer x = 2341
integer y = 900
integer width = 443
integer height = 320
integer taborder = 70
boolean bringtotop = true
string dataobject = "d_relation_promo_marche"
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event getfocus;call super::getfocus;i_s_dw_focus	=	"dw_marche"

If this.RowCount() = 0 then
	this.fu_insert (0)
	this.SetColumn (1)
End if
end event

event we_dwnprocessenter;call super::we_dwnprocessenter;
// --------------------------------------------------------------------------------
// EN FIN DE LIGNE INSERTION D'UNE NOUVELLE LIGNE SI LA LIGNE PRECEDENTE EST SAISIE
// --------------------------------------------------------------------------------
	IF	 this.GetRow () = this.RowCount () then
		this.fu_insert (0)
		this.SetColumn (1)
	ELSE
		Send(Handle(This),256,9,Long(0,0))
		return 1
	END If
end event

type cbx_marche from checkbox within w_gestion_promotion
integer x = 2286
integer y = 784
integer width = 654
integer height = 92
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Pour tous les marchés"
end type

event clicked;if checked  then
	dw_marche.RowsMove(1, dw_marche.RowCount(), Primary!, &
        dw_marche, 1, Delete!)
	dw_marche.setitem(dw_marche.insertrow(0),DBNAME_MARCHE,'ALL')
	dw_marche.enabled = false
else
	dw_marche.RowsMove(1, dw_marche.RowCount(), Primary!, &
        dw_marche, 1, Delete!)
	dw_marche.enabled = true
end if
end event

