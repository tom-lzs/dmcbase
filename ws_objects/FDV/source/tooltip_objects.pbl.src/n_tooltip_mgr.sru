$PBExportHeader$n_tooltip_mgr.sru
forward
global type n_tooltip_mgr from nonvisualobject
end type
type it_timer from timing within n_tooltip_mgr
end type
end forward

global type n_tooltip_mgr from nonvisualobject
event comments ( )
it_timer it_timer
end type
global n_tooltip_mgr n_tooltip_mgr

type variables
integer ii_mouseMoveDelta=100, ii_xAnchor, ii_yAnchor
w_tooltip iw_toolTip
string is_last_pop_control
boolean ib_timeout_close = true

window iw_parent
graphicobject igo_control
string is_control
long il_xpos, il_ypos



end variables

forward prototypes
public function string of_get_tokenized_value (string as_target, string as_token)
public subroutine of_mousemove_notify (readonly window aw_parent, readonly graphicobject ago_control, string as_control, long al_xpos, long al_ypos)
end prototypes

event comments();//  As you may guess, this event is just for comments/documentation and is otherwise completely unused.
// I am using it to document the purpose and usage of this object.

//This is an adaptation of code originally written by Richard (Rik) Brooks in PBDJ vol 7 issue 1 Jan 2000.

//First of all, this object relies on 2 other objects:
//	u_st_autowidth
//	w_tooltip	

//  To keep things simple, you only have to do a couple of things to your code to use the tool-tips.

// 1) add an instance variable of type n_tooltip_mgr
//
//			n_tooltip_mgr tooltip
//
// 2) pick an object.event to trigger the too-ltip -- designed mainly for mousemove, but can be another event.
//
// 3) The code you add to that event depends on it the control is a datawindow or not.
//
//		a) For a non-datawindow control (or if you want a tool-tip just for the dw-control object itself) add the following code:
//
//			if not isvalid(tooltip) then
//				tooltip = create n_tooltip_mgr
//			end if
//			tooltip.of_mousemove_notify(iw_parent, this, classname(), parent.x + this.x + xpos, parent.y + this.y + ypos)
//			//NOTE: The x and y values need to be calculated relative to the parent window
//
// 		b) For a datawindow where you want one or more datawindow objects (columns, labels, etc.) to have a tooltip code the following:
//
//			if not isvalid(tooltip) then
//				tooltip = create n_tooltip_mgr
//			end if
//			tooltip.of_mousemove_notify(iw_parent, this, getobjectatpointer(), parent.x + this.x + xpos, parent.y + this.y + ypos)
//			//NOTE: The x and y values need to be calculated relative to the parent window
//
// 4) Add the tooltip token and text to the object's tag.
//
//		a) For a control on a window (including a datawindow control) put the text in the objects tag property:
//
//			[tooltip] Your tooltip text here.
//
//		b) For a datawindow object control, put the text in the tag property for the control
//
//			[tooltip] Your tooltip text here.

//NOTE: If both the dw control and controls in the dw object have tooltips, then the sizing and spacing of controls in the dw object
//		   should be considered carefully.  Reason: As the mouse moves over the DW control, the tooltip display will potentially change 
//		   quickly from dw object control, to dw control, back to a dw object control.
//		   This causes a distracting, erratic appearance/effect.  In such a case, tooltip items on the dw object should either be spaced 
//		   far appart, OR have no space between to minimize the erratic appearance.
end event

public function string of_get_tokenized_value (string as_target, string as_token);// Get the value part of a token / value pair from the target. 
// First prepare both the token and the target for searching 
string ls_target 
as_token = lower(as_token)       // Enforce case insensitivity 
ls_target = lower(as_target)

long ll_valueStart, ll_valueEnd 
  

ll_valueStart = pos(ls_target, as_token) 
if ll_valueStart = 0 then return "" // no token 
  

// look for the ending bracket so we know where the token 
// ends and move ll_valueStart one beyond that. 
ll_valueStart = pos(ls_target, "]", ll_valueStart + 1) + 1 
  

// Look for the start of the next token 
ll_valueEnd = pos(ls_target, "[", ll_valueStart) 
  

// There are no tokens after the one in question. Just return  the right part of the target. 
if ll_valueEnd = 0 then return trim(right(as_target, len(as_target) - ll_valueStart)) 
  

// Now we know that the value is embedded. Get it out with a mid 
return trim(mid(as_target, ll_valueStart, ll_valueEnd - ll_valueStart)) 


end function

public subroutine of_mousemove_notify (readonly window aw_parent, readonly graphicobject ago_control, string as_control, long al_xpos, long al_ypos);//----------------------------------------------------------------------------------------------
// SCRIPT:		of_mousemove_notify
//
// PURPOSE: 	This is the primary tooltip interface.  It is called by the object 
//					which wants to display it's tooltip text.  Please see the
//					"comments" event for a full usage description.
//
//ARGUMENTS:	Name:						Datatype		   Description
//					-----------------------------------------------------------------
//					aw_parent					window		   This is a read only reference to the
//																	   window that holds the control which
//																	   is requesting tooltip display.
//					ago_control					graphicobject This is the object requesting  the tooltip.
//					as_control					string			   A string containing the name of ago_control OR
//																	   if ago_control is a datawindow, the name of the
//																	   datawindow control to be referenced.
//					al_xpos						long			   The x position at which to display the tooltip.
//					al_ypos						long			   The y position at which to display the tooltip.
//
// RETURN:		Datatype		Description
//					-----------------------------------------------------------------
//
// DATE	     	PROG/ID		CUST/ID	F/E/D	DESCRIPTION OF CHANGE / REASON
// ----------		--------		---------	-----	-----------------------------------------
// 10/04/2002	Erik T. 		Erik T.		DEV	New object.
//------------------------------------------------------------------------------------------------

iw_parent = aw_parent
igo_control = ago_control
is_control = as_control
il_xpos = al_xpos
il_ypos = al_ypos


if not isValid(iw_toolTip)  then 
	it_timer.stop()
	it_timer.start(.5)
else
	it_timer.event timer()
end if

return
end subroutine

on n_tooltip_mgr.create
call super::create
this.it_timer=create it_timer
TriggerEvent( this, "constructor" )
end on

on n_tooltip_mgr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
destroy(this.it_timer)
end on

type it_timer from timing within n_tooltip_mgr descriptor "pb_nvo" = "true" 
end type

event timer;call super::timer;string ls_tag, ls_tag_dw
string ls_control_name
ls_control_name = is_control

stop()

//are we on a datawindow or a different control type
if igo_control.typeof() = datawindow! then
	//It's a datawindow...we should have the name of the object returned by getobjectatpointer()...now get it's tag.
	//Find out if we are over a column 
	datawindow ldw_control
	ldw_control = igo_control
	
	//just get the tag from the datawindow control
	ls_tag = igo_control.tag	
	
	if igo_control.classname() <> is_control then
		// See if the control on the datawindow has a tooltip tag...if so use it
		if len(ls_control_name) < 1 then // Not over a named object...just use the dw_control
			 ls_control_name = ldw_control.classname()
		else
			// ls_control_name will be the name of the control, a tab, 
			// then the row number of the control. We don't care about 
			// the row number. We have to parse that out. 
			ls_control_name = left(ls_control_name, (pos(ls_control_name, "~t") - 1)) 

			if len(ls_control_name) < 1 then return // This SHOULD never happen 
		
			// now ls_control is the name of the control over which the 
			// pointer is. We need to grab its tag attribute since that's 
			// where we will store the tool tip.  
			ls_tag_dw = ldw_control.describe(ls_control_name + ".Tag") 
			if ls_tag_dw <> "!" and ls_tag_dw <> "?" and len(ls_tag_dw) > 0 then
				ls_tag = ls_tag_dw
			else
				ls_control_name = ldw_control.classname()
			end if
		end if
	end if
else
	//just get the tag
	ls_tag = igo_control.tag
end if

// Make sure it's a good tag 
if ls_tag = "!" or len(ls_tag) < 1 then return 

if ls_control_name = is_last_pop_control then
	// Ignore it.  It is the same control. 
	return
else
	//we have a different control 
	if isValid(iw_toolTip)  then 
		// the tooltip is on display...
		close(iw_toolTip) //...close it and proceed on to re-open it for the new control
	end if
end if

// Now check to see if there is a tool tip in this. 
string ls_tip 
ls_tip = of_get_Tokenized_Value(ls_tag, "tooltip") 

if ls_tip = 'null' then
	is_last_pop_control = ls_control_name
	return
end if
	
if len(ls_tip) > 0 then 
    // Found a tip, open the window. 
    openWithParm(iw_tooltip, string(il_xpos + 10) + " " + string(il_ypos + 10) + " " +ls_tip, iw_parent)
//    ib_timeout_close = false
    iw_tooltip.wf_pass_flag(ib_timeout_close)
    is_last_pop_control = ls_control_name
end if

end event

on it_timer.create
call super::create
TriggerEvent( this, "constructor" )
end on

on it_timer.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

