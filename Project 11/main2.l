/*
Submitter1 name: Yair Babayov
Submitter1 ID: 327885562
Submitter2 name: Itay Dabush
Submitter2 ID: 327514212
*/



//--------------system----------------------------
import system;
import system'io;
import system'text;
import system'collections;
import system'routines;

//--------------extentions-------------------------
import extensions;
import extensions'text;
import extensions'routines;

public nameGetter(var path)
{
    var Path := path.splitBy("\");
   
    var lengthList := Path.Length;  
    
    var newPath := Path[lengthList-1];

    var Name := newPath.splitBy(".");

    ^Name[0]; 
}



public startCompile(var dir)
{
    
    tokenFile(dir);
    
    // Get all jack files in the specified directory
    var jackFiles := dir.getFiles("*.jack");

    // Iterate over the jack files in the directory
    for (var j := 0, j < jackFiles.Length, j+=1)
    {
        var fileName := jackFiles[j]; // Get the current file name
        console.writeLine("Compiling " + fileName);
        
        var name:=nameGetter(fileName);
        var tokenFileName:=name +"T.xml";
        console.writeLine("Compilation starts for " + tokenFileName);
        // Generate the corresponding .asm file name by replacing the .jack extension with vm
        var fileName2 := fileName.replace(".jack", ".vm");
        var fileNameToken := fileName.replace(".jack", "T.xml");
        var compiler := new JackCompiler(fileNameToken, fileName2);
        compiler.compileClass(name);  // Add this line  
        console.writeLine("Compilation complete for " + name);
        console.writeLine("go check " + name + ".vm");
        console.readChar(); // Wait for user input to proceed
    }   
  
}


public program()
{

    
    var input := "";
    while (input != "x")
    {
            
    console.writeLine("please enter path of file to compile: / press x to get out");
    var path := console.readLine();
    var dir := Directory.assign(path);
    startCompile(dir);
    };
    console.writeLine("All files compiled successfully.");
    console.readChar();
}





/*-----------------------------paths: files for compiling---------------------------------------
C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\11\Average
C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\11\ComplexArrays
C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\11\ConvertToBin
C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\11\Pong
C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\11\Seven
C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\11\Square
*/
