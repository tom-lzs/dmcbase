$PBExportHeader$nv_sqlca.sru
$PBExportComments$Objet non visuel de type transaction , ajoute des fonctions à SQLCA
forward
global type nv_sqlca from nv_transaction
end type
end forward

global type nv_sqlca from nv_transaction
end type
global nv_sqlca nv_sqlca

type prototypes
// Contrôle existence du code origine de la commande
	subroutine COMEP004(string code_origine,ref string code_retour) RPCFUNC 
// Contrôle existence du code manquant
	subroutine COMEP005(string code_manquant,ref string libelle,ref string code_retour) RPCFUNC
// Contrôle existence du code grossiste
	subroutine COMEP006(string numaeclf,ref string abnaeclf,ref string abvaeclf,ref string code_retour) RPCFUNC
// Contrôle existence du code nature de l'ordre
	subroutine COMEP007(string nature_ordre,ref string code_retour) RPCFUNC
// Contrôle existence du code mode de paiement
	subroutine COMEP008(string mode_paiement,ref string code_retour) RPCFUNC
// Contrôle existence du code mode de gestion
	subroutine COMEP009(string mode_gestion,ref string code_retour) RPCFUNC
// Contrôle existence du code expédition en EXPRESS
	subroutine COMEP010(string exp_express,ref string code_retour) RPCFUNC
// Contrôle existence du code paiement expédition
	subroutine COMEP011(string paiement_exp,ref string code_retour) RPCFUNC
// Contrôle existence du compte analytique
	subroutine COMEP012(string compte_analytique,ref string code_retour) RPCFUNC
// Contrôle existence du code échéance
	subroutine COMEP013(string code_echeance,string codaetrs,ref string code_retour) RPCFUNC
// Contrôle existence du code mode d'expédition
	subroutine COMEP014(string mode_exp,ref string code_retour) RPCFUNC
// Contrôle existence de la référence et recherche du tarif
	subroutine COMEP015(string artaegch,string groaegch,string nuaaegch,string ctaaeecv,ref string cpraepro,string numaeclf,ref double taraeecv,ref double tauaersf,ref string artae000,ref string groae000,ref string nuaae000,ref string code_retour) RPCFUNC
// Recherche du dernier numéro de ligne de commande
	subroutine COMEP016(string numaecde,ref string nseef005,ref string code_retour) RPCFUNC
// Maj des lignes de commande suite à modification de l'entete de cde
	subroutine COMEP017(string numaecde,string new_tarif,string old_tarif,decimal tauaersa,string numaeclf,ref string code_retour) RPCFUNC
// Saisie des lignes de commande (bon de cde et catalogue)
	subroutine COMEP018(string numaecde,string codaevis,string artaegch,string groaegch,string nuaaegch,decimal qteaeuve,string nseef005,string typaesai,string ctaaeecv,ref string code_retour) RPCFUNC
// Fin de saisie des lignes de commande (bon de cde et catalogue)
	subroutine COMEP019(string numaecde,string nseef005,string typaesai,string codaeliv,datetime dtsaeliv,string numaegrf,string codaeech,string codaemqt,string cmdaepai,string ctaaeecv,decimal tauaerli,decimal tauaersa,string numaeclf,ref string code_retour) RPCFUNC
// Recherche des informations client sur le COME9048
	subroutine COMEP020(string numaeclf,string posaeana,ref string txtaeexp,ref string txtaefac,ref string mesaesai,ref string codaefac,ref string cexaeexp,ref string paiaeexp,ref string codaemxp,ref string cptaeana,ref string code_retour) RPCFUNC
// Recherche des informations Données Saisie de commande sur COME9008
	subroutine COMEP021(ref string ctaaeecv,ref string posaeana,ref string code_retour) RPCFUNC
// Valorisation de la commande
	subroutine COMEP022(string numaecde,ref decimal mtlaedir,ref decimal mtlaeind,ref decimal mtlaegrf,ref decimal nbraflig,ref string code_retour) RPCFUNC
// Détermination du numéro de commande
	subroutine COMEP023(string codeevis,ref decimal ncdaeter,ref string code_retour) RPCFUNC
// Contrôle du code nature du client
	subroutine COMEP024(string nataeclf,ref string lnaaeclf,ref string code_retour) RPCFUNC
// Contrôle du code fonction du client
	subroutine COMEP025(string fctaeclf,ref string lfcaefct,ref string code_retour) RPCFUNC
// Contrôle du code région du client
	subroutine COMEP026(string numaerg0,ref string code_retour) RPCFUNC
// Contrôle du code correspondancière
	subroutine COMEP027(string numaeco1,ref string code_retour) RPCFUNC
// Contrôle du code tournée du client
	subroutine COMEP028(string numaeto0,ref string code_retour) RPCFUNC
// Contrôle du code client
	subroutine COMEP029(string numaeclf,ref string code_retour) RPCFUNC
// Mise à jour du client prospect
	subroutine COMEP030(string numaeclf,string cli_prospect,string abnaeclf,string abvaeclf,ref string code_retour) RPCFUNC

end prototypes

on nv_sqlca.create
call transaction::create
TriggerEvent( this, "constructor" )
end on

on nv_sqlca.destroy
call transaction::destroy
TriggerEvent( this, "destructor" )
end on

