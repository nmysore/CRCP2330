import java.io.FileReader; 
import java.io.IOException; 
import java.io.BufferedReader; 
import java.util.HashMap;
import java.util.Map;
import java.io.PrintStream; 
import java.io.OutputStream;
import java.io.FileOutputStream;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.Scanner; 





class Assembler {
     String inputLine = null; 
     Boolean endOfFile = false;
     String file;
     BufferedReader fileBuffer; 
     WriteToFile fileWriter;
     
  //   PrintStream hackOutFile = new PrintStream(new File("hackOutputFile.hack"));
  //   PrintStream console = System.out;
     
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
 //  String outFile = fileName.substring(0,fileName.indexOf(".")) + ".hack";
   if (file != null) {  
      fileBuffer = new BufferedReader(new FileReader(file));
    fileWriter = new WriteToFile("C:\\Users\\Nishad\\Documents\\SMU-Senior Year - Semester 1\\CRCP_2330_nand2tetris\\rect.hack"); //Hardcode to where you want exported
  //   fileWriter = new WriteToFile("C:\\" + outFile); //Hardcode to where you want exported
   //   fileWriter.initialize(file+".hack");
   }
  
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
       }else
       {
        if(commandType == L_COMMAND){
          if (!symbolTable.containsKey(codeLine.substring(1, codeLine.length()-1)))
            symbolTable.put(codeLine.substring(1, codeLine.length()-1), currentLine);
        }
       }
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
     String comments = "\\";
   // if (inputLine.indexOf("/") != -1){
     if (inputLine != null && inputLine.contains(comments)){
      return;
    }
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
              symbolTable.put(instructionA, currentAddress); // new symbol, add to table
              address = currentAddress;
              instrAddr = Integer.toBinaryString(address).replace(' ','0');           
              currentAddress++;
           }else{
             address = symbolTable.get(instructionA); // already exists;
             instrAddr = Integer.toBinaryString(address).replace(' ','0');
           }
         }else{
         //  Non_Symbol A Instruction: ");
           instrAddr = Integer.toBinaryString(Integer.parseInt(instructionA)).replace(' ','0');
         }
         
           while (instrAddr.length() < 16){
             instrAddr = "0" + instrAddr;
           } 
     //      System.setOut(console);
           System.out.println(instrAddr);
           fileWriter.Write(instrAddr);
           
     //      System.setOut(hackOutFile);
     //      System.out.println(instrAddr);
         }else
         {
          //other command types
            String temp = codeLine;
            String address2 = "0b111";
           
           String tempComp = "";
           String tempDest = "";
           String tempJump = "";
           
           int index = temp.indexOf(";");
           if (index > 0){
             tempComp = temp.substring(0,index);
             tempJump = temp.substring(index+1);
           }
            else{
              index = temp.indexOf("=");
              if (index > 0){
                 tempComp = temp.substring(index+1);
                 tempDest = temp.substring(0,index);
              }
            }
                              
         Integer tempAddress = compTable.get(tempComp);
         if (tempAddress != null){
           String compAddr = Integer.toBinaryString(tempAddress);
           while(compAddr.length() < 7){
             compAddr = "0" + compAddr;
           }
           address2 = address2 + compAddr;  

         }else
           address2 = address2 + "0000000";
         
         tempAddress = destTable.get(tempDest);
         if (tempAddress != null){
           String destAddr = Integer.toBinaryString(tempAddress);
          while(destAddr.length() < 3){
             destAddr = "0" + destAddr;         
           }
           address2 = address2 + destAddr;
           }else 
             address2 = address2 + "000";
     
         tempAddress = jumpTable.get(tempJump);
         if (tempAddress != null){
           String jumpAddr = Integer.toBinaryString(tempAddress);
           while(jumpAddr.length() < 3){
             jumpAddr = "0" + jumpAddr;         
           }
           address2 = address2 + jumpAddr;          
         }else
           address2 = address2 + "000";
           
   //        System.setOut(console);
           System.out.println(address2.substring(2)); 
           fileWriter.Write(address2.substring(2));
     //      System.setOut(hackOutFile);
     //      System.out.println(address2.substring(2));
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
    if (line == null) {
      fileBuffer.close();
      return line;
    }
    return line.trim();
}
  
  
  public int getCommand(String codeLine){
    int commandType = 9; //Error situation 
     if(codeLine.indexOf("@") == 0){
           commandType = A_COMMAND; 
      }else 
      {
      // if(codeLine.charAt(0) == '('){
       if(codeLine.indexOf("(") == 0){
         commandType = L_COMMAND;
       }else
             {
               commandType = C_COMMAND; 
             }
      }
    return commandType; 
  }
  
}


  public class WriteToFile {
 
            
        BufferedWriter bufferedWriter = null;
        File myFile = null; //new File(fileName);
        Writer writer = null; //new FileWriter(myFile);
        // bufferedWriter = new BufferedWriter(writer);
        
  public WriteToFile(String fileName ) {
        try {
           // String strContent = "This example shows how to write string content to a file";
              myFile = new File(fileName);
            // check if file exist, otherwise create the file before writing
              if (!myFile.exists()) {
                myFile.createNewFile();
            }
            writer = new FileWriter(myFile);
            bufferedWriter = new BufferedWriter(writer);
          //  bufferedWriter.write(strContent);
        } catch (IOException e) {
            e.printStackTrace();
        } 
    }
    
    public void Write(String hackOutput) throws IOException{
      
       bufferedWriter.write(hackOutput);
       bufferedWriter.newLine();
       
     }
     
     public void Close(){
           try{
                if(bufferedWriter != null) bufferedWriter.close();
            } catch(Exception ex){
                 
            }      
     }
   }


void setup() { 
  
//  Scanner user_input = new Scanner(System.in);
//  String fileName;
//  System.out.print("Enter file name to be compiled using full path: ");
//  fileName = user_input.next(); 
//  user_input.close();
 try{
  
  Assembler aAssembler = new Assembler("C:\\assembly.txt"); //hardcode asm file here you want tested 
//  System.out.println("Input file is: " + fileName);
 // Assembler aAssembler = new Assembler(fileName);
  aAssembler.parserFirstPass(); 
  aAssembler.fileBuffer = new BufferedReader(new FileReader(aAssembler.file));
  
  while(!aAssembler.endOfFile){
   aAssembler.parserNextPass();
   }
  aAssembler.fileWriter.Close();
 } 
 catch(IOException ex1){
   ex1.printStackTrace();
 }
 
 return;
}