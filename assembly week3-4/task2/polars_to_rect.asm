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

polar_complx:
    polar_complx_name db 'c'
    polar_complx_pad db 7 dup(0)
    polar_complx_mag dq 10.0
    polar_complx_ang dq 0.0001

fmt db "%s => %f %f", 10, 0     ;
label_polar2rect db "Testing polars to rectangular",0
label_exp db "Testing exp",0
label_sin db "Testing sin",0
label_cos db "Testing cos",0

;;;;;;;;;;;;;
five dq 5.0
seven dq 7.0
zero dq 0.0
six dq 6.0
two dq 2.0
one dq 1.0
temp dq 0.0
;;;; Fill other constants needed 
;;;;;;;;;;;;;

temp_cmplx:
    temp_name db 'r'
    temp_pad  db 7 dup(0)
    temp_real dq 0.0
    temp_img  dq 0.0

section .text
    default rel
    extern print_cmplx,print_float
    global main

main:
    push rbp
    
    ; ; --- Test: Polar to Rectangular ---
    lea rdi, [polar_complx]         ; pointer to input polar struct
    lea rsi, [temp_cmplx]     ; pointer to output rect struct
    
    call polars_to_rect

    lea rdi, [label_polar2rect]
    lea rsi, [temp_cmplx]
    call print_cmplx          ; should show converted rectangular form

    ; --- Test: exp ---
    movups xmm0, [two]
    mov rdi, 0x6

    call exp

    movups [temp],xmm0 
    lea rdi, [label_exp]
    lea rsi , [temp]
    call print_float

    ; --- Test: sin ---
    movups xmm0, [two]

    call sin

    movups [temp],xmm0 
    lea rdi, [label_sin]
    lea rsi , [temp]
    call print_float

    ; --- Test: cos ---
    movups xmm0, [two]
    call cos

    movups [temp],xmm0 
    lea rdi, [label_cos]
    lea rsi , [temp]
    call print_float

    mov     rax, 60         ; syscall: exit
    xor     rdi, rdi        ; status 0
    syscall


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; FILL FUNCTIONS BELOW ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; -----------------------------------
polars_to_rect:
push rbp
mov rax, rdi
;xmm0 has theta
;xmm4 has r
;xmm5 has theta always
movq    xmm0, qword [rdi + 16]
movq    xmm4, qword [rdi + 8]
movq xmm5, xmm0
call cos
mulsd xmm0, xmm4
movq    [rsi + 8], xmm0
movq xmm0, xmm5
call sin
mulsd xmm0, xmm4
movq    [rsi + 16], xmm0
pop rbp
ret
;-------------------------------------------------
exp:
; xmm0 has the base
; rdi has the power
; rbx has 0 which is for i
; xmm1 has temp which is intialised to 1
; rcx has 1 always
push rbp
mov rbx, [zero]
lea rax, [one]
movq    xmm1, qword [rax]
mov rcx, 1
exp_loop:
cmp rbx, rdi
jge exp_loop_end
mulsd xmm1, xmm0
add rbx, rcx
jmp exp_loop
exp_loop_end:
movq    xmm0, xmm1
pop rbp
ret
;-------------------------------------------------
sin:
push rbp
; xmm3 has the value of theta always
movq xmm2, xmm0
movq xmm3, xmm0
mov rdi, 3
call exp
; xmm0 has theta^3
divsd xmm0, [six]; xmm0 now has theta^3/6
subsd xmm2, xmm0; xmm2 has the required expression until now
movq xmm0, xmm3
mov rdi, 5
call exp
divsd xmm0, [six]
divsd xmm0, [five]
divsd xmm0, [two]
divsd xmm0, [two]
addsd xmm2, xmm0
movq xmm0, xmm3
mov rdi, 7
call exp
divsd xmm0, [seven]
divsd xmm0, [six]
divsd xmm0, [six]
divsd xmm0, [five]
divsd xmm0, [two]
divsd xmm0, [two]
subsd xmm2, xmm0
movq xmm0, xmm2
pop rbp
ret
cos:
push rbp
; xmm3 has the value of theta always
movq xmm2, [one]
movq xmm3, xmm0
mov rdi, 2
call exp
; xmm0 has theta^3
divsd xmm0, [two]; xmm0 now has theta^3/6
subsd xmm2, xmm0; xmm2 has the required expression until now
movq xmm0, xmm3
mov rdi, 4
call exp
divsd xmm0, [six]
divsd xmm0, [two]
divsd xmm0, [two]
addsd xmm2, xmm0
movq xmm0, xmm3
mov rdi, 6
call exp
divsd xmm0, [six]
divsd xmm0, [six]
divsd xmm0, [five]
divsd xmm0, [two]
divsd xmm0, [two]
subsd xmm2, xmm0
movq xmm0, xmm2
pop rbp
ret
;-------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; CODE ENDS HERE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
