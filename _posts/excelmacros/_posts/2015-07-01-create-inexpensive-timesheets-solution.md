---
layout: posts
title: Creating inexpensive timesheet solution
overview: true
author: Vineet Maheshwari
place: Gurgaon
categories: 
 - excelmacros
tags: 
 - VBA
 - Excel
 - Management-Tools
---

#Overview of solution
Using VBA in excel, one can do almost everything in automated fashion, saving great amount of time. This is based on the fact that managers today already do everything on excel, though it is all manual.

This solution, considers, independent excel sheets maintained by individuals to fill timesheets. A coordinator, who pulls data from these individual sheets and populates central database.

#Globals and Initialization

<pre>
Globals
Global shtActiveTimesheet As Worksheet
Global wbkActiveTS As Workbook
Global wbkTI As Workbook
Global shtTIDb As Worksheet
Global shtTICfg As Worksheet

'initialization
Sub initTsImport()
Dim shtCfg As Worksheet

Set wbkTI = ActiveWorkbook
Set shtTIDb = ActiveWorkbook.Worksheets("db")
Set shtTICfg = wbkTI.Worksheets("cfg")
End Sub
</pre>

#Configuration
This sheet is meant to maintain variables that user can chose to change without going into VBA code.

![Configuration Sheet](/images/ts_cfg.jpg)

#Support Functions
<pre>
'get name of the timesheet file for an employee and for a particular week
Function getTimesheetName(empid As Integer, weekOffset As Integer) As String
' 0 for this week
' -1 for last week
' -2 for last to last week

 d = getMonday(weekOffset)
 getTimesheetName = Format(empid, "0###")
 getTimesheetName = getTimesheetName & "_" & Format(Year(d))
 getTimesheetName = getTimesheetName & "_" & Format(Month(d), "0#")
 getTimesheetName = getTimesheetName & "_" & Format(Day(d), "0#")
 getTimesheetName = getTimesheetName & "_timesheet.xlsx"
End Function
</pre>

<pre>
'get date for the monday of this week, of last week, or last to last week
' can be further enhanced to seek any week backward or in future
Function getMonday(offset As Integer) As Date
If (weekOffset = 0) Then
    getMonday = Now() - Weekday(Now(), 3)
ElseIf (weekOffset = -1) Then
    getMonday = Now() - Weekday(Now(), 3) - 7
ElseIf (weekOffset = -2) Then
    getMonday = Now() - Weekday(Now(), 3) - 14
End If
getMonday = DateValue(Format(getMonday, "dd/mm/yyyy"))
End Function
</pre>

#Individual Timesheets (IT)
Individual timesheets need to have following information

* Starting date
* Days of the week
* Employee Id
* Project Id
* Task (optional - rather leave it, why complicate)
* Hours Spent

File name itself shall suggest the date of the timesheet and also the employee id. Latter value is maintained inside the sheet, though it does not change.

There is no automation required within this sheet. It just provides information to be collated by someone else.

![individual timesheet](/images/ts.jpg)

#Integrated Timesheet
Integrated timesheet (ITS) has two sheets to work through. 

* Database of each entries available through individual timesheets - (db)
* Tracking sheet to capture who has submitted, how many hours, in total (required to do followup for those who have not filled it yet) - (timesheet_tracking)

![integrated timesheet db](/images/ts_db.jpg)

##Macro and it's explanation
Iterate through every cell of individual and each date, if the cells in tracking sheet is already updated, than do not fetch / update value in "DB"

Look through configuration (cfg) sheet, for each team member timesheet path and open timesheet path for current week. Get date of monday for current week. If available, iterate through each cell of this timesheet and create an entry into db for non-zero and non-blank cells. Also add to the timesheet_tracking sheet.

There is an option to extend it's functionality to fetch information from last-n weeks.

<pre>
Sub importTimesheet(ts As Worksheet, emp As Integer, dt As Date)
Dim addr As Range, addr2 As Range, li As Range, ndt As Date, hrs As Double
Set li = shtTIDb.Range("A1:A10000").Find("Last Import")
Set addr = shtTIDb.Range(shtTIDb.Cells(li.Row() + 1, 1), shtTIDb.Cells(li.Row() + 40000, 1)).Find("")
Set addr2 = ts.Range("A1:A10000").Find("#")
rowIdx = addr.Row()
If (Not addr Is Nothing) Then
 For Each prj In ts.Range(ts.Cells(addr2.offset(1, 3).Row(), 3), ts.Cells(addr2.offset(1, 3).Row() + 10000, 3))
  If (prj = "") Then Exit For
  tp = prj.offset(0, -1).Value
  For Each dy In ts.Range(ts.Cells(prj.Row(), 4), ts.Cells(prj.Row(), 10))
    If (dy.Value <> 0 And dy.Value <> "") Then
        ndt = DateValue(Format(dt, "dd/mm/yyyy")) + dy.Column() - 4
        hrs = dy.Value
        shtTIDb.Cells(rowIdx, 1).Value = ndt
        shtTIDb.Cells(rowIdx, 2).Value = emp
        shtTIDb.Cells(rowIdx, 3).Value = prj.Value
        shtTIDb.Cells(rowIdx, 4).Value = hrs
        ab = updateHoursToTracking(ndt, emp, hrs)
        rowIdx = rowIdx + 1
    End If
  Next dy
 Next prj
End If
li.offset(0, 1).Value = Now()
End Sub
</pre>

Here is the main code that triggers all. This is the macro which is assigned to the button.
<pre>
Dim dt As Date, emp As Integer
Dim addr As Range, wbkTs As Workbook, shtTs As Worksheet

initTsImport

Set addr = shtTICfg.Range("C3:C1000").Find("Employee Timesheets")

For Each ts In shtTICfg.Range(shtTICfg.Cells(addr.Row() + 1, 3), shtTICfg.Cells(addr.Row() + 1000, 3))
 If (ts = "") Then Exit For
 shtName = getTimesheetName(ts.Value, 0)
 dt = getMonday(0)
 On Error GoTo error_opening
    If (Not isTimesheetFilled(ts.Value, dt)) Then
     If Dir(ts.offset(0, 2) & shtName) <> "" Then
        Set wbkTs = Workbooks.Open(ts.offset(0, 2) & shtName, True)
        Set shtTs = wbkTs.Worksheets("timesheet")
        importTimesheet ts:=shtTs, emp:=ts.Value, dt:=dt
        wbkTs.Close
      Else
        MsgBox ("File not found: " & ts.offset(0, 2) & shtName)
      End If
    End If
    
    GoTo continue
error_opening:
    MsgBox ("Error in opening file" & Err.Number & " " & Err.Description)
continue:

Next ts

End Sub
</pre>

#Timesheet Tracking(TS)
TS helps to ensure timely submission of timesheets and also have birds eye-view on who is working and how much.
A blank cells implies that the timesheet for that particular cell is not yet filled up.

![timesheet tracking](/images/ts_tracking.jpg)

<pre>
'check if the timesheet for the week is filled
Function isTimesheetFilled(emp As Integer, dt As Date) As Boolean
Dim shtTracking As Worksheet, addr As Range, addr2 As Range
Set shtTracking = wbkTI.Worksheets("timesheet_tracking")
Set addr = shtTracking.Range("A2:A1000").Find(dt)
Set addr2 = shtTracking.Range("A2:A1000").Find("Date")
Set addr2 = shtTracking.Range(shtTracking.Cells(addr2.Row(), 2), shtTracking.Cells(addr2.Row(), 100)).Find(emp)
isTimesheetFilled = False
If ((Not addr2 Is Nothing) And (Not addr Is Nothing)) Then
 If (shtTracking.Cells(addr.Row(), addr2.Column()).Value <> "") Then
   isTimesheetFilled = True
 End If
End If
End Function

</pre>

<pre>
Function updateHoursToTracking(dt As Date, emp As Integer, hrs As Double) As Double
Dim shtTracking As Worksheet, addr As Range, addr2 As Range
Set shtTracking = wbkTI.Worksheets("timesheet_tracking")
Set addr = shtTracking.Range("A2:A1000").Find(dt)
Set addr2 = shtTracking.Range("A2:A1000").Find("Date")
Set addr2 = shtTracking.Range(shtTracking.Cells(addr2.Row(), 2), shtTracking.Cells(addr2.Row(), 100)).Find(emp)
If ((Not addr2 Is Nothing) And (Not addr Is Nothing)) Then
    If (shtTracking.Cells(addr.Row(), addr2.Column()).Formula = "") Then
    shtTracking.Cells(addr.Row(), addr2.Column()).Formula = "=" & hrs
    Else
    shtTracking.Cells(addr.Row(), addr2.Column()).Formula = shtTracking.Cells(addr.Row(), addr2.Column()).Formula & "+" & hrs
    End If
End If
End Function
</pre>

#Applications / Extensions
This is a small implementation of what goes in the mind of manager who is concerned about recording time spent on different project / activities by team members. For individuals, it is easy to fill and enables them to maintain records which they can always refer back.

Having done this, one can easily calculate hours spent on every project, link it with salaries of individuals and arrive at costs incurred on project. Salaries being the bigges component of an organization, gets accounted for appropriately, converting indirect costs into direct costs, without the need of SAP.

<a href="mailto:info@dakinegroup.com">Write to us for source</a>