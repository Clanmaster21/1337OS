wallpaper:
mov [command], byte '0'
mov [char], byte 0x00
mov [return], word wallpaper.loop
mov [program], byte '2'
mov [colour], byte 0x10
.loop:
call smallPause
mov bx, blank
call printS
cmp [cursor], word 0x0FA0
jne .next
mov [cursor], word 0x00
call pause

.next:
call random
mov cx, [randint]
sub cx, 0x30
add [colour], cx
cmp [colour], byte 0xff
jge .loop
mov [colour], byte 0x10
jmp Uinput
jmp .loop

blank:
db ' ', 0
