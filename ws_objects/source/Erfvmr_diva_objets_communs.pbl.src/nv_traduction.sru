$PBExportHeader$nv_traduction.sru
forward
global type nv_traduction from nonvisualobject
end type
end forward

global type nv_traduction from nonvisualobject
end type
global nv_traduction nv_traduction

type variables
nv_datastore  ids_traduction
nv_datastore ids_traduction_code
String is_code_langue
String is_datawindow_a_traduire = "A_TRADUIRE"
String is_traduction_notfound = "???"
String is_affiche_tag = "OUI"
String is_tag = "_TAG"
String is_prefix_tag = "[tooltip] "
String is_no_text  = "NO_TEXT"
String is_affiche_liste  = "LISTE"





end variables

forward prototypes
public function string get_traduction (string as_code_intitule)
public subroutine set_traduction_menu (ref powerobject a_menu)
public subroutine set_traduction (ref powerobject a_window)
public subroutine set_traduction_datawindow (ref powerobject a_datawindow)
public subroutine set_traduction_userobject (ref powerobject a_user_object)
public subroutine set_traduction_datastore (datastore a_datastore)
public subroutine set_traduction_report (ref datawindowchild a_dwc)
public function string get_traduction_code (string as_code_table, string as_code)
public function boolean is_traduction_chargee ()
public subroutine set_init_data ()
end prototypes

public function string get_traduction (string as_code_intitule);String ls_traduction
Long ll_row 

ll_row = ids_traduction.find ("CODE_INTITULE = '"+ upper (as_code_intitule) + "' " ,1,ids_traduction.rowcount())
if ll_row > 0 then
	choose case is_code_langue
		case 'F'
			 ls_traduction = ids_traduction.getItemString(ll_row,"INTITULE_FR")
		case 'E'
			 ls_traduction = ids_traduction.getItemString(ll_row,"INTITULE_EN")				
		case 'S'
			 ls_traduction = ids_traduction.getItemString(ll_row,"INTITULE_ES")				
		case 'P'
			 ls_traduction = ids_traduction.getItemString(ll_row,"INTITULE_DE")				
		case 'I'
			 ls_traduction = ids_traduction.getItemString(ll_row,"INTITULE_IT")				
		case else
			ls_traduction = is_traduction_notfound
	end choose
	if isnull(ls_traduction) or len (trim(ls_traduction) ) = 0 then
		ls_traduction = is_traduction_notfound + "  -  " + ids_traduction.getItemString(ll_row,"INTITULE_FR")
	end if 
else
		ls_traduction = is_traduction_notfound  + "  -  " + as_code_intitule
end if

return ls_traduction
end function

public subroutine set_traduction_menu (ref powerobject a_menu);/* <DESC>
   Lors de l'ouverture de la fenetre, appel de la fonction de traduction des differents menu et sous menu.
   Actuellement , un seul niveau de sous menu est gere.
	
  Un cas particulier a été codé pour la gestion des tables à importer qui n'est accessible uniquement que
  par l'informatique. dans ce cas , l'inttule ADMIN a été stocké dans le TAG du sous menu correspondant.
 </DESC> */
  
Integer li_indice
Integer li_indice2
String   ls_menu_search, ls_traduction
Menu  lpo_menu_principal,  lpo_sous_menu, lpo_sous_menu2

lpo_menu_principal = a_menu


for li_indice = 1 to upperbound(lpo_menu_principal.item[])
	lpo_sous_menu = lpo_menu_principal.item[li_indice]
	if lpo_sous_menu.visible = false  or upper(lpo_sous_menu.tag) = "ADMIN"  then
		continue
	end if

     ls_traduction = g_nv_traduction.get_traduction  (lpo_sous_menu.classname())
	if len(ls_traduction) > 0 then
		lpo_sous_menu.text = ls_traduction
	end if
	
	if upperbound( lpo_sous_menu.item[]) = 0 then
		continue
	end if
	
	for li_indice2 = 1 to upperbound( lpo_sous_menu.item[])
		lpo_sous_menu2 = lpo_sous_menu.item[li_indice2]
		if lpo_sous_menu2.visible = false   or upper(lpo_sous_menu2.tag) = "ADMIN"  then
		    continue
  	    end if
			
		ls_traduction = g_nv_traduction.get_traduction  (lpo_sous_menu2.classname())
		if len(ls_traduction) > 0 then
			lpo_sous_menu2.text = ls_traduction
		end if
	next
	
next

end subroutine

public subroutine set_traduction (ref powerobject a_window);/*<DESC>
   Fonction effectuant la traduction des éléments de la fenêtre passée en paramètre
	
   La traduction de la fenêtre se fait en passant en revu tous les objets contenus dans celle ci.

   Pour certain objet comme les menus, les datawindows un fonction spécifique sera appelée
	pour permettre de passer en revue les objets qu'ils contiennent.
	
   Le titre de chaque fenêtre sera traduit en utilisant la valeur qui est stockée dans le TAG de la fenêtre;
	Le TAG contient le code intitulé à rechercher.
</DESC> */
	
Integer  li_indice_object
String    ls_traduction
Powerobject    lo_po
Window    lo_window

/*  traduction du titre de la fenêtre */
lo_window = a_window
If trim(lo_window.tag ) <> DONNEE_VIDE then
	lo_window.title = get_traduction (lo_window.tag)
end if

// Si lexistence d'un menu , traduction du menu 
if trim( lo_window.menuname) <> "" then
	 lo_po = lo_window.menuid
	 set_traduction_menu( lo_po)
end if

/* Passage en revue de tous les objets de la fenêtre */
for li_indice_object = 1 to upperBound(lo_window.control[])
	lo_po = lo_window.control[li_indice_object]

	/* si l'objet est une datawindow, appel de la fonction  qui va traduire les objets contenus dans la datawindow 
	    si le tag associé à la datawindow spécifie qu'il faut la traduire */
	if  lo_window.control[li_indice_object].typeof() = datawindow! then
		 if  lo_window.control[li_indice_object].tag = is_datawindow_a_traduire then
			set_traduction_datawindow(lo_po)
		end if
		continue
	end if
	
	ls_traduction = get_traduction (lo_po.classname( ))
	
	/* si l'objet est une datawindow, appel de la fonction
	   qui va traduire les objets contenus dans la datawindow */
	choose case lo_window.control[li_indice_object].typeof()
		case	CheckBox!
			CheckBox lcheckBox
			lcheckBox = lo_window.control[li_indice_object]
			if lcheckBox.tag <> is_no_text then
				lcheckBox.text = ls_traduction				
			end if
		case OLECustomControl!
		case CommandButton!
			CommandButton lcommandButton
			lcommandButton = lo_window.control[li_indice_object]
			lcommandButton.text = ls_traduction
		case Oval!
		case DataWindow!
		case Picture!
		case DropDownListBox!
		case PictureButton!
			PictureButton lpictureButton
			lpictureButton = lo_window.control[li_indice_object]
			lpictureButton.text = ls_traduction
		case DropDownPictureListBox!
		case PictureListBox!
		case EditMask!
		case RadioButton!
			RadioButton lradioButton
			lradioButton = lo_window.control[li_indice_object]
			lradioButton.text = ls_traduction
		case Graph!
		case Rectangle!
		case GroupBox!	
			GroupBox lgroupBox
			lgroupBox = lo_window.control[li_indice_object]
			if lgroupBox.tag <> is_no_text then
				lgroupBox.text = ls_traduction				
			end if
		case RichTextEdit!
		case HScrollBar!
		case RoundRectangle!
		case Line!	
		case SingleLineEdit!
		case ListBox!	
		case StaticText!
			StaticText lstaticText
			lstaticText = lo_window.control[li_indice_object]

			if upper( lstaticText.tag ) = is_affiche_liste then
				lstaticText.text = "°" + ls_traduction
			elseif lstaticText.tag <> is_no_text then
				lstaticText.text = ls_traduction				
			end if

		case ListView!	
		case Tab!
		case MultiLineEdit!	
		case TreeView!
		case OLEControl!
		case VScrollBar!
		case UserObject!
			set_traduction_userobject(lo_window.control[li_indice_object])
		case else
	end choose
next
end subroutine

public subroutine set_traduction_datawindow (ref powerobject a_datawindow);/* <DESC>
   Traduction du contenu de la datawindow. Pour pourvoir traduire une datawindow
 </DESC> */
 
 integer li_indice_object, li_deb,li_pos,li_long,li_start
 String  ls_setting
 String  ls_objects[]

Datawindow  ldatawindow, ldatawindow2
DataWindowChild l_dwc




 ldatawindow = a_datawindow
 
 // Extraction de la liste des objects contenus dans la datawindow
 ls_setting = ldatawindow.Describe("DataWindow.Objects")

 /*   conversion de la liste des objects en tableau contenant la liste des objects
  car la liste est formatée sous forme d'une chaine de caractère contenant la liste
  des objects séparés par la tabulation 
   */
 li_indice_object = 1
 li_deb= 1
 li_pos  = pos (ls_setting, "~t", 1) 
 li_long = li_pos - 1
   
do
	ls_objects[li_indice_object] = mid (ls_setting, li_deb, li_long)
	li_indice_object = li_indice_object + 1 
	li_start = li_pos + 1
	li_deb = li_start
	li_pos  = pos (ls_setting, "~t", li_start ) 
	li_long = li_pos - li_start
loop until  li_pos = 0

ls_objects[li_indice_object] = mid (ls_setting, li_deb)

// lecture du tableau des objects à traduire
// appel du module de traduction
String ls_type, ls_traduction

for li_indice_object = 1 to upperbound(ls_objects)
	ls_traduction = get_traduction(ls_objects[li_indice_object])
	ls_type =  ldatawindow.describe(ls_objects[ li_indice_object]+ ".type") 
	
	choose case ls_type
		case "text"
			if upper(ldatawindow.describe(ls_objects[ li_indice_object]+ ".tag")) = is_no_text then
				continue
			end if
			
			ldatawindow.modify(ls_objects[ li_indice_object]+ ".text='" + ls_traduction +"'")
		     /* si dans le tag , on trouve le mot cle LISTE, il faut préfixé la traduction par
			    la caractere ° pour specifié que la touche F2 peut  être utlisée pour affichage de
				la liste de valeur */
			if upper(ldatawindow.describe(ls_objects[ li_indice_object]+ ".tag")) = is_affiche_liste then
				ls_traduction = "°" + ls_traduction
				ldatawindow.modify(ls_objects[ li_indice_object]+ ".text='" + ls_traduction +"'")
			end if
			/* si dans le TAG ou trouve le mot cle OUI, c'est qui faut afficher une info bulle et
			    donc recherche le libellé de la zone en recherchant avec le nom de l'initule suffixe
				par _TAG */
			if upper(ldatawindow.describe(ls_objects[ li_indice_object]+ ".tag")) = is_affiche_tag then
				ls_traduction = get_traduction(ls_objects[li_indice_object] + is_tag)
				ldatawindow.modify(ls_objects[ li_indice_object]+ ".tag='" + is_prefix_tag + ls_traduction +"'")
			end if
			
		case "compute"
			ldatawindow.modify(ls_objects[ li_indice_object]+ ".text='" + ls_traduction +"'")
			if upper(ldatawindow.describe(ls_objects[ li_indice_object]+ ".tag")) = is_affiche_tag then
				ls_traduction = get_traduction(ls_objects[li_indice_object] + is_tag)
				ldatawindow.modify(ls_objects[ li_indice_object]+ ".tag='" + is_prefix_tag + ls_traduction +"'")
			end if
			
		case "column"
			if ldatawindow.describe(ls_objects[ li_indice_object]+".Edit.Style") = "dddw" then
				ldatawindow.getchild(ls_objects[ li_indice_object],l_dwc)
				 set_traduction_report(l_dwc)
			end if

		case "datawindow"
		
          case "report"
			ldatawindow.GetChild(ls_objects[ li_indice_object], l_dwc)
		    set_traduction_report(l_dwc)
	end choose
next 

 return
 
end subroutine

public subroutine set_traduction_userobject (ref powerobject a_user_object);/*<DESC>
   Fonction effectuant la traduction des éléments du userobjectpassée en paramètre
	
   La traduction se fait en passant en revu tous les objets contenus dans celle ci.

   Pour certain objet comme lles datawindows un fonction spécifique sera appelée
	pour permettre de passer en revue les objets qu'ils contiennent.
   
</DESC> */
	
Integer  li_indice_object
String    ls_traduction
UserObject     lo_userobject
Powerobject    lo_po

 lo_userobject = a_user_object
/* Passage en revue de tous les objets de la fenêtre */
for li_indice_object = 1 to upperBound(lo_userobject.control[])
	lo_po = lo_userobject.control[li_indice_object]

	/* si l'objet est une datawindow, appel de la fonction  qui va traduire les objets contenus dans la datawindow 
	    si le tag associé à la datawindow spécifie qu'il faut la traduire */
	if  lo_userobject.control[li_indice_object].typeof() = datawindow! then
		set_traduction_datawindow(lo_po)
		continue
	end if
	
	ls_traduction = get_traduction (lo_po.classname( ))
	
	/* si l'objet est une datawindow, appel de la fonction
	   qui va traduire les objets contenus dans la datawindow */
	choose case lo_userobject.control[li_indice_object].typeof()
		case	CheckBox!
			CheckBox lcheckBox
			lcheckBox = lo_userobject.control[li_indice_object]
			lcheckBox.text = ls_traduction
		case OLECustomControl!
		case CommandButton!
			CommandButton lcommandButton
			lcommandButton = lo_userobject.control[li_indice_object]
			lcommandButton.text = ls_traduction
		case Oval!
		case DataWindow!
		case Picture!
		case DropDownListBox!
		case PictureButton!
			PictureButton lpictureButton
			lpictureButton = lo_userobject.control[li_indice_object]
			lpictureButton.text = ls_traduction
		case DropDownPictureListBox!
		case PictureListBox!
		case EditMask!
		case RadioButton!
			RadioButton lradioButton
			lradioButton = lo_userobject.control[li_indice_object]
			lradioButton.text = ls_traduction
		case Graph!
		case Rectangle!
		case GroupBox!	
			GroupBox lgroupBox
			lgroupBox = lo_userobject.control[li_indice_object]
			lgroupBox.text = ls_traduction
		case RichTextEdit!
		case HScrollBar!
		case RoundRectangle!
		case Line!	
		case SingleLineEdit!
		case ListBox!	
		case StaticText!
			StaticText lstaticText
			lstaticText = lo_userobject.control[li_indice_object]
			lstaticText.text = ls_traduction
		case ListView!	
		case Tab!
		case MultiLineEdit!	
		case TreeView!
		case OLEControl!
		case VScrollBar!
		case UserObject!
		case else
	end choose
next
end subroutine

public subroutine set_traduction_datastore (datastore a_datastore);/* <DESC>
   Traduction du contenu de la datawindow. Pour pourvoir traduire une datawindow
 </DESC> */
 
 integer li_indice_object, li_deb,li_pos,li_long,li_start
 String  ls_setting
 String  ls_objects[]

datastore  ldatawindow
DataWindowChild l_dwc

 ldatawindow = a_datastore
 
 // Extraction de la liste des objects contenus dans la datawindow
 ls_setting = ldatawindow.Describe("DataWindow.Objects")

 /*   conversion de la liste des objects en tableau contenant la liste des objects
  car la liste est formatée sous forme d'une chaine de caractère contenant la liste
  des objects séparés par la tabulation 
   */
 li_indice_object = 1
 li_deb= 1
 li_pos  = pos (ls_setting, "~t", 1) 
 li_long = li_pos - 1
   
do
	ls_objects[li_indice_object] = mid (ls_setting, li_deb, li_long)
	li_indice_object = li_indice_object + 1 
	li_start = li_pos + 1
	li_deb = li_start
	li_pos  = pos (ls_setting, "~t", li_start ) 
	li_long = li_pos - li_start
loop until  li_pos = 0

ls_objects[li_indice_object] = mid (ls_setting, li_deb)

// lecture du tableau des objects à traduire
// appel du module de traduction
String ls_type, ls_traduction

for li_indice_object = 1 to upperbound(ls_objects)
	ls_traduction = get_traduction(ls_objects[li_indice_object])
	ls_type =  ldatawindow.describe(ls_objects[ li_indice_object]+ ".type") 
	
	choose case ls_type
		case "text"
			if upper(ldatawindow.describe(ls_objects[ li_indice_object]+ ".tag")) = is_no_text then
				continue
			end if
			
			ldatawindow.modify(ls_objects[ li_indice_object]+ ".text='" + ls_traduction +"'")
			if upper(ldatawindow.describe(ls_objects[ li_indice_object]+ ".tag")) = is_affiche_tag then
				ls_traduction = get_traduction(ls_objects[li_indice_object] + is_tag)
				ldatawindow.modify(ls_objects[ li_indice_object]+ ".tag='" + is_prefix_tag + ls_traduction +"'")
			end if
			
		case "compute"
			ldatawindow.modify(ls_objects[ li_indice_object]+ ".text='" + ls_traduction +"'")
			if upper(ldatawindow.describe(ls_objects[ li_indice_object]+ ".tag")) = is_affiche_tag then
				ls_traduction = get_traduction(ls_objects[li_indice_object] + is_tag)
				ldatawindow.modify(ls_objects[ li_indice_object]+ ".tag='" + is_prefix_tag + ls_traduction +"'")
			end if
			
		case "column"
			if ldatawindow.describe(ls_objects[ li_indice_object]+".Edit.Style") = "dddw" then
				ldatawindow.GetChild( ldatawindow.describe(ls_objects[ li_indice_object]), l_dwc)
			     set_traduction_report(l_dwc)
			end if

		case "datawindow"
		
          case "report"
			ldatawindow.GetChild(ls_objects[ li_indice_object], l_dwc)
			set_traduction_report(l_dwc)
	end choose
next 

 return
 
end subroutine

public subroutine set_traduction_report (ref datawindowchild a_dwc);/* <DESC>
   Traduction du contenu de l'object datawindow child qui est un object report
 </DESC> */
 
 integer li_indice_object, li_deb,li_pos,li_long,li_start
 String  ls_setting
 String  ls_objects[]

DataWindowChild l_dwc

 l_dwc = a_dwc
 
 // Extraction de la liste des objects contenus dans la datawindow
 ls_setting = l_dwc.Describe("DataWindow.Objects")
 if len(ls_setting) = 0 then
	return
end if
 
 /*   conversion de la liste des objects en tableau contenant la liste des objects
  car la liste est formatée sous forme d'une chaine de caractère contenant la liste
  des objects séparés par la tabulation 
   */
 li_indice_object = 1
 li_deb= 1
 li_pos  = pos (ls_setting, "~t", 1) 
 li_long = li_pos - 1
   
do
	ls_objects[li_indice_object] = mid (ls_setting, li_deb, li_long)
	li_indice_object = li_indice_object + 1 
	li_start = li_pos + 1
	li_deb = li_start
	li_pos  = pos (ls_setting, "~t", li_start ) 
	li_long = li_pos - li_start
loop until  li_pos = 0

ls_objects[li_indice_object] = mid (ls_setting, li_deb)

// lecture du tableau des objects à traduire
// appel du module de traduction
String ls_type, ls_traduction

for li_indice_object = 1 to upperbound(ls_objects)
	ls_traduction = get_traduction(ls_objects[li_indice_object])
	ls_type =  l_dwc.describe(ls_objects[ li_indice_object]+ ".type") 
	
	choose case ls_type
		case "text"
			if upper(l_dwc.describe(ls_objects[ li_indice_object]+ ".tag")) = is_no_text then
				continue
			end if
			
			l_dwc.modify(ls_objects[ li_indice_object]+ ".text='" + ls_traduction +"'")
			if upper(l_dwc.describe(ls_objects[ li_indice_object]+ ".tag")) = is_affiche_tag then
				ls_traduction = get_traduction(ls_objects[li_indice_object] + is_tag)
				l_dwc.modify (ls_objects[ li_indice_object]+ ".tag='" + is_prefix_tag + ls_traduction +"'")
			end if
			
		case "compute"
			l_dwc.modify(ls_objects[ li_indice_object]+ ".text='" + ls_traduction +"'")
			if upper(l_dwc.describe(ls_objects[ li_indice_object]+ ".tag")) = is_affiche_tag then
				ls_traduction = get_traduction(ls_objects[li_indice_object] + is_tag)
				l_dwc.modify (ls_objects[ li_indice_object]+ ".tag='" + is_prefix_tag + ls_traduction +"'")
			end if

	end choose
next 

 return
 
end subroutine

public function string get_traduction_code (string as_code_table, string as_code);if ids_traduction_code.retrieve(as_code_table,as_code,is_code_langue) = DB_ERROR then
	f_dmc_error (this.classname() + " " +  ids_traduction_code.uf_getdberror( ))
end if
return ids_traduction_code.getItemString(1,DBNAME_VALEUR_PARAM)
end function

public function boolean is_traduction_chargee ();if ids_traduction.rowCount() = 0 then
	return false
else
	return true
end if
end function

public subroutine set_init_data ();if ids_traduction.retrieve() = -1 then
	f_dmc_error (ids_traduction.uf_getdberror( ))
end if

is_code_langue = g_nv_come9par.get_code_langue( )


ids_traduction_code = create nv_datastore
ids_traduction_code.dataobject = "d_object_traduction_code"
ids_traduction_code.settrans (sqlca)
end subroutine

on nv_traduction.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nv_traduction.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;ids_traduction = create nv_datastore
ids_traduction.DataObject = 'd_traduction'
ids_traduction.SetTransObject (SQLCA)

set_init_data()
end event

event destructor;destroy ids_traduction
end event

