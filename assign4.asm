**************************************
*
*  Name: HG King
*  ID: 14207714
*  Date: 3/22/2018
*  Lab4
*
*  Program description: This program takes an array of numbers and passes them
*				each through a 'fib' subroutine and stores the returned
*				results into a results array. The 'fib' subroutine will
*				take in parameter n and calculate the 4 byte, nth number
*				in the fibonacci sequence and return the result.
*
*  Pseudocode of Main Program:
*
*	int[] NARR = {1,2,5,10,20,128,254,255};
*	int[] RESARR = malloc(sizeof(4byte int) * NARR.length);
*	int* nPtr;
*	int* resPtr;
*	#define SENTIN $00;
*
*	nPtr = &NARR[0];
*	while(*nPtr != SENTIN)  {
*		*resPtr = fib(n);
*		nPtr++;
*		resPtr += 4;
*	}
*
*
*---------------------------------------
*
*  Pseudocode of Subroutine:
* int fib(int n)  {
* 	
*	int result, Fn1, Fn2, i;  //reserve memory bytes
* 	result = Fn = Fn1 = Fn2 = i = 0;  //init to 0
*
* 	while(i != n)  {  //did != because it seems to work
*
*		if(i == 0)  {  //if this is the first go around
*			Fn2.LSB = 1;  //start w/ init variables to 1
*		}
*
*		result.LSB = Fn1.LSB + Fn2.LSB;  //add Fn1 to Fn2
*		result.MSB = Fn1.MSB + Fn2.MSB;
*		Fn2.MSB = Fn1.MSB;  //move Fn1 into Fn2
*		Fn2.LSB = Fn1.MSB;
*		Fn1.MSB = result.MSB;  //move reuslt
*		Fn1.LSB = result.LSB;
*		i++;  //bump that counter
*
* 	}
*	
*	return result;	
*
* }
*
**************************************
*  start of data section
	ORG 	$B000
NARR  FCB   1, 2, 5, 10, 20, 128, 254, 255, $00
SENTIN     EQU   $00

	ORG $B010
RESARR     RMB   32

*  define any variables that your MAIN program might need here
*  REMEMBER: Your subroutine must not access any of the main
*  program variables including NARR and RESARR.


	ORG 	$C000
	LDS   #$01FF           initialize stack pointer
*  start of your main program
	
		LDX		#NARR
		LDY		#RESARR	
WHILE		LDAA		0,X		init nPtr to A
		CMPA		#SENTIN	while(*nPtr != SENTIN) 
		BEQ		ENDWHILE
		
		JSR		FIB		fib(N in A)
		PULA				take first byte
		PULB				and 2nd byte
		STD		0,Y		store high byte in *resPtr
		PULA				take first byte
		PULB				and 2nd byte
		STD		2,Y		store low byte in *resPtr
		INX				nPtr++
		LDAB		#4		resPtr += 4
		ABY
		BRA		WHILE
ENDWHILE	BRA		ENDWHILE
		

*  define any variables that your SUBROUTINE might need here

RESULT  	RMB     	4		neither is RMB
*Fn		RMB		2		realized I don't use this
Fn1		RMB		4
Fn2		RMB		4
i		RMB		1
n		RMB		1
		ORG 		$D000

*  start of your subroutine
FIB		DES				open four
		DES				holes for
		DES				four bytes
		DES				in stack
		STAA		n		put param into memory
		PSHX				put X register on stack
		PSHY				put Y register on stack
		PSHA				save A register too
		TPA				along with the CC
		PSHA				so theres 6 bytes on stack

*  starting the actual fib program
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

WHLE		LDB		i		load i into acc A
		CMPB		n		compare i w/ value of N
		BEQ  		NDWHLE	if != jump to ENDWHLE

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
		BRA		WHLE		repeat loop
NDWHLE	TSX
		
		LDY		10,X		take the return address
		STY		6,X		put it in the hole
		LDY		#RESULT	grab RESULT from mem
		LDD		0,Y		toss the low byte value into D
		STD		8,X		store low byte in hole, below return
		LDD		2,Y		toss high byte value into D
		STD		10,X		put it into rest of hole
		PULA				get your CC off stack
		TAP				put into CCs
		PULA				get your A off stack
		PULY				get Y from staack
		PULX				get X from stack
		RTS				RETURN!!!