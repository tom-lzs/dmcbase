$PBExportHeader$n_tmg.sru
$PBExportComments$Extension Timing Class
forward
global type n_tmg from timing
end type
end forward

global type n_tmg from timing
end type
global n_tmg n_tmg

type variables
Public:
n_cst_tmgsingle			inv_single
end variables

forward prototypes
public function integer of_setsingle (boolean ab_switch)
end prototypes

public function integer of_setsingle (boolean ab_switch);// Check arguments.
If IsNull(ab_switch) Then Return -1

If ab_switch Then
	If IsNull(inv_single) OR NOT IsValid(inv_single) Then
		inv_single = Create n_cst_tmgsingle
//		inv_single.of_SetRequestor(this)
		return 1
	End If
Else
	If IsValid(inv_single) Then
		Destroy inv_single
		return 1
	End If
End If

return 0
end function

on n_tmg.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_tmg.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event timer;//////////////////////////////////////////////////////////////////////////////
//
//	Event: timer
//
//	Arguments: None
//
//	Returns: None
//
//	Description:
//	Processes timer.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	6.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////
If IsValid(inv_single) Then
	inv_single.Event pfc_timer()
End If
end event

event destructor;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	Destructor
//
//	Description:
//	Clean anything that has been created or opened by the service
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	6.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////
of_SetSingle(false)

end event

