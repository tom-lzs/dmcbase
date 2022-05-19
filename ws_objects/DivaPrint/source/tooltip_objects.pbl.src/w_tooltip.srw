$PBExportHeader$w_tooltip.srw
forward
global type w_tooltip from window
end type
type st_1 from u_st_autowidth within w_tooltip
end type
end forward

global type w_tooltip from window
integer width = 617
integer height = 76
boolean enabled = false
boolean border = false
windowtype windowtype = child!
long backcolor = 134217752
string icon = "AppIcon!"
st_1 st_1
end type
global w_tooltip w_tooltip

type variables
double ii_timeout = 2
end variables

forward prototypes
public subroutine wf_pass_flag (ref boolean ab_flag)
end prototypes

public subroutine wf_pass_flag (ref boolean ab_flag);
end subroutine

on w_tooltip.create
this.st_1=create st_1
this.Control[]={this.st_1}
end on

on w_tooltip.destroy
destroy(this.st_1)
end on

event open;string is_parm
is_parm = message.stringparm
int ii_pos_space

ii_pos_space = pos(is_parm, " ", 1)
x = integer( mid(is_parm, 1, ii_pos_space))
is_parm = trim(mid(is_parm, ii_pos_space))

ii_pos_space = pos(is_parm, " ", 1)
y = integer( mid(is_parm, 1, ii_pos_space))
is_parm = trim(mid(is_parm, ii_pos_space))

st_1.ib_autoresize = true
st_1.text = is_parm

st_1.resize()

this.width = st_1.width
this.height = st_1.height

timer(ii_timeout)
parentwindow().setfocus()
end event

event timer;timer(0)
close(this)
end event

type st_1 from u_st_autowidth within w_tooltip
integer width = 613
integer height = 72
integer textsize = -10
long backcolor = 134217752
boolean enabled = false
boolean border = true
borderstyle borderstyle = StyleBox!
boolean focusrectangle = false
end type

