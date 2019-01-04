pause:
push ax
push cx
push dx
mov ah, 0x86 ;set action to wait
mov cx, 0x0002
mov dx ,0x0000
int 0x15 ;waits for (cx*16^4)+dx microseconds
pop dx
pop cx
pop ax
ret

pauseran:
push ax
push cx
push dx
mov dx, [randint]
sub dx, byte 0x30
mov ah, 0x86 ;set action to wait
mov cx, 0x0002
add cx, dx
mov dx ,0x0000
add dx, cx
int 0x15 ;waits for (cx*16^4)+dx microseconds
jae .finish
int 0x15 ;waits for (cx*16^4)+dx microseconds

.finish:
pop dx
pop cx
pop ax
ret

smallPause:
push ax
push cx
push dx
mov ah, 0x86 ;set action to wait
mov cx, 0x0000
mov dx ,0x2000
int 0x15 ;waits for (cx*16^4)+dx microseconds
pop dx
pop cx
pop ax
ret

longPause:
push ax
push cx
push dx
mov ah, 0x86 ;set action to wait
mov cx, 0x0020
mov dx ,0x0000
int 0x15 ;waits for (cx*16^4)+dx microseconds
pop dx
pop cx
pop ax
ret