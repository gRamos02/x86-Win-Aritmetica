.MODEL SMALL
.STACK 100h

.DATA
    ; Datos para créditos
    nombre DB 'José Ramón Romero Zavala', '$'
    control DB '22130584', '$'
    programa DB 'Convertidor Decimal a Binario', '$'
    
    ; Mensajes del menú
    menu_titulo DB '*** MENU PRINCIPAL ***', '$'
    menu_op1 DB '1. Creditos', '$'
    menu_op2 DB '2. Conversion Decimal a Binario', '$'
    menu_op3 DB '3. Salir', '$'
    menu_prompt DB 'Seleccione una opcion: ', '$'
    
    ; Mensajes para conversión
    prompt_num DB 'Introduzca un numero decimal (0-255): ', '$'
    resultado DB 'Numero en binario: ', '$'
    continuar DB 'Desea convertir otro numero? (S/N): ', '$'
    error_msg DB 'Numero invalido. Intente de nuevo.', '$'
    
    ; Variables de trabajo
    numero DB 0
    binario DB 8 DUP('$')
    nueva_linea DB 0Dh, 0Ah, '$'
    limpiar DB 25 DUP(0Ah), '$'

.CODE
inicio:
    mov ax, @data
    mov ds, ax

menu_principal:
    ; Limpiar pantalla
    mov dx, OFFSET limpiar
    mov ah, 9
    int 21h
    
    ; Mostrar menú
    mov dx, OFFSET menu_titulo
    mov ah, 9
    int 21h
    
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET menu_op1
    mov ah, 9
    int 21h
    
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET menu_op2
    mov ah, 9
    int 21h
    
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET menu_op3
    mov ah, 9
    int 21h
    
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET menu_prompt
    mov ah, 9
    int 21h
    
    ; Leer opción
    mov ah, 1
    int 21h
    
    ; Procesar opción
    cmp al, '1'
    je short_creditos    ; Usar salto intermedio
    cmp al, '2'
    je short_convertir   ; Usar salto intermedio
    cmp al, '3'
    je short_salir
    jmp menu_principal

short_salir:             ; Etiqueta intermedia
    jmp salir

short_creditos:          ; Etiqueta intermedia
    jmp mostrar_creditos

short_convertir:         ; Etiqueta intermedia
    jmp convertir_decimal

mostrar_creditos:
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET nombre
    mov ah, 9
    int 21h
    
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET control
    mov ah, 9
    int 21h
    
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET programa
    mov ah, 9
    int 21h
    
    ; Esperar tecla
    mov ah, 1
    int 21h
    jmp menu_principal

convertir_decimal:
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET prompt_num
    mov ah, 9
    int 21h
    
    ; Leer número
    xor bx, bx          ; Inicializar BX a 0 (acumulador)
    
leer_digito:
    mov ah, 1           ; Función para leer carácter
    int 21h
    
    cmp al, 0Dh         ; ¿Es Enter?
    je fin_lectura
    
    cmp al, '0'         ; Validar si es dígito
    jb error_lectura
    cmp al, '9'
    ja error_lectura
    
    sub al, '0'         ; Convertir ASCII a número
    
    ; Multiplicar número actual por 10
    push ax             ; Guardar dígito actual
    mov ax, bx          ; Mover número actual a AX
    mov cx, 10          
    mul cx              ; AX = AX * 10
    mov bx, ax          ; Guardar resultado en BX
    pop ax              ; Recuperar dígito
    
    ; Sumar nuevo dígito
    xor ah, ah          ; Limpiar AH
    add bx, ax          ; Sumar dígito al total
    
    cmp bx, 255         ; Verificar si excede 255
    ja error_lectura
    
    jmp leer_digito

error_lectura:
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET error_msg
    mov ah, 9
    int 21h
    
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    jmp convertir_decimal

fin_lectura:
    mov numero, bl      ; Guardar número final
    
    ; Convertir a binario
    mov cx, 8           ; Contador para 8 bits
    mov bx, 0           ; Índice para guardar bits
    
conversion:
    mov al, numero
    shr al, 1           ; Desplazar bit a CF
    mov numero, al
    
    mov al, '0'         ; Preparar '0'
    jnc guardar_bit     ; Si CF=0, guardar '0'
    mov al, '1'         ; Si CF=1, cambiar a '1'
    
guardar_bit:
    mov binario[bx], al
    inc bx
    loop conversion
    
    ; Mostrar resultado
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET resultado
    mov ah, 9
    int 21h
    
    mov dx, OFFSET binario
    mov ah, 9
    int 21h
    
    ; Preguntar si continuar
    mov dx, OFFSET nueva_linea
    mov ah, 9
    int 21h
    
    mov dx, OFFSET continuar
    mov ah, 9
    int 21h
    
    mov ah, 1
    int 21h
    
    cmp al, 'S'
    je convertir_decimal
    cmp al, 's'
    je convertir_decimal
    jmp menu_principal

salir:
    mov ax, 4C00h
    int 21h

END inicio