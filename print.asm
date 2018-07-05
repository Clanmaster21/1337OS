printS:
mov cx,[bx] ;sets cx to a character of the string referenced by bx
mov al, cl ;move the last byte of cx to al
cmp al, 0x00 ;is al empty?
je .done ;if so goto finish

cmp al, 0x0D ;is it enter
jne .name ;if not, continue to next special
call enter ;if so, new line
jmp .next ;coninue along string

.name:
cmp al, 0xFE ;is the char 0xfe, set by game?
jne .Health
push bx
cmp [Insults], byte 0x00
jne .insult
mov bx, name
call printS
pop bx
jmp .next

.Health:
cmp al, 0xD0 ;is the char 0xD0, set by game?
jne .MaxHealth
push bx
mov bx, Health
call printS
pop bx
jmp .next

.MaxHealth:
cmp al, 0xD1 ;is the char 0xD0, set by game?
jne .RAM
push bx
mov bx, MaxHealth
call printS
pop bx
jmp .next

.RAM:
cmp al, 0xD3 ;is the char 0xD0, set by game?
jne .RAMusage
push bx
mov bx, RAM
call printS
pop bx
jmp .next

.RAMusage:
cmp al, 0xD2 ;is the char 0xD0, set by game?
jne .EHP
push bx
mov bx, RAMusage
call printS
pop bx
jmp .next

.insult:
call random
mov bx, insults_list
sub [randint], byte 0x30
shl byte [randint], 0x01 ;as each location is a word, not a byte
add bx, [randint] ;move along randint bytes
mov bx, [bx] ;use the insult at that location
call printS
pop bx
jmp .next

.EHP:
cmp al, 0xD4 ;is the char 0xD0, set by game?
jne .EMaxHP
push bx
mov bx, EHP
call printS
pop bx
jmp .next

.EMaxHP:
cmp al, 0xD5 ;is the char 0xD0, set by game?
jne .ERAMusage
push bx
mov bx, EMaxHP
call printS
pop bx
jmp .next

.ERAMusage:
cmp al, 0xD6 ;is the char 0xD0, set by game?
jne .ERAM
push bx
mov bx, ERAMusage
call printS
pop bx
jmp .next

.ERAM:
cmp al, 0xD7 ;is the char 0xD0, set by game?
jne .Ename
push bx
mov bx, ERAM
call printS
pop bx
jmp .next

.Ename:
cmp al, 0xD8 ;is the char 0xD0, set by game?
jne .normal
push bx
mov bx, Ename
call printS
pop bx
jmp .next

.normal: ;for non-special chars
call printn ;prints
add [cursor], word 0x02 ;goes to next position on screen
call SetCursorPos

.next:
add bx, 0x1 ;tries next character
jmp printS ;loops
.done:
ret

print:
mov ah , 0x0e ;Tells the BIOS interupt what to print
int 0x10 ;calls BIOS interupt
ret

printn:
call rows
pusha ;save all registers
mov bx, [cursor] ;move cursor to bx, as only bx can be used to reference an address
mov ah, [colour] ; set colour of character to blue
cmp al, 0xff ;is the char 0xff, set by draw?
jne .fd
mov ah, 0x25

.fd:
cmp al, 0xfd
jne .fc
mov [colour], byte 0x07
jmp .fin
.fc:
cmp al, 0xfc
jne .cont
mov [colour], byte 0x09
jmp .fin
.cont:
mov [es:bx],ax ;set the bxth character to ax
.fin:
popa ;load all registers
ret ;return

rows:
pusha
mov dx, 0
mov ax, [cursor]
mov bx, 0xA0
div bx
cmp ax, 0x19
jl .done
call cls
.done:
popa
ret

cls: ;clears the screen
pusha
xor bx, bx
mov cx, 0x7F0

.loop:
mov [es:bx], word 0x0900
add bx, 0x02
loop .loop

mov [cursor], word 0x0
call SetCursorPos
popa
ret

backspace:
pusha ;save all registers
cmp [program], byte '4'
je .paint
mov dx, 0
mov ax, [cursor]
mov bx, 0xA0
div bx
cmp dx, word 0x00
je .end
.paint:
sub [cursor], word 0x02 ;go back a character
mov ax, 0x00 ;we need to clear a char
mov bx, [cursor] ;move cursor to bx
mov [es:bx],ax ;set the bxth character to ax

.end:
popa ;load all registers
call SetCursorPos
ret ;return


enter:
pusha
mov dx, 0
mov ax, [cursor]
mov bx, 0xA0
div bx ;divide cursor by rows to get column in dx and row in ax
add [cursor], word 0xA0
sub [cursor], dx
call rows
call SetCursorPos
popa
ret

SetCursorPos:
pusha
mov dx, 0
mov ax, [cursor]
mov bx, 0xA0
div bx ;divide cursor by rows to get column in dx and row in ax
mov ah, 2
mov bh, 0
mov dh, al
shr dl, 1
int 10h
popa
ret

colour:
db 0x09
