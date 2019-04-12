;*******************************************************************************
;                     public functions                                         *
;*******************************************************************************
CTimer_start          proto
CTimer_delay          proto
;*******************************************************************************
;                     private functions                                        *
;*******************************************************************************
CTimer_get_ticks      proto


.data
frame_rate           dd 40
startTicks           dd 0


.code
CTimer_start proc uses ebx esi edi

    fn GetTickCount
    ;----------------------------
    mov dword ptr[startTicks],eax
    ;----------------------------

	ret
CTimer_start endp
;********************************************************************************
CTimer_delay proc uses ebx esi edi

    fn CTimer_get_ticks
    ;----------------------------
    cmp eax,dword ptr[frame_rate]
    jge @@Ret
    ;----------------------------
    mov ebx,dword ptr[frame_rate]
    ;----------------------------
    sub ebx,eax
    ;----------------------------
    fn Sleep,ebx
@@Ret:
	ret
CTimer_delay endp
;********************************************************************************
CTimer_get_ticks proc uses ebx esi edi

    fn GetTickCount
    ;--------------------------------
    sub eax,dword ptr[startTicks]
    ;--------------------------------

	ret
CTimer_get_ticks endp