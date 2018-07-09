beep:
pusha
        mov     al, 182         ; Prepare the speaker for the
        out     43h, al         ;  note.
        mov     ax, [note]        ; Frequency number (in decimal)
                  		;  for middle C.
        out     42h, al         ; Output low byte.
        mov     al, ah          ; Output high byte.
        out     42h, al 
        in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
        or      al, 00000011b   ; Set bits 1 and 0.
        out     61h, al         ; Send new value.
        mov     bx, 25          ; Pause for duration of note.
call pause
        in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        and     al, 11111100b   ; Reset bits 1 and 0.
        out     61h, al         ; Send new value.
popa
ret

note:
dw 0x0

piano:
call cls ;clear the screen
mov bx, pianoS
call printS ;print the welcome message
call enter ;new line
mov [command], byte 0x00
mov [char], byte 0x00
mov [program], byte '1' ;set the program
mov [return], word piano.loop
.loop:
cmp [command], byte ' '
je Uinput
mov ax, 0x0088 ;move a tone to ax
sub ax, 0x60 ; I think this is supposed to be bx
mov bx, [command] ; as bx is now >60 if a character is pressed
call mult ;multiply them to get a tone
mov ax, [ans]
mov [note], ax
call beep ;play it
jmp Uinput
jmp .loop

tone: ;cycles through a load of tones at startup
pusha
mov bx, 0x55
mov ax, 0x00
.loop:
call mult
mov cx, [ans]
mov [note], cx
call beep
add ax, 0x01
add bx, 0x01
cmp ax, 0x040
jne .loop
popa 
ret

pianoS:
db 'The Piano', 0