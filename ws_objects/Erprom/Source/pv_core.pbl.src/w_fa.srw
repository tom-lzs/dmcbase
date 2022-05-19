$PBExportHeader$w_fa.srw
$PBExportComments$[MDI/MICROHELP] Ancêtre des fenêtre frame MDI.
forward
global type w_fa from w_fa_pt
end type
end forward

global type w_fa from w_fa_pt
string MenuName="m_frame"
end type
global w_fa w_fa

on w_fa.create
call w_fa_pt::create
if this.MenuName = "m_frame" then this.MenuID = create m_frame
end on

on w_fa.destroy
call w_fa_pt::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

