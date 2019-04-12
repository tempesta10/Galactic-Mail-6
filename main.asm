include main.inc

include CApp.asm




.code
start:
  fn HideConsole
  ;-----------------
  fn Main
  ;-----------------
  fn ExitProcess,eax
;**********************************
Main proc

    ;----------------
    fn CApp_onExecute
    ;----------------

	ret
Main endp



end start