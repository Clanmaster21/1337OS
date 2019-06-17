wallpaper:
mov [command], byte '0'
mov [char], byte 0x00
mov [return], word wallpaper.loop
mov [program], byte '2'
mov ah, 0x10

.loop:
mov dx ,0x2000
call pause2
push ax
mov al, 0xDB
mov bx, [cursor]
mov [es:bx], ax
pop ax
cmp [cursor], word 0x0FA0
jne .next
mov [cursor], word 0xFFFE
mov cx ,0x0002
call pause

.next:
add [cursor], word 0x02
call random
mov cx, [randint]
sub ch, 0x30
add al, ch
adc ah, 0x00
jmp Uinput
jmp .loop
