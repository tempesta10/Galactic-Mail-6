CApp_onRender          proto

.code
CApp_onRender proc uses ebx esi edi

    ;call dword ptr[fRoomRender]
    mov eax,lpvBase
    call dword ptr[eax]
    ;--------------------------------
    fn BitBlt,window,0,0,ROOM_WIDTH,ROOM_HEIGHT,screen,0,0,00CC0020h
    ;--------------------------------

	ret
CApp_onRender endp