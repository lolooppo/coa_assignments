.intel_syntax noprefix

.section .data
inputf: .asciz "%d"        # format string for scanf
outputf: .asciz "sum=%f\n" # format string for printf
one: .double 1.0            # constant 1.0
counter: .double 1.0         
curr: .double 0.0           # current value in the loop
n: .int 0                    # Input variable for the loop
t: .int 0                  
final: .double 1.0          
total: .double 0.0          
d: .double 2.0             

.section .text
.globl _main

_main:
    sub ESP, 8              # Allocate space for local variables on the stack

    push OFFSET n
    push OFFSET inputf
    call _scanf             # Read an integer from the user
    add ESP, 8              

    mov ECX, n              # Initialize loop counter with user input

    for:
        FLD QWORD PTR one   
        FDIV QWORD PTR counter 
        FSTP QWORD PTR d

        finit                # Initialize FPU
        mov t, ECX           # Move loop counter to a temporary variable
        fild dword ptr t     # Load loop counter onto the FPU stack
        FSTP QWORD PTR curr  # Store loop counter in curr

        FLD QWORD PTR d      # Load d onto the FPU stack
        FADD QWORD PTR curr  # Add curr to d and store the result in total
        FSTP QWORD PTR total

        FLD QWORD PTR final  # Load final onto the FPU stack
        FMUL QWORD PTR total # Multiply final by total and store the result in final
        FSTP QWORD PTR final

        FLD QWORD PTR one    
        FADD QWORD PTR counter 
        FSTP QWORD PTR counter

        loop for              

    push OFFSET outputf
    push final
    call _printf            # Print the result
    add ESP, 12             # Clean up the stack

    add ESP, 8              # Clean up the space for local variables
    ret