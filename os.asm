[bits 16]
[org 0x7c00]
call diski
call SetCursorPos
mov cx, 0xb800
mov es, cx
call cls
mov sp, 0xBc00 ;set up stack
mov bx, String ;move bx to the start of the string
mov [device], dl
mov [cursor],word 0x00 ;set screen position to 0
mov [char], word 0x00
mov [program], byte '0'
mov [command], byte 0x00
mov [colour], byte 0x09
mov bx, image
call printS
call longPause
call longPause
os:
mov [colour], byte 0x09
call Uinput
call cls
cmp [name], word 0x00
jne welcome_back

mov bx, String
call printS
call enter
jmp loop

welcome_back:
mov bx, returnS
call printS
call enter

loop:
call random ;sets randint
call pauseran
mov ax, 0x0478 ;move low note
mov bx, [randint] ;multiply by randint
sub bx, 0x30 ;convert to decimal
call mult ;ans becomes answer
mov ax, [ans] ;ax becomes answer
mov [note], ax ;note becomes answer, random note

call Uinput

call beep
call Uinput

jmp loop

%include "diskIO.asm" ;read/write to disk

String: 
db 'Welcome to 1337 OS', 0

returnS:
db 'Welcome to 1337 OS, ',0xFE, 0

cursor:
dw 0x0

times 510-($-$$) db 0
dw 0xaa55

test:
ret

%include "print.asm" ;contains printing, and other screen based stuff
%include "input.asm" ;check for all keys, or singular key. returns in zf
%include "maths.asm" ;more complex mathematical functions that take a few lines
%include "exec.asm" ;takes the input and executes it
%include "wallpaper.asm" ;pretty colours
%include "sound.asm" ;it can beep
%include "startup.asm" ;opening image
%include "Scene1.asm" ;scene 1 of the game
%include "Scene2.asm" ;scene 2 of the game
%include "wait.asm" ;waits a moment, must be manual edited at the current time
%include "Save.asm" ;saves the game
%include "load.asm" ;loads the game
%include "fight.asm" ;the basis of all Fight scenes
%include "paint.asm" ;Paint, an attempt at mouse drivers
%include "keys.asm" ;keyboard drivers
%include "pong.asm" ;pong, back for round 2
%include "game.asm" ;The main attraction, an RPG
times 10240-($-$$) db 0