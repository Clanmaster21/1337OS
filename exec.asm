exec:
pusha 
mov ax, [char]
mov [char], byte 0x00 ;clear buffer
cmp [command], byte 'h'; the help command
jne .action
mov bx, .help
add bx, [program]
add bx, [program]
sub bx, 0x60
mov bx, [bx]
call printS
call enter
jmp .end

.action:

cmp [command], byte '1'
jl .end

mov bx, .programs
add bx, [program]
add bx, [program]
sub bx, 0x60

mov ax, [bx+2]
mov bx, [bx]
sub ax, bx
shr ax, 1
add ax, '0'
cmp al, [command]
jl .end

add bx, [command]
add bx, [command]
sub bx, 0x62
mov bx, [bx]
mov [return+2], bx
popa
push word [return+2]
ret

.end:
popa
push word [return]
ret

dw .quit
.programs:
dw .os, .piano, .wallpaper, .game, .paint, .pong, .array 

.os:
dw piano, .off, wallpaper, gamestart, keys, keys

.piano:
dw .quit

.wallpaper:
dw .quit

.game:
dw new, save, .quit

.paint:
dw .quit

.pong:
dw .quit

.array:

.off:
mov [command], byte 0x00
mov [program], byte '0'
mov [char], byte 0x00
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
jmp .quit

.quit:
popa
jmp os

.help:
dw .helpOS, .helpPiano,program,.helpGame, .helpPaint
.helpOS:
db 0x0D, 'enter 1 for piano', 0x0D, 'enter 2 for off, and saves the game', 0x0D, 'enter 3 for wallpaper', 0x0D, 'enter 4 for game', 0x0D, 'enter 5 for paint', 0x0D, 'enter 6 for pong', 0x0D,'enter h for help with any program', 0
.helpPiano:
db 0x0D, 'Press a key and produce a tone', 0x0D, 'Enter 1 to quit', 0
.helpGame:
db 0x0D, 'enter 1 for new game, 2 to save your progress and the computer state. enter 3 to exit', 0
.helpPaint:
db 0x0D, 'enter 1 to exit, 2 for Dank Memes', 0
command:
db '0', 0
program:
db '0', 0
return:
dw 0, 0