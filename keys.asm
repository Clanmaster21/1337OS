keys:
xor     ax, ax
mov     es, ax
cli                         ; update ISR address w/ ints disabled
push    word [es:9*4+2]     ; preserve ISR address
push    word [es:9*4]       ; start custom driver
mov     word [es:9*4], irq1isr
mov     [es:9*4+2],cs
sti
mov cx, 0xb800
mov es, cx
cmp [command], word '5'
jne .pong
call paint    ;program that requires custom driver
jmp .exit
.pong:
cmp [command], word '6' ;this is more like the old exec.asm system, since not all programs use these drivers it'd be harder to implement an array without wasting space because programs 1-4 will never be needed
jne .exit 
call pong
jmp .exit

.exit:
xor     ax, ax
mov     es, ax
cli                         ; update ISR address w/ ints disabled
pop     word [es:9*4]       ; restore ISR address
pop     word [es:9*4+2]     ; end custom driver
sti
mov cx, 0xb800
mov es, cx
jmp exec

irq1isr:
pusha

; read keyboard scan code
in      al, 0x60

; update keyboard state
xor     bh, bh
mov     bl, al
and     bl, 0x7F            ; bx = scan code
shr     al, 7               ; al = 0 if pressed, 1 if released
xor     al, 1               ; al = 1 if pressed, 0 if released
mov     [cs:bx+kbdbuf], al
; send EOI to XT keyboard
in      al, 0x61
mov     ah, al
or      al, 0x80
out     0x61, al
mov     al, ah
out     0x61, al

; send EOI to master PIC
mov     al, 0x20
out     0x20, al

popa
iret


kbdbuf:
    times   128 db 0

