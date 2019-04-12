CApp_updateState      proto

.code
CApp_updateState proc uses ebx esi edi

     .if next_state != STATE_NULL
     
        ;call dword ptr[fRoomQuit]
        mov eax,lpvBase
        call dword ptr[eax+12]
        ;--------------------------------------
        switch next_state
       
            case STATE_TITLE
            
                fn CRoom_CreateRoom,STATE_TITLE
            
            case STATE_ROOM_FIRST
            
                fn CRoom_CreateRoom,STATE_ROOM_FIRST
            
            case STATE_ROOM_SECOND
            
                fn CRoom_CreateRoom,STATE_ROOM_SECOND
            

            case STATE_ROOM_THIRD
            
                 fn CRoom_CreateRoom,STATE_ROOM_THIRD
            
            case STATE_ROOM_COMPLETED
            
                  fn CRoom_CreateRoom,STATE_ROOM_COMPLETED
            
        endsw
     ;-------------------------------
     mov ebx,dword ptr[next_state]
     mov dword ptr[id_state],ebx
     ;-------------------------------
     mov dword ptr[next_state],STATE_NULL
    .endif
	ret
CApp_updateState endp