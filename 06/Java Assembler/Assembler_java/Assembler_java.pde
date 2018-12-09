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
     
   private Map<String, Integer> symbolTable = new HashMap<String,Integer>(100);
     
     
  public Assembler(String fileName) throws IOException{
   file = fileName;  
   if (file != null)
     
  fileBuffer = new BufferedReader(new FileReader(file));
  
  initializeSymbols(symbolTable);
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
  
  public String getLine() throws IOException{
    String line = "Error";
    line = fileBuffer.readLine();
    if (line == null) {
      fileBuffer.close();
      return line;
    }
    return line;
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
 String inputLine = null;
 Boolean eof = false;
// String file = args[0];
 
 try{
  Assembler aAssembler = new Assembler("C:\\assemblyin.txt");
  while(!eof){
  inputLine =  aAssembler.getLine();
  if (inputLine == null){
   eof=true;
   continue;
  }
  System.out.println(inputLine);
  //remove comments
  inputLine = inputLine.replaceAll("\\s","");
  inputLine = inputLine.replaceAll("//","");
  inputLine = inputLine.replaceAll("/\\*","");
  System.out.println(inputLine);
 }
 } 
 catch(IOException ex1){
   ex1.printStackTrace();
 }
// System.out.println(inputLine);
 return;
}