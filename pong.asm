pong:
pusha
call cls
mov [command], word '1'
mov [program], word '5' ;set the program
.loop:
call smallPause
call smallPause
call smallPause
call smallPause
call smallPause
call smallPause

;key presses, move player
mov al, [kbdbuf + 0x48] ;get up jey
cmp al, 0x00
jnz     .up
.updone:
mov al, [kbdbuf + 0x50] ;get down key
cmp al, 0x00
jnz     .down
.downdone:


;draw ball
xor bx, bx
xor ax, ax
mov bl, [.bally+1]
mov al, byte 0xA0
call mult
mov bx, [ans]
mov ax, [.cpuy]
add ax, 0x140
cmp ax, bx


;cpu movement
push bx
jg .cpuup
jl .cpudown
.cpudone:
pop bx

;move ball
mov ax, [.bally] ;move y
add ax, [.yvel]
mov [.bally], ax
cmp ax, 0x7F ;check y collisions
jge .wallt
neg word [.yvel]
.wallt:
cmp ax, 0x187F
jl .wallb
neg word [.yvel]
.wallb:

mov ax, [.ballx] ;move x
add ah, [.xvel]
add ah, [.xvel]
jo .ballright
jc .ballleft

.ballxcol:
cmp al, 0x0C
jc .playerc

cmp al, 0x92
jnc .cpuc

.ballxdone:
mov [.ballx], ax


;finish drawing the ball
xor ah, ah
add bx, ax
mov [es:bx], word 0x2500
cmp bx, [.ballxy]
je .balldrawn
push bx
mov bx, [.ballxy]
mov [es:bx], word 0x0900
pop bx
mov [.ballxy], bx
.balldrawn:

;draw the player
mov cx, 0x04
mov bx, [.playery]
xor ax, ax
.drawplayer:
mov [es:bx+0x0A], word 0x2500
add bx, 0xA0
loop .drawplayer

;draw the cpu
mov cx, 0x04
mov bx, [.cpuy]
.drawcpu:
mov [es:bx+0x92], word 0x2500
add bx, 0xA0
loop .drawcpu

jmp .loop

.up:
mov ax, [.playery]
cmp ax, 0x00
je .updone
sub [.playery], word 0xA0
mov bx, [.playery]
add bx, 0x280
mov [es:bx+0x0A], word 0x0900
jmp .updone

.down:
mov ax, [.playery]
cmp ax, 0x0D20
jge .downdone
mov bx, [.playery]
mov [es:bx+0x0A], word 0x0900
add [.playery], word 0xA0
jmp .downdone


.cpuup:
mov ax, [.cpuy]
cmp ax, 0x00
je .cpudone
sub [.cpuy], word 0xA0
mov bx, [.cpuy]
add bx, 0x280
mov [es:bx+0x92], word 0x0900
jmp .cpudone

.cpudown:
mov ax, [.cpuy]
cmp ax, 0x0D20
jge .cpudone
mov bx, [.cpuy]
mov [es:bx+0x92], word 0x0900
add [.cpuy], word 0xA0
jmp .cpudone

.ballright:
add al, 0x02
xor ah, ah
jmp .ballxcol

.ballleft:
sub al, 0x02
xor ah, ah
jmp .ballxcol

.playerc:
cmp al, 0x06
je .lose
push ax
mov ax, [.playery]
mov cl, 0xA0
div cl
mov cl,al
pop ax
cmp cl, [.bally+1]
jg .ballxdone
add cl, 0x03
cmp [.bally+1], cl
jg .ballxdone

xor ch, ch
sub cl, [.bally+1]

cmp cl, 0x01
jle .pbot
shl cl, 4
add [.yvel], word 0x10
sub [.yvel], cx
jmp .ptop

.pbot:
shl cl, 4
sub [.yvel], cx
add [.yvel], word 0x20

.ptop:
add [.xvel], byte 0x80
jo .ballxdone
add [.xvel], byte 0x80
jmp .ballxdone

.cpuc:
cmp al, 0x94
je .win
push ax
mov ax, [.cpuy]
mov cl, 0xA0
div cl
mov cl,al
pop ax
cmp cl, [.bally+1]
jg .ballxdone
add cl, 0x03
cmp [.bally+1], cl
jg .ballxdone

xor ch, ch
sub cl, [.bally+1]

cmp cl, 0x01
jle .cbot
shl cl, 4
add [.yvel], word 0x10
sub [.yvel], cx
jmp .ctop

.cbot:
shl cl, 4
sub [.yvel], cx
add [.yvel], word 0x20

.ctop:
add [.xvel], byte 0x80
jno .ballxdone
add [.xvel], byte 0x80
jmp .ballxdone

.win:
mov bx, .winS
jmp .gameover

.lose:
mov bx, .loseS
jmp .gameover

.gameover:
call printS
call enter
mov bx, pressenter
call printS
popa
.ent2con:
mov al, [kbdbuf + 0x1C] ;get up jey
cmp al, 0x00
je     .ent2con
ret

;playerx is 10, cpux is 70, both are constant
.playery:
dw 0
.cpuy:
dw 0
.ballx:
db 80, 0 ;second value acts as decimal
.bally:
dw 0x0c00
.xvel:
db 0x7F
.yvel:
dw 0x00
.ballxy:
dw 0x00
.winS:
db 'You Won!', 0
.loseS:
db 'You Lost!',0