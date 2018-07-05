paint:
pusha
call cls ;clear the screen
mov bx, paintS
call printS ;print the welcome message
call enter ;new line
mov [command], word 0x00
mov [char], word 0x00
mov [program], word '4' ;set the program


.loop:
call smallPause
call smallPause

	mov al, [kbdbuf + 0x4B] ;move left
    cmp al, 0x00
    jnz     .left

    mov al, [kbdbuf + 0x4D] ;move right
    cmp al, 0x00
    jnz     .right

    mov al, [kbdbuf + 0x48] ;move up
    cmp al, 0x00
    jnz     .up

    mov al, [kbdbuf + 0x50] ;move down
    cmp al, 0x00
    jnz     .down

	mov al, [kbdbuf + 0x2C] ;brush down
    cmp al, 0x00
    jnz     .z

	mov al, [kbdbuf + 0x2D] ;brush up
    cmp al, 0x00
    jnz     .x

	mov al, [kbdbuf + 0x02]
    cmp al, 0x00
    jz     .loop
    mov [command], word '1'
    popa
	ret

jmp .loop

.left:
mov bx, .Brush
call backspace
call printS
sub [cursor], word 0x02
jmp .loop

.right:
mov bx, .Brush
call printS
jmp .loop

.z:
mov [.Brush], byte 0xff
jmp .loop

.x:
mov [colour], byte 0x00
mov [.Brush], byte '0'
jmp .loop

.up:
cmp [cursor], word 0xA0
jle .loop
mov bx, .Brush
sub [cursor], word 0xA0
call backspace
call printS
jmp .loop

.down:
mov bx, .Brush
cmp [cursor], word 0xF00
jge .loop
add [cursor], word 0xA0
call backspace
call printS
jmp .loop

.Brush:
db 0xfc, 0

paintS:
db 'Welcome to paint', 0


