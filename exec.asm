
exec:
pusha

.help:
cmp [command], word 'h' ;help command
jne .os ;if not, go to next
cmp [program], word '0'
jne .help1
mov bx, helpOS ;mov bx to the help string
call printS ;print it

.help1:
cmp [program], word '1'
jne .help2
mov bx, helpPiano
call printS

.help2:
cmp [program], word '3'
jne .help3
mov bx, helpGame
call printS

.help3:
jmp .help4

.help4:
cmp [program], word '4'
jne .exit ;now exit
mov bx, helpPaint
call printS
jmp .exit
.os:
cmp [program], word '0' ;are we on the command line:
jne .piano ;if not, skip to next
cmp [command], word '1'
jne .off
call piano

.off:
cmp [command], word '2'
jne .wallpaper
mov [command], word 0x00
mov [program], word '0'
mov [char], word 0x00
call disko
MOV AX, 5301H; Function 5301h: APM Connect real-mode interface
XOR BX, BX; Device ID: 0000h (= system BIOS)
INT 15H; Call interrupt: 15h

MOV AX, 530EH; Function 530Eh: APM Driver version
MOV CX, 0102H; Driver version: APM v1.2
INT 15H; Call interrupt: 15h

MOV AX, 5307H; Function 5307h: APM Set system power state
MOV BL, 01H; Device ID: 0001h (= All devices)
MOV CX, 0003H; Power State: 0003h (= Off)
INT 15H; Call interrupt: 15h 
jmp .exit

.wallpaper:
cmp [command], word '3' ;if command is not 3
jne .game ;try next
call wallpaper ;else, call wallpaper

.game:
cmp [command], word '4' ; if command is not 4
jne .paint
call gamestart

.paint:
cmp [command], word '5' ;if command is not 5
jne .pong
call keys

.pong:
cmp [command], word '6'
jne .exit
call keys

.piano:
cmp [program], word '1' ;if the piano is running
jne .wall ;try next program
cmp [command], word '1' ;and the command is 1
jne .wall ;try next program
mov [program], word '0' ;clear program and command
mov [command], word '0'
popa
jmp os ;return to OS

.wall:
cmp [program], word '2' ;same as above, but for wallpaper
jne .game1
cmp [command], word '1'
jne .game1
popa
mov [program], word '0'
mov [command], word '0'
jmp os

.game1:
cmp [program], word '3' ;same as above, but for the game
jne .pant
cmp [command], word '1'
jne .load
call new
.load:
cmp [command], word '2'
jne .over
call load
.over:
cmp [command], word '3'
jne .exit
popa
mov [program], word '0'
mov [command], word '0'
jmp os

.pant:
cmp [program], word '4' ;same as above, but for paint
jne .poong
cmp [command], word '1'
jne .memes
popa
mov [program], word '0'
mov [command], word '0'
jmp os

.memes:
cmp [command], word '2'
jne .poong
call paint

.poong:
cmp [program], word '5'
jne .next1
popa
mov [program], word '0'
mov [command], word '0'
jmp os


.next1:
.exit:
popa
ret

helpOS:
db 0x0D, 'enter 1 for piano', 0x0D, 'enter 2 for off, and saves the game', 0x0D, 'enter 3 for wallpaper', 0x0D, 'enter 4 for game', 0x0D, 'enter 5 for paint', 0x0D, 'enter h for help with any program', 0

helpPiano:
db 0x0D, 'Press a key and produce a tone', 0x0D, 'Enter 1 to quit', 0
program:
db '0', 0
helpGame:
db 0x0D, 'enter 1 for new game, 2 for load. the game will then begin. enter 3 to exit', 0
helpPaint:
db 0x0D, 'enter 1 to exit, 2 for Dank Memes', 0
command:
db '1', 0