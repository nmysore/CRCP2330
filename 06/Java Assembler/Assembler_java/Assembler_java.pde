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
   private Map<String, Integer> destTable = new HashMap<String,Integer>(100);
   private Map<String, Integer> jumpTable = new HashMap<String,Integer>(100);
     
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
 //       System.out.println("Command = " + commandType + "---Code = " + codeLine); 
       }else
       {
        if(commandType == L_COMMAND){
          if (!symbolTable.containsKey(codeLine.substring(1, codeLine.length()-1)))
            symbolTable.put(codeLine.substring(1, codeLine.length()-1), currentLine);
        }
       }

  //     System.out.println(" Finishing FirsttPass - :" + codeLine); 
       codeLine = getLine(); 
     }
     
   if (fileBuffer != null)
     {
       fileBuffer.close();
     }
   }  
   
    public void parserNextPass() throws IOException{
     String codeLine = getLine(); 
     inputLine = codeLine;
     if (inputLine == null){
       endOfFile = true;
     }
 //    System.out.println(" In ParseNextPass - :" + codeLine); 
//     String hackOut;
     int commandType; 
      if(codeLine != null){ 
       commandType = getCommand(codeLine);
       String instructionA = codeLine.substring(1);
       if(commandType == A_COMMAND){
         Integer address=0;
         String instrAddr = "";
         if(!Character.isDigit(instructionA.charAt(0))){
           if (!symbolTable.containsKey(instructionA)){
            symbolTable.put(instructionA, currentAddress);
           // System.out.println(" Instr_A - A_COMMAND:" + instructionA); 
            address = currentAddress;
           // System.out.println("hack_Out New Symbol: ");
           instrAddr = Integer.toBinaryString(address).replace(' ','0');
  //         while (instrAddr.length() < 16){
    //         instrAddr = "0" + instrAddr;
      //     }
           
           // System.out.println(String.format("%16s", Integer.toBinaryString(address).replace(' ','0')));
            currentAddress++;
           }else{
             address = symbolTable.get(instructionA);
          //   System.out.println("hack_Out Exixting Symbol: ");
             instrAddr = Integer.toBinaryString(address).replace(' ','0');
       //      System.out.println(String.format("%16s", Integer.toBinaryString(address).replace(' ','0')));
           }
         }else{
         //  System.out.println("hack_Out Non_Symbol: ");
           instrAddr = Integer.toBinaryString(Integer.parseInt(instructionA)).replace(' ','0');
       //    System.out.println(String.format("%16s", Integer.toBinaryString(Integer.parseInt(instructionA)).replace(' ','0')));
         }
         
           while (instrAddr.length() < 16){
             instrAddr = "0" + instrAddr;
           } 
           System.out.println(instrAddr);
         }else
         {
          //other command types
         //   System.out.println(" Instr_A - Other COMMAND:");
            String temp = codeLine;
            String address2 = "0b111";
           
           String tempComp = "";
           String tempDest = "";
           String tempJump = "";
           
      //    System.out.println("Command is: " + temp);
           int index = temp.indexOf(";");
       //    System.out.println(" ; index is " + index);
           if (index > 0){
             tempComp = temp.substring(0,index);
        //     System.out.println("Comp is: " + tempComp);
             tempJump = temp.substring(index+1);
        //     System.out.println("Jump is: " + tempJump);
           }
            else{
              index = temp.indexOf("=");
        //      System.out.println(" = index is " + index);
              if (index > 0){
                 tempComp = temp.substring(index+1);
         //       System.out.println("Comp is: " + tempComp);
                 tempDest = temp.substring(0,index);
         //        System.out.println("Dest is: " + tempDest);
              }
            }
                     
      //     System.out.println("Instr string = " + temp); 
         
          Integer tempAddress = compTable.get(tempComp);
     //     System.out.println("tempAddress Comp= " + tempAddress);
         if (tempAddress != null){
     //      System.out.println(Integer.toBinaryString(tempAddress));
           String compAddr = Integer.toBinaryString(tempAddress);
           while(compAddr.length() < 7){
             compAddr = "0" + compAddr;
           }
     //        System.out.println("tempAddress - Padded comp: " + compAddr);
           address2 = address2 + compAddr;  

     //      System.out.println("address 2: " + address2);
         }else
           address2 = address2 + "0000000";
         
         tempAddress = destTable.get(tempDest);
     //    System.out.println("tempAddress Dest= " + tempAddress);
         if (tempAddress != null){
           String destAddr = Integer.toBinaryString(tempAddress);
          while(destAddr.length() < 3){
             destAddr = "0" + destAddr;         
           }
     //      System.out.println("tempAddress - Padded dest: " + destAddr);
           address2 = address2 + destAddr;
           }else 
             address2 = address2 + "000";
     
          tempAddress = jumpTable.get(tempJump);
   //       System.out.println("tempAddress Jump= " + tempAddress);
         if (tempAddress != null){
   //        System.out.println("tempAddress Jump= " + tempAddress);
           String jumpAddr = Integer.toBinaryString(tempAddress);
           while(jumpAddr.length() < 3){
             jumpAddr = "0" + jumpAddr;
          
           }
    //        System.out.println("tempAddress - Padded jump: " + jumpAddr);
           address2 = address2 + jumpAddr;          
         }else
           address2 = address2 + "000";
           System.out.println(address2.substring(2));   
         }   
     }  
return;
     }

     
   
   
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
    
    compTable.put("0", Integer.parseInt("0101010", 2));
    compTable.put("1", Integer.parseInt("0111111", 2));
    compTable.put("-1",Integer.parseInt( "0111010", 2));
    compTable.put("D", Integer.parseInt("0001100" , 2));
    compTable.put("A", Integer.parseInt("0110000", 2));
    compTable.put("!D",Integer.parseInt("0001101", 2));
    compTable.put("!A",Integer.parseInt("0110001", 2));
    compTable.put("-D",Integer.parseInt("0001111", 2));
    compTable.put("-A",Integer.parseInt("0110011", 2));
    compTable.put("D+1",Integer.parseInt("0011111", 2));
    compTable.put("A+1",Integer.parseInt("0110111", 2));
    compTable.put("D-1",Integer.parseInt("0001110", 2));
    compTable.put("A-1",Integer.parseInt("0110010", 2));
    compTable.put("D+A",Integer.parseInt("0000010" , 2));
    compTable.put("D-A",Integer.parseInt("0010011", 2));
    compTable.put("A-D",Integer.parseInt("0000111", 2));
    compTable.put("D&A",Integer.parseInt("0000000", 2));
    compTable.put("D|A",Integer.parseInt("0010101", 2));
    compTable.put("M", Integer.parseInt("1110000", 2));
    compTable.put("!M",Integer.parseInt("1110001", 2));
    compTable.put("-M",Integer.parseInt("1110011",2));
    compTable.put("M+1",Integer.parseInt("1110111", 2));
    compTable.put("M-1",Integer.parseInt("1110010", 2));
    compTable.put("D+M",Integer.parseInt("1000010", 2));
    compTable.put("D-M",Integer.parseInt("1010011", 2));
    compTable.put("M-D",Integer.parseInt("1000111", 2));
    compTable.put("D&M",Integer.parseInt("1000000", 2));
    compTable.put("D|M",Integer.parseInt("1010101", 2));
    
   }
  
  private void initializeDest(Map destTable){
     destTable.put("null", Integer.parseInt("000",2));
     destTable.put("M", Integer.parseInt("001",2));
     destTable.put("D", Integer.parseInt("010",2));
     destTable.put("MD",Integer.parseInt("011",2));
     destTable.put("A",Integer.parseInt("100", 2));
     destTable.put("AM",Integer.parseInt("101", 2));
     destTable.put("AD",Integer.parseInt("110",2));
     destTable.put("AMD",Integer.parseInt("111",2));
  }
  
  private void initializeJump(Map jumpTable){ 
     jumpTable.put("null",Integer.parseInt("000",2));
     jumpTable.put("JGT", Integer.parseInt("001", 2));
     jumpTable.put("JEQ", Integer.parseInt("010",2));
     jumpTable.put("JGE", Integer.parseInt("011", 2));
     jumpTable.put("JLT", Integer.parseInt("100", 2));
     jumpTable.put("JNE", Integer.parseInt("101", 2));
     jumpTable.put("JLE", Integer.parseInt("110",2));
     jumpTable.put("JMP", Integer.parseInt("111",2));
  }
  
  public String getLine() throws IOException{
    String line = "Error";
    line = fileBuffer.readLine();
//    System.out.println("getLine: " + line);
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

void setup() { 
 try{
  Assembler aAssembler = new Assembler("C:\\assemblyin.txt");
  aAssembler.parserFirstPass(); 
//  System.out.println("inputLIne after first pass: " + aAssembler.inputLine);
//  System.out.println("fileBuffer after first pass: " + aAssembler.fileBuffer);
  aAssembler.fileBuffer = new BufferedReader(new FileReader(aAssembler.file));
//  System.out.println("fileBuffer after init: " + aAssembler.fileBuffer);
  
  while(!aAssembler.endOfFile){
   aAssembler.parserNextPass();
//  System.out.println(aAssembler.inputLine);
//  System.out.println(aAssembler.inputLine);
 }
 } 
 catch(IOException ex1){
   ex1.printStackTrace();
 }
 return;
}