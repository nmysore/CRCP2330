// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.


@R1
D=M
@i
M=D
//M=0
@R2 //our product
M=0
(LOOP)
@i
D=M
@END
D; JEQ
@R1 
D=D-A
//@R2
//M=M+D 
@i
M=D
@R2
D=M
@R0
D=D+M
@R2
M=D
//@i
//M=M-1
//D=M
@LOOP
0;JMP
//D=D+M
//@R2
//M=D*/
(END)
@END 
0; JMP