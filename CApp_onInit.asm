CApp_onInit            proto

.code
CApp_onInit proc uses ebx esi edi
    LOCAL dwReturnValue:DWORD

    mov dword ptr[dwReturnValue],1
    ;----------------------------
    fn SetConsoleTitle,"Galactic Mail v1.0"
    ;----------------------------
    fn SetConCursor,0
    ;----------------------------
    fn SetConsoleWindowSize,WINDOW_WIDTH,WINDOW_HEIGHT
    ;----------------------------
    fn SetConsoleCenterScreen,HWND_TOP,ROOM_WIDTH,ROOM_HEIGHT
    ;----------------------------
    fn GetModuleHandle,0
    ;----------------------------
    mov dword ptr[hInstance],eax
    ;----------------------------
    fn GetConsoleHwnd
    ;----------------------------
    mov dword ptr[hWnd],eax
    ;----------------------------
    ; Create Device Contex
    ;----------------------------
    fn GetDC,eax
    mov dword ptr[window],eax
    ;----------------------------
    ; Create Virtual Window
    ;----------------------------
    fn CreateCompatibleDC,eax
    mov dword ptr[screen],eax
    ;----------------------------
    fn GetSystemMetrics,1
    push eax
    fn GetSystemMetrics,0
    push eax
    push dword ptr[window]
    call CreateCompatibleBitmap
    ;----------------------------
    mov dword ptr[screenBmp],eax
    ;----------------------------
    fn SelectObject,screen,eax
    ;----------------------------
    mov dword ptr[bmpOld],eax
    ;----------------------------
    mov eax,dword ptr[dwReturnValue]
	ret
CApp_onInit endp