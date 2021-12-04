; file.asm - использование файлов в NASM
extern printf
extern fscanf

extern  typeSphere
extern  typeParallelepiped
extern  typeRegularTetraheadron

;----------------------------------------------
; // Ввод параметров сферы из файла
; void InFigureSphere(void *r, FILE *ifst) {
;     fscanf(ifst, "%d%d", (int*)r, (int*)(r+intSize));
; }
global InFigureSphere
InFigureSphere:
section .data
    .inputSphere db "%d%d", 0
section .bss
    .FILE     resq    1              ; временное хранение указателя на файл
    .SphereAd resq    1              ; адрес
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.SphereAd],  rdi        ; сохраняется адрес
    mov     [.FILE], rsi             ; сохраняется указатель на файл

    ; Ввод из файла
    mov     rdi, [.FILE]
    mov     rsi, .inputSphere        ; Формат - 1-й аргумент
    mov     rdx, [.SphereAd]         ; &радиус
    mov     rcx, [.SphereAd]       ; &плотность фигуры 
    add     rcx, 4
    mov     rax, 0                   ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

;----------------------------------------------
; // Ввод параметров парвильного тетраэдра из файла
; void InFigureRegularTetrahedron(void *r, FILE *ifst) {
;     fscanf(ifst, "%d%d", (int*)r, (int*)(r+intSize));
; }
global InFigureRegularTetrahedron
InFigureRegularTetrahedron:
section .data
    .inputTetrahed db "%d%d", 0
section .bss
    .FILE     resq    1              ; временное хранение указателя на файл
    .RgTetAd  resq    1              ; адрес тетраэдра
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.RgTetAd], rdi          ; сохраняется адрес тетраэдра
    mov     [.FILE], rsi             ; сохраняется указатель на файл

    ; Ввод из файла
    mov     rdi, [.FILE]
    mov     rsi, .inputTetrahed      ; Формат - 1-й аргумент
    mov     rdx, [.RgTetAd]          ; &сторона тетраэдра
    mov     rcx, [.RgTetAd]        ; &плотность фигуры
    add     rcx, 4
    mov     rax, 0                   ; нет чисел с плавающей точкой
    call    fscanf

leave
ret

;----------------------------------------------
; // Ввод параметров парвильного тетраэдра из файла
; void InFigureParallelepiped(void *r, FILE *ifst) {
;     fscanf(ifst, "%d%d%d%d", (int*)r, (int*)(r+intSize), (int*)(r+2*intSize), (int*)(r+3*intSize));
; }
global InFigureParallelepiped
InFigureParallelepiped:
section .data
    .inputParallelepiped db "%d%d%d%d", 0
section .bss
    .FILE   resq    1                ; временное хранение указателя на файл
    .ParalleAd   resq    1           ; адрес параллелепипеда
section .text  
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.ParalleAd], rdi        ; сохраняется адрес параллелепипеда
    mov     [.FILE], rsi             ; сохраняется указатель на файл

    ; Ввод параллелепипеда из файла
    mov     rdi, [.FILE]
    mov     rsi, .inputParallelepiped; Формат - 1-й аргумент
    mov     rdx, [.ParalleAd]        ; &a
    mov     rcx, [.ParalleAd]      ; &b
    mov      r8, [.ParalleAd]      ; &c
    mov      r9, [.ParalleAd]     ; &плотность фигуры
    add     rcx, 4
    add      r8, 8
    add     r9, 12
    mov     rax, 0                   ; нет чисел с плавающей точкой
    call    fscanf

leave
ret


global InShape
InShape:
section .data
    .tagFormat   db     "%d", 0
section .bss
    .FILE       resq    1            ; временное хранение указателя на файл
    .pshape     resq    1            ; адрес фигуры
    .shapeTag   resd    1            ; признак фигуры
section .text
push rbp
mov rbp, rsp

    ; Сохранение принятых аргументов
    mov     [.pshape], rdi           ; сохраняется адрес фигуры
    mov     [.FILE],   rsi           ; сохраняется указатель на файл

    ; чтение признака фигуры и его обработка
    mov     rdi, [.FILE]
    mov     rsi, .tagFormat
    mov     rdx, [.pshape]           ; адрес начала фигуры (ее признак)
    xor     rax, rax                 ; нет чисел с плавающей точкой
    call    fscanf

    ; Тестовый вывод признака фигуры
;     mov     rdi, .tagOutFmt
;     mov     rax, [.pshape]
;     mov     esi, [rax]
;     call    printf

    mov rcx, [.pshape]               ; загрузка адреса начала фигуры
    mov eax, [rcx]                   ; и получение прочитанного признака
    cmp eax, [typeSphere]
    je .pointSphere
    cmp eax, [typeRegularTetraheadron]
    je .pointTetrahedron
    cmp eax, [typeParallelepiped]
    je .pointParallepiped
    xor eax, eax                     ; Некорректный признак - обнуление кода возврата
    jmp .return
.pointSphere:
    ; Ввод сферы
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InFigureSphere
    mov     rax, 1                   ; Код возврата - true
    jmp     .return
.pointTetrahedron:
    ; Ввод тетраэдра
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InFigureRegularTetrahedron
    mov     rax, 1                   ; Код возврата - true
    jmp     .return                     
.pointParallepiped:
    ; Ввод параллелепипеда
    mov     rdi, [.pshape]
    add     rdi, 4
    mov     rsi, [.FILE]
    call    InFigureParallelepiped
    mov     rax, 1                   ; Код возврата - true
.return:
leave
ret

; // Ввод содержимого контейнера из указанного файла
; void InContainer(void *c, int *len, FILE *ifst) {
;     void *tmp = c;
;     while(!feof(ifst)) {
;         if(InShape(tmp, ifst)) {
;             tmp = tmp + shapeSize;
;             (*len)++;
;         }
;     }
; }
global InContainer
InContainer:
section .bss
    .pcont  resq    1                ; адрес контейнера
    .plen   resq    1                ; адрес для сохранения числа введенных элементов
    .FILE   resq    1                ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi                ; сохраняется указатель на контейнер
    mov [.plen], rsi                 ; сохраняется указатель на длину
    mov [.FILE], rdx                 ; сохраняется указатель на файл
    ; В rdi адрес начала контейнера
    xor rbx, rbx                     ; число фигур = 0
    mov rsi, rdx                     ; перенос указателя на файл
.loop:
    ; сохранение рабочих регистров
    push rdi
    push rbx

    mov     rsi, [.FILE]
    mov     rax, 0                   ; нет чисел с плавающей точкой
    call    InShape                  ; ввод фигуры
    cmp rax, 0                       ; проверка успешности ввода
    jle  .return                     ; выход, если признак меньше или равен 0
    pop rbx
    inc rbx
    pop rdi
    add rdi, 20                      ; адрес следующей фигуры
    jmp .loop
.return:
    mov rax, [.plen]                 ; перенос указателя на длину
    mov [rax], ebx                   ; занесение длины
leave
ret
