include CTimer.asm
include CIMG.asm
;-----------------------------
CApp_onExecute            proto


.const
     ROOM_WIDTH           equ 640
     ROOM_HEIGHT          equ 480
     ;--------------------------------
     WINDOW_WIDTH         equ 80
     WINDOW_HEIGHT        equ 40
     
     
     STATE_NULL           equ 0
     STATE_TITLE          equ 1
     STATE_ROOM_FIRST     equ 2
     STATE_ROOM_SECOND    equ 3
     STATE_ROOM_THIRD     equ 4
     STATE_ROOM_COMPLETED equ 5
     STATE_EXIT           equ 6
     ;--------------------------------
     IDI_BACKGROUND       equ 100


.data
    id_state              dd STATE_NULL
    next_state            dd STATE_NULL
    ;----------------------------------
    hWnd                  dd 0
    hInstance             dd 0
    window                dd 0
    screen                dd 0
    screenBmp             dd 0
    bmpOld                dd 0
    ;----------------------------------
    include CEntity.asm
    include CRoom.asm
    include CApp_onInit.asm
    include CApp_onStart.asm
    include CApp_onQuit.asm
    include CApp_onLoop.asm
    include CApp_onRender.asm
    include CApp_onEvent.asm
    include CApp_updateState.asm
    include CApp_onGame.asm

.code
CApp_onExecute proc uses ebx esi edi
   LOCAL dwReturnValue:DWORD
   
   mov dword ptr[dwReturnValue],STATE_NULL
   ;------------------------
   fn CApp_onInit
   ;------------------------
   or eax,eax
   jne @F
   ;-----------------------
   fn MessageBox,0,"Game Initialize failed!","Error!",MB_ICONERROR
   ;-----------------------
   xor eax,eax
   dec eax
   mov dword ptr[dwReturnValue],eax
   jmp @@Ret
   ;-----------------------
@@:
   ;-----------------------
   fn CApp_onStart
   ;-----------------------
   ;        GAME LOOP
   ;-----------------------
   fn CApp_onGame 
   ;-----------------------
   fn CApp_onQuit
   ;-----------------------

@@Ret:
    mov eax,dword ptr[dwReturnValue]
	ret
CApp_onExecute endp