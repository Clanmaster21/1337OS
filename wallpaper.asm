wallpaper:
pusha
mov [command], word 0x00
mov [char], word 0x00
mov [program], word '2'
mov [colour], byte 0x10
.loop:
call Uinput
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
jmp .loop

blank:
db ' ', 0
