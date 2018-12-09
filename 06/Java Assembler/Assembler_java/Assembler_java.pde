import java.io.FileReader; 
import java.io.IOException; 
import java.io.BufferedReader; 



class Assembler {
     String inputLine = null; 
     Boolean endOfFile = false;
     String file;
     BufferedReader fileBuffer; 
     
  public Assembler(String fileName) throws IOException{
   file = fileName;  
   if (file != null)
     
  fileBuffer = new BufferedReader(new FileReader(file));
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