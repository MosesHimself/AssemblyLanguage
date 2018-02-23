
********************************************
*
* This program will add data1 and data3 and subtract data2 
*
*
*                                Table to be filled out
*     Step    |    PC         |   Register A |   Memory $B003 |   NZVC    |
*     ----------------------------------------------------------------------------
*       1       |   $C003    |      $0A        |           00                |     0000     |
*       2       |   $C006    |      $FB        |           00                |     1001     |
*       3       |   $C009    |      $15         |           00                |     0001     |
*       4       |   $C00C   |      $15         |           00                |     0001     |
*
********************************************
* data location starts at $B000
		ORG		$B000
DATA1	FCB     	10
DATA2	FCB     	15
DATA3	FCB     	$1A
RESULT	RMB     	1     		reserve storage for answer

* main program starts at $C000
       		ORG     	$C000

		LDAA    	DATA1   	load A with data1
       		SUBA    	DATA2   	subtract data2 from A
       		ADDA    	DATA3   	add data3 to A
 		STAA    	RESULT	store A in RESULT
DONE   	BRA     	DONE   	a little goofy, but convenient
       	 	END                    		Tells the Assembler that we’re done

