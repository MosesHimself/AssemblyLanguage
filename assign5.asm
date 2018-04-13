**************************************
*
* Name: HG King
* ID: 14207714
* Date: 4/13/18
* Lab5
*
* Program description: This program will compute the Nth number in the fib sequence.
* From an array of N numbers, it will compute each value and store the resulting number into
* another array. The fib calculations take place in a subroutine which will preserve the values
* inside the registers when returning to the main routine. Additionally, it uses dynamic variables
* that reside in the stack and are deleted upon the subroutine's exit. The parameters of n is passed
* to the subroutine over the A register.
*
* Pseudocode of Main Program:
*
*	int[] NARR = {1,2,5,10,20,128,254,255};
*	int[] RESARR = malloc(sizeof(4byte int) * NARR.length);
*	int* nPtr;
*	int* resPtr;
*	#define SENTIN $00;
*
*	nPtr = &NARR[0];
*	while(*nPtr != SENTIN)  {
*		load n into ACCA
*		*resPtr = fib(n);
*		nPtr++;
*		resPtr += 4;
*	}
*
*---------------------------------------
*
* Pseudocode of Subroutine:
* int fib(int n)  {
* 	open space for all of these variables on stack
*	int result, Fn1, Fn2, i;  //reserve memory bytes
* 	result = Fn = Fn1 = Fn2 = i = 0;  //init to 0
*	A register as well as all others are saved in stack
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



* start of data section
	ORG $B000
NARR	FCB	1, 10, 5, 10, 20, 128, 254, 255, $00
SENTIN	EQU	$00

	ORG $B010
RESARR	RMB	32	



* define any variables that your MAIN program might need here
* REMEMBER: Your subroutine must not access any of the main
* program variables including NARR and RESARR.



	ORG $C000
	LDS	#$01FF		initialize stack pointer
* start of your main program

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

* NOTE: NO STATIC VARIABLES ALLOWED IN SUBROUTINE
*       AND SUBROUTINE MUST BE TRANSPARENT TO MAIN PROGRAM

RESULT  	RMB     	4		neither is RMB
*Fn		RMB		2		realized I don't use this
Fn1		RMB		4
Fn2		RMB		4
i		RMB		1
*n		RMB		1

	ORG $D000
* start of your subroutine

FIB		DES				open four
		DES				holes for
		DES				four bytes
		DES				in stack
		PSHX				put X register on stack
		PSHY				put Y register on stack
		PSHA				save A register too
		TPA				along with the CC
		PSHA				so theres 6 bytes on stack
		LDAB		#0		this is a spot for i
		PSHB
		DES				this is for RESULT
		DES
		DES
		DES
		DES				this is for fn1
		DES
		DES
		DES	
		DES				this is for fn2
		DES
		DES
		DES
*  starting the actual fib program
		LDD		#0		load value 0 into acc D
		TSX
		
		STD		8,X			clear MSB to 0
		STD		10,X			clear LSB to 0
*		LDX		#Fn1		put address of Fn1 into X
		STD		4,X			clear MSB to 0
		STD		6,X			clear LSB to 0
*		LDX		#Fn2		put address of Fn2 into X
		STD		0,X			clear MSB to 0
		STD		2,X			clear LSB to 0

WHLE		
		LDB		12,X		load i into acc A
		CMPB		14,X		compare i w/ value of N
		BEQ  		NDWHLE	if != jump to ENDWHLE

IF		LDB		7,X		load Fn1 into acc D
		CMPB		#0		compare Fn1 w/ value 0
		BNE		ENDIF		if != jump to ENDIF
THEN		LDD		#1		load 1 into D
*		LDX		#Fn2
		STD		2,X		store that 1 into Fn2
			*initialize x and Y
*		LDX		#Fn1		set x to address of Fn1
*		LDY		#Fn2		set y to address of Fn2
			* LSB addition
ENDIF		LDD		6,X		load LSB of Fn1 into D
		ADDD		2,X		add LSB of Fn2 with D

*		LDX		#RESULT	set x to address of RESULT
		STD		10,X		put D(result) into LSB of RESULT

*		LDX		#Fn1		put x back to address of Fn1
		LDD		4,X		load MSB of Fn1 into D

		ADCB		1,X		add LSbits of Fn2 w/ LSbits of Fn1
		ADCA		0,X		add MSbits of Fn2 w/ MSbits of Fn1
		STD		8,X		put result into MSB of RESULT

			*Fn1(x) -> Fn2(y)
		LDD		4,X		take MSB of Fn1
		STD		0,X		put it into MSB of Fn2
		LDD		6,X		take LSB of Fn1
		STD		2,X		put it into LSB of Fn2
		
*		LDY		#RESULT	set Y to address of RESULT
			*RESULT -> Fn1
		LDD		8,X		take MSB of RESULT
		STD		4,X		put it into MSB of Fn1
		LDD		10,X		take LSB of RESULT
		STD		6,X		put it into LSB of Fn1

		INC		12,X		increment the loop counter
		BRA		WHLE		repeat loop

NDWHLE	LDY		23,X		take the return address
		STY		19,X		put it in the hole
*		LDY		#RESULT	grab RESULT from mem
		LDD		10,X		toss the low byte value into D
		STD		23,X		store low byte in hole, below return
		LDD		8,X		toss high byte value into D
		STD		21,X		put it into rest of hole
		INS
		INS
		INS
		INS
		INS
		INS
		INS
		INS
		INS
		INS
		INS
		INS
		INS
		PULA				get your CC off stack
		TAP				put into CCs
		PULA				get your A off stack
		PULY				get Y from staack
		PULX				get X from stack
		RTS				RETURN!!!