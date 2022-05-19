$PBExportHeader$u_dw_comptabilite_client.sru
$PBExportComments$Permet d'afficher la situation comptable du client et la liste des remises gamme qui lui sont associés
forward
global type u_dw_comptabilite_client from userobject
end type
type dw_remise_gamme from u_dwa within u_dw_comptabilite_client
end type
type dw_1 from datawindow within u_dw_comptabilite_client
end type
end forward

global type u_dw_comptabilite_client from userobject
integer width = 2798
integer height = 900
long backcolor = 12632256
dw_remise_gamme dw_remise_gamme
dw_1 dw_1
end type
global u_dw_comptabilite_client u_dw_comptabilite_client

type variables

end variables

forward prototypes
public function datawindow fu_get_datawindow ()
end prototypes

public function datawindow fu_get_datawindow ();return  dw_1
end function

on u_dw_comptabilite_client.create
this.dw_remise_gamme=create dw_remise_gamme
this.dw_1=create dw_1
this.Control[]={this.dw_remise_gamme,&
this.dw_1}
end on

on u_dw_comptabilite_client.destroy
destroy(this.dw_remise_gamme)
destroy(this.dw_1)
end on

type dw_remise_gamme from u_dwa within u_dw_comptabilite_client
integer x = 1623
integer y = 104
integer width = 1061
integer height = 420
integer taborder = 30
string dataobject = "d_remise_gamme"
boolean vscrollbar = true
end type

type dw_1 from datawindow within u_dw_comptabilite_client
string tag = "A_TRADUIRE"
integer x = 37
integer y = 60
integer width = 2711
integer height = 764
integer taborder = 20
string dataobject = "d_client_comptable"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

