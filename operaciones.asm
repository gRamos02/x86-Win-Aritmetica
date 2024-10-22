; Programa que pide y suma dos numerso 
STACK SEGMENT PARA STACK 'STACK'  ; Declaración del segmento de pila.
    DB 64 DUP (?)                 ; Reserva 64 bytes para la pila.
STACK ENDS                        ; Fin del segmento de pila.

DATA SEGMENT                      ; Declaración del segmento de datos.
    msg_prompt1 DB 'Introduce el primer numero: $'  ; Mensaje para el primer numero.
    msg_prompt2 DB 'Introduce el segundo numero: $' ; Mensaje para el segundo numero.
    msg_result DB 'La suma es: $'                   ; Mensaje de resultado.
    newline DB 0Dh, 0Ah, '$'                        ; Secuencia de salto de línea.
    buffer DB 5 DUP('$')                            ; Buffer para almacenar el numero ingresado.
    result DB 6 DUP('$')                            ; Espacio para el resultado en cadena.
DATA ENDS

CODE SEGMENT PARA PUBLIC 'CODE'   ; Declaración del segmento de código.
ASSUME CS:CODE, DS:DATA, ES:CODE, SS:STACK

inicio:
    jmp principio                 ; Salta el área de datos.

principio:
    ; Asignar el segmento de datos
    mov ax, DATA
    mov ds, ax

    ; Solicitar primer numero
    mov dx, OFFSET msg_prompt1
    mov ah, 9h                    ; Función 09h para imprimir la cadena.
    int 21h

    ; Leer primer numero
    call LeerNumero
    mov bx, ax                    ; Guardar el primer numero en BX.

    ; Solicitar segundo numero
    mov dx, OFFSET msg_prompt2
    mov ah, 9h                    ; Función 09h para imprimir la cadena.
    int 21h

    ; Leer segundo numero
    call LeerNumero
    mov cx, ax                    ; Guardar el segundo numero en CX.

    ; Sumar los dos números
    add bx, cx                    ; Suma BX y CX y deja el resultado en BX.

    ; Mostrar el resultado
    mov ax, bx                    ; Mueve el resultado a AX para imprimirlo.
    call ImprimirNumero            ; Convierte y muestra el numero.

    ; Terminar el programa
    mov ax, 4C00h                 ; Función 4Ch para terminar el programa.
    int 21h

; Rutina para leer un numero (Parece ser que la maestra dijo que no podiamos usar esto) 
LeerNumero PROC
    ; Leer cadena de caracteres
    mov dx, OFFSET buffer
    mov ah, 0Ah                   ; Función 0Ah para leer la cadena.
    int 21h

    ; Convertir cadena a numero
    xor ax, ax                    ; Limpiar AX para almacenar el numero.
    mov si, OFFSET buffer + 1      ; Saltar el primer byte (longitud).
    mov cx, 0                     ; Limpiar CX para acumular el numero.

leer_cadena:
    mov dl, [si]                  ; Obtener el carácter actual.
    cmp dl, '$'                   ; Es el final de la cadena?
    je fin_lectura                ; Si es '$', termina.

    sub dl, '0'                   ; Convierte el carácter ASCII a su valor numérico.
    mov dh, 0
    add ax, dx                    ; Suma el dígito a AX.
    inc si                        ; Avanza al siguiente carácter.
    jmp leer_cadena               ; Repite para el siguiente carácter.

fin_lectura:
    ret
LeerNumero ENDP

; Rutina para imprimir un numero
ImprimirNumero PROC
    ; Preparar el mensaje del resultado
    mov dx, OFFSET msg_result
    mov ah, 9h
    int 21h

    ; Convertir numero a cadena
    mov si, OFFSET result + 5      ; Empezamos desde el final de la cadena.
    mov byte ptr [si], '$'         ; Final de la cadena.
    dec si

convierte:
    mov dx, 0
    div word ptr 10                ; Divide el numero en AX entre 10.
    add dl, '0'                    ; Convierte el dígito en ASCII.
    mov [si], dl                   ; Almacena el dígito.
    dec si
    cmp ax, 0                      ; Hay mas dgitos?
    jne convierte                  ; Si hay más, repetir.

    inc si                         ; Ajusta el puntero SI al inicio de la cadena.

    ; Imprimir el numero
    mov dx, si
    mov ah, 9h
    int 21h

    ; Salto de línea
    mov dx, OFFSET newline
    mov ah, 9h
    int 21h

    ret
ImprimirNumero ENDP

CODE ENDS
END inicio
