**************************************
*
* Name: HG King
* ID: 14207714
* Date: 03/07/2018
* Lab3
*
* Program description: This program will find the Nth fibonacci
* number, but with 4byte numbers!!
*
* Pseudocode:
* #define N 40
* int result, Fn1, Fn2, i;  //reserve memory bytes
* result = Fn1 = Fn2 = i = 0;  //init to 0
*
* while(i != N)  {  //did != because it seems to work
*
*	if(i == 0)  {  //if this is the first go around
*		Fn2.LSB = 1;  //start w/ init variables to 1
*	}
*
*	result.LSB = Fn1.LSB + Fn2.LSB;  //add Fn1 to Fn2
*	result.MSB = Fn1.MSB + Fn2.MSB;
*	Fn2.MSB = Fn1.MSB;  //move Fn1 into Fn2
*	Fn2.LSB = Fn1.MSB;
*	Fn1.MSB = result.MSB;  //move reuslt
*	Fn1.LSB = result.LSB;
*	i++;  //bump that counter
*
* }
*
*
**************************************

* start of data section

	ORG $B000
N       FCB    	40			FCB not in instruction set

	ORG $B010
RESULT  RMB     4				neither is RMB

* define any other variables that you might need here

*Fn		RMB		2		realized I don't use this
Fn1		RMB		4
Fn2		RMB		4
i		RMB		1

	ORG $C000
* start of your program


		LDD		#0		load value 0 into acc D

		LDX		#RESULT	put address of RESULT into X
		STD		0,X			clear MSB to 0
		STD		2,X			clear LSB to 0
		LDX		#Fn1		put address of Fn1 into X
		STD		0,X			clear MSB to 0
		STD		2,X			clear LSB to 0
		LDX		#Fn2		put address of Fn2 into X
		STD		0,X			clear MSB to 0
		STD		2,X			clear LSB to 0
		CLR		i		i = 0

WHILE		LDB		i		load i into acc A
		CMPB		N		compare i w/ value of N
		BEQ  		ENDWHLE	if != jump to ENDWHLE

IF		LDB		i		load Fn1 into acc D
		CMPB		#0		compare Fn1 w/ value 0
		BNE		ENDIF		if != jump to ENDIF
THEN		LDD		#1		load 1 into D
		LDX		#Fn2
		STD		2,X		store that 1 into Fn2
			*initialize x and Y
ENDIF		LDX		#Fn1		set x to address of Fn1
		LDY		#Fn2		set y to address of Fn2
			* LSB addition
		LDD		2,X		load LSB of Fn1 into D
		ADDD		2,Y		add LSB of Fn2 with D

		LDX		#RESULT	set x to address of RESULT
		STD		2,X		put D(result) into LSB of RESULT

		LDX		#Fn1		put x back to address of Fn1
		LDD		0,X		load MSB of Fn1 into D

		ADCB		1,Y		add LSbits of Fn2 w/ LSbits of Fn1
		ADCA		0,Y		add MSbits of Fn2 w/ MSbits of Fn1

		STD		RESULT	put result into MSB of RESULT

			*Fn1(x) -> Fn2(y)
		LDD		0,X		take MSB of Fn1
		STD		0,Y		put it into MSB of Fn2
		LDD		2,X		take LSB of Fn1
		STD		2,Y		put it into LSB of Fn2
		
		LDY		#RESULT	set Y to address of RESULT
			*RESULT -> Fn1
		LDD		0,Y		take MSB of RESULT
		STD		0,X		put it into MSB of Fn1
		LDD		2,Y		take LSB of RESULT
		STD		2,X		put it into LSB of Fn1

		INC		i		increment the loop counter
		BRA		WHILE		repeat loop
ENDWHLE	BRA		ENDWHLE   	a little goofy, but convenient
       	END                    	Tells the Assembler that we're done