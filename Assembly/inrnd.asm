; file.asm - использование файлов в NASM
extern printf
extern rand

extern  typeSphere
extern  typeParallelepiped
extern  typeRegularTetraheadron


;----------------------------------------------
; // rnd.c - содержит генератор случайных чисел в диапазоне от 1 до 20
; int Random() {
;     return rand() % 20 + 1;
; }
global Random
Random:
section .data
    .i20     dq      20
    .rndNumFmt       db "Random number = %d",10,0
section .text
push rbp
mov rbp, rsp

    xor     rax, rax                    ;
    call    rand                        ; запуск генератора случайных чисел
    xor     rdx, rdx                    ; обнуление перед делением
    idiv    qword[.i20]                 ; (/%) -> остаток в rdx
    mov     rax, rdx
    inc     rax                         ; должно сформироваться случайное число

    ;mov     rdi, .rndNumFmt
    ;mov     esi, eax
    ;xor     rax, rax
    ;call    printf


leave
ret

;----------------------------------------------
;// Случайный ввод параметров caths
;void InRndSphere(void *r) {
    ;int x = Random();
    ;*((int*)r) = x;
    ;int y = Random();
    ;*((int*)(r+intSize)) = y;
;}
global InRndSphere
InRndSphere:
section .bss
    .psAd  resq 1            ; адрес
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес
    mov     [.psAd], rdi
    ; Генерация
    call    Random
    mov     rbx, [.psAd]
    mov     [rbx], eax        ; &радиус
    call    Random
    mov     rbx, [.psAd]
    mov     [rbx+4], eax      ; &плотность фигуры

leave
ret

;----------------------------------------------
;// Случайный ввод параметров caths
;void InRndTetrahedron(void *r) {
    ;int x = Random();
    ;*((int*)r) = x;
    ;int y = Random();
    ;*((int*)(r+intSize)) = y;
;}
global InRndTetrahedron
InRndTetrahedron:
section .bss
    .ptAd  resq 1   ; адрес
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес
    mov     [.ptAd], rdi
    ; Генерация сторон
    call    Random
    mov     rbx, [.ptAd]
    mov     [rbx], rax        ; &сторона
    call    Random
    mov     rbx, [.ptAd]
    mov     [rbx+4], rax      ; &плотность фигуры

leave
ret

;----------------------------------------------
;// Случайный ввод параметров caths
;void InRndParallelepiped(void *r) {
    ;int x = Random();
    ;*((int*)r) = x;
    ;int y = Random();
    ;*((int*)(r+intSize)) = y;
    ;int z = Random();
    ;*((int*)(r+2*intSize)) = z;
    ;int w = Random();
    ;*((int*)(r+3*intSize)) = w;
;}
global InRndParallelepiped
InRndParallelepiped:
section .bss
    .ppAd  resq 1   ; адрес
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес
    mov     [.ppAd], rdi
    ; Генерация сторон
    call    Random
    mov     rbx, [.ppAd]
    mov     [rbx], eax
    call    Random
    mov     rbx, [.ppAd]
    mov     [rbx+4], eax
    call    Random
    mov     rbx, [.ppAd]
    mov     [rbx+8], eax
    call    Random
    mov     rbx, [.ppAd]
    mov     [rbx+12], eax   ; &плотность фигуры


leave
ret

;----------------------------------------------
;// Случайный ввод обобщенной фигуры
;int InRndShape(void *s) {
    ;int k = rand() % 2 + 1;
    ;switch(k) {
        ;case 1:
            ;*((int*)s) = RECTANGLE;
            ;InRndRectangle(s+intSize);
            ;return 1;
        ;case 2:
            ;*((int*)s) = TRIANGLE;
            ;InRndTriangle(s+intSize);
            ;return 1;
        ;default:
            ;return 0;
    ;}
;}
global InRndShape
InRndShape:
section .data 
    .a dq 3
    .rndNumFmt       db "Random number = %d",10,0
section .bss
    .pshape     resq    1   ; адрес фигуры
    .key        resd    1   ; ключ
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov [.pshape], rdi

    ; Формирование признака фигуры
    xor rax, rax     ;
    call rand        ; запуск генератора случайных чисел
    xor rdx, rdx     ; обнуление перед делением
    idiv qword[.a]   ; (/%) -> остаток в rdx
    mov rax, rdx     ; 0 или 1 или 2
    inc rax

    ;mov     [.key], eax
    ;mov     rdi, .rndNumFmt
    ;mov     esi, [.key]
    ;xor     rax, rax
    ;call    printf
    ;mov     eax, [.key]

    mov     rdi, [.pshape]
    mov     [rdi], rax        ; запись ключа в фигуру
    cmp eax, [typeSphere]
    je .pointRndSphere
    cmp eax, [typeRegularTetraheadron]
    je .pointRndTetrahedron
    cmp eax, [typeParallelepiped]
    je .pointRndParallelepiped
    xor rax, rax               ; код возврата = 0
    jmp     .return
.pointRndSphere:
    ; Генерация сферы
    add     rdi, 4
    call    InRndSphere
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.pointRndTetrahedron:
    ; Генерация тетраэдра
    add     rdi, 4
    call    InRndTetrahedron
    mov     eax, 1      ;код возврата = 1
    jmp     .return
.pointRndParallelepiped:
    ; Генерация параллелепипеда
    add     rdi, 4
    call    InRndParallelepiped
    mov     eax, 1      ;код возврата = 1
.return:
leave
ret

;----------------------------------------------
;// Случайный ввод содержимого контейнера
;void InRndContainer(void *c, int *len, int size) {
    ;void *tmp = c;
    ;while(*len < size) {
        ;if(InRndShape(tmp)) {
            ;tmp = tmp + shapeSize;
            ;(*len)++;
        ;}
    ;}
;}
global InRndContainer
InRndContainer:
section .bss
    .pcont  resq    1   ; адрес контейнера
    .plen   resq    1   ; адрес для сохранения числа введенных элементов
    .psize  resd    1   ; число порождаемых элементов
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi    ; сохраняется указатель на контейнер
    mov [.plen],  rsi    ; сохраняется указатель на длину
    mov [.psize], edx    ; сохраняется число порождаемых элементов
    ; В rdi адрес начала контейнера
    xor ebx, ebx         ; число фигур = 0
.loop:
    cmp ebx, edx
    jge .return
    ; сохранение рабочих регистров
    push rdi
    push rbx
    push rdx
    call InRndShape  ; ввод фигуры
    cmp  rax, 0          ; проверка успешности ввода
    jle  .return        ; выход, если признак меньше или равен 0

    pop rdx
    pop rbx
    inc rbx

    pop rdi
    add rdi, 20         ; адрес следующей фигуры
    jmp .loop
.return:
    mov rax, [.plen]    ; перенос указателя на длину
    mov [rax], ebx      ; занесение длины
leave
ret
