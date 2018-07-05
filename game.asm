gamestart:
pusha
mov [command], word 0x00
mov [char], word 0x00 ;clear past inputs
mov [program], word '3' ;set program
call cls ;clear screen
mov bx, gameS
call printS ;welcome message
call enter

.loop:
call Uinput ;inputs for start/load
call pause
jmp .loop

; we won't use Uinput, the game will require special keys and inputs larger than a character

new:
mov [name], byte 0x00
mov [Points], word '10'
mov [Insults], byte 0x00
mov [char], word 0x00 ;clear input
mov [Charisma], word '10'
mov [Strength], word '10'
mov [Intelligence], word '10'
mov [Dexterity], word '10'
mov [Wisdom], word '10'
mov [Constitution], word '10'
call Ninput ;call procedure for name input
call enter ;new line
mov bx, name ;print name as a test (not used anymore)
call printS
ret
gameS:
db 'Welcome to the game', 0

Ninput:
call cls ;clears the screen, the game now begins
mov bx, nameS
call printS ;enter your name
mov bx, name ;move bx to name
push bx ;push bx as it's needed multiple times
.do:
call pause ;makes sure the input's aren't horrifically fast
call key ;char now contains last keypress
mov bx, char ;point bx to char
cmp [char], word 0x00 ;check if there is a character
je .do ;skip if not

cmp [char], word 0x0D ;if enter
je .name_end ;end input

cmp [char], word 0x08 ;if not backspace
jne .cont ;continue as normal
pop bx ;else, take bx
sub bx, 0x01 ;take one from the location
push bx ;put bx back
mov [char], word 0x00 ;set the character to empty
call backspace ;call screen backspace to edit screen
jmp .do ;go to top of loop
.cont:
call printS ;print
mov ax, [char] ;move the char to ax
pop bx ;get position in name
mov [bx], ax ;set it to char
add bx, 0x01 ;add one
push bx ;store position in name so bx can be reused
mov [command], ax ;make the char the command
mov [char], word 0x00 ;clear buffer
jmp .do

.name_end:
pop bx ;free the space being used
call createChar ;call createChar

createChar:
mov bx, StatsS
call printS ;print out stat choices
sub [cursor], word 0xA4 ;set cursor position
call SetCursorPos ;make it visible
.loop:
call .check
call Ginput ;game_key now contains special
cmp [game_key], word 0x48
je .up ;if up
cmp [game_key], word 0x50
je .down ;if down
cmp [game_key], word 0x4D
je .right ;if right
cmp [game_key], word 0x4B
je .left ;if left
cmp [game_key], word 0x1C
je firstroll
mov [game_key], word 0x00 ;clear input
call pause
call .PointsRemain
jmp .loop ;loop

.up:
cmp [cursor],word 0x128 ;if hit upper limit
jl .loop ;do nothing
sub [cursor], word 0xA0 ;lower row by 1
call SetCursorPos ;make it visible
mov [game_key], word 0x00 ;clear input
jmp .loop

.down:
cmp [cursor],word 0x350 ;lower limit
jg .loop
add [cursor], word 0xA0 ;lower row by 1
call SetCursorPos
mov [game_key], word 0x00
jmp .loop

.right:
pusha
cmp [Points], byte '0'
jne .continue
cmp [Points+1], byte '0'
jne .continue
popa
mov [game_key], word 0x00 ;clear inputs
jmp .loop
.continue:
mov bx, [cursor] ;make bx the cursor position
add [es:bx], word 0x01 ;add 1 to the value
mov ax, [es:bx] ;put the value in ax
cmp al, ':' ;if it's the character after 9
je .increment ;we need to increase the next digit
sub bx, word 0x02 ;if that's not the case, we need to check if it's 20
mov cx, [es:bx] ;we make cx that character
cmp cl, '2' ;we see if it's a 2
jne $+0xF ;if not, ignore
cmp al, '0' ;if so, check there's a 0. I don't think this bit runs, if it did the code wouldn't work logically.
je $+0xB ;if not ignore, this shouldn't be necessary but I'm unwilling to touch working code
mov al, 0x00 ;blank al, for the sake of it
add bx, word 0x02 ;move bx along
mov [es:bx], byte '0' ;reset it to 0
mov [game_key], word 0x00 ;clear inputs
popa
jmp .loop ;continue looping like nothing ever happened

.left:
pusha
mov bx, [cursor] ;move bx to the cursor position
sub [es:bx], word 0x01 ;take one from the character there
mov ax, [es:bx] ;move the new char to ax
cmp al, '/' ;if we've gone too low
je .decrement ;decrease the next digit
mov [game_key], word 0x00 ;clear the input
popa
jmp .loop ;continue looping

.increment:
sub [Points+1], byte 0x02
mov al, '0' ;change al to 0
mov [es:bx], ax ;make the current screen character 0
sub bx, 0x02 ;go back a screen character
add [es:bx], word 0x01 ;add one to it
mov [game_key], word 0x00 ;continue
popa
jmp .loop

.decrement:
add [Points+1], word 0x02
mov al, '9' ;make al 9
mov [es:bx], ax ;make the current screen character 9
sub bx, 0x02 ;go back a character
sub [es:bx], word 0x01 ;take one from it
mov ax, [es:bx] ;make ax that character
cmp al, byte '/' ;if we've not gone too low
jne .low ;ignore this next bit
add [es:bx], byte 0x01 ;add one back to the current char
add bx, 0x02 ;go along a char
mov ax, [es:bx]
mov al, '0'
mov [es:bx], ax ;make is 0
sub [Points+1], byte 0x02
.low:
mov [game_key], word 0x00 ;continue
popa
jmp .loop

.PointsRemain:
pusha
mov bx, 0xC6 ;set bx to correct column and row
mov ax, [es:bx] ;get the char there
mov [Charisma], al ;set the first digit of Charisma to it
add bx, 0xA0 ;go down a row
mov ax, [es:bx]
mov [Intelligence], al ;repeat for intellignece
add bx, 0xA0
mov ax, [es:bx]
mov [Strength], al ;repeat for strength
add bx, 0xA0
mov ax, [es:bx]
mov [Wisdom], al ;repeat for wisdom
add bx, 0xA0
mov ax, [es:bx]
mov [Dexterity], al ;repeat for dexterity
add bx, 0xA0
mov ax, [es:bx]
mov [Constitution], al ;repeat for Constitution

mov bx, 0xC8 ;set bx to correct column and row for second digit of stat
mov ax, [es:bx] ;move the char to ax
cmp al, [Charisma+1] ;compare it to the second digit of charisma
mov [Charisma+1], al
jne .ChangePoints ;if it's not the same, we're screwed
add bx, 0xA0
mov ax, [es:bx] ;move the char to ax
cmp al, [Intelligence+1] ;compare it to the second digit of intelligence
mov [Intelligence+1], al
jne .ChangePoints ;if it's not the same, we're screwed
add bx, 0xA0
mov ax, [es:bx] ;move the char to ax
cmp al, [Strength+1] ;compare it to the second digit of Strength
mov [Strength+1], al
jne .ChangePoints ;if it's not the same, we're screwed
add bx, 0xA0
mov ax, [es:bx] ;move the char to ax
cmp al, [Wisdom+1] ;compare it to the second digit of Wisdom
mov [Wisdom+1], al
jne .ChangePoints ;if it's not the same, we're screwed
add bx, 0xA0
mov ax, [es:bx] ;move the char to ax
cmp al, [Dexterity+1] ;compare it to the second digit of dexterity
mov [Dexterity+1], al
jne .ChangePoints ;if it's not the same, we're screwed
add bx, 0xA0
mov ax, [es:bx] ;move the char to ax
cmp al, [Constitution+1] ;compare it to the second digit of constitution
mov [Constitution+1], al
jne .ChangePoints ;if it's not the same, we're screwed

popa
ret

.ChangePoints:
jl .add;if above
sub [Points+1], byte 0x02 ;sub 2 to counter add 1
.add: ;then only add
add [Points+1], byte 0x01 ;add 1
mov bx, 0x486 ;set cursor position
mov al, [Points] ;edit points on screen
mov [es:bx], al
add bx, 0x02 ;edit second digit
mov al, [Points+1]
mov [es:bx], al
popa
jmp .loop

.check:
pusha
cmp [Points+1], byte '/' ;if not too low
jne .next ;skip
mov [Points+1], byte '9' ;set digit to 9
sub [Points], byte 0x01 ;take 1 from next digit
.next:
cmp [Points+1], byte ':' ;if not too high
jne .finish ;skip
mov [Points+1], byte '0' ;set digit to 0
add [Points], byte 0x01 ;add 1 to next digit
.finish:
mov bx, 0x486 ;edit screen to new points value
mov al, [Points]
mov [es:bx], al
add bx, 0x02
mov al, [Points+1]
mov [es:bx], al
popa
ret
nameS:
db 'Enter your name:', 0

Ginput:
pusha

.code:
mov ah, 0x01 ;check if a key has been pressed
int 0x16 ;call the interrupt
jz .nil ;if nothing, skip

mov ah, 0x00 ;read last key pressed
int 0x16 ;call the interrupt
mov [game_key], ah ;replace char with the keypress
jmp .code ;repeat until there are no more inputs

.nil:
popa
ret

firstroll:
mov [cursor], word 0x500 ;set cursor position
mov bx, rollSc ;we're rolling for charisma, c
call printS 
call ent2con ;call procedure for enter to continue
call D20 ;roll a D20, stored in roll
mov [cursor], word 0x530 ;move cursor along sufficiently
mov bx, Charisma ;get charisma stat
call Str2Hex ;in hex, ready for arithmetic
mov cx, 0x0F ;make cx the value needed by someone with 0 charisma
mov ax, [roll]
add [ans], ax ;add stat and roll
call roll2S
call enter
cmp [ans], cx ;compare it to the amount needed
jl .fail;if too low
jge .success;if high enough
.fail:
mov bx, .failS
call printS
call ent2con
mov [Insults], byte 0x01
jmp Scene1
.success:
mov bx, .successS
call printS
call ent2con
jmp Scene1

.failS:
db 'Although your name is ', 0xFE, ' people call you whatever they feel like calling you', 0x00

.successS:
db 'Most people respect you enough to use your real name', 0x00
ent2con:
pusha
mov [game_key], word 0x00
mov bx, pressenterf
call printS
mov cx, [cursor]
push cx
.loop:
mov bx, pressenter
call printS
pop cx
mov [cursor], cx
push cx
mov [count], byte 0x30

.input1:
call Ginput
cmp [game_key], byte 0x1C
mov [game_key], byte 0x00
je .cont
call smallPause
sub [count],  byte 0x01
cmp [count], byte 0x00
jne .input1

mov bx, pressenterf
call printS
pop cx
mov [cursor], cx
push cx
mov [count], byte 0x30

.input2:
call Ginput
cmp [game_key], byte 0x1C
mov [game_key], byte 0x00
je .cont
call smallPause
sub [count],  byte 0x01
cmp [count], byte 0x00
jne .input2
jmp .loop
.cont:
pop cx
mov bx, pressenterf
call printS
popa
ret

roll2S:
pusha
mov ax, [roll] ;move roll to ax
mov dx, 0x00 ;clear dx
mov bx, 0x0A ;move 10 to bx
div bx ;divide
mov [rollS], ax ;move the answer to rollS, digit 1
add [rollS], byte 0x30 ;convert to ascii
mov [rollS+1], dx
add [rollS+1], byte 0x30
mov bx, rollS
call printS
popa
ret

rollS:
db '00', 0x0
StatsS:
db 0x0D, 'Charisma:        ', 0x3C, ' 10 ', 0x3E
db 0x0D, 'Intelligence:    ', 0x3C, ' 10 ' , 0x3E
db 0x0D, 'Strength:        ', 0x3C, ' 10 ' , 0x3E
db 0x0D, 'Wisdom:          ', 0x3C, ' 10 ' , 0x3E
db 0x0D, 'Dexterity:       ', 0x3C, ' 10 ' , 0x3E
db 0x0D, 'Constitution:    ', 0x3C, ' 10 ' , 0x3E
db 0x0D, 'Points Remaining: ', ' 10 ' , 0x00

Charisma:
db '10', 0

Intelligence:
db '10', 0

Strength:
db '10', 0

Wisdom:
db '10', 0

Dexterity:
db '10', 0

Constitution:
db '10', 0

Insults:
db 0x00
Points:
db '10', 0
name:
db 'Asa', 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
count:
db 0x00

rollSc:
db 'Roll for Charisma', 0

pressenter:
db 'Press enter to continue', 0
pressenterf:
db '                       ', 0
game_key:
db 0x00, 0x00F