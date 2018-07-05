save:
pusha
call cls
mov bx, .saveS
call printS
call ent2con
call enter
call disko
jc .fail
mov bx, .success
call printS
jmp load

.saveS:
db 'The game will now be saved. Once the game has been saved you may turn off your device', 0x0D, 'If you do not wish to save, power off your device now', 0x00
.success:
db 'Save Successful, you may power off your device or continue playing', 0x00
.failure:
db 'Save failed, retrying', 0x00

.fail:
mov bx, .failure
call printS
call ent2con
jmp save