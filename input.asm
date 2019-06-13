key:
push ax

.code:
mov ah, 0x01 ;check if a key has been pressed
int 0x16 ;call the interrupt
jz .nil ;if nothing, skip

mov ah, 0x00 ;read last key pressed
int 0x16 ;call the interrupt
mov [char], al ;replace char with the keypress
mov [char+2], ah ;save scan code too
jmp .code ;repeat until there are no more inputs

.nil:
pop ax
ret

Uinput: ;allows user to type on the screen
push ax
push bx
call key ; char will now contain the latest keypress
mov bx, char ;point bx to char
cmp [char], word 0x00 ;check if there is a character

je .skip ;skip if not
cmp [char], byte 0x08 ;is it backspace?
jne .next ;skip if not
call backspace ;backspace, in print
mov [char], byte 0x00
jmp .skip ;not a printable character, so skip.

.next:
cmp [char], byte 0x0D ;is it enter?
jne .print ;if not, print
pop bx
pop ax
jmp exec ;we need to try excecuting what the user has inputted
jmp .print

.print:
call printS ;print
mov ax, [char]
mov [command], ax
mov [char], byte 0x00 ;clear buffer

.skip:
in al, 0x60
pop bx
pop ax

push word [return]
ret

char:
db '0', 0, 0x48
