;------------------------------------------------------------------------------
; perimeter.asm - единица компиляции, вбирающая функции вычисления периметра
;------------------------------------------------------------------------------

extern printf
extern fprintf

;----------------------------------------------
; Вычисление периметра прямоугольника
;double PerimeterRectangle(void *r) {
;    return 2.0 * (*((int*)r)
;           + *((int*)(r+intSize)));
;}
global VolumeSphere
VolumeSphere:
section .data
    pi dq 3.1415
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес сферы
    movsd xmm0, [pi]
    mov eax, [rdi]
    cvtsi2sd xmm1, eax
    mulsd xmm0, xmm1
    mulsd xmm0, xmm1
    mulsd xmm0, xmm1
    mov eax, 4
    cvtsi2sd xmm1, eax
    mulsd xmm0, xmm1
    mov eax, 3
    cvtsi2sd xmm1, eax
    divsd xmm0, xmm1

leave
ret

;----------------------------------------------
; Вычисление периметра прямоугольника
;double PerimeterRectangle(void *r) {
;    return 2.0 * (*((int*)r)
;           + *((int*)(r+intSize)));
;}
global VolumeTetrahedron
VolumeTetrahedron:
section .data
    sqrt2 dq 1.414
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес тетраэдра
    movsd xmm0, [sqrt2]
    mov eax, 12
    cvtsi2sd xmm1, eax
    divsd xmm0, xmm1
    mov eax, [rdi]
    cvtsi2sd xmm1, eax
    mulsd xmm0, xmm1
    mulsd xmm0, xmm1
    mulsd xmm0, xmm1


leave
ret

;----------------------------------------------
; Вычисление периметра прямоугольника
;double PerimeterRectangle(void *r) {
;    return 2.0 * (*((int*)r)
;           + *((int*)(r+intSize)));
;}
global VolumeParallelepiped
VolumeParallelepiped:
section .text
push rbp
mov rbp, rsp

    ; В rdi адрес параллелепипеда
    mov eax, [rdi]
    cvtsi2sd xmm0, eax
    mov eax, [rdi+4]
    cvtsi2sd xmm1, eax
    mulsd xmm0, xmm1
    mov eax, [rdi+8]
    cvtsi2sd xmm1, eax
    mulsd xmm0, xmm1

leave
ret