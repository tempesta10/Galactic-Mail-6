CApp_onGame            proto

.code
CApp_onGame proc uses ebx esi edi

    .while id_state != STATE_EXIT

           fn CTimer_start
           ;---------------------
           fn CApp_onLoop
           ;---------------------
           fn CApp_onRender
           ;---------------------
           fn CApp_onEvent
           ;---------------------
           fn CApp_updateState
           ;---------------------
           fn CTimer_delay
           
    .endw
	ret
CApp_onGame endp