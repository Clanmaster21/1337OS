diski:
    pusha
    mov cx, 0
    mov es, cx ;we are in sector 0
    mov ah, 0x02 ;set mode to read
    mov al, 0x20 ;sectors to read
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov bx, test ;load them to test
    int 0x13
    popa
    ret
disko:
    pusha
    mov cx, 0
    mov es, cx ;we are in sector 0
    mov ah, 0x03 ;set mode to write
    mov al, 0x20 ;sectors to write
    mov dl, [device]
    mov ch, 0
    mov dh, 0
    mov cl, 2
    mov bx, test ;write them to test
    int 0x13
mov cx, 0xb800
mov es, cx
mov [colour], byte 0x09
    popa
    ret
device:
db 0x00