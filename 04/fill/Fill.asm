// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.


//@SCREEN
//M=-1
//@16512
//M=-1



@8192 //512 pixels of 16 words each
D=A
@numpixels
M=D
//@currentpixel
//M=0

@SCREEN
D=A
@currentpixel 
M=D
//@SCREEN
//M=0
//M=-1

(LOOP)
@24576
D=M
@BLACK
D; JNE


(BLACK)
@scrncolor
M=-1
D=M

(WHITE)
@scrncolor
M=0
D=M

@currentpixel
A=D
M=M+1

@numpixels
M=M-1
D=M

@LOOP
D; JGT

(END)
@END 
0; JMP

