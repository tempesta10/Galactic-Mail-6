CRoom_CreateRoom            proto :DWORD
CRoom_VirtualAlloc          proto
CRoom_VirtualFree           proto
;----------------------------------------------
CRoom_LoadBackground        proto :DWORD,:DWORD
;----------------------------------------------
CRoom_onLoop                proto
CRoom_onRender              proto
CRoom_onEvent               proto :DWORD
CRoom_onQuit                proto
CRoom_onKeyDown             proto :DWORD,:DWORD
CRoom_onExit                proto
;----------------------------------------------
CRoom_move_camera           proto :DWORD
CRoom_set_camera            proto :DWORD,:DWORD,:DWORD,:DWORD
;----------------------------------------------
CGameRoom_onLoop            proto
CGameRoom_onKeyDown         proto :DWORD,:DWORD
CGameRoom_onEvent           proto :DWORD


.data
lpvBase             dd 0
background          dd 0
camera              RECT <0,0,ROOM_WIDTH,ROOM_HEIGHT>
hspeed              dd 0
vspeed              dd 0
completed           dd 0
failed              dd 0
ticks               dd 0
;----------------------------------------------
;fRoomRender         dd offset CRoom_onRender
;fRoomLoop           dd offset CRoom_onLoop
;fRoomEvent          dd offset CRoom_onEvent
;fRoomQuit           dd offset CRoom_onQuit
;fRoomOnKeyDown      dd offset CRoom_onKeyDown



.code
CRoom_VirtualFree proc uses ebx esi edi

    fn VirtualFree,lpvBase,0,MEM_RELEASE

	ret
CRoom_VirtualFree endp
;**************************************************************
CRoom_VirtualAlloc proc uses ebx esi edi
   LOCAL sSysInfo:SYSTEM_INFO

   fn GetSystemInfo,addr sSysInfo
   ;-----------------------------
   fn VirtualAlloc,0,sSysInfo.dwPageSize,MEM_COMMIT,PAGE_READWRITE
   ;-----------------------------
   mov dword ptr[lpvBase],eax
   or eax,eax
   jne @F
   ;-----------------------------
   fn MessageBox,0,"Failed Allocate Memory","Error!",MB_ICONERROR
   fn ExitProcess,-1
   
 @@:
   mov dword ptr[eax],offset CRoom_onRender
   mov dword ptr[eax+4],offset CRoom_onLoop
   mov dword ptr[eax+8],offset CRoom_onEvent
   mov dword ptr[eax+12],offset CRoom_onQuit
   mov dword ptr[eax+16],offset CRoom_onKeyDown

	ret
CRoom_VirtualAlloc endp
;**************************************************************
CRoom_CreateRoom  proc uses ebx esi edi idRoom:DWORD

   mov dword ptr[completed],0
   mov dword ptr[failed],0
   mov dword ptr[ticks],30
   ;------------------------------------------------
   switch idRoom
       
       case STATE_TITLE
            
            
            
       case STATE_ROOM_FIRST
            
            fn CEntity_Create,ASTEROID,183,10,50,50,272,32
            fn CEntity_Create,ASTEROID,183,10,50,50,16,96
            ;---------------------------------------
            fn CEntity_Create,MOON,8,0,64,64,496,64
            fn CEntity_Create,BASE_MOON,8,0,64,64,80,72
            ;---------------------------------------
            fn CEntity_Create,PLAYER,72,0,48,48,10,10
            ;---------------------------------------
            mov eax,lpvBase
            mov dword ptr[eax+4],offset CGameRoom_onLoop
            mov dword ptr[eax+8],offset CGameRoom_onEvent
            mov dword ptr[eax+16],offset CGameRoom_onKeyDown
            
       case STATE_ROOM_SECOND
            
            

       case STATE_ROOM_THIRD
            
            
            
       case STATE_ROOM_COMPLETED
            
            
            
    endsw


	ret
CRoom_CreateRoom endp
;*************************************************************
CRoom_onExit proc

    mov eax,STATE_EXIT

	ret
CRoom_onExit endp
;**************************************************************
CRoom_onKeyDown proc uses ebx esi edi dwKey:DWORD,idState:DWORD
    LOCAL dwReturnValue:DWORD
    
    mov dword ptr[dwReturnValue],STATE_NULL
    ;--------------------------------------
    mov eax,dword ptr[dwKey]
    or eax,eax
    je @@Ret
    ;--------------------------------------
    mov eax,dword ptr[idState]
    inc eax
    cmp eax,STATE_ROOM_COMPLETED
    ;--------------------------------------
    jg @F
    mov dword ptr[dwReturnValue],eax
    jmp @@Ret
@@:
    mov dword ptr[dwReturnValue],STATE_TITLE
    ;---------------------------------------
@@Ret:
    ;---------------------------------------
    mov eax,dword ptr[dwReturnValue]

	ret
CRoom_onKeyDown endp
;**************************************************************
CGameRoom_onKeyDown proc uses ebx esi edi dwKey:DWORD,idState:DWORD
    LOCAL dwReturnValue:DWORD
    
    mov dword ptr[dwReturnValue],STATE_NULL
    ;--------------------------------------
    switch dwKey
    
       case LEFT_ARROW
       
            fn CPlayer_onKeyLeft
            
       case RIGHT_ARROW
    
            fn CPlayer_onKeyRight
            
       case VK_SPACE
       
            fn CPlayer_onKeySpace
    
    endsw
    ;---------------------------------------
    mov eax,dword ptr[dwReturnValue]
	ret
CGameRoom_onKeyDown endp
;**************************************************************
CRoom_onQuit proc uses ebx esi edi

    mov eax,dword ptr[pEntity]
    or eax,eax
    je @@Ret
    ;-------------------------
    xor ebx,ebx
    mov esi,pEntity
    assume esi:PTR ENTITY
    jmp @@For
    ;-------------------------
@@In:  
    mov eax,dword ptr[esi].sprite
    fn DeleteObject,eax
    ;-------------------------
    add esi,sizeof ENTITY
    inc ebx
    
@@For:
    cmp ebx,entity_num
    jl @@In
    ;-------------------------
    assume esi:nothing
    ;-------------------------
    fn LocalFree,pEntity
    mov dword ptr[pEntity],0
    ;-------------------------
    mov dword ptr[entity_num],0
@@Ret:
	ret
CRoom_onQuit endp
;***************************************************************
CRoom_onEvent proc uses ebx esi edi idState:DWORD
   LOCAL dwReturnValue:DWORD
    
    mov dword ptr[dwReturnValue],STATE_NULL
    ;----------------------
    fn Keyboard_check
    ;----------------------
    .if eax == VK_ESCAPE
    
       fn CRoom_onExit
       mov dword ptr[dwReturnValue],eax
       
    .else
    
       push dword ptr[idState]
       push eax
       ;call dword ptr[fRoomOnKeyDown]
       mov eax,lpvBase
       call dword ptr[eax+16]
       ;-------------------
       mov dword ptr[dwReturnValue],eax
       
    .endif
    ;----------------------
    mov eax,dword ptr[dwReturnValue]
    
	ret
CRoom_onEvent endp
;****************************************************************
CRoom_onLoop proc uses ebx esi edi

   xor ebx,ebx
   jmp @@For
   ;-------------------------------
@@In:
   mov esi,pEntity
   mov eax,sizeof ENTITY
   mul ebx
   add esi,eax
   ;-------------------------------
   mov eax,dword ptr[esi+17]
   
   .if eax != ID_NONE
   
       mov eax,dword ptr[esi+65] ; offset fLoop
       push esi
       call eax
   
   .endif
   ;-------------------------------
   inc ebx
   add esi,sizeof ENTITY
@@For:
   cmp ebx,entity_num
   jl @@In
   ;------------------------------

	ret
CRoom_onLoop endp
;*****************************************************************
CRoom_onRender proc uses ebx esi edi

   fn CIMG_DrawBMP,background,screen,camera.left,camera.top,camera.right,camera.bottom
   ;--------------------------------
   mov esi,pEntity
   xor ebx,ebx
   assume esi:PTR ENTITY
   jmp @@For
   ;-------------------------------
@@In:
   mov eax,dword ptr[esi].id
   
   .if eax != ID_NONE
   
       mov eax,dword ptr[esi].fRender
       push esi
       call eax
   
   .endif
   ;-------------------------------
   inc ebx
   add esi,sizeof ENTITY
@@For:
   cmp ebx,entity_num
   jl @@In
   ;------------------------------
   assume esi:nothing
	ret
CRoom_onRender endp
;******************************************************************
CGameRoom_onLoop proc uses ebx esi edi

    fn CRoom_onLoop
    ;------------------------------
    xor ebx,ebx
    mov esi,pEntity
    assume esi:PTR ENTITY
    ;------------------------------
    jmp @@For
    
@@In:
    mov eax,dword ptr[esi].id
    
    .if eax == PLAYER
    
        .if dword ptr[esi].sprite == 0
    
            fn CEntity_LoadSprite,hInstance,IDI_PLAYER
            mov dword ptr[esi].sprite,eax
    
        .endif
    
      jmp @@Ret
      
    .endif
    ;------------------------------
    add esi,sizeof ENTITY
    inc ebx
@@For:
    cmp ebx,entity_num
    jl @@In
    ;------------------------------
@@Ret:
    assume esi:nothing
	ret
CGameRoom_onLoop endp
;******************************************************************
CGameRoom_onEvent proc uses ebx esi edi idState:DWORD

    cmp dword ptr[completed],1
    je @@Ret
    ;--------------------------
    fn CEntity_IsEntityExist,MOON
    ;--------------------------
    or eax,eax
    jne @@Next
    ;--------------------------
    fn CEntity_GetEntity,PLAYER
    or eax,eax
    je @F
    ;--------------------------
    mov dword ptr[eax+17],PLAYER_COMPLETED
@@:
   dec dword ptr[ticks]
   cmp dword ptr[ticks],0
   jg @@Ret
   ;---------------------------
   mov dword ptr[completed],1
   ;---------------------------
   fn MessageBox,0,"Mission Completed!","Lucky!",0
   jmp @@Ret
@@Next:
   cmp dword ptr[failed],1
   je @@Ret
   ;---------------------------
   fn CEntity_IsEntityExist,EXPLOSION
    ;--------------------------
    or eax,eax
    je @@Ret
   ;---------------------------
   dec dword ptr[ticks]
   cmp dword ptr[ticks],0
   jg @@Ret
   ;---------------------------
   mov dword ptr[failed],1
   fn MessageBox,0,"Mission Failed",0,MB_ICONERROR
@@Ret:
    fn CRoom_onEvent,idState
	ret
CGameRoom_onEvent endp
;******************************************************************
CRoom_LoadBackground proc uses ebx esi edi hInst:DWORD,idBmp:DWORD

    fn CIMG_LoadBMP,hInst,idBmp
    mov dword ptr[background],eax
    ;----------------------------
    or eax,eax
    jne @F
    ;----------------------------
    fn MessageBox,0,"Load Background Faild","Error!",MB_ICONERROR
    fn ExitProcess,-1
  @@:  
	ret
CRoom_LoadBackground endp
;*******************************************************************
CRoom_move_camera proc uses ebx esi edi lvlWidth:DWORD

    mov eax,dword ptr[hspeed]
    add dword ptr[camera.left],eax
    ;-------------------------
    mov eax,dword ptr[vspeed]
    add dword ptr[camera.top],eax
    ;-------------------------
    mov eax,dword ptr[camera.left]
    add eax,dword ptr[camera.right]
    cmp eax,dword ptr[lvlWidth]
    jge @F
    jmp @@Ret
    ;-------------------------
 @@:
    mov eax,dword ptr[lvlWidth]
    sub eax,dword ptr[camera.right]
    mov dword ptr[camera.left],eax
 
@@Ret:
	ret
CRoom_move_camera endp
;*******************************************************************
CRoom_set_camera proc uses ebx esi edi left:DWORD,top:DWORD,right:DWORD,bottom:DWORD

    fn SetRect,offset camera,left,top,right,bottom
    
	ret
CRoom_set_camera endp