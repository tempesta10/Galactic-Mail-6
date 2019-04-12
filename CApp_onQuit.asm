CApp_onQuit            proto

.code
CApp_onQuit proc uses ebx esi edi


   ;call dword ptr[fRoomQuit]
   mov eax,lpvBase
   call dword ptr[eax+12]
   ;---------------------------
   fn CRoom_VirtualFree
   ;---------------------------
   fn DeleteObject,background
   ;---------------------------
   fn SelectObject,screen,bmpOld
   ;----------------------------
   fn DeleteDC,screen
   fn DeleteObject,screenBmp
   ;----------------------------
   fn ReleaseDC,hWnd,window
   ;----------------------------
	ret
CApp_onQuit endp