.MODEL SMALL
.STACK 100h
.386

.DATA
 
   ; Mensajes del menú principal
    menu_titulo DB '*** MENU PRINCIPAL ***$'
    menu_op1 DB '1. Mostrar Creditos$'
    menu_op2 DB '2. Ejecutar Calculadora$'
    menu_op3 DB '3. Salir$'
    menu_prompt DB 'Seleccione una opcion: $'

    ; Mensajes de créditos
    creditos_equipo DB 'Equipo 7$'
    creditos_titulo DB 'Calculadora de Resta y Division$'
    creditos_alumno1 DB 'José Ramón Romero Zavala - 22130584$'
    creditos_alumno2 DB 'Gerardo Enrique Ramos Espinoza - 21130599$'
    msg_continuar DB 'Presiona ENTER para regresar al menu...$'
    msg_volver DB 'Desea volver a correr el programa? (S/N): $'

    ; Mensajes de la calculadora
    msg_titulo DB 'Calculadora de Resta y Division', 0Dh, 0Ah, '$'
    msg_num1 DB 'Primer numero (0-999): $'
    msg_num2 DB 'Segundo numero (0-999): $'
    msg_op DB 'Operacion (- o /): $'
    msg_resultado DB 'Resultado: $'
    msg_div_cero DB 'Error: Division por cero', 0Dh, 0Ah, '$'
    msg_overflow DB 'Error: Desbordamiento', 0Dh, 0Ah, '$'
    msg_error_menor DB 'Error: Primer numero debe ser mayor que el segundo', 0Dh, 0Ah, '$'
    nueva_linea DB 0Dh, 0Ah, '$'
    
    buffer DB 6 DUP(?)
    num1 DW 0
    num2 DW 0
    resultado DW 0
    temp DW 0
    operador DB 0

.CODE
    ASSUME cs:@code, ds:@data

inicio:
    mov ax, @data
    mov ds, ax

menu_principal:
    ; Limpiar pantalla
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h

    ; Título
    mov ah, 02h
    mov bh, 0
    mov dh, 8        ; Fila 8
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, menu_titulo
    mov ah, 09h
    int 21h

    ; Opción 1
    mov ah, 02h
    mov dh, 10       ; Fila 10
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, menu_op1
    mov ah, 09h
    int 21h

    ; Opción 2
    mov ah, 02h
    mov dh, 11       ; Fila 11
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, menu_op2
    mov ah, 09h
    int 21h

    ; Opción 3
    mov ah, 02h
    mov dh, 12       ; Fila 12
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, menu_op3
    mov ah, 09h
    int 21h

    ; Prompt
    mov ah, 02h
    mov dh, 14       ; Fila 14
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, menu_prompt
    mov ah, 09h
    int 21h

leer_opcion:
    mov ah, 01h     ; Leer carácter
    int 21h

    cmp al, '1'     ; Opción 1 - Créditos
    je mostrar_creditos
    cmp al, '2'     ; Opción 2 - Calculadora
    je iniciar_calculadora
    cmp al, '3'     ; Opción 3 - Salir
    je fin
    jmp leer_opcion ; Si no es opción válida, seguir leyendo   

iniciar_calculadora:
    ; Limpiar pantalla
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h

    ; Mostrar título centrado
    mov ah, 02h
    mov bh, 0
    mov dh, 8
    mov dl, 25
    int 10h

    lea dx, msg_titulo
    mov ah, 09h
    int 21h

leer_num1:
    mov ah, 02h
    mov bh, 0
    mov dh, 10
    mov dl, 25
    int 10h

    lea dx, msg_num1
    mov ah, 09h
    int 21h

    xor bx, bx      ; Limpiar BX para acumular número
    mov cx, 5       ; Máximo 5 dígitos

leer_digito1:
    mov ah, 08h
    int 21h
    
    cmp al, 0Dh     ; Enter
    je fin_num1
    
    cmp al, '0'
    jb leer_digito1
    cmp al, '9'
    ja leer_digito1

    mov dl, al ; Si llegamos aqui es un digito valido
    mov ah, 02h
    int 21h
    
    sub al, '0'     ; Convertir ASCII a número
    
    ; Multiplicar número actual por 10
    push ax
    mov ax, bx
    mov dx, 10
    mul dx
    mov bx, ax
    pop ax
    
    ; Agregar nuevo dígito
    xor ah, ah
    add bx, ax
    
    loop leer_digito1

fin_num1:
    mov num1, bx

leer_num2:
    mov ah, 02h
    mov bh, 0
    mov dh, 12
    mov dl, 25
    int 10h

    lea dx, msg_num2
    mov ah, 09h
    int 21h

    xor bx, bx
    mov cx, 5

leer_digito2:
    mov ah, 08h
    int 21h
    
    cmp al, 0Dh
    je fin_num2
    
    cmp al, '0'
    jb leer_digito2
    cmp al, '9'
    ja leer_digito2

    mov dl, al ; Si llegamos aqui es un digito valido
    mov ah, 02h
    int 21h

    
    sub al, '0'
    
    push ax
    mov ax, bx
    mov dx, 10
    mul dx
    mov bx, ax
    pop ax
    
    xor ah, ah
    add bx, ax
    
    loop leer_digito2

fin_num2:
    mov num2, bx

leer_operacion:
    mov ah, 02h
    mov bh, 0
    mov dh, 14
    mov dl, 25
    int 10h

    lea dx, msg_op
    mov ah, 09h
    int 21h

esperar_operador:
    mov ah, 01h
    int 21h
    
    cmp al, '-'
    je hacer_resta
    cmp al, '/'
    je hacer_division
    jmp esperar_operador

hacer_resta:
    mov ax, num1
    cmp ax, num2
    jb numero_menor ; SI num1 < num2 mostrar error
    sub ax, num2
    jo overflow_error
    mov resultado, ax
    jmp mostrar_resultado

hacer_division:
    mov ax, num1
    cmp ax, num2
    jb numero_menor ; Si num1 < num2 mostrar error
    mov bx, num2
    cmp bx, 0
    je division_cero
    xor dx, dx
    div bx
    mov resultado, ax
    jmp mostrar_resultado

numero_menor:
    mov ah, 02h
    mov bh, 0
    mov dh, 16
    mov dl, 25
    int 10h

    lea dx, msg_error_menor
    mov ah, 09h
    int 21h
    jmp preguntar_volver

mostrar_resultado:
    mov ah, 02h
    mov bh, 0
    mov dh, 16
    mov dl, 25
    int 10h

    lea dx, msg_resultado
    mov ah, 09h
    int 21h

    mov ax, resultado
    mov bx, 10
    xor cx, cx      ; Contador de dígitos

convertir_a_ascii:
    xor dx, dx
    div bx          ; Dividir por 10
    push dx         ; Guardar residuo
    inc cx          ; Incrementar contador
    test ax, ax     ; ¿Terminamos?
    jnz convertir_a_ascii

mostrar_digitos:
    pop dx          ; Obtener dígito
    add dl, '0'     ; Convertir a ASCII
    mov ah, 02h     ; Imprimir carácter
    int 21h
    loop mostrar_digitos

    jmp preguntar_volver

division_cero:
    mov ah, 02h
    mov bh, 0
    mov dh, 16
    mov dl, 25
    int 10h

    lea dx, msg_div_cero
    mov ah, 09h
    int 21h
    jmp preguntar_volver

overflow_error:
    mov ah, 02h
    mov bh, 0
    mov dh, 16
    mov dl, 25
    int 10h

    lea dx, msg_overflow
    mov ah, 09h
    int 21h
    jmp preguntar_volver

preguntar_volver:
    mov ah, 02h
    mov bh, 0
    mov dh, 18
    mov dl, 25
    int 10h

    lea dx, msg_volver
    mov ah, 09h
    int 21h

    mov ah, 01h
    int 21h
    
    cmp al, 'S'
    je iniciar_calculadora 
    cmp al, 's'
    je iniciar_calculadora
    jmp menu_principal

mostrar_creditos:
    ; Limpiar pantalla
    mov ax, 0600h
    mov bh, 07h
    mov cx, 0000h
    mov dx, 184Fh
    int 10h

    ; Equipo
    mov ah, 02h
    mov bh, 0
    mov dh, 8        ; Fila 8
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, creditos_equipo
    mov ah, 09h
    int 21h

    ; Título
    mov ah, 02h
    mov dh, 10       ; Fila 10
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, creditos_titulo
    mov ah, 09h
    int 21h

    ; Alumno 1
    mov ah, 02h
    mov dh, 12       ; Fila 12
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, creditos_alumno1
    mov ah, 09h
    int 21h

    ; Alumno 2
    mov ah, 02h
    mov dh, 13       ; Fila 13
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, creditos_alumno2
    mov ah, 09h
    int 21h

    ; Mensaje continuar
    mov ah, 02h
    mov dh, 15       ; Fila 15
    mov dl, 25       ; Columna 25
    int 10h
    lea dx, msg_continuar
    mov ah, 09h
    int 21h


esperar_enter:
    mov ah, 01h
    int 21h
    cmp al, 0Dh
    jne esperar_enter
    jmp menu_principal

fin:
    mov ax, 4C00h
    int 21h

END inicio
