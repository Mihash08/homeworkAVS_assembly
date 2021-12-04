; file.asm - использование файлов в NASM
extern printf
extern fprintf

extern VolumeSphere
extern VolumeTetrahedron
extern VolumeParallelepiped

extern  typeSphere
extern  typeRegularTetraheadron
extern  typeParallelepiped

;----------------------------------------------
;// Вывод параметров прямоугольника в файл
;void OutSphere(void *r, FILE *ofst) {
;    fprintf(ofst, "It is Rectangle: x = %d, y = %d. Volume = %g\n",
;            *((int*)r), *((int*)(r+intSize)), VolumeSphere(r));
;}
global OutSphere
OutSphere:
section .data
    .outfmt db "It is Sphere: Radius = %d Density = %d. Volume = %g", 10, 0
section .bss
    .psAd   resq  1
    .FILE   resq  1               ; временное хранение указателя на файл
    .p      resq  1               ; вычисленный объем
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.psAd], rdi          ; сохраняется адрес
    mov     [.FILE], rsi          ; сохраняется указатель на файл
    ; Вычисление объема (адрес уже в rdi)
    call    VolumeSphere
    movsd   [.p], xmm0            ; сохранение (может лишнее) периметра

    ; Вывод информации о прямоугольнике в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.psAd]        ; адрес
;     mov     esi, [rax]          ; x
;     mov     edx, [rax+4]        ; y
;     movsd   xmm0, [.p]
;     mov     rax, 1              ; есть числа с плавающей точкой
;     call    printf

    ; Вывод информации в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt          ; Формат - 2-й аргумент
    mov     rax, [.psAd]          ; адрес
    mov     rdx, [rax]            ; r
    mov     rcx, [rax+4]          ; density
    mov     rax, 1                ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
;// Вывод параметров прямоугольника в файл
;void OutSphere(void *r, FILE *ofst) {
;    fprintf(ofst, "It is Rectangle: x = %d, y = %d. Volume = %g\n",
;            *((int*)r), *((int*)(r+intSize)), VolumeSphere(r));
;}
global OutTetrahedron
OutTetrahedron:
section .data
    .outfmt db "It is Tetrahedron: Side = %d, Density = %d. Volume = %g", 10, 0
section .bss       
    .ptAd   resq  1
    .FILE   resq  1               ; временное хранение указателя на файл
    .p      resq  1               ; вычисленный объем
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.ptAd], rdi          ; сохраняется адрес тетраэдра
    mov     [.FILE], rsi          ; сохраняется указатель на файл
    ; Вычисление объема тетраэдра (адрес уже в rdi)
    call    VolumeTetrahedron
    movsd   [.p], xmm0            ; сохранение (может лишнее) объема

    ; Вывод информации о прямоугольнике в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.ptAd]        ; адрес
;     mov     esi, [rax]          ; x
;     mov     edx, [rax+4]        ; y
;     movsd   xmm0, [.p]
;     mov     rax, 1              ; есть числа с плавающей точкой

    ; Вывод информации о тетраэдре в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.ptAd]       ; адрес тетраэдра
    mov     edx, [rax]          ; a
    mov     ecx, [rax+4]        ; density
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
;// Вывод параметров прямоугольника в файл
;void OutSphere(void *r, FILE *ofst) {
;    fprintf(ofst, "It is Rectangle: x = %d, y = %d. Volume = %g\n",
;            *((int*)r), *((int*)(r+intSize)), VolumeSphere(r));
;}
global OutParallelepiped
OutParallelepiped:
section .data
    .outfmt db "It is Parallelepiped: Side A = %d, Side B = %d, Side C = %d, Density = %d. Volume = %g", 10, 0
section .bss
    .ppAd   resq  1
    .FILE   resq  1       ; временное хранение указателя на файл
    .p      resq  1               ; вычисленный объем
section .text
push rbp
mov rbp, rsp

    ; Сохранени принятых аргументов
    mov     [.ppAd], rdi        ; сохраняется адрес параллелепипеда
    mov     [.FILE], rsi          ; сохраняется указатель на файл

    ; Вычисление объема (адрес уже в rdi)
    call    VolumeParallelepiped
    movsd   [.p], xmm0            ; сохранение (может лишнее) объема

    ; Вывод информации о прямоугольнике в консоль
;     mov     rdi, .outfmt        ; Формат - 1-й аргумент
;     mov     rax, [.ppAd]        ; адрес
;     mov     esi, [rax]          ; x
;     mov     edx, [rax+4]        ; y
;     movsd   xmm0, [.p]
;     mov     rax, 1              ; есть числа с плавающей точкой

    ; Вывод информации в файл
    mov     rdi, [.FILE]
    mov     rsi, .outfmt        ; Формат - 2-й аргумент
    mov     rax, [.ppAd]      ; адрес параллелепипеда
    mov     edx, [rax]          ; a
    mov     ecx, [rax+4]        ; b
    mov      r8, [rax+8]        ; c
    mov      r9, [rax+12]       ; density
    mov     rax, 1              ; есть числа с плавающей точкой
    call    fprintf

leave
ret

;----------------------------------------------
; // Вывод параметров текущей фигуры в файл
; void OutShape(void *s, FILE *ofst) {
;     int k = *((int*)s);
;     if(k == Sphere) {
;         OutSphere(s+intSize, ofst);
;     }
;     else if(k == Tetrahedron) {
;         OutTetrahedron(s+intSize, ofst);
;     }
;     if(k == Parallelepiped) {
;         OutParallelepiped(s+intSize, ofst);
;     }
;     else {
;         fprintf(ofst, "Incorrect figure!\n");
;     }
; }
global OutShape
OutShape:
section .data
    .erShape db "Incorrect figure!", 10, 0
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес фигуры
    mov eax, [rdi]
    cmp eax, [typeSphere]
    je SphereOut
    cmp eax, [typeRegularTetraheadron]
    je TetrahedronOut
    cmp eax, [typeParallelepiped]
    je ParallelepipedOut
    mov rdi, .erShape
    mov rax, 0
    call fprintf
    jmp     return
SphereOut:
    ; Вывод сферы
    add     rdi, 4
    call    OutSphere
    jmp     return
TetrahedronOut:
    ; Вывод тетраэдра
    add     rdi, 4
    call    OutTetrahedron
    jmp     return
ParallelepipedOut:
    ; Вывод параллелепипеда
    add     rdi, 4
    call    OutParallelepiped
return:
leave
ret

;----------------------------------------------
; // Вывод содержимого контейнера в файл
; void OutContainer(void *c, int len, FILE *ofst) {
;     void *tmp = c;
;     fprintf(ofst, "Container contains %d elements.\n", len);
;     for(int i = 0; i < len; i++) {
;         fprintf(ofst, "%d: ", i);
;         OutShape(tmp, ofst);
;         tmp = tmp + shapeSize;
;     }
; }
global OutContainer
OutContainer:
section .data
    numFmt  db  "%d: ",0
section .bss
    .pcont  resq    1   ; адрес контейнера
    .len    resd    1   ; адрес для сохранения числа введенных элементов
    .FILE   resq    1   ; указатель на файл
section .text
push rbp
mov rbp, rsp

    mov [.pcont], rdi   ; сохраняется указатель на контейнер
    mov [.len],   esi     ; сохраняется число элементов
    mov [.FILE],  rdx    ; сохраняется указатель на файл

    ; В rdi адрес начала контейнера
    mov rbx, rsi            ; число фигур
    xor ecx, ecx            ; счетчик фигур = 0
    mov rsi, rdx            ; перенос указателя на файл
.loop:
    cmp ecx, ebx            ; проверка на окончание цикла
    jge .return             ; Перебрали все фигуры

    push rbx
    push rcx

    ; Вывод номера фигуры
    mov     rdi, [.FILE]    ; текущий указатель на файл
    mov     rsi, numFmt     ; формат для вывода фигуры
    mov     edx, ecx        ; индекс текущей фигуры
    xor     rax, rax,       ; только целочисленные регистры
    call fprintf

    ; Вывод текущей фигуры
    mov     rdi, [.pcont]
    mov     rsi, [.FILE]
    call OutShape           ; Получение периметра первой фигуры

    pop rcx
    pop rbx
    inc ecx                 ; индекс следующей фигуры

    mov     rax, [.pcont]
    add     rax, 20         ; адрес следующей фигуры
    mov     [.pcont], rax
    jmp .loop
.return:
leave
ret

