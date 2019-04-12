CIMG_LoadBMP            proto :DWORD,:DWORD
CIMG_DrawBMP            proto :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD
CIMG_DrawTransparentBMP proto :DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD,:DWORD

.code
CIMG_LoadBMP proc uses ebx esi edi hInst:DWORD,idBmp:DWORD

    fn LoadBitmap,hInst,idBmp
    ;------------------------
	ret
CIMG_LoadBMP endp
;**********************************************************************************************
CIMG_DrawBMP proc uses ebx esi edi hBitmap:DWORD,hScreen:DWORD,x:DWORD,y:DWORD,w:DWORD,h:DWORD
   LOCAL hOldBmp:DWORD
   LOCAL hMemDC:DWORD
   
   fn CreateCompatibleDC,hScreen
   ;---------------------------
   mov dword ptr[hMemDC],eax
   ;---------------------------
   fn SelectObject,eax,hBitmap
   mov dword ptr[hOldBmp],eax
   ;---------------------------
   fn BitBlt,hScreen,x,y,w,h,hMemDC,0,0,00CC0020h   ;SRCCOPY
   ;---------------------------
   fn SelectObject,hMemDC,hOldBmp
   fn DeleteDC,hMemDC
   ;---------------------------
	ret
CIMG_DrawBMP endp
;***********************************************************************************************
CIMG_DrawTransparentBMP proc uses ebx esi edi hBmp:DWORD,hScreen:DWORD,xs:DWORD,ys:DWORD,ws:DWORD,hs:DWORD,x2:DWORD,y2:DWORD,w2:DWORD,h2:DWORD,color:DWORD
   LOCAL hOldBmp:DWORD
   LOCAL hMemDC:DWORD
   
   fn CreateCompatibleDC,hScreen
   ;---------------------------
   mov dword ptr[hMemDC],eax
   ;---------------------------
   fn SelectObject,eax,hBmp
   mov dword ptr[hOldBmp],eax
   ;---------------------------
   fn TransparentBlt,hScreen,xs,ys,ws,hs,hMemDC,x2,y2,w2,h2,color 
   ;---------------------------
   fn SelectObject,hMemDC,hOldBmp
   fn DeleteDC,hMemDC
   ;---------------------------
	ret
CIMG_DrawTransparentBMP endp