; Ricardo, Justin Gerard

; MIPS Program run on EDUMIPS64
; Last Revised On: 11/12/2016

.data
	INPUT_DNA:		.asciiz		"AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC"
	str_len:		.asciiz		"DNA string length: %d \n"
	a_str:			.asciiz		"Frequency of A: %d \n"
	a_str_addr:		.space		8
	a_ctr_addr:		.space		8
	
	t_str:			.asciiz		"Frequency of T: %d \n"
	t_str_addr:		.space		8
	t_ctr_addr:		.space		8
	
	g_str:			.asciiz		"Frequency of G: %d \n"
	g_str_addr:		.space		8
	g_ctr_addr:		.space		8
	
	c_str:			.asciiz		"Frequency of C: %d \n"
	c_str_addr:		.space		8
	c_ctr_addr:		.space		8
	
	final_str:		.asciiz		"Reverse complement of the DNA string: \n%s\n"
	revcom_str: 	.space		100
	final_addr:		.space		8
	revcom_addr: 	.space		8

	end_msg:		.asciiz		"\n ...Program finished with no errors! =)\n"	

	temp_str:		.space		100
	end_addr:		.space		8
	dna_addr:		.space		8
	count_addr:		.space		8
	
	; Constants
	SYMBOL_A:		.asciiz		"A"
	SYMBOL_T:		.asciiz		"T"
	SYMBOL_G:		.asciiz		"G"
	SYMBOL_C:		.asciiz		"C"
	
.text
MAIN:	daddiu	r8, r0, 0	; DNA String Length/Counter
		daddiu r15, r0, 0	; A Frequency Counter
		daddiu r16, r0, 0	; T Frequency Counter
		daddiu r17, r0, 0	; G Frequency Counter
		daddiu r18, r0, 0	; C Frequency Counter
		daddiu r19, r0, 0	; Counter for REVERSE_LOOP
		
		lb r10, SYMBOL_A(r0) ; Load Constant A
		lb r11, SYMBOL_T(r0) ; Load Constant T
		lb r12, SYMBOL_G(r0) ; Load Constant G
		lb r13, SYMBOL_C(r0) ; Load Constant C
	
		COUNT_LOOP:
			lb		r9, INPUT_DNA(r8)	; Load DNA String
			daddiu	r8, r8, 1	; Increment DNA Counter

			; Update other counters
			; Procedures found below
			; They perform the Frequency Count & Reverse Complement
			beq r9, r10, COMP_A
			beq r9, r11, COMP_T
			beq r9, r12, COMP_C
			beq r9, r13, COMP_G
			END_OF_FREQ:
				
			bne		r9, r0, COUNT_LOOP
			daddiu	r8, r8, -1	; Actual/Final Length (Removes Excess)
			j PRINT_COUNTERS
			
				; Procedure Definitions
				COMP_A:
				daddiu	r15, r15, 1
				daddiu	r8, r8, -1
				sb		r11, temp_str(r8)
				daddiu	r8, r8, 1
				j END_OF_FREQ
				
				COMP_T:
				daddiu	r16, r16, 1
				daddiu	r8, r8, -1
				sb		r10, temp_str(r8)
				daddiu	r8, r8, 1
				j END_OF_FREQ
				
				COMP_C:
				daddiu	r17, r17, 1
				daddiu	r8, r8, -1
				sb		r13, temp_str(r8)
				daddiu	r8, r8, 1
				j END_OF_FREQ
				
				COMP_G:
				daddiu	r18, r18, 1
				daddiu	r8, r8, -1
				sb		r12, temp_str(r8)
				daddiu	r8, r8, 1
				j END_OF_FREQ
		
		PRINT_COUNTERS:
			; Print DNA String Length
			daddiu	r10, r0, str_len
			sw		r10, dna_addr(r0)
			sb		r8, count_addr(r0)
			daddiu	r14, r0, dna_addr
			SYSCALL 5
			
			; Print value of each counter
			; A Frequency Counter
			daddiu	r11, r0, a_str
			sw		r11, a_str_addr(r0)
			sb		r15, a_ctr_addr(r0)
			daddiu	r14, r0, a_str_addr
			SYSCALL 5
			
			; C Frequency Counter
			daddiu	r12, r0, c_str
			sw		r12, c_str_addr(r0)
			sb		r18, c_ctr_addr(r0)
			daddiu	r14, r0, c_str_addr
			SYSCALL 5
			
			; G Frequency Counter
			daddiu	r13, r0, g_str
			sw		r13, g_str_addr(r0)
			sb		r17, g_ctr_addr(r0)
			daddiu	r14, r0, g_str_addr
			SYSCALL 5
			
			; T Frequency Counter
			daddiu	r12, r0, t_str
			sw		r12, t_str_addr(r0)
			sb		r16, t_ctr_addr(r0)
			daddiu	r14, r0, t_str_addr
			SYSCALL 5

		; Realign DNA String length to become starting index 
		; & define r20 as end of loop 
		daddiu	r8, r8, -1
		daddiu	r20, r0, -1

		; Reads a character from complemented string
		; Then stores each character in another string by reverse order
		REVERSE_LOOP:
		lb		r9, temp_str(r8) ; Load MS byte
		sb		r9, revcom_str(r19) ; Store to LS byte
		
		daddiu	r19, r19, 1
		daddiu	r8, r8, -1
		bne	r8, r20, REVERSE_LOOP ; Iterate until length of original string is equal to -1
		
		; Prints out Reverse Complement of the DNA string
		PRINT_REVERSE_COMP:
		daddiu	r21, r0, final_str
		daddiu	r9, r0, revcom_str
		sw		r21, final_addr(r0)
		sd		r9, revcom_addr(r0)
		daddiu	r14, r0, final_addr
		SYSCALL 5
		
		; Print End of Program Message
		daddiu	r22, r0, end_msg
		sw		r22, end_addr(r0)
		daddiu	r14, r0, end_addr
		SYSCALL 5
		
		EXIT_PROG:
		SYSCALL 0
