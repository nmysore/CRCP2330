import java.io.FileReader; 
import java.io.IOException; 
import java.io.BufferedReader; 
import java.util.HashMap;
import java.util.Map;

class Assembler {
     String inputLine = null; 
     Boolean endOfFile = false;
     String file;
     BufferedReader fileBuffer; 
     
     int A_COMMAND = 0;
     int C_COMMAND = 1;
     int L_COMMAND = 2; 
     
     int currentLine = 0; 
     int currentAddress = 16; //address 16 to 16383 are available for non=predefined symbols
     
   private Map<String, Integer> symbolTable = new HashMap<String,Integer>(100);
   private Map<String, Integer > compTable = new HashMap<String,Integer>(100);
   private Map<String, String> destTable = new HashMap<String,String>(100);
   private Map<String, String> jumpTable = new HashMap<String,String>(100);
     
  public Assembler(String fileName) throws IOException{
   file = fileName;  
   if (file != null)
     
  fileBuffer = new BufferedReader(new FileReader(file));
  
  initializeSymbols(symbolTable); 
  initializeComp(compTable);
  initializeDest(destTable);
  initializeJump(jumpTable); 
}


  public void parserFirstPass() throws IOException{
     String codeLine = getLine(); 
     int commandType; 
     while(codeLine != null){
       commandType = getCommand(codeLine);
       if(commandType == A_COMMAND || commandType == C_COMMAND){
         currentLine++;
        System.out.println("Command = " + commandType + "---Code = " + codeLine); 
        // System.out.println(codeLine);
       // codeLine = getLine(); 
       }else
       {
        if(commandType == L_COMMAND){
          if (!symbolTable.containsKey(codeLine.substring(1, codeLine.length()-1)))
            symbolTable.put(codeLine.substring(1, codeLine.length()-1), currentLine);
        }
       }

       System.out.println(" Finishing FirsttPass - :" + codeLine); 
       codeLine = getLine(); 
     }
     
   if (fileBuffer != null)
     {
       fileBuffer.close();
     }
 //    fileBuffer = new BufferedReader(new FileReader(file));
   }  
   
    public void parserNextPass() throws IOException{
     String codeLine = getLine(); 
     inputLine = codeLine;
     if (inputLine == null){
       endOfFile = true;
     }
     System.out.println(" In ParseNextPass - :" + codeLine); 
//     String hackOut;
     int commandType; 
//     while(codeLine != null){
      if(codeLine != null){ 
       commandType = getCommand(codeLine);
       String instructionA = codeLine.substring(1);
       if(commandType == A_COMMAND){
 //        String instructionA = codeLine.substring(1);
         Integer address=0;
         if(!Character.isDigit(instructionA.charAt(0))){
           if (!symbolTable.containsKey(instructionA)){
            symbolTable.put(instructionA, currentAddress);
            System.out.println(" Instr_A - A_COMMAND:" + instructionA); 
            address = currentAddress;
            System.out.println("hack_Out New Symbol: ");
            System.out.println(String.format("%16s", Integer.toBinaryString(address).replace(' ','0')));
            currentAddress++;
           }else{
             address = symbolTable.get(instructionA);
             System.out.println("hack_Out Exixting Symbol: ");
             System.out.println(String.format("%16s", Integer.toBinaryString(address).replace(' ','0')));
           }
         }else{
           System.out.println("hack_Out Non_Symbol: ");
           System.out.println(String.format("%16s", Integer.toBinaryString(Integer.parseInt(instructionA)).replace(' ','0')));
         }
         }else
         {
          //if(commandType == L_COMMAND){
            System.out.println(" Instr_A - Other COMMAND:");
            String temp = instructionA; 
           temp = temp.replaceAll(".*=", "");
           temp = temp.replaceAll(";,*", "");
           System.out.println("comp string = " + temp); 
           System.out.println(compTable.get(temp)); 
        //  String tempAddress = Integer.toBinaryString(compTable.get(temp));
         Integer tempAddress = compTable.get(temp);
         System.out.println("tempAddress = " + tempAddress);
         System.out.println(Integer.toBinaryString(tempAddress));
         String address2 = "0b111" + Integer.toBinaryString(tempAddress); 
         System.out.println("address 2: " + address2);
         tempAddress = 
     //     System.out.println("Shifted Address: " + address2);
   //        Integer tempInt = Integer.parseInt(tempAddress);
    //       System.out.println("tempInt = " + tempInt);
        //    Integer comp = Integer.parseInt(compTable.get(temp));
          //  System.out.println("comp string = " + temp);
       //     System.out.println("comp = " + comp);
        //    Integer dest = Integer.parseInt(destTable.get(instructionA));
        //    System.out.println("dest = " + dest);
        //    Integer jump = Integer.parseInt(jumpTable.get(instructionA));
        //    System.out.println("jump = " + jump);
        //    Integer address2 = 0b1110000000000000 + (comp << 6) + (dest << 3) + jump; 
         //   System.out.println(String.format("%16s", Integer.toBinaryString(address2).replace(' ','0')));
         //   Integer address2 = 0b1110000000000000 + (compTable.get(instructionA) << 6) + (destTable.get(instructionA) << 3) + (jumpTable.get(instructionA)); 
        //  }
       // System.out.println("Command = " + commandType + " --- Code = " + codeLine); 
        // System.out.println(codeLine);
       // codeLine = getLine(); 
       }
     }
   //    codeLine = getLine(); 
      // System.out.println(String.format("%16s", Integer.toBinaryString(address).replace(' ','0')));
return;
     }
//   }
     
   
   
  private void initializeSymbols(Map hashTable){
    
    //mapping addresses of predefined symbols 
    hashTable.put("SP", 0);
    hashTable.put("LCL", 1);
    hashTable.put("ARG", 2);
    hashTable.put("THIS", 3);
    hashTable.put("THAT", 4);
    
    hashTable.put("R0", 0);
    hashTable.put("R1", 1);
    hashTable.put("R2", 2);
    hashTable.put("R3", 3);
    hashTable.put("R4", 4);
    hashTable.put("R5", 5);
    hashTable.put("R6", 6);
    hashTable.put("R7", 7);
    hashTable.put("R8", 8);
    hashTable.put("R9", 9);
    hashTable.put("R10", 10);
    hashTable.put("R11", 11);
    hashTable.put("R12", 12);
    hashTable.put("R13", 13);
    hashTable.put("R14", 14);
    hashTable.put("R15", 15);
    
    hashTable.put("SCREEN", 16384);
    hashTable.put("KBD", 24576);
  }
  
   private void initializeComp(Map compTable){
   //mapping comps using binary literals
    compTable.put("M", Integer.parseInt("1110000", 2));
    compTable.put("0", Integer.parseInt("0101010", 2));
    compTable.put("D", Integer.parseInt("0001100" , 2));
    compTable.put("D+A", Integer.parseInt("0000010" , 2));
 /*   compTable.put("1", "0b0111111");
    compTable.put("-1", "0b0111010");
    compTable.put("D", "0b0001100");
    compTable.put("A", "0b0110000");
    compTable.put("!D", "0b0001101");
    compTable.put("!A", "0b0110001");
    compTable.put("-D", "0b0001111");
    compTable.put("-A", "0b0110011");
    compTable.put("D+1", "0b0011111");
    compTable.put("A+1", "0b0110111");
    compTable.put("D-1", "0b0001110");
    compTable.put("A-1", "0b0110010");
    compTable.put("D+A", "0b0000010");
    compTable.put("D-A", "0b0010011");
    compTable.put("A-D", "0b0000111");
    compTable.put("D&A", "0b0000000");
    compTable.put("D|A", "0b0010101");
    compTable.put("M", "0b1110000");
    compTable.put("!M", "0b1110001");
    compTable.put("-M", "0b1110011");
    compTable.put("M+1", "0b1110111");
    compTable.put("M-1", "0b1110010");
    compTable.put("D+M", "0b1000010");
    compTable.put("D-M", "0b1010011");
    compTable.put("M-D", "0b1000111");
    compTable.put("D&M", "0b1000000");
    compTable.put("D|M", "0b1010101");*/
    
   }
  
  private void initializeDest(Map destTable){
     destTable.put("null", "0b000");
     destTable.put("M", "0b001");
     destTable.put("D", "0b010");
     destTable.put("MD", "0b011");
     destTable.put("A", "0b100");
     destTable.put("AM", "0b101");
     destTable.put("AD", "0b110");
     destTable.put("AMD", "0b111");
  }
  
  private void initializeJump(Map jumpTable){ 
     jumpTable.put("null", "0b000");
     jumpTable.put("JGT", "0b001");
     jumpTable.put("JEQ", "0b010");
     jumpTable.put("JGE", "0b011");
     jumpTable.put("JLT", "0b100");
     jumpTable.put("JNE", "0b101");
     jumpTable.put("JLE", "0b110");
     jumpTable.put("JMP", "0b111");
  }
  
  public String getLine() throws IOException{
    String line = "Error";
    line = fileBuffer.readLine();
    System.out.println("getLine: " + line);
    if (line == null) {
      fileBuffer.close();
      return line;
    }
    return line;
}
  
  
  public int getCommand(String codeLine){
    int commandType = 9; //Error situation 
      if(codeLine.charAt(0) == '@'){
         commandType = A_COMMAND; 
      }else 
      {
       if(codeLine.charAt(0) == '('){
         commandType = L_COMMAND;
       }else
             {
               commandType = C_COMMAND; 
             }
      }
    return commandType; 
  }
  
}

// void setup(String args[]) {
void setup() { 
//   BufferedReader fileBuffer; 
//  fileBuffer = createReader("assemblyin.txt");
 /* if(args.length == 0) {
  System.err.println("Specify a file name");
  return; 
 }else 
 {
  if(args.length > 1) {
  System.err.println("Specify only 1 file");
  return;   
  } 
 }*/
 //String inputLine = null;
// Boolean eof = false;
// String file = args[0];
 
 try{
  Assembler aAssembler = new Assembler("C:\\assemblyin.txt");
  aAssembler.parserFirstPass(); 
  System.out.println("inputLIne after first pass: " + aAssembler.inputLine);
  System.out.println("fileBuffer after first pass: " + aAssembler.fileBuffer);
  aAssembler.fileBuffer = new BufferedReader(new FileReader(aAssembler.file));
  System.out.println("fileBuffer after init: " + aAssembler.fileBuffer);
  
  while(!aAssembler.endOfFile){
  //inputLine =  aAssembler.getLine();
   aAssembler.parserNextPass();
   /*if (inputLine == null){
     eof=true;
     //continue;
  }/*else
  {
   aAssembler.parserNextPass(); 
  }*/
  System.out.println(aAssembler.inputLine);
  //remove comments
//  inputLine = inputLine.replaceAll("\\s","");
 // inputLine = inputLine.replaceAll("//","");
 // inputLine = inputLine.replaceAll("/\\*","");
  System.out.println(aAssembler.inputLine);

    
 }
 } 
 catch(IOException ex1){
   ex1.printStackTrace();
 }
// System.out.println(inputLine);
 return;
}