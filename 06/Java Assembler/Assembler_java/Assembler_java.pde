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
   if (file == null)
     
  fileBuffer = new BufferedReader(new FileReader(file));
 //inputLine = getLine();
  }
  
  
  public String getLine() throws IOException{
    String line;
    while(true) {
      line = fileBuffer.readLine();
      if (line == null) {
        fileBuffer.close();
        return null;
      }
      if (line.length() == 0)
        continue;
      return line;
    }
  }

}

 void setup(String args[]) {
   
 if(args.length == 0) {
  System.err.println("Specify a file name");
  return; 
 }else 
 {
  if(args.length > 1) {
  System.err.println("Specify only 1 file");
  return;   
  } 
 }
 String inputLine = null;
 String file = args[0];
 
 try{
  Assembler aAssembler = new Assembler(file);
 while(true){
 inputLine =  aAssembler.getLine();
 }
 } 
 catch(IOException ex1){
   ex1.printStackTrace();
 }

 if (inputLine == null)
 return;

 return;
}