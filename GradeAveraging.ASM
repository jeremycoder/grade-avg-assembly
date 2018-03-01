;Assembly Program 1
;Grade Averaging Program
;
;CSC 323 - 001 - Assembly Language Programming
;4 February 2016
;
;Group #2
;
;BL	
;Jeremy Mwangelwa 
;
;
;
INCLUDE C:\Irvine\Irvine32.inc		;Must include these INCLUDE directives

.386						;32 bits
;.MODEL flat, stdcall		;
.STACK 4096					;stack size is 4096

;INCLUDELIB Irvine32.lib		;to access Irvine32 library subroutines
;INCLUDELIB User32.lib		;
;INCLUDELIB kernel32.lib		;Assumption is that these files are located in project folder!

ExitProcess PROTO,dwExitCode:DWORD

.data
	grade_total DWORD 0									;to hold the sum of grades
	grade_count DWORD 0									;to hold the total number of grades
	grade_average DWORD 0								;to hold average calculation
	grade_remainder DWORD 0								;to hold remainder after idivision

	bufferSize EQU 60									;constant size of buffer for input/output
	buffer BYTE buffersize DUP(0)						;create buffer of bytes of size buffersize

	prompt BYTE "Enter grade from 0 to 100. Enter 888 to quit: ",0			;some message strings
	nodata BYTE "Invalid value entered. Quitting.",0	;
	averageIs BYTE "The sum is ",0						;
	endLabel BYTE "ENDING ",0							;
	summary0 BYTE "Program has been terminated",10,10,0	;
	summary1 BYTE "Grade total is: ", 0					;
	summary2 BYTE "Grade average is: ", 0				;
	summary3 BYTE "Grade count is: ",0					;
	zero_division BYTE 10,"ERROR: No valid grades were entered", 10, 10, 0

	NEW_LINE_CHAR BYTE 10, 0
	REMAINDER BYTE " R ", 0

.code
main PROC

while1:
	mov edx, offset prompt		;move string address prompt to edx register
	call WriteString			;call WriteString function to output string prompt

	mov edx, offset buffer		;read command-line
	mov ecx, sizeof buffer		;
	call ReadString				;returns number of bytes read into eax register

	cmp eax, 0					;Before parse, comparison to check if eax
	jz while1					;is NULL	

	call ParseInteger32			;convert string in eax into integer

	jo	while1					;If non-number is entered, overflow flag is set by ParseInteger32
								;jump back to start of loop (ignore entry)

	cmp eax, 888				;Comparison to check if eax
	jz endwhile					;equals 888, the terminal number

	cmp eax, 0					;After parse, comparison to check if
	jl while1					;the value stored in eax is outside
	cmp eax, 100				;the bounds of zero and one hundred
	jg while1					; if out of bounds, go back to start of loop (ignore entry)

	inc grade_count				;increase grade_count by 1
	add grade_total, eax		;add eax to total_grade

jmp while1

endwhile:
	cmp grade_count, 0 
	jnz dividable	
		mov edx, offset zero_division
		call WriteString	

		jmp terminate

dividable:
	mov eax, grade_total				;prep registers for idivision
	cdq									;grade_total->eax
	mov ebx, grade_count				;grade_count->ebx
	idiv ebx							

	mov grade_remainder, edx			;store results of idivision operation
	mov grade_average, eax				;in memory

	mov edx, offset summary0			;notifies user that it is
	call WriteString					;the end of the program

	mov edx, offset NEW_LINE_CHAR		;print a new line for
	call WriteString					;formatting

	mov edx, offset summary1			;tell user that total is
	call WriteString					;about to be displayed
		
	mov eax, grade_total				;display total
	call WriteDec						;

	mov edx, offset NEW_LINE_CHAR		;new line for formatting
	call WriteString					;

	mov edx, offset summary3			;tell user that grade count
	call WriteString					;is about to be displayed

	mov eax, grade_count				;display grade count
	call WriteDec						;

	mov edx, offset NEW_LINE_CHAR		;print new line for formatting
	call WriteString					;

	mov edx, offset summary2			;tell user that average is 
	call WriteString					;about to be displayed

	mov eax, grade_average				;display average
	call WriteDec						;
	mov edx, offset REMAINDER			;an 'R' formatting
	call WriteString					;
	mov eax, grade_remainder			;display average
	call WriteDec	

	mov edx, offset NEW_LINE_CHAR		;new line for formatting
	call WriteString					;

terminate:
	call WaitMsg						;wait to allow user to read results
	
	INVOKE ExitProcess,0
main ENDP
END main