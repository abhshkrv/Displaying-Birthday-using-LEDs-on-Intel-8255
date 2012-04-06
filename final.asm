;$mod186
NAME EG0_COMP
; CG2007		Microprocessor Systems
; Sem 2			AY2011-2012
;
; Author:       Mr. Niu Tianfang
; Address:      Department of Electrical Engineering 
;               National University of Singapore
;               4 Engineering Dr 3
;               Singapore 117576. 
; Date:         Jan 2012
;
; This file contains proprietory information and cannot be copied 
; or distributed without prior permission from the author.
; --------------------------------------------------------------------


;IO Setup for 80C188 
	UMCR    EQU    0FFA0H ; Upper Memory Control Register
	LMCR    EQU    0FFA2H ; Lower Memory control Register         
	PCSBA   EQU    0FFA4H ; Peripheral Chip Select Base Address
	MPCS    EQU    0FFA8H ; MMCS and PCS Alter Control Register
	
	
; STACK SEGMENT
STACK_SEG		SEGMENT stack
 
db	128 DUP(?)
tos	label word

	
STACK_SEG		ENDS
	
	
; DATA SEGMENT
DATA_SEG        SEGMENT 
; day db 16h
; Month db 03h
; Year db 5dh

DATA_SEG        ENDS


; RESET SEGMENT
Reset_Seg   SEGMENT

    MOV DX, UMCR
    MOV AX, 03E07H
    OUT DX, AX
	JMP far PTR start
	
Reset_Seg  ends


; MESSAGE SEGMENT
MESSAGE_SEG     SEGMENT


MESSAGE_SEG     ENDS


;CODE SEGMENT
CODE_SEG        SEGMENT
       
PUBLIC	START

ASSUME  CS:CODE_SEG, DS:DATA_SEG, SS:STACK_SEG

START:

; Initialize MPCS to MAP peripheral to IO address
	MOV DX, MPCS
	MOV AX, 0083H
	OUT DX, AX

; PCSBA initial, set the parallel port start from 00H
	MOV DX, PCSBA
	MOV AX, 0003H ; Peripheral starting address 00H no READY, No Waits
	OUT DX, AX

; Initialize LMCS 
    MOV DX, LMCR
    MOV AX, 01C4H  ; Starting address 1FFFH, 8K, No waits, last shoud be 5H for 1 waits      
    OUT DX, AX

	; YOUR CODE HERE ...
	; GOOD LUCK!

	mov ax,DATA_SEG
	mov ds,ax

	xor ax,ax
	
	mov ax,STACK_SEG
	mov ss,ax

	xor ax,ax

	; set appropriate modes for the ports
    mov al,80h ;io mode,port for outpur, mode 0
	mov dx,83h ; address
	out dx,al

	xor ax,ax
	mov dx,80h
	;display day
	mov al,02h
	not al
	out dx,al
    ;start delay
	 push cx
	  push bx
	  mov cx,0FFFFh
outer1:mov bx,0FFh
	  
inner1: nop
     dec bx
	  cmp bx,00h
	  je inner1
     
     loop outer1
     pop bx 
	  pop cx
	;end delay
	
	xor ax,ax
	mov dx,80h
	;print month
	mov al,03h
	not al
	out dx,al
    
;start delay
 push cx
	  push bx
	  mov cx,0FFFFh
outer2:mov bx,0FFh
	  
inner2: nop
     dec bx
	  cmp bx,00h
	  je inner2
     
     loop outer2
     pop bx 
	  pop cx
	;end delay

	;year
	xor ax,ax
	 mov dx,80h
	mov al,92h
	not al
	out dx,al
	
	push cx
	  push bx
	  mov cx,0FFFFh
outer3:mov bx,0FFh
	  
inner3: nop
     dec bx
	  cmp bx,00h
	  je inner3
     
     loop outer3
     pop bx 
	  pop cx

	




	
CODE_SEG        ENDS
END