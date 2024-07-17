

   MEMBER('')                             ! This is a MEMBER module

!                     MAP
!ShowTime               PROCEDURE(<REAL>,<STRING>,<STRING>,<*STRING[,]>,<*STRING[,]>),STRING
!                     END


ShowTime             PROCEDURE  (ilxTime,sxTnnShowTimeFormat,sxSuffix,dxSuffix,dxMessage) ! Declare Procedure
!! Procedure Equates Declaration for: TimeEquates
TimeEqu:eAnneeJulien       EQUATE(3110400000)
TimeEqu:eAnnee             EQUATE(3153600000)
TimeEqu:eMois              EQUATE(241920000)
TimeEqu:eSemaine           EQUATE(60480000)
TimeEqu:eHeure             EQUATE(360000)
TimeEqu:eJour              EQUATE(8640000)
TimeEqu:eMinute            EQUATE(6000)
TimeEqu:eSeconde           EQUATE(1)
TimeEqu:eCentSec           EQUATE(1)
TimeEqu:e3PnPictureFormat  EQUATE(@P###P)
TimeEqu:e2PnPictureFormat  EQUATE(@P##P)
TimeEqu:e1PnPictureFormat  EQUATE(@P#P)
TimeEqu:eMessage1          EQUATE(3)
TimeEqu:eMessage2          EQUATE(4)
TimeEqu:eMessage3          EQUATE(5)
TimeEqu:eEnglish           EQUATE(1)
TimeEqu:eFrench            EQUATE(2)

!! Procedure Group Declaration for: TimeIncoming
TimeIncoming         GROUP,PRE(TimeSav),BINDABLE,THREAD
irAnneeJulien               REAL
irAnnee                     REAL
irMois                      REAL
irSemaine                   REAL
irJour                      REAL
irHeure                     REAL
irMinute                    REAL
irSeconde                   REAL
irCentSec                   REAL
                     END
!! Procedure Group Declaration for: TimeProcess
TimeProcess          GROUP,PRE(TimeTim),BINDABLE,THREAD
irTime                      REAL
ibLanguage                  BYTE
s1ShortFormat               STRING(1)
s1LongFormat                STRING(1)
s4TnnShowTimeFormat         STRING(4)
ibTimeFormat                BYTE
ibDefini                    STRING(20)
ibDebut                     BYTE
ibFin                       BYTE
ibPos                       BYTE
ibResultat                  BYTE
s1Suffix                    STRING(1)
s25Annee                    STRING(25)
s25Mois                     STRING(25)
s25Semaine                  STRING(25)
s25Jour                     STRING(25)
s25Heure                    STRING(20)
s25Minute                   STRING(25)
s25Seconde                  STRING(25)
s25CentSec                  STRING(25)
s80Time                     STRING(80)
s1Espace                    STRING(1)
                     END
!! Procedure Group Declaration for: TimeReturn
TimeReturn           GROUP,PRE(TimeRet),BINDABLE,THREAD
irAnneeJulien               REAL
irAnnee                     REAL
irMois                      REAL
irSemaine                   REAL
irJour                      REAL
irHeure                     REAL
irMinute                    REAL
irSeconde                   REAL
irCentSec                   REAL
                     END
!===== Time Function Declaration =====

!===== Time Format parameter =====

gTimeFormat   GROUP             ! List of Picture Token
    STRING('@T1 @T2 @T3 @T4 @T5 @T6 @T7 @T8 @T9 @T10')
    STRING('@T11@T12@T13@T14@T15@T16@T17@T18@T19@T20')
    STRING('@T21@T22@T23@T24@T25@T26@T27@T28@T29@T30')
    STRING('@T31@T32@T33@T34@T35@T36@T37@T38@T39@T40')
    STRING('@T41@T42@T43@T44')
              END

s4TimeFormat  STRING(4),DIM(44),OVER(gTimeFormat)! Adress of the Picture Token

    OMIT('!*=TimeFormatDefinition=*!')
 =============================== START AND END POSITION OF TIME =============================
  IF the Time Format equal to "@T40" then the START position is 1 and the END position is
  4.  It means that the first position of the time is the YEAR and the last position of the
  time is the DAY.
!*=TimeFormatDefinition=*!
                ! Start position of @T1 = 5
                 ! End position of @T1  = 6
                  ! Start position of @T2 = 5
                   ! End position of @T2  = 6
                          ! Start position of @T6 = 6
                           ! End position of @T6  = 7
gDebutFin   GROUP           ! Start and end position of the Time
        STRING('56565657586768784546')
        STRING('47483435363738232425')
        STRING('26272812131415161718')
        STRING('11223344556677881114')
        STRING('15161718')        !End position of @T40 picture time format
            END             !Start position of @T40 picture time format

s1DebutFin  STRING(1)DIM(88),OVER(gDebutFin)     ! Position adress

!===== Suffix of time =====

gSuffix     GROUP                ! Suffix format
   !Pos    1      2  3  4      5      6      7      8
   STRING('Y      M      W      D      h      m      s      c      ') ! English short format
   STRING('Year   Month  Week   Day    hour   minute second cen    ') ! English long format
   STRING('Missing Parameter                                       ') ! 1st Message
   STRING('Wrong Format                                            ') ! 2nd Message
   STRING('Reformat                                                ') ! 3rd Message
   STRING('A      M      S      J      h      m      s      c      ') ! French short format
   STRING('Anné  Mois   SemaineJour   heure  minute secondecen     ') ! French long format
   STRING('Paramètre Manquant                                      ') ! 1st Message
   STRING('Mauvais Format                                          ') ! 2nd Message
   STRING('Reformater                                              ') ! 3rd Message
          .
s7Suffix      STRING(7),DIM(2,40),OVER(gSuffix)  ! Get the time suffix from gSuffix
ibTimeSuffix  BYTE               ! From which unit to start

siMessage     STRING(56),DIM(2,5),OVER(gSuffix)

!===== ShowTime Documentation =====


        OMIT('!*ShowTimeDocumentation*!')
___________________________________________________________________________________________
============================================ShowTime===========================================
___________________________________________________________________________________________


   Purpose : The ShowTime function converts a NUMERIC value into a string according to
             a time picture format within the range of hundred of a seconds to number of
             years.

   Program : Universal Module

    Module : ShowTime.clw
       Map : ShowTime function within ShowTime.clw module

         MAP
           MODULE('ShowTime.clw')
ShowTime     FUNCTION(REAL,<STRING>,<STRING>,<*STRING[,]>,<*STRING[,]>),STRING
         . .

Function  : ShowTime(TimeComputed,TimeFormat,TimeSuffix,TimeLanguage,ExternalSuffixArray,|
              ExternalMessageArray)

ShowTime      FUNCTION(ilxTime,sxTnn,sxSuffix,Tim:ibLangue,dxSuffix,dxMessage)
ilxTime     ! Time in 100th of a second
sxTnn       ! Time Format between '@t1' and '@t20'
sxSuffix    ! Time Suffix unit 10h15
dxSuffix    ! External time suffix array
dxMessage   ! External error message

     Where
         TimeComputed
           The Computed Time is the processed time value. The parameter is a NUMERIC
           value. Can Not be OMITTED
         TimeFormat
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
              '@t6'   .........mmmmm:ss                   3215m35            ms      5  22
              '@t7'   .........mmmmm:ss:cc                2315m33s75         msc     8  33
              '@t8'   ............sssss:cc                  23335s56          sc     5  22
              '@t9'   .....DDDDDD:hh                3233D10h                h        5  22
              '@t10'  .....DDDDDD:hh:mm             3233D10h15m             hm       8  33
              '@t11'  .....DDDDDD:hh:mm:ss          5050D10h15m35s          hms     11  44
              '@t12'  .....DDDDDD:hh:mm:ss:cc       5050D10h15m35s68       Dhmsc    14  55
              '@t13'  ...WWWWWW:D                 1222W3D                 WD         5  22
              '@t14'  ...WWWWWW:D:hh              1222W3D10h              WDh        8  33
              '@t15'  ...WWWWWW:D:hh:mm           3122W3D10h15m           WDhm      11  44
              '@t16'  ...WWWWWW:D:hh:mm:ss        3422W0D10h15m35s        WDhms     14  55
              '@t17'  ...WWWWWW:D:hh:mm:ss:cc     6322W0D10h15m35s68      WDhmsc    17  66
              '@t18'  ..MMMM:WW                 122M22W                   W          5  22
              '@t19'  ..MMMM:WW:D               122M22W3D                MWD         8  33
              '@t20'  ..MMMM:WW:D:hh            122M22W3D10h             MWDh       11  44
              '@t21'  ..MMMM:WW:D:hh:mm         312M22W3D10h15m          MWDhm      14  55
              '@t22'  ..MMMM:WW:D:hh:mm:ss      342M22W0D10h15m35s       MWDhms     17  66
              '@t23'  ..MMMM:WW:D:hh:mm:ss:cc  2632M22W0D10h15m35s68     MWDhmsc    20  77
              '@t24'  YYY:MM                 822Y23M                    YM           5  22
              '@t25'  YYY:MM:WW              822Y23M22W                 YMW          8  33
              '@t26'  YYY:MM:WW:D            822Y23M22W1D               YMWD        11  44
              '@t27'  YYY:MM:WW:D:hh         822Y23M22W1D23h            YMWDh       14  55
              '@t28'  YYY:MM:WW:D:hh:mm      822Y23M22W1D23h23m         YMWDhm      17  66
              '@t29'  YYY:MM:WW:D:hh:mm:ss   822Y23M22W1D23h23m34s      YMWDhms     20  77
              '@t30'  YYY:MM:WW:D:hh:mm:ss:cc822Y23M22W1D23h23m34s99    YMWDhmsc    23  88
              '@t31'  YYY                   8222                    Year             2  11
              '@t32'  ..MMMM                  23478                  Month           2  11
              '@t33'  .....WWWW                   2332                Week           2  11
              '@t34'  .....DDDDDD                   3222               Day           2  11
              '@t35'      ......hhhhh                  1002             hour         2  11
              '@t36'      .........mmmm                   2332           minute      2  11
              '@t37'      .............ssss               1023322         second     2  11
              '@t38'      .............ccccccc              12233306       hundred   2  11
              '@t39'  ..YYYYY                   23822                  Julian Year   2  11
              '@t40'  ..YYYYY:DDD          23822Y322D                   YD           5  22
              '@t41'  ..YYYYY:DDD:hh       23822Y331D23h                YDh          8  33
              '@t42'  ..YYYYY:DDD:hh:mm    23822Y221D23h32m             YDhm        11  44
              '@t43'  ..YYYYY:DDD:hh:mm:ss 23822Y121D23h23m34s          YDhms       14  55
              '@t44'  ..YYYYY:DDD:hh:mm:ss:cc822Y021D23h23m34s32        YDhmsc      17  66

         TimeSuffix
           The Time Suffix, is the component that identify the time suffix
           unit.  The time unit is Year, Month, Week, Day, Hour, Minute,
           Second and Hundred of a Second or Y,M,W,D,h,m, s & c or any signs.
           The parameter must be any letter, or any character. There's only two
           types of a suffix that has some specific interpretation.
           1st. The ~ sign identify the short suffix unit of the time:
            (0000Y00M00W000D00h00m00s000c) English format
            (0000A00M00S000J00h00m00s000c) French format
           2nd. The $ sign identify the long suffix unit of the time :
           (000 Year 00 Month 00 Week 0 Day 00 hour 00 minute 00 second 000)
           (000 Année 00 Mois 000 Semaine 0 Jour 00 heure 00 minute 00 seconde 000)
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

         TimeLanguage
           The Time Language will display a "J" for Jour in French and a letter "D"
           for Day in English. You must past a value of 2 for the French format
           or a 1 for the English format. The parameter is a value between 1 and 255.
           Here's the different format.  If the external time array is passed
           then the external group array will be used.  This gives the possibility
           to write your own suffix. In this case the value passed as 1 will be
           your definition of the suffix. See also ExternalSuffix
           English  Y      M      W  D  h      m      s      c
                Year   Month  Week   Day    hour   minute second cen
           French   A      M      S  J  h      m      s      c
                Année  Mois   SemaineJour   heure  minute secondecen
           This parameter can be OMITTED

          ExternalSuffixArray
           The External Suffix array is a user defined suffix format.
           It may be used in any language format; French, German, Spanish or
           other.  The parameter must be a 2 dimensional array. The
           received string suffix is a 25 characters long.  This is important
           for the string value of each item within the group dimension to be no
           longer than 25. You must past only the dimension array.  Make sure you
           have 8 suffix unit from hundred of second to year for each string within
           the string group.  To understand how to implement this feature within
           your application look "How to use External Suffix" on page 6.
           If this parameter is omitted the default will be the French or English
           format defined internally in the ShowTime function.
           This parameter can be OMITTED

         ExternalMessageArray
           The External Message array is a user defined Message.
           It may be used in any language format; French, German, Spanish or
           other. The parameter must be the same 2 dimensional array. The
           received string Message is a 200 characters long or the size of the
           string of the array defined by the user. This is important
           for the string value of each message within the group dimension to be no
           longer than the String Array. You must past only the dimension array.
           Make sure you have the 3 defined internal message.
              1st is: Missing Parameter
              2nd is: Wrong Format
              3rd is: Reformat
           To understand how to implement this feature within
           your application look "How to use External Message" on page 7.
           If this parameter is omitted the default will be the French or English
           format defined internally in the ShowTime function.
           This parameter can be OMITTED

         Note about Julian Year
           The Julian Year format from picture token @t39 through @t44 is
           now active.

         Note about performance of the function
           The speed ratio of ShowTime function is around 1/5 of a second or 20/100th
           second.  Look at the data of the examples you'll see the diffirence
           between record in hundred of seconds.
           The speed ratio of HOUR function is around 1/20 of a second or 5/100th
           second.
           We have to consider the change of the speed ratio cause by the computer
           and the I/O of the data to the file.
           If you want speed use HOUR function and if you want versatility and
           flexibility use ShowTime function.

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
           StringVariable = ShowTime(TimeComputed,TimeFormat,TimeSuffix,TimeLanguage)

           CODE
           begTime = CLOCK()
           LOOP
             endTime = CLOCK()
             cTime = endTime - begTime + 1
             Pre:sTime = ShowTime(cTime,'@t1','!',1)
             Pre:sTime = ShowTime(cTime) ! Use the internal default format
           END

           The above procedure will count the elapse time between the
           beginning and the current time.
           ShowTime function will convert the cTime long value into a string
           according to the picture format '@t1' and '!'.  There's no predefined
           language used.
           Result:
              22!15

      How to use External Suffix
           Used as a function call
           StringVariable = ShowTime(TimeComputed,TimeFormat,TimeSuffix,|
                     TimeLanguage,ExternalSuffix)
           Steps
             1. Define a group with each format item of the language
             2. Define an a array over the group
             3. Call Time function with the array[]

         PROGAM

gLangSuffix GROUP              ! Suffix format
        !Pos    1   2   3   4   5   6   7   8
        STRING('Y       M       W       D       h       m       s       c       ')
        STRING('Yr      Mth     Wk      Dy      hour    minute  second  cen     ')
        STRING('A       M       S       J       h       m       s       c       ')
        STRING('An      Ms      Semaine Jr      heure   minute  seconde cen     ')
        STRING('A       M       S       J       h       m       s       c       ')
        STRING('An      Ms      Sem     Jr      heure   minute  seconde cen     ')
          .
ds8Suffix   STRING(8),DIM(3,16),OVER(gSuffix)  ! Get the time suffix from gSuffix

           CODE
           begTime = CLOCK()
           LOOP
             endTime = CLOCK()
             cTime = endTime - begTime + 1
             Pre:sTime = ShowTime(cTime,'@t30','$',3,ds8Suffix[])
             Pre:sTime = ShowTime(cTime) ! Use the internal default format
           END

           The above program will count the elapse time between the
           beginning and the current time.
           ShowTime function will convert the cTime long value into a string
           according to the picture format '@t30' and '$' which is equal to
           to predefined language format within the external array.
           Result:
            23 An 23 Ms 2 Sem 3 Jr 12 heure 2 minute 33 seconde 22 cen

      How to use External Message
           Used as a function call
           StringVariable = ShowTime(TimeComputed,TimeFormat,TimeSuffix,|
                     TimeLanguage,ExternalSuffix,ExternalMessage)
           Steps
             1. Define a group with each format item of the language
             2. Define an a array over the group
             3. Call ShowTime function with the array[]
         PROGAM
gLangSuffix GROUP              ! Suffix format
      !Pos    1       2       3       4       5       6       7       8
      STRING('Y       M       W       D       h       m       s       c       ')
      STRING('Yr      Mth     Wk      Dy      hour    minute  second  cen     ')
      STRING('Missing Parameter                                               ')
      STRING('Wrong Format                                                    ')
      STRING('Reformat                                                        ')
      STRING('A       M       S       J       h       m       s       c       ')
      STRING('An      Ms      Semaine Jr      heure   minute  seconde cen     ')
      STRING('Paramètre Manquant                                              ')
      STRING('Mauvais Format                                                  ')
      STRING('Reformater                                                      ')
      STRING('A       M       S       J       h       m       s       c       ')
      STRING('An      Ms      Sem     Jr      heure   minute  seconde cen     ')
      STRING('Parametra manquante                                             ')
      STRING('Mauvais Formata                                                 ')
      STRING('Reformata ect...                                                ')
          .
ds8Suffix   STRING(8),DIM(3,40),OVER(gSuffix)   ! Get the time suffix from gSuffix
dsMessage   STRING(64),DIM(3,5),OVER(gSuffix)   ! Get the ErrorMessage
       CODE
       begTime = CLOCK()
       LOOP
          endTime = CLOCK()
          Pre:sTime = ShowTime(EndTime - BegTime,'@t30','$',3,ds8Suffix[],dsMessage[])
          mTemps = ShowTime(CLOCK())
          mTemps = ShowTime(endTime,s4TnnFormat,s1Separator,ibLangue)
          mTemps = ShowTime(endTime,s4TnnFormat,s1Separator,ibLangue,ds8Suffix[])
          mTemps = ShowTime(Tem:irTemps,s4TnnFormat,s1Separator,ibLangue,ds8Suffix[],dsMessage[])
          mTemps = ShowTime(CLOCK(),s4TnnFormat,s1Separator,ibLangue,ds8Suffix[],dsMessage[])
          mTemps = ShowTime(Tem:irTe,s4TnnFormat,s1Separator,ibLangue,ds8Suffix[],dsMessage[])
          mTemps = ShowTime(CLOCK(),s4TnnFormat,s1Separator,ibLangue,ds8Suffix[],dsMessage[])
       END
           The above procedure will count the elapse time between the
           beginning and the current time.
           ShowTime function will convert the cTime long value into a string
           according to the picture format '@t30' and '$' which is equal to
           predifined language format within the external array.

           Result:
             23 An 23 Ms 2 Sem 3 Jr 12 heure 2 minute 33 seconde 22 cen
___________________________________________________________________________________________
======================================ShowTime==============================================P:8
___________________________________________________________________________________________
     Compiler    : Clarion v2.1 release 2108
     Compiler    : Clarion 5.5 relase h
  Environment    : Called as a function or return value procedure
   References    : Clarion reference, Chapter 13, DATE(), CLOCK(), TODAY(), AGE(), YEAR(),    
                          MONTH()
      Version    : 1.0                                         
 Created Date    : 92/1/1                                     
 Modified Date   : 92/1/2,92/1/3,92/1/4,92/1/5,92/1/11,92/1/12,94/3/10,94/3/11,94/3/12,03/03/01
    Published    : Joliciel
     Notice      : None
     Author      : Robert Gaudreau,
                   205 Bégon
                   Auteuil, Qc, H7H 2A4
___________________________________________________________________________________________
!*ShowTimeDocumentation*!
  CODE
  !===== TIME FUNCTION CODE SECTION =====
  IF TimeTim:ibLanguage = 0 THEN TimeTim:ibLanguage = TimeEqu:eFrench.! If no languge defined assign french
  IF OMITTED(1) THEN                     ! If the numiric value is missing
    IF ~OMITTED(6) THEN
      RETURN(dxMessage[TimeTim:ibLanguage,TimeEqu:eMessage1])  ! Return Message
    ELSE
      RETURN(siMessage[TimeTim:ibLanguage,TimeEqu:eMessage1])  ! Return Message
    .
  ELSE                                   ! Otherwise
    TimeTim:irTime = ilxTime                 !  Get the Time in hundred of second
  .
  !===== Check the time format =====
  IF OMITTED(2) THEN
    TimeTim:s4TnnShowTimeFormat = '@T5'                    !Get the time format
  ELSIF sxTnnShowTimeFormat = ''
    TimeTim:s4TnnShowTimeFormat = '@T5'                    !Get the time format
  ELSE
    TimeTim:s4TnnShowTimeFormat = UPPER(sxTnnShowTimeFormat) !Get the time format
  .
  TimeTim:ibPos   = INSTRING(TimeTim:s4TnnShowTimeFormat,gTimeFormat,1)! Locate the time format position
  IF TimeTim:ibPos = 1 THEN                  ! Ajust when position of 1
    TimeTim:ibPos = 2
  ELSIF TimeTim:ibPos = 2                    ! Ajust when position of 2
    TimeTim:ibPos = 4
  ELSIF TimeTim:ibPos > 2 THEN               ! Calculate the position higher then 2
    TimeTim:ibPos = ((TimeTim:ibPos - ((4-1)*INT(TimeTim:ibPos/4)))*2)
  ELSIF TimeTim:ibPos < 1 OR TimeTim:ibPos > 44      ! Check for wrong format
    IF ~OMITTED(6) THEN
      RETURN(dxMessage[TimeTim:ibLanguage,TimeEqu:eMessage3])  ! Return the external Wrong format message
    ELSE
      RETURN(siMessage[TimeTim:ibLanguage,TimeEqu:eMessage3])  ! Return Wrong Format message
  . .
  TimeTim:ibDebut = s1DebutFin[TimeTim:ibPos-1]  ! Start position of the time format
  TimeTim:ibFin   = s1DebutFin[TimeTim:ibPos]    ! End position of the time format
  !===== Get the type of time format =====
  IF OMITTED(3) THEN
    TimeTim:s1Suffix = ':'                   ! If the suffix is omitted then use ":"
  ELSE
    TimeTim:s1Suffix = sxSuffix              ! Assign external suffix
  .
  CASE TimeTim:s1Suffix                  ! Type of suffix used
  OF TimeTim:s1ShortFormat               ! Define suffix of short format
    ibTimeSuffix = 1                     ! Starting position of the short format
    DO DefTimSuffix                      ! Define Time Suffix
  OF TimeTim:s1LongFormat                    ! Define suffix of long format
    ibTimeSuffix = 9                     ! Starting position of the long format
    DO DefTimSuffix                      ! Define Time Suffix
  ELSE                                   ! One character suffix format
    TimeTim:ibDefini   = 0                   ! This is not the define format
    TimeTim:s25Annee   = TimeTim:s1Suffix        ! Assign a unique suffix format
    TimeTim:s25Mois    = TimeTim:s1Suffix        ! Assign a unique suffix format
    TimeTim:s25Semaine = TimeTim:s1Suffix        ! Assign a unique suffix format
    TimeTim:s25Jour    = TimeTim:s1Suffix        ! Assign a unique suffix format
    TimeTim:s25Heure   = TimeTim:s1Suffix        ! Assign a unique suffix format
    TimeTim:s25Minute  = TimeTim:s1Suffix        ! Assign a unique suffix format
    TimeTim:s25Seconde = TimeTim:s1Suffix        ! Assign a unique suffix format
    TimeTim:s25CentSec = TimeTim:s1Suffix        ! Assign a unique suffix format
    TimeTim:s1Espace   = ''                  ! Remove the space
  .
  !===== Get the amount of time according to the variable =====
  TimeSav:irAnneeJulien = INT( TimeTim:irTime / TimeEqu:eAnneeJulien )        ! ROUND number of Julian Years
  TimeSav:irAnnee      = INT( TimeTim:irTime / TimeEqu:eAnnee      )          ! ROUND number of Years
  TimeSav:irMois       = INT( TimeTim:irTime / TimeEqu:eMois       )          ! ROUND number of Months
  TimeSav:irSemaine    = INT( TimeTim:irTime / TimeEqu:eSemaine    )          ! ROUND number of Weeks
  TimeSav:irJour       = INT( TimeTim:irTime / TimeEqu:eJour       )          ! ROUND number of days
  TimeSav:irHeure      = INT( TimeTim:irTime / TimeEqu:eHeure      )          ! ROUND number of hours
  TimeSav:irMinute     = INT( TimeTim:irTime / TimeEqu:eMinute     )          ! ROUND number of minutes
  TimeSav:irSeconde    = INT( TimeTim:irTime / TimeEqu:eSeconde    )          ! ROUND number of seconds
  TimeSav:irCentSec    = INT( TimeTim:irTime / TimeEqu:eCentSec    )          ! Get number of hundred/seconds
  !===== Get the time and convert according to the time unit =====
  TimeRet:irAnneeJulien = TimeSav:irAnneeJulien                         ! Return Julian Year
  TimeRet:irAnnee      = TimeSav:irAnnee                              ! Return Year
  TimeRet:irMois       = TimeSav:irMois    - ( TimeSav:irAnnee   * 13  )  ! Return Month
  TimeRet:irSemaine    = TimeSav:irSemaine - ( TimeSav:irMois    * 4   )  ! Return Week
  TimeRet:irJour       = TimeSav:irJour    - ( TimeSav:irSemaine * 7   )  ! Return Day
  TimeRet:irHeure      = TimeSav:irHeure   - ( TimeSav:irJour    * 24  )  ! Return Hour
  TimeRet:irMinute     = TimeSav:irMinute  - ( TimeSav:irHeure   * 60  )  ! Return Minute
  TimeRet:irSeconde    = TimeSav:irSeconde - ( TimeSav:irMinute  * 60  )  ! Return Second
  TimeRet:irCentSec    = TimeSav:irCentSec - ( TimeSav:irSeconde * 100 )  ! Return Hundred of second
  TimeTim:s80Time = ''

  !===== Format the return time =====
  LOOP TimeTim:ibResultat = TimeTim:ibDebut TO TimeTim:ibFin              ! Format the time according to the picture token
    CASE TimeTim:ibResultat                                       ! Which time unit is formatted
    OF 1 !===== Format year =====
      IF ~TimeTim:ibDefini THEN IF TimeTim:ibResultat = TimeTim:ibFin THEN TimeTim:s25Annee = ''..
      IF TimeTim:ibPos > 76 THEN             ! Check for Julian Year
    TimeTim:s80Time = TimeRet:irAnneeJulien & CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Annee)
      ELSE
    TimeTim:s80Time = TimeRet:irAnnee & CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Annee)
      .
    OF 2 !===== Format Month =====
      IF ~TimeTim:ibDefini THEN IF TimeTim:ibResultat = TimeTim:ibFin THEN TimeTim:s25Mois = ''..
      IF TimeTim:ibDebut < TimeTim:ibResultat THEN
        TimeTim:s80Time = CLIP(TimeTim:s80Time) & CLIP(TimeTim:s1Espace) & FORMAT(TimeRet:irMois,TimeEqu:e2PnPictureFormat) & |
              CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Mois)
      ELSE
        TimeTim:s80Time = TimeSav:irMois & CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Mois)
      .
    OF 3 !===== Format Week =====
      IF ~TimeTim:ibDefini THEN IF TimeTim:ibResultat = TimeTim:ibFin THEN TimeTim:s25Semaine = ''..
      IF TimeTim:ibDebut < TimeTim:ibResultat THEN
        TimeTim:s80Time = CLIP(TimeTim:s80Time) & CLIP(TimeTim:s1Espace) & FORMAT(TimeRet:irSemaine,TimeEqu:e2PnPictureFormat) & |
              CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Semaine)
      ELSE
        TimeTim:s80Time = TimeSav:irSemaine & CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Semaine)
      .
    OF 4 !===== Format Day =====
      IF ~TimeTim:ibDefini THEN IF TimeTim:ibResultat = TimeTim:ibFin THEN TimeTim:s25Jour = ''..
      IF TimeTim:ibDebut < TimeTim:ibResultat THEN
        TimeTim:s80Time = CLIP(TimeTim:s80Time) & CLIP(TimeTim:s1Espace) & FORMAT(TimeRet:irJour,TimeEqu:e2PnPictureFormat) & |
              CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Jour)
      ELSE
        TimeTim:s80Time = TimeSav:irJour & CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Jour)
      .
    OF 5 !===== Format Hour =====
      IF ~TimeTim:ibDefini THEN IF TimeTim:ibResultat = TimeTim:ibFin THEN TimeTim:s25Heure = ''..
      IF TimeTim:ibDebut < TimeTim:ibResultat THEN
        TimeTim:s80Time = CLIP(TimeTim:s80Time) & CLIP(TimeTim:s1Espace) & FORMAT(TimeRet:irHeure,TimeEqu:e2PnPictureFormat) & |
              CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Heure)
      ELSE
        TimeTim:s80Time = TimeSav:irHeure & CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Heure)
      .
      IF TimeTim:s4TnnShowTimeFormat = '@T2'
        DO CheckFormat
        TimeTim:s80Time = TimeRet:irHeure
      ELSIF TimeTim:s4TnnShowTimeFormat = '@T3'
        DO CheckFormat
        TimeTim:s80Time = FORMAT(ilxTime,@t3)
        TimeTim:ibResultat = TimeTim:ibFin
      .
    OF 6 !===== Format Minute =====
      IF ~TimeTim:ibDefini THEN IF TimeTim:ibResultat = TimeTim:ibFin THEN TimeTim:s25Minute = ''..
      IF TimeTim:ibDebut < TimeTim:ibResultat THEN
        TimeTim:s80Time = CLIP(TimeTim:s80Time) & CLIP(TimeTim:s1Espace) & FORMAT(TimeRet:irMinute,TimeEqu:e2PnPictureFormat) & |
              CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Minute)
      ELSE
        TimeTim:s80Time = TimeSav:irMinute & CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Minute)
      .
    OF 7 !±±±±± Format Seconde ±±±±±
      IF ~TimeTim:ibDefini THEN IF TimeTim:ibResultat = TimeTim:ibFin THEN TimeTim:s25Seconde = ''..
      IF TimeTim:ibDebut < TimeTim:ibResultat THEN
        TimeTim:s80Time = CLIP(TimeTim:s80Time) & CLIP(TimeTim:s1Espace) & FORMAT(TimeRet:irSeconde,TimeEqu:e2PnPictureFormat) & |
              CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Seconde)
      ELSE
        TimeTim:s80Time = TimeSav:irSeconde & CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25Seconde)
      .
    OF 8 !±±±±± Format Hundred of a second ±±±±±
      IF ~TimeTim:ibDefini THEN IF TimeTim:ibResultat = TimeTim:ibFin THEN TimeTim:s25CentSec = ''..
      IF TimeTim:ibDebut < TimeTim:ibResultat THEN
        TimeTim:s80Time = CLIP(TimeTim:s80Time) & CLIP(TimeTim:s1Espace) & FORMAT(TimeRet:irCentSec,TimeEqu:e2PnPictureFormat) & |
              CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25CentSec)
      ELSE
        TimeTim:s80Time = TimeSav:irCentSec & CLIP(TimeTim:s1Espace) & CLIP(TimeTim:s25CentSec)
      .
    END
  END
  RETURN(TimeTim:s80Time)                                      ! Return time according picture format

!===== Define the Time internal or external suffix =====
DefTimSuffix ROUTINE                                                 ! Defined Time Suffix routine
  TimeTim:ibDefini     = 1                                           ! This is the define format
  !TimeTim:s1Espace    = CHR(255)                                    ! Assign a space character
  TimeTim:s1Espace = ''
  IF ~OMITTED(5) THEN                                                ! Use external suffix format
    IF OMITTED(4) OR ERROR() OR TimeTim:ibLanguage < 1 THEN          ! If Langue is omitted use first definition
       TimeTim:ibLanguage = TimeEqu:eFrench                          ! Check the language
    .
    TimeTim:s25Annee   = dxSuffix[TimeTim:ibLanguage,ibTimeSuffix]   ! Define the Year suffix format
    TimeTim:s25Mois    = dxSuffix[TimeTim:ibLanguage,ibTimeSuffix+1] ! Define the Month suffix format
    TimeTim:s25Semaine = dxSuffix[TimeTim:ibLanguage,ibTimeSuffix+2] ! Define the Week suffix format
    TimeTim:s25Jour    = dxSuffix[TimeTim:ibLanguage,ibTimeSuffix+3] ! Define the Day suffix format
    TimeTim:s25Heure   = dxSuffix[TimeTim:ibLanguage,ibTimeSuffix+4] ! Define the Hour suffix format
    TimeTim:s25Minute  = dxSuffix[TimeTim:ibLanguage,ibTimeSuffix+5] ! Define the Minute suffix format
    TimeTim:s25Seconde = dxSuffix[TimeTim:ibLanguage,ibTimeSuffix+6] ! Define the Second suffix format
    TimeTim:s25CentSec = dxSuffix[TimeTim:ibLanguage,ibTimeSuffix+7] ! Define the Hundred of a second suffix format
  ELSE                                                     ! Use internal language format
    IF OMITTED(4) OR ERROR() OR TimeTim:ibLanguage < 1 OR |      ! If Langue is omitted use French.
      TimeTim:ibLanguage > 2 THEN                                ! Check the language value
      TimeTim:ibLanguage = TimeEqu:eFrench
    .
    TimeTim:s25Annee   = s7Suffix[TimeTim:ibLanguage,ibTimeSuffix]   ! Define the Year suffix format
    TimeTim:s25Mois    = s7Suffix[TimeTim:ibLanguage,ibTimeSuffix+1] ! Define the Month suffix format
    TimeTim:s25Semaine = s7Suffix[TimeTim:ibLanguage,ibTimeSuffix+2] ! Define the Week suffix format
    TimeTim:s25Jour    = s7Suffix[TimeTim:ibLanguage,ibTimeSuffix+3] ! Define the Day suffix format
    TimeTim:s25Heure   = s7Suffix[TimeTim:ibLanguage,ibTimeSuffix+4] ! Define the Hour suffix format
    TimeTim:s25Minute  = s7Suffix[TimeTim:ibLanguage,ibTimeSuffix+5] ! Define the Minute suffix format
    TimeTim:s25Seconde = s7Suffix[TimeTim:ibLanguage,ibTimeSuffix+6] ! Define the Second suffix format
    TimeTim:s25CentSec = s7Suffix[TimeTim:ibLanguage,ibTimeSuffix+7] ! Define the Hundred of a second suffix format
  .
!===== Check for the wright format of @T2 and @T3 =====
CheckFormat  ROUTINE
  IF TimeSav:irHeure > 24 THEN                                 ! IF The hour is longer then a day
    IF ~OMITTED(6) THEN
      RETURN(dxMessage[TimeTim:ibLanguage,TimeEqu:eMessage2])            !    Return the wrong format message
    ELSE
      RETURN(siMessage[TimeTim:ibLanguage,TimeEqu:eMessage2])            !    Return the wrong format message
    .
  .
