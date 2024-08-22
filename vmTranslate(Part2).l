/*
Submitter1 name: Yair Babayov
Submitter1 ID:327885562
Submitter2 name: Itay Dabush
Submitter2 ID:327514212
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

//---------push methods---------------------------
public writePush(var items, var writer,var fileName)
{
    var func := items[1];
    func =>
    "constant" {
        writer.writeLine("//comment push const");
        writer.writeLine("@" + items[2]); 
        writer.writeLine("D=A"); 
        writer.writeLine("@SP"); 
        writer.writeLine("A=M"); 
        writer.writeLine("M=D"); 
        writer.writeLine("@SP"); 
        writer.writeLine("M=M+1"); 
    }
    "local" { 
        writer.writeLine("@LCL"); 
        writer.writeLine("D=M"); 
        writer.writeLine("@" + items[2]); 
        writer.writeLine("A=D+A"); 
        writer.writeLine("D=M"); 
        writer.writeLine("@SP"); 
        writer.writeLine("A=M"); 
        writer.writeLine("M=D"); 
        writer.writeLine("@SP"); 
        writer.writeLine("M=M+1"); 
    }
    "this" {
        writer.writeLine("@THIS"); 
        writer.writeLine("D=M"); 
        writer.writeLine("@" + items[2]); 
        writer.writeLine("A=D+A"); 
        writer.writeLine("D=M"); 
        writer.writeLine("@SP"); 
        writer.writeLine("A=M"); 
        writer.writeLine("M=D"); 
        writer.writeLine("@SP"); 
        writer.writeLine("M=M+1"); 
    }
    "that" {
        writer.writeLine("@THAT"); 
        writer.writeLine("D=M"); 
        writer.writeLine("@" + items[2]); 
        writer.writeLine("A=D+A"); 
        writer.writeLine("D=M"); 
        writer.writeLine("@SP"); 
        writer.writeLine("A=M"); 
        writer.writeLine("M=D"); 
        writer.writeLine("@SP"); 
        writer.writeLine("M=M+1"); 
    }
    "argument" {
        writer.writeLine("//comment push arg");
        writer.writeLine("@ARG"); 
        writer.writeLine("D=M"); 
        writer.writeLine("@" + items[2]); 
        writer.writeLine("A=D+A"); 
        writer.writeLine("D=M"); 
        writer.writeLine("@SP"); 
        writer.writeLine("A=M"); 
        writer.writeLine("M=D"); 
        writer.writeLine("@SP"); 
        writer.writeLine("M=M+1"); 
    }
    "temp" {
        var t := items[2].toInt() + 5; // Adjust index for temp segment
        writer.writeLine("@" + t.toString()); 
        writer.writeLine("D=M"); 
        writer.writeLine("@SP"); 
        writer.writeLine("A=M"); 
        writer.writeLine("M=D"); 
        writer.writeLine("@SP"); 
        writer.writeLine("M=M+1"); 
    }
    "static" { 
         writer.writeLine("//comment push static");
        var staticAddr := "@" + fileName + "." + items[2];  
        writer.writeLine(staticAddr.toString()); 
        writer.writeLine("D=M");
        writer.writeLine("@SP");
        writer.writeLine("A=M");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("M=M+1");

    }
    "pointer" {
        if (items[2] == "0") {
            writer.writeLine("@THIS"); 
        };
        if (items[2] == "1") {
            writer.writeLine("@THAT"); 
        };
        writer.writeLine("D=M"); 
        writer.writeLine("@SP"); 
        writer.writeLine("A=M"); 
        writer.writeLine("M=D"); 
        writer.writeLine("@SP"); 
        writer.writeLine("M=M+1"); 
    }
}

//---------------------pop methods-----------------------------
public writePop(var items, var writer,var fileName)
{
    var func := items[1];
    func =>
    "local" {
        writer.writeLine("@" + items[2]);
        writer.writeLine("D=A");
        writer.writeLine("@LCL");
        writer.writeLine("D=D+M");
        writer.writeLine("@R13");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@R13");
        writer.writeLine("A=M");
        writer.writeLine("M=D");
    }
    "this" {
        writer.writeLine("@" + items[2]);
        writer.writeLine("D=A");
        writer.writeLine("@THIS");
        writer.writeLine("D=D+M");
        writer.writeLine("@13");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@R13");
        writer.writeLine("A=M");
        writer.writeLine("M=D");
    }
    "that" {
        writer.writeLine("@" + items[2]);
        writer.writeLine("D=A");
        writer.writeLine("@THAT");
        writer.writeLine("D=D+M");
        writer.writeLine("@R13");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@R13");
        writer.writeLine("A=M");
        writer.writeLine("M=D");
    }
    "argument" {
        writer.writeLine("@" + items[2]);
        writer.writeLine("D=A");
        writer.writeLine("@ARG");
        writer.writeLine("D=D+M");
        writer.writeLine("@R13");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@R13");
        writer.writeLine("A=M");
        writer.writeLine("M=D");
    }
    "temp" {
        writer.writeLine("//comment pop temp");
        var t := items[2].toInt() + 5;
        writer.writeLine("@" + t.toString());
        writer.writeLine("D=A");
        writer.writeLine("@R13");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@R13");
        writer.writeLine("A=M");
        writer.writeLine("M=D");
    }
    "static" {
        writer.writeLine("//comment pop static");
        var staticAddr := "@" + fileName + "." + items[2];  
        writer.writeLine("@SP");
        writer.writeLine("M=M-1");
        writer.writeLine("A=M");
        writer.writeLine("D=M");
        writer.writeLine(staticAddr.toString());  
        writer.writeLine("M=D");
        //writer.writeLine("@" + staticAddr.toString());
        //writer.writeLine("M=D");
        //var staticAddr := 16+ i +(items[2].toInt());
        //var address :=staticAddr.toString();
       /* writer.writeLine("//comment pop static");
        writer.writeLine("@"+fileName);
        writer.writeLine("D=A");
        writer.writeLine("@"+items[2]);
        writer.writeLine("D=D+A");
        writer.writeLine("@R13");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@R13");//?
        writer.writeLine("A=M");
        writer.writeLine("M=D");*/

        
    }
    "pointer" {
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        if (items[2] == "0") {
            writer.writeLine("@THIS");
        }; if (items[2] == "1") {
            writer.writeLine("@THAT");
        };
        writer.writeLine("M=D");
    }
}

//-----------------------arithmetic operations-------------------------
public Arithmetic(var items, var writer, int i)
{
    var op := items[0];
    op =>
    "eq" {
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M-D");
        writer.writeLine("@IF_TRUE" + i.toString());
        writer.writeLine("D;JEQ");
        writer.writeLine("D=0");
        writer.writeLine("@IF_FALSE" + i.toString());
        writer.writeLine("0;JMP");
        writer.writeLine("(IF_TRUE" + i.toString() + ")");
        writer.writeLine("D=-1");
        writer.writeLine("(IF_FALSE" + i.toString() + ")");
        writer.writeLine("@SP");
        writer.writeLine("A=M");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("M=M+1");
    }
    "lt" {
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M-D");
        writer.writeLine("@IF_TRUE" + i.toString());
        writer.writeLine("D;JLT");
        writer.writeLine("D=0");
        writer.writeLine("@IF_FALSE" + i.toString());
        writer.writeLine("0;JMP");
        writer.writeLine("(IF_TRUE" + i.toString() + ")");
        writer.writeLine("D=-1");
        writer.writeLine("(IF_FALSE" + i.toString() + ")");
        writer.writeLine("@SP");
        writer.writeLine("A=M");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("M=M+1");
    }
    "gt" {
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M-D");
        writer.writeLine("@IF_TRUE" + i.toString());
        writer.writeLine("D;JGT");
        writer.writeLine("D=0");
        writer.writeLine("@IF_FALSE" + i.toString());
        writer.writeLine("0;JMP");
        writer.writeLine("(IF_TRUE" + i.toString() + ")");
        writer.writeLine("D=-1");
        writer.writeLine("(IF_FALSE" + i.toString() + ")");
        writer.writeLine("@SP");
        writer.writeLine("A=M");
        writer.writeLine("M=D");
        writer.writeLine("@SP");
        writer.writeLine("M=M+1");
    }
    "add" {
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("A=A-1");
        writer.writeLine("M=D+M");
    }
    "sub" {
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("A=A-1");
        writer.writeLine("M=M-D");
    }
    "neg" {
        writer.writeLine("@SP");
        writer.writeLine("A=M");
        writer.writeLine("A=A-1");
        writer.writeLine("M=-M");
    }
    "and" {
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("A=A-1");
        writer.writeLine("M=D&M");
    }
    "or" {
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("A=A-1");
        writer.writeLine("M=D|M");
    }
    "not" {
        writer.writeLine("@SP");
        writer.writeLine("A=M");
        writer.writeLine("A=A-1");
        writer.writeLine("M=!M");
    }
}

// פונקציה לאתחול SP והתחלת הפונקציה Sys.init
public init(var writer)
{
    writer.writeLine("@261");
    writer.writeLine("D=A");
    writer.writeLine("@SP");
    writer.writeLine("M=D");
    writer.writeLine("@Sys.init");
    writer.writeLine("0;JMP");
}

// פונקציות לזרימת הפקודות
public Flow(var items, var writer, var fileName)
{
    var lname := fileName + "." + items[1];
    var name :=lname.replace(".vm"," ");
    var op := items[0];
    op =>
    "label" {
        writer.writeLine("//comment label");
        writer.writeLine("(" + name + ")");
    }
    "goto" {
        writer.writeLine("//comment goto");
        writer.writeLine("@" + name);
        writer.writeLine("0;JMP");
    }
    "if-goto" {
        writer.writeLine("@SP");
        writer.writeLine("AM=M-1");
        writer.writeLine("D=M");
        writer.writeLine("@" + name);
        writer.writeLine("D;JNE");
    }
}

// פונקציה לפונקציות VM
public vm_function(var writer, string function_name, int n_vars)
{
    writer.writeLine("(" + function_name + ") // function " + function_name + " " + n_vars.toString());
    for (var n := 0, n < n_vars, n := n + 1)
    {
        writer.writeLine("//comment func"+ n.toString());
        writer.writeLine("@SP");
        writer.writeLine("A=M");
        writer.writeLine("M=0");
        writer.writeLine("@SP");
        writer.writeLine("M=M+1");
    }
    
}

// פונקציה לקריאת VM
public vm_call(var writer, string function_name, int n_args, int counter)
{
    writer.writeLine("//comment call");
    var returnAddress :=  function_name + "_" + counter.toString();
    writer.writeLine("@" + returnAddress + " // call " + function_name + " " + n_args.toString());
    writer.writeLine("D=A");
    writer.writeLine("@SP");
    writer.writeLine("A=M");
    writer.writeLine("M=D");
    writer.writeLine("@SP");
    writer.writeLine("M=M+1");

    writer.writeLine("@LCL");
    writer.writeLine("D=M");
    writer.writeLine("@SP");
    writer.writeLine("A=M");
    writer.writeLine("M=D");
    writer.writeLine("@SP");
    writer.writeLine("M=M+1");

    writer.writeLine("@ARG");
    writer.writeLine("D=M");
    writer.writeLine("@SP");
    writer.writeLine("A=M");
    writer.writeLine("M=D");
    writer.writeLine("@SP");
    writer.writeLine("M=M+1");

    writer.writeLine("@THIS");
    writer.writeLine("D=M");
    writer.writeLine("@SP");
    writer.writeLine("A=M");
    writer.writeLine("M=D");
    writer.writeLine("@SP");
    writer.writeLine("M=M+1");

    writer.writeLine("@THAT");
    writer.writeLine("D=M");
    writer.writeLine("@SP");
    writer.writeLine("A=M");
    writer.writeLine("M=D");
    writer.writeLine("@SP");
    writer.writeLine("M=M+1");

    writer.writeLine("@SP");
    writer.writeLine("D=M");
    writer.writeLine("@5");
    writer.writeLine("D=D-A");
    writer.writeLine("@" + n_args.toString());
    writer.writeLine("D=D-A");
    writer.writeLine("@ARG");
    writer.writeLine("M=D");

    writer.writeLine("@SP");
    writer.writeLine("D=M");
    writer.writeLine("@LCL");
    writer.writeLine("M=D");

    writer.writeLine("@" + function_name);
    writer.writeLine("0;JMP");

    writer.writeLine("(" + returnAddress + ")");
}

// פונקציה להחזרת VM
public vm_return(var writer)
{
    writer.writeLine("//comment return");
    writer.writeLine("@LCL // return");
    writer.writeLine("D=M");
    writer.writeLine("@R13");
    writer.writeLine("M=D");

    writer.writeLine("@R13");
    writer.writeLine("D=M");
    writer.writeLine("@5");
    writer.writeLine("A=D-A");
    writer.writeLine("D=M");
    writer.writeLine("@R14");
    writer.writeLine("M=D");

    writer.writeLine("@SP");
    writer.writeLine("AM=M-1");
    writer.writeLine("D=M");
    writer.writeLine("@ARG");
    writer.writeLine("A=M");
    writer.writeLine("M=D");

    writer.writeLine("@ARG");
    writer.writeLine("D=M+1");
    writer.writeLine("@SP");
    writer.writeLine("M=D");

    writer.writeLine("@R13");
    writer.writeLine("D=M");
    writer.writeLine("@1");
    writer.writeLine("A=D-A");
    writer.writeLine("D=M");
    writer.writeLine("@THAT");
    writer.writeLine("M=D");

    writer.writeLine("@R13");
    writer.writeLine("D=M");
    writer.writeLine("@2");
    writer.writeLine("A=D-A");
    writer.writeLine("D=M");
    writer.writeLine("@THIS");
    writer.writeLine("M=D");

    writer.writeLine("@R13");
    writer.writeLine("D=M");
    writer.writeLine("@3");
    writer.writeLine("A=D-A");
    writer.writeLine("D=M");
    writer.writeLine("@ARG");
    writer.writeLine("M=D");

    writer.writeLine("@R13");
    writer.writeLine("D=M");
    writer.writeLine("@4");
    writer.writeLine("A=D-A");
    writer.writeLine("D=M");
    writer.writeLine("@LCL");
    writer.writeLine("M=D");

    writer.writeLine("@R14");
    writer.writeLine("A=M");
    writer.writeLine("0;JMP");
}

public trimmer(str)
{
   for (var i := str.Length - 1, i >= 0, i := i - 1)
    {
        // Check if the current character is a backslash
        if (str[i] == "\")
        {
            // Return the substring from the next character to the end
            ^ str.Substring(i + 1, (str.Length - i - 1))
        }
    };
    ^ str
}

public asmName(str)
{
    for (var i := str.Length - 1, i >= 0, i := i - 1)
    {
        // Check if the current character is a backslash
        if (str[i] == "\")
        {
            // Return the substring from the next character to the end
            var newStr := str.Substring(0, (i));
            var newAsm := trimmer(newStr);
            var sofi := newStr + "\\" + newAsm + ".asm";
            ^ sofi;      
        }
    };
    ^ str   
}

public program()
{    
    // Assign the directory to work with. Uncomment the appropriate line for the desired test.
        
    //---------------------------------------------------exercise 1------------------------------------------------------
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\07\\MemoryAccess\\BasicTest");
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\07\\MemoryAccess\\PointerTest");
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\07\\MemoryAccess\\StaticTest");
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\07\\StackArithmetic\\StackTest");
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\07\\StackArithmetic\\SimpleAdd");
    //-------------------------------------------------------------------------------------------------------------------
    
    
    
    //---------------------------------------------------exercise 2------------------------------------------------------
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\08\\ProgramFlow\\FibonacciSeries");
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\08\\ProgramFlow\\BasicLoop"); 
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\08\\FunctionCalls\\SimpleFunction");
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\08\\FunctionCalls\\NestedCall");
    
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\08\\FunctionCalls\\FibonacciElement");
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\08\\FunctionCalls\\StaticsTest");
    //--------------------------------------------------------------------------------------------------------------------- 
    
    var files := dir.getFiles("*.vm");
    var asmFileName := asmName(files[0]);
    
    if (files.Length > 1)
    {
        using(auto writer := File.assign(asmFileName).textwriter())
        {
            writer.writeLine("//init bootstrap");
            init(writer);
        };
    };
    
    // Iterate over the VM files in the directory
    for (var j := 0, j < files.Length, j := j + 1)
    {
        var fileNameOpen := files[j];
        var fileName := trimmer(files[j]);
        console.printLine(files[j]);
        //var fileName2 := fileName.replace(".vm", ".asm");

        using(auto reader := File.assign(fileNameOpen).textreader())
        {
            using(auto writer := File.assign(asmFileName).logger())
            {
                int i := 0;
                while (reader.Available)
                {
                    string line := reader.readLine();
                    var items := line.splitBy(" ");
                    var op := items[0];
                    op =>
                    "//" {}
                    "push" { writePush(items, writer , fileName); }
                    "pop" { writePop(items, writer, fileName); }
                    "eq" { Arithmetic(items, writer, i); }
                    "lt" { Arithmetic(items, writer, i); }
                    "gt" { Arithmetic(items, writer, i); }
                    "add" { Arithmetic(items, writer, i); }
                    "sub" { Arithmetic(items, writer, i); }
                    "neg" { Arithmetic(items, writer, i); }
                    "and" { Arithmetic(items, writer, i); }
                    "or" { Arithmetic(items, writer, i); }
                    "not" { Arithmetic(items, writer, i); }
                    "label" { Flow(items, writer, fileName); }
                    "goto" { Flow(items, writer, fileName); }
                    "if-goto" { Flow(items, writer, fileName); }
                    "function" { vm_function(writer, items[1], items[2].toInt()); }
                    "call" { vm_call(writer, items[1], items[2].toInt(), i); }
                    "return" { vm_return(writer); };
                    i := i + 1;
                    console.printLine(line);
                };
            };
        };
        console.readChar(); // Wait for user input to proceed
    }
}
