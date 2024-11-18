.MODEL SMALL

.STACK 100h

.DATA
equipo DB 'Equipo 7:', '$'
nombre1 DB 09h, 'Jose Ramon Romero Zavala - 22130584', '$'
nombre2 DB 09h, 'Gerardo Enrique Ramos Espinoza - 21130599', '$'
proyecto DB 'Aritmetica', '$'
msg_prompt1 DB 'Introduce el primer numero: ', '$'
msg_prompt2 DB 'Introduce el segundo numero: ', '$'
resultado DB 'El resultado es: ', '$'
of_msg DB 'Hay sobreflujo!', '$'
buffer DB 100 DUP('$')        ; Espacio para almacenar la entrada.
nueva_linea DB 0Dh, 0Ah, '$'  ; 0D = CR y 0A = Salto de línea
num1 DB 0
num2 DB 0
sum DB 0
multiplicador DW 10  

.CODE
inicio:
    mov ax, @data
    mov ds, ax

    ; Mostrar encabezado
    jmp encabezado

encabezado:
    mov dx, OFFSET equipo
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    mov dx, OFFSET nombre1
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    mov dx, OFFSET nombre2
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    mov dx, OFFSET proyecto
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    jmp pedir_numero1

pedir_numero1:
    LEA dx, msg_prompt1
    mov ah, 9h
    int 21h

    ; mov ah, 0Ah
    ; LEA dx, buffer ;
    mov ah, 01h ; Leer un solo caracter
    int 21h
    sub al, '0' ; Convertir ascii en valor numerico

    mov num1, al ; Mover valor num. a num1
    
    LEA dx, nueva_linea
    mov ah, 9h
    int 21h

    ;; Convertir entrada a número (primer número)
    ; lea si, buffer + 2
    ;; Convierte la cadena de entrada (SI apunta al inicio) en un número decimal (AX).
    ; xor ax, ax
    ; xor bx, bx

    jmp pedir_numero2

pedir_numero2:
    mov dx, OFFSET msg_prompt2
    mov ah, 9h
    int 21h

    ; mov ah, 0Ah
    ; mov dx, OFFSET buffer
    mov ah, 01h ; Leer un solo caracter
    int 21h
    sub al, '0' ; Convertir ascii en valor numerico

    mov num2, al ; Mover valor num. a num1

    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    ; Convertir entrada a número (segundo número)
    ; lea si, buffer + 2
    ; Convierte la cadena de entrada (SI apunta al inicio) en un número decimal (AX).
    ; xor ax, ax
    ; xor bx, bx
    ; mov num2, ax
    jmp calcular_suma

calcular_suma:
    ; Calcular la suma
    mov al, num1
    add al, num2
    JO sobreflujo ; Verifica si hay sobreflujo, si hay salta a esa etiqueta
    add al, '0' ; Para convertir a ascii, se le suma 48 (0)
    mov sum, al

    jmp imprimir_resultado

imprimir_resultado:
    mov dx, OFFSET resultado
    mov ah, 9h
    int 21h

    mov dl, sum
    mov ah, 02h ; Imprimir caracter
    int 21h
    ; Convierte un número en AX a cadena decimal e imprime.

    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    jmp termina

sobreflujo:
    LEA dx, of_msg
    mov ah, 09h
    int 21h
    jmp termina

termina:
    mov ax, 4C00h
    int 21h
END inicio
