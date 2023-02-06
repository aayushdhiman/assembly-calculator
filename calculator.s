#
# Usage: ./calculator <op> <arg1> <arg2>
#

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

# int main(int argc, char argv[][])
main:
  # Function prologue
  enter $0, $0

  # Variable mappings:
  # op -> %r12
  # arg1 -> %r13
  # arg2 -> %r14
  movq 8(%rsi), %r12  # op = argv[1]
  movq 16(%rsi), %r13 # arg1 = argv[2]
  movq 24(%rsi), %r14 # arg2 = argv[3]

  # Hint: Convert 1st operand to long int
  movq %r13, %rdi
  call atol
  movq %rax, %r13

  # Hint: Convert 2nd operand to long int
  movq %r14, %rdi
  call atol
  movq %rax, %r14

  # Hint: Copy the first char of op into an 8-bit register
  # i.e., op_char = op[0] - something like mov 0(%r12), ???

  # if (op_char == '+') {
  #   ...
  # }
  # else if (op_char == '-') {
  #  ...
  # }
  # ...
  # else {
  #   // print error
  #   // return 1 from main
  # }
  
  mov 0(%r12), %cl
 
  mov $plus, %r10
  movb 0(%r10), %dl
  cmpb %dl, %cl
  je add

  mov $minus, %r10
  movb 0(%r10), %dl
  cmpb %dl, %cl
  je subtract

  mov $times, %r10
  movb 0(%r10), %dl
  cmpb %dl, %cl
  je multiply

  mov $quotient, %r10
  movb 0(%r10), %dl
  cmpb %dl, %cl
  je divide

  movq $error, %rsi
  movq $format, %rdi
  call printf

  # Function epilogue
  leave
  ret

add:
  addq %r13, %r14
  movq %r14, %rsi
  movq $format, %rdi
  call printf
  leave
  ret

subtract:
  subq %r14, %r13
  movq %r13, %rsi
  movq $format, %rdi
  call printf
  leave
  ret

divide:
  cmpq $0, %r13
  jle negdivide

  movq $0, %rdx
  movq %r13, %rax
  idiv %r14
  movq %rax, %rsi
  movq $format, %rdi
  call printf
  leave
  ret

negdivide:
  movq $0, %rdx
  imul $-1, %r13
  movq %r13, %rax
  idiv %r14
  imul $-1, %rax
  movq %rax, %rsi
  movq $format, %rdi
  call printf
  leave
  ret

multiply:
  imul %r13, %r14
  movq %r14, %rsi
  movq $format, %rdi
  call printf
  leave
  ret


# Start of the data section
.data
plus: 
  .asciz "+"

minus:
  .asciz "-"

times:
  .asciz "*"

quotient:
  .asciz "/"

format: 
  .asciz "%ld\n"

error:
  .asciz "Unknown operand\n"
