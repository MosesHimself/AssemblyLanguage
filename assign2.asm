**************************************
*
* Name: HG King
* ID: 14207714
* Date: 02/22/2018
* Lab2
*
* Program description: This program will find the Nth fibonacci
* number
*
* Pseudocode:
* #define N 10
* int result, Fn1, Fn2, i;  //reserve memory bytes
* Fn = Fn1 = Fn2 = i = 0;  //init to 0
*
* while(i != N)  {  //did != because it seems to work
*
*	if(Fn1 == 0)  {  //if this is the first go around
*		Fn2 = 1;  //start w/ init variables to 1
*	}
*
*	result = Fn1 + Fn2;  //add Fn1 to Fn2
*	Fn2 = Fn1;  //move Fn1 into Fn2
*	Fn1 = result;  //move reuslt
*	i++;  //bump that counter
*
*
* }
*
*
**************************************

* start of data section

	ORG $B000
N       FCB    	10			FCB not in instruction set

	ORG $B010
RESULT  RMB     2				neither is RMB

* define any other variables that you might need here

*Fn		RMB		2		realized I dont use this
Fn1		RMB		2
Fn2		RMB		2
i		RMB		1

	ORG $C000
* start of your program


		LDD		#0		load value 0 into acc D
*		STD		Fn		store 2 bytes of 0 into Fn
		STD		Fn1		and Fn1 and Fn2
		STD		Fn2		b/c CLR just inits 1 byte
		CLR		i		i = 0

WHILE		LDB		i		load i into acc A
		CMPB		N		compare i w/ value of N
		BEQ  		ENDWHLE	if != jump to ENDWHLE

IF		LDD		Fn1		load Fn1 into acc D
		CMPD		#0		compare Fn1 w/ value 0
		BNE		ENDIF		if != jump to ENDIF
THEN		LDD		#1		load 1 into D
		STD		Fn2		store that 1 into Fn2
ENDIF		LDD		Fn1		load Fn1 into D
		ADDD		Fn2		add Fn2 to Fn1 from D
		STD		RESULT	store in Result
		LDD		Fn1		put Fn1 into D
		STD		Fn2		move Fn1 value into Fn2
		LDD		RESULT	put result into D
		STD		Fn1		move result into Fn1

		INC		i		increment the loop counter
		BRA		WHILE		repeat loop
ENDWHLE	BRA		ENDWHLE   	a little goofy, but convenient
       	END                    	Tells the Assembler that we're done