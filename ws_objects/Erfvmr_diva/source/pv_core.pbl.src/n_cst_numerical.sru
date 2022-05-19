$PBExportHeader$n_cst_numerical.sru
$PBExportComments$* Extension Numerical service
forward
global type n_cst_numerical from nonvisualobject
end type
end forward

global type n_cst_numerical from nonvisualobject autoinstantiate
end type

type variables
Protected:
Constant Integer SIZE_BOOLEAN = 1 // Boolean
Constant Integer SIZE_CHAR = 1 // Char
Constant Integer SIZE_INT = 2 // Signed integer
Constant Integer SIZE_UINT = 2 // Unsigned integer
Constant Integer SIZE_LONG = 4 // Signed Long
Constant Integer SIZE_ULONG = 4 // Unsigned Long
Constant Integer SIZE_STRING = 4 // Assume as string pointer

// Supported DataTypes
Integer INTEGER
UInt UINT
Long LONG
ULong ULONG
Char CHAR
String STRING
Boolean BOOLEAN
end variables

forward prototypes
public function long of_clearbit (long al_decimal, unsignedinteger aui_bit)
public function long of_bitwiseor (long al_decimala, long al_decimalb)
public function integer of_bitwisexor (integer ai_decimala, integer ai_decimalb)
public function long of_bitwisexor (long al_decimala, long al_decimalb)
public function integer of_clearbit (integer ai_decimal, unsignedinteger aui_bit)
public function long of_decimal (string as_binary)
public function boolean of_getbit (long al_decimal, unsignedinteger aui_bit)
public function integer of_setbit (integer ai_decimal, unsignedinteger aui_bit)
public function long of_setbit (long al_decimal, unsignedinteger aui_bit)
public function integer of_flipbit (integer ai_decimal, unsignedinteger aui_bit)
public function long of_flipbit (long al_decimal, unsignedinteger aui_bit)
public function integer of_bitwiseand (integer ai_decimala, integer ai_decimalb)
public function long of_bitwiseand (long al_decimala, long al_decimalb)
public function integer of_bitwisenot (integer ai_decimal)
public function long of_bitwisenot (long al_decimal)
public function integer of_bitwiseor (integer ai_decimala, integer ai_decimalb)
public function long of_sizeof (long al_data)
public function long of_sizeof (string as_data)
public function long of_sizeof (unsignedinteger aui_data)
public function long of_sizeof (unsignedlong aul_data)
public function long of_sizeof (character ac_data)
public function string of_binary (long al_decimal)
public function long of_sizeof (integer ai_data)
public function long of_sizeof (powerobject apo_data)
public function long of_sizeof (boolean ab_data)
protected function long of_sizeof (variabledefinition avdf_data[])
public function ulong of_bitwiseor (unsignedlong al_values[])
protected function long of_sizeof (any aa_data[])
public function long of_sizeof (powerobject apo_data[])
end prototypes

public function long of_clearbit (long al_decimal, unsignedinteger aui_bit);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_ClearBit
//
// Access:	public
//
//	Arguments:
//		al_decimal		value
//		aui_bit			bit number to clear
//
//	Returns:  new value
//
//	Description:	Clears a given bit in a number.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	1.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996 Simon Harris (simon@addease.com.au).  All Rights Reserved.
//
//////////////////////////////////////////////////////////////////////////////

if of_GetBit(al_decimal, aui_bit) then
	return al_decimal - (2 ^ (aui_bit - 1))
end if

return al_decimal
end function

public function long of_bitwiseor (long al_decimala, long al_decimalb);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_BitwiseOR
//
// Access:	public
//
//	Arguments:
//		al_decimala
//		al_decimalb
//
//	Returns:  long
//
//	Description:	Logically OR 2 numbers
//
//		a	b	result
//		-- -- ------
//		0	0	0
//		0	1	1
//		1	0	1
//		1	1	1
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	1.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
unsignedint lui_bit
long			ll_decimal

ll_decimal = 0

for lui_bit = 1 to 32
	if this.of_GetBit(al_decimala, lui_bit) or this.of_GetBit(al_decimalb, lui_bit) then
		ll_decimal = this.of_SetBit(ll_decimal, lui_bit)
	end if
next

return ll_decimal
end function

public function integer of_bitwisexor (integer ai_decimala, integer ai_decimalb);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_BitwiseXOR
//
// Access:	public
//
//	Arguments:
//		ai_decimala
//		ai_decimalb
//
//	Returns:  int
//
//	Description:	Logically XOR 2 numbers
//
//		a	b	result
//		-- -- ------
//		0	0	0
//		0	1	1
//		1	0	1
//		1	1	0
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	1.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
unsignedint lui_bit
int			li_decimal

li_decimal = 0

for lui_bit = 1 to 16
	if this.of_GetBit(ai_decimala, lui_bit) <> this.of_GetBit(ai_decimalb, lui_bit) then
		li_decimal = this.of_SetBit(li_decimal, lui_bit)
	end if
next

return li_decimal
end function

public function long of_bitwisexor (long al_decimala, long al_decimalb);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_BitwiseXOR
//
// Access:	public
//
//	Arguments:
//		al_decimala
//		al_decimalb
//
//	Returns:  long
//
//	Description:	Logically XOR 2 numbers
//
//		a	b	result
//		-- -- ------
//		0	0	0
//		0	1	1
//		1	0	1
//		1	1	0
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	1.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
unsignedint lui_bit
long			ll_decimal

ll_decimal = 0

for lui_bit = 1 to 32
	if this.of_GetBit(al_decimala, lui_bit) <> this.of_GetBit(al_decimalb, lui_bit) then
		ll_decimal += (2 ^ (lui_bit - 1))
	end if
next

return ll_decimal
end function

public function integer of_clearbit (integer ai_decimal, unsignedinteger aui_bit);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_ClearBit
//
// Access:	public
//
//	Arguments:
//		ai_decimal		value
//		aui_bit			bit number to clear
//
//	Returns:  new value
//
//	Description:	Clears a given bit in a number.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	1.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
if of_GetBit(ai_decimal, aui_bit) then
	return ai_decimal - (2 ^ (aui_bit - 1))
end if

return ai_decimal
end function

public function long of_decimal (string as_binary);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_Decimal
//
// Access:	public
//
//	Arguments:
//		as_binary	string to convert
//
//	Returns:	long
//
//	Description:	Convert an array of 1's and 0's in big-endian format
//						i.e. LSB at index 1 to a number.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	1.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
long ll_decimal
unsignedint lui_cnt

// Propogate the sign bit
as_binary += Fill(Right(as_binary, 1), 31)

// Calculate the value
for lui_cnt = 1 to 32
	ll_decimal = ll_decimal + (long(Mid(as_binary, lui_cnt, 1)) * (2 ^ (lui_cnt - 1)))
next

return ll_decimal
end function

public function boolean of_getbit (long al_decimal, unsignedinteger aui_bit);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_GetBit
//
// Access:	public
//
//	Arguments:
//		al_decimal		value
//		aui_bit			bit number to test
//
//	Returns:  boolean
//
//	Description:	Tests a given bit in a number.
//
//////////////////////////////////////////////////////////////////////////////
ULong lul_decimal


lul_decimal = al_decimal

If (Mod(Long(lul_decimal /  2 ^ (aui_bit - 1)), 2) > 0) Then return true

return false
end function

public function integer of_setbit (integer ai_decimal, unsignedinteger aui_bit);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_SetBit
//
// Access:	public
//
//	Arguments:
//		ai_decimal		value
//		aui_bit			bit number to set
//
//	Returns:  new value
//
//	Description:	Sets a given bit in a number.
//
//////////////////////////////////////////////////////////////////////////////
If NOT this.of_GetBit(ai_decimal, aui_bit) Then
	return (ai_decimal + (2 ^ (aui_bit - 1)))
End If

return ai_decimal
end function

public function long of_setbit (long al_decimal, unsignedinteger aui_bit);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_SetBit
//
// Access:	public
//
//	Arguments:
//		al_decimal		value
//		aui_bit			bit number to set
//
//	Returns:  new value
//
//	Description:	Sets a given bit in a number.
//
//////////////////////////////////////////////////////////////////////////////
If NOT this.of_GetBit(al_decimal, aui_bit) Then
	return (al_decimal + (2 ^ (aui_bit - 1)))
End If

return al_decimal
end function

public function integer of_flipbit (integer ai_decimal, unsignedinteger aui_bit);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_FlipBit
//
// Access:	public
//
//	Arguments:
//		ai_decimal		value
//		aui_bit			bit number to flip
//
//	Returns:  new value
//
//	Description:	Flips a given bit in a number.
//
//////////////////////////////////////////////////////////////////////////////
If NOT this.of_GetBit(ai_decimal, aui_bit) Then
	return this.of_SetBit(ai_decimal, aui_bit)
Else
	return this.of_ClearBit(ai_decimal, aui_bit)
End If
end function

public function long of_flipbit (long al_decimal, unsignedinteger aui_bit);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_FlipBit
//
// Access:	public
//
//	Arguments:
//		al_decimal		value
//		aui_bit			bit number to flip
//
//	Returns:  new value
//
//	Description:	Flips a given bit in a number.
//
//////////////////////////////////////////////////////////////////////////////
If NOT this.of_GetBit(al_decimal, aui_bit) Then
	return this.of_SetBit(al_decimal, aui_bit)
Else
	return this.of_ClearBit(al_decimal, aui_bit)
End If
end function

public function integer of_bitwiseand (integer ai_decimala, integer ai_decimalb);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_BitwiseAND
//
// Access:	public
//
//	Arguments:
//		ai_decimala
//		ai_decimalb
//
//	Returns:  int
//
//	Description:	Logically AND 2 numbers
//
//		a	b	result
//		-- -- ------
//		0	0	0
//		0	1	0
//		1	0	0
//		1	1	1
//
//////////////////////////////////////////////////////////////////////////////
Integer li_decimal
UnsignedInteger lui_bit


For lui_bit = 1 To 16
	If of_GetBit(ai_decimala, lui_bit) AND of_GetBit(ai_decimalb, lui_bit) Then
		li_decimal = of_SetBit(li_decimal, lui_bit)
	End If
Next

Return li_decimal
end function

public function long of_bitwiseand (long al_decimala, long al_decimalb);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_BitwiseAND
//
// Access:	public
//
//	Arguments:
//		al_decimala
//		al_decimalb
//
//	Returns:  long
//
//	Description:	Logically AND 2 numbers
//
//		a	b	result
//		-- -- ------
//		0	0	0
//		0	1	0
//		1	0	0
//		1	1	1
//
//////////////////////////////////////////////////////////////////////////////
Long ll_decimal
UnsignedInteger lui_bit


For lui_bit = 1 To 32
	If of_GetBit(al_decimala, lui_bit) AND of_GetBit(al_decimalb, lui_bit) Then
		ll_decimal = of_SetBit(ll_decimal, lui_bit)
	End If
Next

Return ll_decimal
end function

public function integer of_bitwisenot (integer ai_decimal);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_BitwiseNOT
//
// Access:	public
//
//	Arguments:
//		ai_decimal		value to not
//
//	Returns:	none
//
//	Description:	Logically NOT all bits in a number
//
//		a	result
//		-- ------
//		0	1
//		1	0
//
//////////////////////////////////////////////////////////////////////////////
Integer li_decimal
UnsignedInteger lui_bit


For lui_bit = 1 To 16
	If NOT of_GetBit(ai_decimal, lui_bit) Then
		li_decimal = of_SetBit(li_decimal, lui_bit)
	End If
Next

Return li_decimal
end function

public function long of_bitwisenot (long al_decimal);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_BitwiseNOT
//
// Access:	public
//
//	Arguments:
//		al_decimal		value to not
//
//	Returns:	none
//
//	Description:	Logically NOT all bits in a number
//
//		a	result
//		-- ------
//		0	1
//		1	0
//
//////////////////////////////////////////////////////////////////////////////
Long ll_decimal
UnsignedInteger lui_bit


For lui_bit = 1 To 32
	If NOT of_GetBit(al_decimal, lui_bit) Then
		ll_decimal = of_SetBit(ll_decimal, lui_bit)
	End If
Next

Return ll_decimal
end function

public function integer of_bitwiseor (integer ai_decimala, integer ai_decimalb);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_BitwiseOR
//
// Access:	public
//
//	Arguments:
//		ai_decimala
//		ai_decimalb
//
//	Returns:  int
//
//	Description:	Logically OR 2 numbers
//
//		a	b	result
//		-- -- ------
//		0	0	0
//		0	1	1
//		1	0	1
//		1	1	1
//
//////////////////////////////////////////////////////////////////////////////
unsignedint lui_bit
int			li_decimal

li_decimal = 0

for lui_bit = 1 to 16
	if this.of_GetBit(ai_decimala, lui_bit) or this.of_GetBit(ai_decimalb, lui_bit) then
		li_decimal = this.of_SetBit(li_decimal, lui_bit)
	end if
next

return li_decimal
end function

public function long of_sizeof (long al_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		al_data
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
//////////////////////////////////////////////////////////////////////////////
Return(SIZE_LONG)
end function

public function long of_sizeof (string as_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		as_data
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
//////////////////////////////////////////////////////////////////////////////
Return(SIZE_STRING)
end function

public function long of_sizeof (unsignedinteger aui_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		aui_data
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
//////////////////////////////////////////////////////////////////////////////
Return(SIZE_UINT)
end function

public function long of_sizeof (unsignedlong aul_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		aul_data
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
//////////////////////////////////////////////////////////////////////////////
Return(SIZE_ULONG)
end function

public function long of_sizeof (character ac_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		ac_data
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
//////////////////////////////////////////////////////////////////////////////
Return(SIZE_CHAR)
end function

public function string of_binary (long al_decimal);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_Binary
//
// Access:	public
//
//	Arguments:
//		al_decimal		unsigned long to convert to bit string
//
//	Returns:  string
//
//	Description:	Convert al_decimal to a string of 32 1's and 0's in
//						big-endian format i.e with LSB at position 1.
//
//////////////////////////////////////////////////////////////////////////////
Long ll_remainder
String ls_binary
UnsignedInteger lui_cnt
UnsignedLong lul_decimal


lul_decimal = al_decimal

For lui_cnt = 1 To 32
	ll_remainder = Mod(lul_decimal, 2)
	lul_decimal = lul_decimal / 2
	ls_binary = ls_binary + String(ll_remainder)
Next

Return ls_binary
end function

public function long of_sizeof (integer ai_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		ai_data
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
//////////////////////////////////////////////////////////////////////////////
Return(SIZE_INT)
end function

public function long of_sizeof (powerobject apo_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		apo_data  powerobject
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
// Notes:
// 1) Cannot calculate the size of a structure with strings (variable size), for fixed sized strings use a char array;
// 2) CAN calculate the size of multi-dimension arrays within the structures
//////////////////////////////////////////////////////////////////////////////
ClassDefinition lcdf_classdef
VariableDefinition lvdf_vardef[]


lcdf_classdef = apo_data.ClassDefinition
lvdf_vardef = lcdf_classdef.VariableList

Return of_SizeOf(lvdf_vardef)
end function

public function long of_sizeof (boolean ab_data);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		ai_data
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
//////////////////////////////////////////////////////////////////////////////
Return SIZE_BOOLEAN
end function

protected function long of_sizeof (variabledefinition avdf_data[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: protected
//
//	Arguments:
//		avdf_data[]		variabledefinition
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
//////////////////////////////////////////////////////////////////////////////
ClassDefinition lcdf_typeinfo
VariableDefinition lvdf_varlist[]
VariableCardinalityDefinition lvcdf_varcardef
ArrayBounds lab_arraybounds[]

Long ll_size
Long ll_index
Long ll_array
Long ll_count


ll_count = Upperbound(avdf_data)

For ll_index = 2 To ll_count

	lvcdf_varcardef = avdf_data[ll_index].Cardinality
	lab_arraybounds = lvcdf_varcardef.ArrayDefinition

	If Upperbound(lab_arraybounds) > 0 Then 
		ll_array = lab_arraybounds[1].UpperBound
	Else 
		ll_array = 1
	End If

	Choose Case avdf_data[ll_index].TypeInfo.DataTypeOf
		Case "long"
			ll_size += of_SizeOf(LONG) * ll_array
		Case "ulong","unsignedlong"
			ll_size += of_SizeOf(ULONG) * ll_array
		Case "int","integer"
			ll_size += of_SizeOf(INTEGER) * ll_array
		Case "uint","unsignedint","unsignedinteger"
			ll_size += of_SizeOf(UINT) * ll_array
		Case "char","character"
			ll_size += of_SizeOf(CHAR)  * ll_array
		Case "string"
			ll_size += of_SizeOf(STRING) * ll_array
		Case "structure"
			lcdf_typeinfo = avdf_data[ll_index].TypeInfo
			lvdf_varlist = lcdf_typeinfo.VariableList
			ll_size += this.of_SizeOf(lvdf_varlist)
		Case Else
			MessageBox('of_SizeOf Error', 'Type is not supported, possibly variable sized or object type.', StopSign!, Ok!)
			Return -1
	End Choose
Next

Return ll_size
end function

public function ulong of_bitwiseor (unsignedlong al_values[]);Integer li_bit
Integer li_size
Integer li_index = 2

Long ll_rc
Long ll_value1
Long ll_value2


li_size = UpperBound(al_values)

If li_size < 2 Then Return -1

ll_value1 = al_values[1]

Do 
	ll_value2 = al_values[li_index]
	For li_bit = 0 To 31
		If Mod(Long(ll_value1 /  2 ^ li_bit), 2) > 0 OR Mod(Long(ll_value2 /  2 ^ li_bit), 2) > 0 Then
			If NOT Mod(Long(ll_rc /  2 ^ li_bit), 2) > 0 Then ll_rc += 2^li_bit
		End If
	Next
	ll_value1 = ll_rc
	li_index++
Loop Until li_index > li_size

Return ll_rc
end function

protected function long of_sizeof (any aa_data[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		aa_data[]
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
// Notes:	1) Supports mixed type arrays (and variable sized strings within the array)
//				2) DOESN'T support multi-dimension arrays
//////////////////////////////////////////////////////////////////////////////
Long ll_size
Long ll_index
Long ll_count


ll_count = UpperBound(aa_data)

For ll_Index = 1 To ll_count
	Choose Case ClassName(aa_data[ll_Index])
		Case 'long'
			ll_size += of_SizeOf(LONG)
		Case 'unsignedlong', 'ulong'
			ll_size += of_SizeOf(ULONG)
		Case 'int','integer'
			ll_size += of_SizeOf(INTEGER) 
		Case 'uint','unsignedinteger','unsignedint'
			ll_size += of_SizeOf(UINT)
		Case 'char', 'character'
			ll_size += of_SizeOf(CHAR)
		Case 'string'
			ll_size += of_SizeOf(CHAR) * of_SizeOf(String(aa_data[ll_Index]))
		Case 'boolean'
			ll_size += of_SizeOf(BOOLEAN)
	End Choose
Next

Return ll_size
end function

public function long of_sizeof (powerobject apo_data[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function: of_SizeOf
//
// Access: public
//
//	Arguments:
//		apo_data  powerobject
//
//	Returns:	long
//
//	Description: Determine the number of bytes associated with the passed datatype.
//
// Notes:
// 1) Cannot calculate the size of a structure with strings (variable size), for fixed sized strings use a char array;
// 2) CAN calculate the size of multi-dimension arrays within the structures
//////////////////////////////////////////////////////////////////////////////
ClassDefinition lcdf_classdef
VariableDefinition lvdf_vardef[]

Long ll_rc
Long ll_index
Long ll_upperbound


ll_upperbound = Upperbound(apo_data[])

For ll_index = 1 To ll_upperbound
	lcdf_classdef = apo_data[ll_index].ClassDefinition
	lvdf_vardef = lcdf_classdef.VariableList
	ll_rc += this.of_SizeOf(lvdf_vardef)
Next

Return ll_rc
end function

on n_cst_numerical.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_numerical.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

