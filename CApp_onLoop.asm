CApp_onLoop       proto

.code
CApp_onLoop proc uses ebx esi edi

    ;------------------------
    ;call dword ptr[fRoomLoop]
    mov eax,lpvBase
    call dword ptr[eax+4]
    ;------------------------
	ret
CApp_onLoop endp