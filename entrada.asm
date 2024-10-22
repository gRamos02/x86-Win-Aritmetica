; Programa ENSA03.ASM

STACK SEGMENT PARA STACK 'STACK'  ; Declaración del segmento de pila.
    DB 64 DUP (?)                 ; Reserva 64 bytes para la pila.
STACK ENDS                        ; Fin del segmento de pila.

DATA SEGMENT                      ; Declaración del segmento de datos.
    msg_prompt DB 'Introduce un mensaje: $' ; Mensaje de solicitud.
    buffer DB 100 DUP('$')        ; Espacio para almacenar la cadena ingresada.
    msg_newline DB 0Dh, 0Ah, '$'  ; 0D = CR y 0A = Salto de linea
DATA ENDS                         ; Fin del segmento de datos.

CODE SEGMENT PARA PUBLIC 'CODE'   ; Declaración del segmento de código.
ASSUME CS:CODE, DS:DATA, ES:CODE, SS:STACK

inicio:
    jmp principio                 ; Saltar el área de datos.

principio:
    ; Asignar el segmento de datos.
    mov ax, DATA
    mov ds, ax

    ; Mostrar mensaje de solicitud.
    mov dx, OFFSET msg_prompt      ; Coloca el desplazamiento del mensaje en DX.
    mov ah, 9h                    ; Pone en AH la función 09h de la interrupción 21h.
    int 21h                       ; Llamada a la interrupción DOS para mostrar la cadena.

    ; Leer la cadena ingresada.
    mov dx, OFFSET buffer         ; Coloca el desplazamiento del buffer en DX.
    mov ah, 0Ah                   ; Pone en AH la función 0Ah de la interrupción 21h para leer cadena.
    int 21h                       ; Llamada a la interrupción DOS para leer la cadena.

    ; Mostrar la cadena ingresada.
    mov dx, OFFSET msg_newline    ; Imprimir salto de línea.
    mov ah, 9h
    int 21h

    mov dx, OFFSET buffer + 1      ; Saltar el primer byte (tamaño máximo) y segundo byte (tamaño real).
    mov ah, 9h                    ; Pone en AH la función 09h para mostrar la cadena.
    int 21h                       ; Llamada a la interrupción DOS para imprimir la cadena ingresada.

    ; Imprimir salto de línea final.
    mov dx, OFFSET msg_newline    ; Imprimir salto de línea.
    mov ah, 9h
    int 21h

    ; Terminar el programa.
    mov ax, 4C00h                 ; Función 4Ch de la interrupción 21h para terminar el programa.
    int 21h

CODE ENDS                         ; Fin del segmento de código.
END inicio
