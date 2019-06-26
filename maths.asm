random:
push ax
push bx
push dx
mov ah,0x00
int 0x1A
mov ax, dx
mov dx, 0
mov bx, 0x000A
div bx
mov [randint], dl
pop dx
pop bx
pop ax
ret

D20:
push ax
push bx
push dx
mov [roll], byte 0x00
mov ah,0x00
int 0x1A
mov ax, dx
mov dx, 0
mov bx, 0x0015
div bx
mov [roll], word dx
pop dx
pop bx
pop ax
ret
randint:
db 0x00

Str2Hex: ;converts a 2 digit string, pointed to by bx, to hex
push ax
push bx
push cx
mov ax, [bx]
sub ax, 0x30
mov cl, 0x0A
mul cl
mov [ans], ax
mov ax, [bx+1]
sub ax, 0x30
add [ans], ax
mov [ans+1], byte 0x00
pop cx
pop bx
pop ax
ret

roll:
db 0x00, 0x00

ans:
db 0x0, 0x0, 0x0