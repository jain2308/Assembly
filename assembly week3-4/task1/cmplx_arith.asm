section .data

complex1:
    complex1_name db 'a'
    complex1_pad  db 7 dup(0)  
    complex1_real dq 1.0
    complex1_img  dq 2.5

complex2:
    complex2_name db 'b'
    complex2_pad  db 7 dup(0)  
    complex2_real dq 3.5
    complex2_img  dq 4.0

label_add db "Testing Addition",0
label_sub db "Testing subtraction",0
label_mul db "Testing Multiplication", 0
label_recip db "Testing Reciprocal", 0

temp_cmplx:
    temp_name db 'r'
    temp_pad  db 7 dup(0)
    temp_real dq 0.0
    temp_img  dq 0.0

section .text
    default rel
    extern print_cmplx
    global main

main:
    push rbp

    ; --- Test: Addition ---
    lea rdi, [complex2]
    lea rsi, [complex1]
    lea rdx, [temp_cmplx]
    call add_cmplx
    lea rdi, [label_add]
    lea rsi, [temp_cmplx]
    call print_cmplx  ; Expect 2.5, 1.5

    ; --- Test: Subtraction ---
    lea rdi, [complex2]
    lea rsi, [complex1]
    lea rdx, [temp_cmplx]
    call sub_cmplx
    lea rdi, [label_sub]
    lea rsi, [temp_cmplx]
    call print_cmplx  ; Expect 2.5 1.5

    ; --- Test: Multiplication ---
    lea rdi, [complex2]
    lea rsi, [complex1]
    lea rdx, [temp_cmplx]
    call mul_cmplx
    lea rdi, [label_mul]
    lea rsi, [temp_cmplx]
    call print_cmplx  ; Expect -6.500000 12.750000

    ; --- Test: Reciprocal ---
    lea rdi, [complex1]
    lea rsi, [temp_cmplx]
    call recip_cmplx
    lea rdi, [label_recip]
    lea rsi, [temp_cmplx]
    call print_cmplx  ; Reciprocal of (1 + 2.5i) = (0.137931 -0.344828i)

    pop rbp
    mov     rax, 60         ; syscall: exit
    xor     rdi, rdi        ; status 0
    syscall

add_cmplx:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to input three addresses of complex numbers subtract the complexes at the first two addresses and 
; write the result into the thrid address (source1,source2,destination) => write (source1 + source2) into destination
push rbp
mov rax, rdi
movq    xmm0, qword [rax + 8]
mov rax, rsi
movq    xmm1, qword [rax + 8]
addsd xmm0, xmm1
movq   [rdx + 8], xmm0
mov rax, rdi
movq    xmm0, qword [rax + 16]
mov rax, rsi
movq    xmm1, qword [rax + 16]
addsd xmm0, xmm1
movq    [rdx + 16], xmm0
pop rbp
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -----------------------------------
sub_cmplx:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to input three addresses of complex numbers subtract the complexes at the first two addresses and 
; write the result into the thrid address (source1,source2,destination) => write (source1 - source2) into destination
push rbp
mov rax, rdi
movq    xmm0, qword [rax + 8]
mov rax, rsi
movq    xmm1, qword [rax + 8]
subsd xmm0, xmm1
movq   [rdx + 8], xmm0
mov rax, rdi
movq    xmm0, qword [rax + 16]
mov rax, rsi
movq    xmm1, qword [rax + 16]
subsd xmm0, xmm1
movq    [rdx + 16], xmm0
pop rbp
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -----------------------------------
mul_cmplx:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to input three addresses of complex numbers multiply the complexes at the first two addresses and 
; write the result into the thrid address
push rbp
mov rax, rdi
movq    xmm0, qword [rax + 8]
movq    xmm1, qword [rax + 16]
mov rax, rsi
movq    xmm2, qword [rax + 8]
movq    xmm3, qword [rax + 16]
mulsd xmm0, xmm2
mulsd xmm1, xmm3
subsd xmm0, xmm1
movq   [rdx + 8], xmm0
mov rax, rdi
movq    xmm0, qword [rax + 8]
movq    xmm1, qword [rax + 16]
mulsd xmm0, xmm3
mulsd xmm1, xmm2
addsd xmm0, xmm1
movq   [rdx + 16], xmm0
pop rbp
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -----------------------------------
recip_cmplx:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Start of your code ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Write code to input two addresses of complex numbers find reciprocal of the complex at the first address and 
; write the result into the second address (source1,destination) => write (1/source1) into destination
push rbp
mov rax,rdi
movq xmm0, qword[rax+8]; xmm0 has r
movq xmm1, qword[rax+16]; xmm1 has c
movsd xmm2, xmm0; xmm2 has r
mulsd xmm2, xmm0; xmm2 has r^2
movsd xmm3, xmm1; xmm3 has c
mulsd xmm3, xmm1; xmm3 has c^2
addsd xmm2, xmm3; xmm2 has r^2 + c^2
divsd xmm0, xmm2; xmm0 has r/(r^2 + c ^2)
divsd xmm1, xmm2; xmm1 has c/(r^2 + c^2)
subsd xmm3, xmm3; xmm3 has 0
subsd xmm3, xmm1; xmm3 has -c/(r^2 + c^2)
movq   [rsi + 8], xmm0
movq   [rsi + 16], xmm3
pop rbp
ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  End of your code  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -----------------------------------
