

   MEMBER('')                             ! This is a MEMBER module



Hour                 PROCEDURE  (irxHour,sxTnnHourFormat,sxSuffix) ! Declare Procedure
!! Procedure Equates Declaration for: HourEquates
Hour:eHeure                EQUATE(360000)
Hour:eMinute               EQUATE(6000)
Hour:eSeconde              EQUATE(1)
Hour:eCentSec              EQUATE(1)
Hour:eT1HourFormat         EQUATE('@T1')
Hour:eT2HourFormat         EQUATE('@T2')
Hour:eT3HourFormat         EQUATE('@T3')
Hour:eT4HourFormat         EQUATE('@T4')
Hour:eT5HourFormat         EQUATE('@T5')
Hour:eNoValue              EQUATE('Missing Parameter')
Hour:eNoValueA             EQUATE('Paramètre manquant')

!! Procedure Group Declaration for: HourIncoming
HourIncoming         GROUP,PRE(HourSav),BINDABLE,THREAD
irHeure                     REAL
irMinute                    REAL
irSeconde                   REAL
irCentSec                   REAL
                     END
!! Procedure Group Declaration for: HourProcess
HourProcess          GROUP,PRE(HourTim),BINDABLE,THREAD
irHour                      REAL
s4TnnHourFormat             STRING(4)
s1Suffix                    STRING(1)
s80Hour                     STRING(80)
                     END
!! Procedure Group Declaration for: HourReturn
HourReturn           GROUP,PRE(HourRet),BINDABLE,THREAD
irHeure                     REAL
irMinute                    REAL
irSeconde                   REAL
irCentSec                   REAL
                     END
!===== Hour Documentation =====


        OMIT('!*HourDocumentation*!')
___________________________________________________________________________________________
============================================Hour===========================================
___________________________________________________________________________________________


   Purpose : The Hour function converts a NUMERIC value into a string according to
             a time picture format within the range of hundred of a seconds to number of
             years.

   Program : Universal Module

    Module : Hour.cla
       Map : Hour function within Hour.cla module

         MAP
           MODULE('Hour.clw')
Hour     FUNCTION(<REAL>,<STRING>,<STRING>),STRING

         . .

Function  : Hour(irxHour,sxTnnHourFormat,sxSuffix)
Hour      FUNCTION((irxHour,sxTnnHourFormat,sxSuffix)
ilxHour             ! Time in 100th of a second
sxTnnHourFormat     ! Time Format between '@t1' and '@t20'
sxSuffix            ! Time Suffix unit separator 10h15

     Where
         ilxHour
           The Computed Time is the processed time value. The parameter is a NUMERIC
           value. Can Not be OMITTED
         sxTnnHourFormat
           The Time Format will return one of the available picture format. The
           parameter is a string of one of the available picture token. It must be
           quoted '@tn' or assign to a variable or assign as an equate label.
           This parameter can be OMITTED
           '@tn' Time format n where

   Y=Year     Token   Time Format           Examples              Time Unit        String
   M=Mon h            YearMthWk Dyhr minseccent Y  O  W  D h  m s c                Length
   W=Week     Pos =   1   2  3  4 5  6  7  8    1  2  3  4 5  6 7 8     YMWDhmsc   Sht /Lng
   D=Day     ______________________________________________________________________________
   h=Hour     '@t1'         .....hhhhhh:mm               10h15              hm       5  22
   m=Minute   '@t2'   .....hhhhhhmm                     1015                hm       4   4
   s=Second   '@t3'   .....hhhhhh:mmxm                   10h15Am/Pm         hm-ampm  7   7
   c=Hundred  '@t4'   .....hhhhhh:mm:ss                  10h15m35           hms      8  33
              '@t5'   ......hhhhh:mm:ss:cc             2310h15m36s85        hmsc    11  44

         TimeSuffix
           The Time Suffix, is the component that identify the time suffix
           unit.  The time unit is Year, Month, Week, Day, Hour, Minute,
           Second and Hundred of a Second or Y,M,W,D,h,m, s & c or any signs.
           The parameter must be any letter, or any character. There's only two
           types of a suffix that has some specific interpretation.
           1st. The ~ sign identify the short suffix unit of the time:
            (00h00m00s000c) English format
            (00h00m00s000c) French format
           2nd. The $ sign identify the long suffix unit of the time :
           (00 hour 00 minute 00 second 000)
           (00 heure 00 minute 00 seconde 000)
           Look the table below to see some more examples of time format
           '@tnX' Time Suffix X where = between A and Z, or any
                           character like (-,./=\ etc...)
           ___________________________________________________________
             Token XSuffix    Time Format     Example
           ___________________________________________________________
             '@tn'    )             hh)mm,      10)15
             '@tn'    %       YY%OO%hh%mm%ss%cc%  01%01%10%15%35%68%
             '@tn'    !          OO!hh!mm        12!10!15
             '@tn'    -             hh-mm       10-15
             '@tn'    .             hh.mm       10.15
             '@tn'    /             hh/mm/ss/cc     10/15/35/68
             '@tn'    :             hh:mm       10:15
             '@tn'    ;             hh;mm       10;15
             '@tn'    =             hh=mm=ss=cc     10=15=35=68
             '@tn'    \             hh\mm\ss\cc     10\15\35\68
             '@tn'    A             hhAmmAssAcc     10A15
             '@tn'    B             hhBmmBssBcc     10B15
           __________________________________________________________
           This parameter can be OMITTED


     What to use
           Any type of procedure. It could be used within a MENU, TABLE
           FORM, REPORT, BATCH PROCESSED, or OTHER type of procedure.
     When to use
           When you have a report where you count the number of days
           hours, minutes, seconds and hundreds of a second.
           When you want to count the elapse time in a project.
           When you want to count the time in a project.
           When you want to count the elapse time of a task.
           When you want to count the time of a task.
           When you want to use a chronometer.
     Where to use
           Within a CASE FIELD, EDIT ROUTINE and DISPLAY FIELD.
           Within a LOOP where you count the time.
           Within a FUNCTION where you count two different time.
     Why to use
           The purpose of this function is to provide the Clarion
           programmer more ways to format the time. Since the Clarion
           library doesn't support Days or number of hours in thousands,
           or hundreds of seconds or years.
     How to use
           Used as a function call
           StringVariable = Hour(TimeComputed,TimeFormat,TimeSuffix)

           CODE
           begTime = CLOCK()
           LOOP
             endTime = CLOCK()
             cTime = endTime - begTime + 1
             Pre:sTime = Hour(cTime,'@t1','!')
             Pre:sTime = Hour(cTime) ! Use the internal default format
           END

           The above procedure will count the elapse time between the
           beginning and the current time.
           Hour function will convert the cTime long value into a string
           according to the picture format '@t1' and '!'.  There's no predefined
           language used.
           Result:
              22!15

      How to use External Suffix
           Used as a function call
           StringVariable = Hour(TimeComputed,TimeFormat,TimeSuffix)
                     
           Steps
             1. Define a group with each format item of the language
             2. Define an a array over the group
             3. Call Time function with the array[]

         PROGAM

           CODE
           begTime = CLOCK()
           LOOP
             endTime = CLOCK()
             cTime = endTime - begTime + 1
             Pre:sTime = Hour(cTime,'@t1','$')
             Pre:sTime = Hour(cTime) ! Use the internal default format
           END

           The above program will count the elapse time between the
           beginning and the current time.
           Hour function will convert the cTime long value into a string
           according to the picture format '@t1' and '$' which is equal to
           to predefined language format within the external array.
           Result:
            12 h 2 m 33 s 22 c

      How to use External Message
           Used as a function call
           StringVariable = Hour(TimeComputed,TimeFormat,TimeSuffix)
                     
           Steps
             1. Define a group with each format item of the language
             2. Define an a array over the group
             3. Call Hour function with the array[]
         PROGAM
       CODE
       begTime = CLOCK()
       LOOP
          endTime = CLOCK()
          Pre:sTime = Hour(EndTime - BegTime,'@t1','$')
          mTemps = Hour(CLOCK())
          mTemps = Hour(EndTime,s4TnnFormat,s1Separator)
          mTemps = Hour(EndTime,s4TnnFormat,s1Separator)
          mTemps = Hour(Tem:irTemps,s4TnnFormat,s1Separator)
          mTemps = Hour(EndTime,s4TnnFormat,s1Separator)
          mTemps = Hour(EndTime,s4TnnFormat,s1Separator)
          mTemps = Hour(CLOCK(),s4TnnFormat,s1Separator)
       END
           The above procedure will count the elapse time between the
           beginning and the current time.
           Hour function will convert the cTime long value into a string
           according to the picture format '@t1' and '$' which is equal to
           predifined language format within the external array.

           Result:
             12 h 2 m 33 s 22 c
___________________________________________________________________________________________
======================================Hour==============================================P:8
___________________________________________________________________________________________
     Compiler    : Clarion v2.1 release 2108                             
  Environment    : Called as a function                                 
   References    : Clarion reference, Chapter 13, DATE(), CLOCK(), TODAY(), AGE(), YEAR(),    
                          MONTH()                     
      Version    : 1.0                                         
 Created Date    : 92/1/1                                     
 Modified Date   : 92/1/2,92/1/3,92/1/4,92/1/5,92/1/11,92/1/12,94/3/10,94/3/11,94/3/12,03/03/01
    Published    : None                                         
     Notice      : None
     Author      : Robert Gaudreau,
                   205 Bégon
                   Auteuil, Qc, H7H 2A4
___________________________________________________________________________________________
!*HourDocumentation*!
  CODE
!===== Hour Function Code Section =====
  IF OMITTED(1) THEN                              ! IF The Hour is
    HourTim:irHour = CLOCK()
  ELSE
    HourTim:irHour  = irxHour                     ! Get the Hour in hundred of second
  .
  !      Check the Hour format
  IF OMITTED(2) THEN
    HourTim:s4TnnHourFormat = Hour:eT4HourFormat  ! Get default Hour format
  ELSE
    HourTim:s4TnnHourFormat = UPPER(sxTnnHourFormat)! Get the Hour format
  .
  !      Get the type of Hour format
  IF OMITTED(3) THEN
    HourTim:s1Suffix = '~'                        ! If the suffix is omitted then use ":"
  ELSE
    HourTim:s1Suffix = sxSuffix                   ! Assign the suffix format
  .
  !      Get the amount of Hour according to the variable
  HourSav:irHeure      = INT( HourTim:irHour / Hour:eHeure      )          ! ROUND number of hours
  HourSav:irMinute     = INT( HourTim:irHour / Hour:eMinute     )          ! ROUND number of minutes
  HourSav:irSeconde    = INT( HourTim:irHour / Hour:eSeconde    )          ! ROUND number of seconds
  HourSav:irCentSec    = INT( HourTim:irHour / Hour:eCentSec    )          ! Get number of hundred/seconds
  !      Get the Hour and convert according to the Hour unit
  HourRet:irHeure      = HourSav:irHeure                  ! Return Hour
  HourRet:irMinute     = HourSav:irMinute  - ( HourSav:irHeure   * 60  )  ! Return Minute
  HourRet:irSeconde    = HourSav:irSeconde - ( HourSav:irMinute  * 60  )  ! Return Second
  HourRet:irCentSec    = HourSav:irCentSec - ( HourSav:irSeconde * 100 )  ! Return Hundred of second
  HourTim:s80Hour = ''

  !      Format the return Hour
  CASE HourTim:s4TnnHourFormat                        ! Which Hour unit is formatted
  OF Hour:eT1HourFormat
     IF HourTim:s1Suffix = '~'
       HourTim:s80Hour = HourRet:irHeure & 'h' & CLIP(HourRet:irMinute) & 'm'
     ELSE
       HourTim:s80Hour = HourRet:irHeure & HourTim:s1Suffix & CLIP(HourRet:irMinute)
     .
  OF Hour:eT2HourFormat
     HourTim:s80Hour = HourRet:irHeure & CLIP(HourRet:irMinute)
  OF Hour:eT3HourFormat
     HourTim:s80Hour = FORMAT(HourTim:irHour,@T3)
  OF Hour:eT4HourFormat
     IF HourTim:s1Suffix = '~'
       HourTim:s80Hour = HourRet:irHeure & 'h' & CLIP(HourRet:irMinute) & 'm' & |
            CLIP(HourRet:irSeconde) & 's'
     ELSE
       HourTim:s80Hour = HourRet:irHeure & HourTim:s1Suffix & CLIP(HourRet:irMinute) & HourTim:s1Suffix & |
            CLIP(HourRet:irSeconde)
     .
  OF Hour:eT5HourFormat
     IF HourTim:s1Suffix = '~'
       HourTim:s80Hour = HourRet:irHeure & 'h' & CLIP(HourRet:irMinute) & 'm' & |
             CLIP(HourRet:irSeconde) & 's' & CLIP(HourRet:irCentSec)
     ELSE
       HourTim:s80Hour = HourRet:irHeure & HourTim:s1Suffix & CLIP(HourRet:irMinute) & HourTim:s1Suffix & |
             CLIP(HourRet:irSeconde) & HourTim:s1Suffix & CLIP(HourRet:irCentSec)
     .
  ELSE
      HourTim:s80Hour = 'Reformat'
  END
  RETURN(HourTim:s80Hour)                         ! Return Hour according picture format

