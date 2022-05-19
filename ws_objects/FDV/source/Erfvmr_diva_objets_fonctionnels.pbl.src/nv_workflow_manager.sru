$PBExportHeader$nv_workflow_manager.sru
$PBExportComments$Permet la navigation d'une fenêtre vers une aure avec passage des paramètres ou non, en controlant le nombre d'instance, le statut de la commande, l'existence ou non de la sélection d'un client,....
forward
global type nv_workflow_manager from nonvisualobject
end type
end forward

global type nv_workflow_manager from nonvisualobject
end type
global nv_workflow_manager nv_workflow_manager

type variables
str_pass i_str_pass
integer  i_nbr_workflow = 0
Constant integer NO_LIMIT = -1
Constant integer WITH_LIMIT = 0
Constant integer WITH_NON_AUTORISER = -99
Constant String PAS_DE_MESSAGE = DONNEE_VIDE

// cette variable est alimentée lors de  l'appel de la fonction
// fu_check_workflow.  Si besoin est pour la fenetre destination de connaitre 
// l'origine de l'appel, elle devra sur l'evenement open sauvegardée
// cette info
String is_fenetre_origine          
String is_fenetre_liste_origine
end variables

forward prototypes
public function string fu_check_workflow (string as_fenetre_active, any as_str_pass)
public function any fu_define_parametre (any as_workflow, any as_str_pass)
public function any fu_ident_client (boolean ab_uniquement_donneur_ordre, any astr_pass)
public function string fu_get_fenetre_origine ()
public subroutine fu_set_liste_origine (string as_fenetre_liste)
public subroutine fu_affiche_liste_origine (any as_str_pass)
public subroutine fu_set_fenetre_origine (string as_fenetre_origine)
public function string fu_cancel_option (any as_str_pass)
private function boolean fu_check_commande (any as_workflow, ref any as_str_pass)
end prototypes

public function string fu_check_workflow (string as_fenetre_active, any as_str_pass);/* <DESC>
   Cette fonction est appelée par l'evenement ue_workflow des differentes fenetres de l'application et permet d'afficher
   la fenetre de destination en passant des paramètres en fonction des enchainements définis lors de la création de l'object
   (voir evenement constructor)
     
   1- Controle si un enchainement spécifique a été défini lors de la création de cet object.
	  Si aucun object trouvé, création d'un object par défaut qui contiendra
	      Fenetre origine, fenetre destination, sans controle de l'etat de la commande,
		 Sans limite du nombre de fenetre destination affiche, avec passage de parametre
   2- Si l'enchainement doit se faire avec passage de parametre, on initialise le nouvelle structure avec la structure
	  passée en argument sinon création d'une structure vide
   3- Effectue le controle du statut de la commande , si cela est necessaire.
	  Si le controle détecte une anomalie, aucun enchainement ne sera effectué
   4- Si l'enchainement souhaité n'est autorisé, affiche du message d'anomalie et aucun enchainement ne sera
	  effectue.
   5- Si le nombre de fenetre est limité, on controle si une instance de la fenetre de destination n'est pas
	  déjà ouverte, si tel est le cas aucun enchainement ne sera effectué
	 </DESC> */
integer li_indice
String ls_return
nv_workflow_object l_workflow
Str_pass l_str_pass
Boolean	lb_workflow_trouve = false

is_fenetre_origine = as_fenetre_active
l_str_pass = as_str_pass
g_nv_trace.fu_write_trace(is_fenetre_origine, "ue_workflow", l_str_pass.s[01], l_str_pass.s[02], this.classname( ) , g_s_fenetre_destination)

// recherche de l'object workflow contenant les infos
for li_indice = 1 to i_nbr_workflow
	l_workflow = i_str_pass.po[li_indice]
	if l_workflow.is_this_workflow (as_fenetre_active, g_s_fenetre_destination) then
		lb_workflow_trouve = true
		exit		
	end if
next

// aucun enchainement de défini
if not lb_workflow_trouve then
	l_workflow = Create nv_workflow_object
	l_workflow.fu_create_workflow(as_fenetre_active,g_s_fenetre_destination,BLANK,WITH_LIMIT, AVEC_PASSAGE_PARAMETRE,PAS_DE_MESSAGE)
end if

l_str_pass = fu_define_parametre(l_workflow, as_str_pass)

if not fu_check_commande(l_workflow, as_str_pass) then
	return BLANK
end if

l_str_pass.s[7] = is_fenetre_origine
Choose case  l_workflow.fu_get_nbr_fenetre_autorisee()
	case WITH_NON_AUTORISER
		messageBox ("Workflow Control", l_workflow.fu_get_message(), information!, ok!)
		ls_return =  ACTION_CANCEL		
	case NO_LIMIT
		g_w_frame.fw_open_sheet(g_s_fenetre_destination, 0, -1, l_str_pass)
		ls_return =  BLANK		
	case WITH_LIMIT
		IF g_w_frame.fw_get_type_cnt (g_s_fenetre_destination) > 0 THEN
			g_w_frame.fw_open_sheet_keyed (g_s_fenetre_destination,0,1,l_str_pass,"")
			if l_workflow.fu_get_message() <> PAS_DE_MESSAGE and len(trim( l_workflow.fu_get_message())) = 0 then
				messageBox ("Workflow Control", l_workflow.fu_get_message(), information!, ok!)
			end if
			ls_return =  BLANK	
		else
			g_w_frame.fw_open_sheet(g_s_fenetre_destination, 0, 1, l_str_pass)			
			ls_return =  BLANK				
		end if
end choose

return ls_return

end function

public function any fu_define_parametre (any as_workflow, any as_str_pass);/* <DESC>
    Permet de créer la structure a passée à la fenêtre de destination et ceci en fonction des paramètres
	 defini lors de la définition de l'enchainement.
	 Si aucun paramètres ne doit être passé, création d'une structure vide, sinon assage de la structure
	 passé en argument
	 </DESC> */
str_pass l_str_pass

nv_Workflow_object lworkflow
lworkflow = as_workflow

if lworkflow.fu_avec_parametre() then
	return as_str_pass
end if

return l_str_pass



end function

public function any fu_ident_client (boolean ab_uniquement_donneur_ordre, any astr_pass);/* <DESC>
    Permet l'affichage de le fenetre de selection du client, si lors de l'affichage d'une fenetre necessitant d'avoir
	 les donnes client, aucune information client n'a ete selectionnée.
	 Cette fonction est appelee par chaque fenetre necessitant d'avoir une client sélectionné
	 </DESC> */
str_pass l_str_pass
l_str_pass = astr_pass
l_str_pass.s_action = ACTION_OK
Boolean lb_pas_de_client

lb_pas_de_client = true

IF UpperBound(l_str_pass.s) = 0  THEN
	lb_pas_de_client = false
elseif l_str_pass.s[1] = "" then
	lb_pas_de_client = false
end if

// Aucun client sélectionner, affichage de la liste pour selection
IF not lb_pas_de_client  THEN
		l_str_pass.b[1]  = ab_uniquement_donneur_ordre
		l_str_pass.b[20] = false 
		l_str_pass.b[21] = ab_uniquement_donneur_ordre //AFFICHAGE_TOUS_LES_CLIENT
		l_str_pass.b[22] = false
		l_str_pass.b[23] = true
		OpenWithParm (w_ident_client, l_str_pass)

		l_str_pass = Message.fnv_get_str_pass()
		Message.fnv_clear_str_pass()
         l_str_pass.s[2] = DONNEE_VIDE
		if l_str_pass.s_action = ACTION_CANCEL then
			goto FIN 
		end if
END IF

if not ab_uniquement_donneur_ordre then
	GOTO FIN
end if

// S'il s'agit de la gestion des commandes , on controle que
// le client est bien un donneur d'ordre
nv_client_object l_client
// l_client = l_str_pass.po[1]

l_client = CREATE nv_client_object
l_client.fu_retrieve_client(l_str_pass.s[1])

if l_client.is_donneur_ordre() then
   goto fin
end if

MessageBox("Workflow Manager",g_nv_traduction.get_traduction("CONTROLE_CLIENT_DO"), StopSign!, ok!)
l_str_pass.s_action = ACTION_CANCEL

FIN:
return l_str_pass
end function

public function string fu_get_fenetre_origine ();/* <DESC>
     Permet de retourner le nom de la fenetre d'origine
	 </DESC> */
if isNull(is_fenetre_origine) or trim(is_fenetre_origine) = DONNEE_VIDE then
	return BLANK
else
	return is_fenetre_origine
end if
end function

public subroutine fu_set_liste_origine (string as_fenetre_liste);/* <DESC>
      Permet d'initialiser la variable contenant le nom de la liste des commandes d'origine passé en parametre.
		Ce qui permettra le retour sur la liste.
	 </DESC> */
is_fenetre_liste_origine = as_fenetre_liste
end subroutine

public subroutine fu_affiche_liste_origine (any as_str_pass);/* <DESC>
     Permet de revenir sur la liste d'origne (Liste des dernieres commandes ou la liste
	 des commandes du visiteur)
	Par défaut , la liste d'origine est celle du visiteur
	</DESC> */
	
str_pass l_str_pass
l_str_pass = as_str_pass

String ls_window
ls_window = FENETRE_LISTE_CDE

if upperBound(l_str_pass.s) > 19 then
	if trim(l_str_pass.s[20]) <>  DONNEE_VIDE then
			ls_window = l_str_pass.s[20]
	end if
end if

IF g_w_frame.fw_get_type_cnt (ls_window) > 0 THEN
	g_w_frame.fw_open_sheet_keyed (ls_window,0,1,as_str_pass,"")
else
	g_w_frame.fw_open_sheet(ls_window, 0, 1, as_str_pass)	
end if
end subroutine

public subroutine fu_set_fenetre_origine (string as_fenetre_origine);/* <DESC>
      Permet d'initialiser la varible contenant la fenetre d'origine et passée en argument
	 </DESC> */
is_fenetre_origine = as_fenetre_origine
end subroutine

public function string fu_cancel_option (any as_str_pass);/* <DESC>
    Permet pour certaine fenetre, lors de la sortie par echap de revenir à la fenetre d'origine.
    Ceci est vrai pour la fiche client, carnet de commande, situation comptale.
   </DESC> */
String ls_window = DONNEE_VIDE

if is_fenetre_origine <> DONNEE_VIDE and not  IsNull(is_fenetre_origine) then
	ls_window = is_fenetre_origine
elseif is_fenetre_liste_origine  <> DONNEE_VIDE and not  IsNull(is_fenetre_liste_origine) then
	ls_window = is_fenetre_origine
end if

if ls_window = DONNEE_VIDE  then
	return BLANK
end if


IF g_w_frame.fw_get_type_cnt (ls_window) > 0 THEN
	g_w_frame.fw_open_sheet_keyed (ls_window,0,1,as_str_pass,"")
else
	g_w_frame.fw_open_sheet(ls_window, 0, 1, as_str_pass)			
end if

return BLANK

end function

private function boolean fu_check_commande (any as_workflow, ref any as_str_pass);/* <DESC>
      Permet lorsque l'on souhaite afficher une fenetre de gestion des commandes (Option du menu Saisie cde) de controler
	 l'etat de la commande. Il ne sera pas possible d'effectuer une des options si le commande est validée ou est transférée dans SAP
	 </DESC> */
nv_workflow_object l_workflow
l_workflow = as_workflow

str_pass l_str_pass
l_str_pass = as_str_pass
integer li_reponse

nv_commande_object l_commande
		
if g_s_fenetre_destination = FENETRE_LIGNE_CDE or & 
   g_s_fenetre_destination = FENETRE_ENTETE_CDE or & 
   g_s_fenetre_destination = FENETRE_ENTETE_CDE or & 	
   g_s_fenetre_destination = FENETRE_BON_CDE or & 		
   g_s_fenetre_destination = FENETRE_CATALOGUE or & 			
   g_s_fenetre_destination = FENETRE_PROMO or & 				
   g_s_fenetre_destination = FENETRE_LIGNE_CDE_OPERATRICE then
	if upperbound(l_str_pass.po)  <  2 then
		return true
	end if	
 
   if isnull(l_str_pass.po[2]) or trim(l_str_pass.s[2]) = DONNEE_VIDE   then 
	 return true	 
  end if
  
   l_commande = create NV_COMMANDE_Object
   if l_str_pass.s[2] <>  DONNEE_VIDE  then
		l_commande.fu_set_numero_cde(l_str_pass.s[2])
     	l_commande.fu_retrieve_commande()
	else
	     l_commande = l_str_pass.po[02]
	     l_commande.fu_retrieve_commande()
	end if
	if l_commande.fu_is_commande_validee() or  l_commande.fu_is_commande_transferee()  then
		messagebox (this.classname( )  , g_nv_traduction.get_traduction(ACCES_COMMANDE_IMPOSSIBLE),StopSign!,Ok!,1)			
		return false
	end if	
	
    l_commande.fu_controle_numero_cde(l_str_pass.po[1])
end if

return true
end function

event constructor;/* <DESC>
    Creation de la liste des enchainements possibles en créant les objects de navigation
	A chaque object navigation on precise differents paramétres qui sont :
	   - Fenetre origine
	   - Fenetre destination
        - Controle du statut de la commande ou non
	   - Nbr de fenetre affichée limité ou non
	   - Avec passage de paramétre ou non
	   - Avec controle qu'une commande n'est pas en cours de modification ou non
		
	Tous les enchainements non pas besoin d'être défini mais uniquement ceux qui ont des particularités
	Par défaut lors du controle de l'enchainement , un object est créé avec les valeurs par défaut qui sont
	      Pas de controle du statut de la commande, nbr de fenêtre limité, avec passage de paramètre
   </DESC> */

nv_workflow_object us_workflow
i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_CDE,FENETRE_LIGNE_CDE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_CDE,FENETRE_ENTETE_CDE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_CDE,FENETRE_CATALOGUE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_CDE,FENETRE_PROMO,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_CDE,FENETRE_BON_CDE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_CDE,FENETRE_MESSAGE_CDE,BLANK,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_CDE,FENETRE_LIGNE_CDE_OPERATRICE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_DERNIERE_CDE,FENETRE_LIGNE_CDE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_DERNIERE_CDE,FENETRE_ENTETE_CDE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_DERNIERE_CDE,FENETRE_BON_CDE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_DERNIERE_CDE,FENETRE_CATALOGUE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_DERNIERE_CDE,FENETRE_PROMO,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_DERNIERE_CDE,FENETRE_MESSAGE_CDE,BLANK,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LISTE_DERNIERE_CDE,FENETRE_LIGNE_CDE_OPERATRICE,WORKFLOW_CTRL_STATUT_CDE,WITH_LIMIT,AVEC_PASSAGE_PARAMETRE, COMMANDE_ENCOURS)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LIGNE_CDE_OPERATRICE,FENETRE_PROMO,BLANK,WITH_NON_AUTORISER,AVEC_PASSAGE_PARAMETRE, NON_AUTORISER)
i_str_pass.po[i_nbr_workflow] = us_workflow

i_nbr_workflow ++
us_workflow = CREATE nv_workflow_object
us_workflow.fu_create_workflow(FENETRE_LIGNE_CDE_OPERATRICE,FENETRE_CATALOGUE,BLANK,WITH_NON_AUTORISER,AVEC_PASSAGE_PARAMETRE, NON_AUTORISER)
i_str_pass.po[i_nbr_workflow] = us_workflow
end event

on nv_workflow_manager.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_workflow_manager.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

