$PBExportHeader$u_st_autowidth.sru
forward
global type u_st_autowidth from statictext
end type
type struct_size from structure within u_st_autowidth
end type
end forward

type struct_size from structure
	long		sl_width
	long		sl_height
end type

global type u_st_autowidth from statictext
integer width = 457
integer height = 84
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "Simple Test"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
end type
global u_st_autowidth u_st_autowidth

type prototypes
Function ulong GetDC(ulong hWnd) LIBRARY "USER32"
Function boolean GetTextExtentPoint32A(ulong hDC, string tex, long len, REF struct_size size)  LIBRARY "GDI32" alias for "GetTextExtentPoint32A;Ansi"
Function ulong ReleaseDC( ulong hWnd, ulong hdcr ) Library "USER32"
Function ulong SelectObject( ulong hdc, ulong hWnd) Library "GDI32"

end prototypes

type variables
boolean ib_autoResize
end variables

forward prototypes
public function long resize ()
end prototypes

public function long resize ();//ulong hDC, hWnd
//if ib_autoResize then 
//    struct_size lstruct_size 
//    hWnd =  Handle(this) 
//    hDC = GetDC(hWnd)
//    GetTextExtentPoint32A ( hDC, Text, Len(Text), lstruct_size) 
//    width =  PixelsToUnits(lstruct_size.sl_width, XPixelsToUnits!)  + 100
//end if 
//return width
//
constant integer c_wmGetFont = 49 // hex 0x0031

integer li_Len
uLong lul_Hdc
ulong lul_Handle
ulong lul_hFont
struct_size lstruct_size

li_Len = len( text )

// Get the handle of the Object and create a Device Context
lul_Handle = Handle( this )
lul_Hdc = GetDC( lul_Handle )

// Get the font in use on the Static Text
lul_hFont = Send( lul_Handle, c_wmGetFont, 0, 0 )

// Select it into the device context
SelectObject( lul_Hdc, lul_hFont )

// Get the size of the text.
If Not GetTextExtentpoint32A( lul_Hdc, Text, li_Len, lstruct_size ) Then 
ReleaseDC( lul_Handle, lul_Hdc )
Return -1
end if

this.width = PixelsToUnits(lstruct_size.sl_Width + 6, xPixelsToUnits!)
this.height = PixelsToUnits(lstruct_size.sl_Height + 2, yPixelsToUnits!)

ReleaseDC( lul_Handle, lul_Hdc )

Return 0

end function

on u_st_autowidth.create
end on

on u_st_autowidth.destroy
end on

