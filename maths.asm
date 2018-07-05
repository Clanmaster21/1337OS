random:
pusha
mov ah,0x00
int 0x1A
mov ax, dx
mov dx, 0
mov bx, 0x000A
div bx
add dx, 0x30
mov [randint], word dx
popa
ret

mult: ;multiplies ax and bx, returns in ans
pusha
mov cx, ax ;moves the current ax to cx
.loop:
sub bx, 0x01 ;lowers bx by one
cmp bx, 0x0 ;if bx is 0
je .done ;finish
add ax, cx ;increase ax by its original value
jmp .loop ;loop
.done:
mov [ans], word ax
popa
ret

D20:
pusha
mov [roll], byte 0x00
mov ah,0x00
int 0x1A
mov ax, dx
mov dx, 0
mov bx, 0x0015
div bx
mov [roll], word dx
popa
ret
randint:
dw '0', 0

Str2Hex: ;converts a 2 digit string, pointed to by bx, to hex
pusha
mov ax, [bx]
sub ax, 0x30
push bx
mov bx, 0x0A
call mult
pop bx
mov ax, [bx+1]
sub ax, 0x30
add [ans], ax
mov [ans+1], byte 0x00
popa
ret

roll:
db 0x00, 0x00

ans:
dw 0x0, 0x0, 0x0