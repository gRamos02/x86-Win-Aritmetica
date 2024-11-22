.MODEL SMALL

.STACK 100h

.DATA
equipo DB 'Equipo 7:', '$'
nombre1 DB 09h, 'José Ramón Romero Zavala - 22130584', '$'
nombre2 DB 09h, 'Gerardo Enrique Ramos Espinoza - 21130599', '$'
proyecto DB 'Aplicación de instrucciones de aritmética', '$'
msg_prompt1 DB 'Introduce el primer numero: ', '$'
msg_prompt2 DB 'Introduce el segundo numero: ', '$'
msg_operaciones1 DB 'Operaciones: ', '$'
msg_operaciones2 DB 'Sumar: +', '$'
msg_operaciones3 DB 'Restar: -', '$'
msg_operaciones4 DB 'Multiplicar: *', '$'
msg_operaciones5 DB 'Dividir: /', '$'
msg_prompt3 DB 'Introduce la operación deseada: ', '$'
resultado DB 'El resultado es: ', '$'
of_msg DB 'Hay sobreflujo!', '$'
err_msg DB 'Símbolo invalido!', '$'
error_msg DB 'Entrada invalida, por favor ingrese un numero.', '$'
buffer DB 100 DUP('$')        ; Espacio para almacenar la entrada.
nueva_linea DB 0Dh, 0Ah, 0Ah, '$'  ; 0D = CR y 0A = Salto de línea
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

    leer_numero1:
    mov ah, 01h ; Leer un solo caracter
    int 21h
    cmp al, '0'
    jb entrada_invalida1
    cmp al, '9'
    ja entrada_invalida1

    sub al, '0' ; Convertir ascii en valor numerico
    mov num1, al ; Mover valor num. a num1

    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h
    jmp pedir_numero2

entrada_invalida1:
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h
    mov dx, OFFSET error_msg
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h
    jmp pedir_numero1

pedir_numero2:
    mov dx, OFFSET msg_prompt2
    mov ah, 9h
    int 21h

    leer_numero2:
    mov ah, 01h ; Leer un solo caracter
    int 21h
    cmp al, '0'
    jb entrada_invalida2
    cmp al, '9'
    ja entrada_invalida2

    sub al, '0' ; Convertir ascii en valor numerico
    mov num2, al ; Mover valor num. a num2

    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h
    jmp imprimir_menu

entrada_invalida2:
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h
    mov dx, OFFSET error_msg
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h
    jmp pedir_numero2

imprimir_menu:
    ; Mostrar las opciones del menú
    mov dx, OFFSET msg_operaciones1
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    mov dx, OFFSET msg_operaciones2
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    mov dx, OFFSET msg_operaciones3
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    mov dx, OFFSET msg_operaciones4
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    mov dx, OFFSET msg_operaciones5
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    mov dx, OFFSET msg_prompt3
    mov ah, 9h
    int 21h

    ; Leer la operación deseada
    mov ah, 01h ; Leer un solo carácter
    int 21h
    mov bl, al  ; Guardar la operación en BL
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h

    ; Comparar la operación ingresada
    cmp bl, '+'      ; Comparar con suma
    je calcular_suma ; Si es '+', saltar a calcular_suma

    cmp bl, '-'      ; Comparar con resta
    je calcular_resta ; Si es '-', saltar a calcular_resta

    cmp bl, '*'      ; Comparar con multiplicación
    je calcular_multi ; Si es '*', saltar a calcular_multi

    cmp bl, '/'      ; Comparar con división
    je calcular_div   ; Si es '/', saltar a calcular_div

    ; Si la entrada no es válida
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h
    mov dx, OFFSET err_msg
    mov ah, 9h
    int 21h
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h
    jmp imprimir_menu ; Volver al menú

calcular_suma:
    ; Sumar num1 + num2
    mov al, num1
    add al, num2
    jo sobreflujo ; Verificar sobreflujo
    add al, '0'
    mov sum, al
    jmp imprimir_resultado

calcular_resta:
    ; Restar num1 - num2
    mov al, num1
    sub al, num2
    jo sobreflujo ; Verificar sobreflujo
    add al, '0'
    mov sum, al
    jmp imprimir_resultado

calcular_multi:
    ; Multiplicar num1 * num2
    mov al, num1
    mov bl, num2
    mul bl        ; Multiplicar AL por BL
    jo sobreflujo ; Verificar sobreflujo
    add al, '0'
    mov sum, al
    jmp imprimir_resultado

calcular_div:
    ; Dividir num1 / num2
    xor ax, ax      ; Limpiar registro ax
    mov al, num1    ; Mover el dividendo a AL
    cbw            ; Convertir byte a word 
    mov bl, num2    ; Mover divisor a bl
    cmp bl, 0      ; Verificar división entre 0
    je division_error     
    div bl         ; Dividir AX por BL, resultado en AL y residuo en AH
    add al, '0'    ; Convertir el resultado devuelta a ASCII
    mov sum, al
    jmp imprimir_resultado

division_error:
    ; Mostrar error de división entre 0
    mov dx, OFFSET nueva_linea
    mov ah, 9h
    int 21h
    mov dx, OFFSET of_msg
    mov ah, 9h
    int 21h
    jmp imprimir_menu

imprimir_resultado:
    mov dx, OFFSET resultado
    mov ah, 9h
    int 21h

    mov dl, sum
    mov ah, 02h ; Imprimir caracter
    int 21h

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
