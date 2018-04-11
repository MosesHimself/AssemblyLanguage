***************************************
*  Name: HG King
*  ID: 14207714
*  Date: 04/11/2018
*  Lab5
*
*  Program description:
*
*  Pseudocode of Main Program:
*
*---------------------------------------
*
*  Pseudocode of Subroutine:
*
**************************************


*  start of data section
          ORG     $B000
NARR      FCB     1, 2, 5, 10, 20, 128, 254, 255, $00
SENTIN    EQU     $00

          ORG     $B010
RESARR    RMB     32
*  define any variables that your MAIN program might need here
*  REMEMBER: Your subroutine must not access any of the main
*  program variables including NARR and RESARR.


          ORG     $C000
          LDS     #$01FF        initialize stack pointer
*  start of your main program


*  NOTE: NO STATIC VARIABLES ALLOWED IN SUBROUTINE
*  AND SUBROUTINE MUST BE TRANSPARENT TO MAIN PROGRAM

          ORG     $D000
*  start of your subroutine
