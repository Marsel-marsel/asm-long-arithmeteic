; !!!!!!!!!
; First run check_floppy_sum.py. It will initialize FLOPPY_0 file with variables var_1 and var_2
; !!!!!!!!!


org 0x100

SEGMENT_SIZE equ 0x100          ; floppy segment size in words (512 bytes)          
jmp main:
db 0xD  dup(0)                   ; data alignment
VAR_1 dw SEGMENT_SIZE dup(0) 
VAR_2 dw SEGMENT_SIZE dup(0)
RES dw SEGMENT_SIZE*2 dup(0)     ; RES = VAR_1 + VAR_2

 
main: nop


; initialize VAR_1: read first sector of floppy 0
; void read_floppy0(var_1, 1st sector)
push 1
lea ax, [var_1]
push ax
call read_floppy_0:
                             
                             
; initialize VAR_2: read 2nd sector of floppy 0
; void read_floppy0(var_2, 2nd sector)
push 2
lea ax, [var_2]
push ax
call read_floppy_0:


; add var_1 and var_2
; void sum(res, var_1, var_2)
lea ax, var_2
push ax
lea ax, var_1
push ax
lea ax, res
push ax
call sum:


; write result to floppy_0
; void write_floppy_0(result 1st half, 3rd sector)
push 3
lea ax, [res]
push ax
call write_floppy_0:
nop


; write result carry to floppy_0
; void write_floppy_0(result 2nd half, 4th sector)
push 4
lea ax, [res+SEGMENT_SIZE*2]
push ax
call write_floppy_0:

jmp $




; void read_floppy_0(word* buf, int sector_num)
proc read_floppy_0:
    push bp
    mov bp, sp
    mov ah, 2   
    mov al, 1   
    mov ch, 0
    mov cl, [bp + 6]        ; sector_num
    mov bx, [bp + 4]        ; buf
    int 13h
    pop bp
    ret 4

; void write_floppy_0(word* buf, int sector_num)    
proc write_floppy_0:
    push bp
    mov bp, sp
    mov ah, 3
    mov al, 1
    mov ch, 0
    mov cl, [bp + 6]
    mov bx, [bp + 4]
    int 13h       
    pop bp
    ret 4 

; void sum(word* result, word* var_1, word* var_2)
proc sum:
    push bp
    mov bp, sp
    
    mov cx, SEGMENT_SIZE
    clc
        
    mov di, [bp + 8]    ; var_2
    mov si, [bp + 6]    ; var_1
    mov bp, [bp + 4]    ; result
   
L:  lodsw 
    adc ax, es:[di]    ; es:di = var_2
    mov ds:[bp], ax   
    inc di
    inc di
    inc bp
    inc bp
    loop L:
    mov ax, 0
    adc ax, 0    
    mov ds:[bp], ax  

    pop bp
    ret 6
        
