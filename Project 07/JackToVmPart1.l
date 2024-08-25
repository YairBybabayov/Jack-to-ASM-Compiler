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
/**

Handles the 'push' command in VM, translating it into Hack assembly code.
@param items An array containing the parts of the VM command.
@param writer The writer to write the output assembly code.
*/

public writePush (var items, var writer)
{
    var func:=items [1];
                func=>
                "constant" {
                // Pushes a constant value onto the stack
                writer.writeLine("@" + items[2]); // Load the constant value into A
                writer.writeLine("D=A"); // Store the constant value in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the constant value at the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M+1"); // Increment the stack pointer
                writer.writeLine();
                }
                
                "local" { 
                // Pushes a value from the local segment onto the stack
                writer.writeLine("@LCL"); // Load the base address of LCL into A
                writer.writeLine("D=M"); // Store the base address of LCL in D
                writer.writeLine("@" + items[2]); // Load the index into A
                writer.writeLine("A=A+D"); // Set A to the address of the local variable
                writer.writeLine("D=M"); // Store the value of the local variable in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value of the local variable at the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M+1"); // Increment the stack pointer
                writer.writeLine();   
                }
                "this" {
               // Pushes a value from the this segment onto the stack
                writer.writeLine("@THIS"); // Load the base address of THIS into A
                writer.writeLine("D=M"); // Store the base address of THIS in D
                writer.writeLine("@" + items[2]); // Load the index into A
                writer.writeLine("A=A+D"); // Set A to the address of the THIS variable
                writer.writeLine("D=M"); // Store the value of the THIS variable in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value of the THIS variable at the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M+1"); // Increment the stack pointer
                writer.writeLine();
                } 
                "that" {
               // Pushes a value from the that segment onto the stack
                writer.writeLine("@THAT"); // Load the base address of THAT into A
                writer.writeLine("D=M"); // Store the base address of THAT in D
                writer.writeLine("@" + items[2]); // Load the index into A
                writer.writeLine("A=A+D"); // Set A to the address of the THAT variable
                writer.writeLine("D=M"); // Store the value of the THAT variable in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value of the THAT variable at the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M+1"); // Increment the stack pointer
                writer.writeLine();                                
                } 
                "argument" {
                // Pushes a value from the argument segment onto the stack               
                writer.writeLine("@ARG"); // Load the base address of ARG into A
                writer.writeLine("D=M"); // Store the base address of ARG in D
                writer.writeLine("@" + items[2]); // Load the index into A
                writer.writeLine("A=A+D"); // Set A to the address of the argument variable
                writer.writeLine("D=M"); // Store the value of the argument variable in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value of the argument variable at the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M+1"); // Increment the stack pointer
                writer.writeLine();                
                }
                "temp" {
               // Pushes a value from the temp segment onto the stack
                var t := items[2].toInt(); // Convert the index to an integer
                t := t - 1; // Adjust the index for the temp segment
                writer.writeLine("@" + t.toString()); // Load the adjusted index into A
                writer.writeLine("D=A"); // Store the adjusted index in D
                writer.writeLine("@" + items[2]); // Load the original index into A
                writer.writeLine("A=A+D"); // Set A to the address of the temp variable
                writer.writeLine("D=M"); // Store the value of the temp variable in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value of the temp variable at the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M+1"); // Increment the stack pointer
                writer.writeLine();
                } 
                "static" { 
                // Pushes a value from the static segment onto the stack
                //writer.writeLine ("@StaticTest."+ items [2]);
                               
                int a := 16; // Base address of the static segment
                int b := a + (items[2].toInt()); // Compute the address of the static variable
                writer.writeLine("@" + b.toString()); // Load the address of the static variable into A
                writer.writeLine("D=M"); // Store the value of the static variable in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value of the static variable at the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M+1"); // Increment the stack pointer
                writer.writeLine();
                }
                "pointer" {
                // Pushes a value from the pointer segment (this/that) onto the stack    
                if (items[2] == "0") { writer.writeLine("@THIS") }; // Load the base address of THIS into A if index is 0
                if (items[2] == "1") { writer.writeLine("@THAT") }; // Load the base address of THAT into A if index is 1
                writer.writeLine("D=M"); // Store the value of THIS/THAT in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value of THIS/THAT at the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M+1"); // Increment the stack pointer
                writer.writeLine();
                };
                
       

}


//---------------------pop methods-----------------------------
/**

Handles the 'pop' command in VM, translating it into Hack assembly code.
@param items An array containing the parts of the VM command.
@param writer The writer to write the output assembly code.
*/
public writePop (var items, var writer)
{
    var func:= items [1] ;// Determine the type of segment
                func=>
                
                "local" {
                writer.writeLine("@" + items[2]); // Load the index into A
                writer.writeLine("D=A"); // Store the index in D
                writer.writeLine("@LCL"); // Load the base address of LCL into A
                writer.writeLine("D=D+M"); // Add the base address to the index and store in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the computed address into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine("A=M"); // Set A to the new top of the stack
                writer.writeLine("D=M"); // Store the top value of the stack in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("AM=M+1"); // Increment the stack pointer and set A to new top
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value in D into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine();
                } 

                // Pops a value from the stack into the this segment
                "this" {
                writer.writeLine("@" + items[2]); // Load the index into A
                writer.writeLine("D=A"); // Store the index in D
                writer.writeLine("@THIS"); // Load the base address of THIS into A
                writer.writeLine("D=D+M"); // Add the base address to the index and store in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the computed address into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine("A=M"); // Set A to the new top of the stack
                writer.writeLine("D=M"); // Store the top value of the stack in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("AM=M+1"); // Increment the stack pointer and set A to new top
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value in D into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine();
                }
    
                // Pops a value from the stack into the that segment
                "that" {
                writer.writeLine("@" + items[2]); // Load the index into A
                writer.writeLine("D=A"); // Store the index in D
                writer.writeLine("@THAT"); // Load the base address of THAT into A
                writer.writeLine("D=D+M"); // Add the base address to the index and store in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the computed address into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine("A=M"); // Set A to the new top of the stack
                writer.writeLine("D=M"); // Store the top value of the stack in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("AM=M+1"); // Increment the stack pointer and set A to new top
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value in D into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine();
                }

                // Pops a value from the stack into the argument segment
                "argument" {
                writer.writeLine("@" + items[2]); // Load the index into A
                writer.writeLine("D=A"); // Store the index in D
                writer.writeLine("@ARG"); // Load the base address of ARG into A
                writer.writeLine("D=D+M"); // Add the base address to the index and store in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the computed address into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine("A=M"); // Set A to the new top of the stack
                writer.writeLine("D=M"); // Store the top value of the stack in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("AM=M+1"); // Increment the stack pointer and set A to new top
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value in D into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine();
                }

                // Pops a value from the stack into the temp segment
                "temp" {
                writer.writeLine("@" + items[2]); // Load the index into A
                writer.writeLine("D=A"); // Store the index in D
                var t := items[2].toInt();
                t := t - 1; // Adjust index for temp segment
                writer.writeLine("@" + t.toString()); // Load adjusted index into A
                writer.writeLine("D=D+A"); // Add adjusted index to D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the computed address into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine("A=M"); // Set A to the new top of the stack
                writer.writeLine("D=M"); // Store the top value of the stack in D
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("AM=M+1"); // Increment the stack pointer and set A to new top
                writer.writeLine("A=M"); // Set A to the address of the top value in the stack
                writer.writeLine("M=D"); // Store the value in D into the top of the stack
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine();
                }

                // Pops a value from the stack into the static segment
                "static" {
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine("A=M"); // Set A to the new top of the stack
                writer.writeLine("D=M"); // Store the top value of the stack in D
                int a := 16; // Base address for static segment
                int b := a + (items[2].toInt()); // Compute address for the static variable
                writer.writeLine("@" + b.toString()); // Load the computed address into A
                writer.writeLine("M=D"); // Store the value in D into the static variable
                writer.writeLine();
                }
                
                "pointer" {
                // Pops a value from the stack into the pointer segment (this/that)
                writer.writeLine("@SP"); // Load the stack pointer into A
                writer.writeLine("M=M-1"); // Decrement the stack pointer
                writer.writeLine("A=M"); // Set A to the new top of the stack
                writer.writeLine("D=M"); // Store the top value of the stack in D
                if (items[2] == "0") {writer.writeLine("@THIS")}; // Load the base address of THIS into A
                if (items[2] == "1") {writer.writeLine("@THAT")}; // Load the base address of THAT into A
                writer.writeLine("M=D"); // Store the value in D into THIS or THAT
                writer.writeLine();
                };
}


//-----------------------arithmetic operations-------------------------
/**

Handles arithmetic and logical commands in VM, translating them into Hack assembly code.
@param items An array containing the parts of the VM command.
@param writer The writer to write the output assembly code.
*/
public Arithmetic(var items, var writer,int i)    
{
    var op:= items[0];// Determine the type of arithmetic operation
    op =>
        "eq" { 
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("AM=M-1"); // Decrements SP and sets A and M to the new top of stack value
         writer.writeLine("D=M"); // Stores the top value of the stack into the D register (D = *SP)
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("AM=M-1"); // Decrements SP and sets A and M to the new top of stack value
         writer.writeLine("D=M-D"); // Subtracts the second top value from the top value (D = M-D)
         writer.writeLine("@IF_TRUE" + i.toString()); // Jumps to IF_TRUE if D is zero (i.e., values are equal)
         writer.writeLine("D; JEQ"); // Jump if D is zero (equal)
         writer.writeLine("D=0"); // Set D to 0 (false)
         writer.writeLine("@IF_FALSE" + i.toString()); // Jump to IF_FALSE
         writer.writeLine("0; JMP"); // Unconditional jump
         writer.writeLine("(IF_TRUE" + i.toString() + ")"); // Label for IF_TRUE
         writer.writeLine("D=-1"); // Set D to -1 (true)
         writer.writeLine("(IF_FALSE" + i.toString() + ")"); // Label for IF_FALSE
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("A=M"); // Sets A to the current top of the stack
         writer.writeLine("M=D"); // Sets the top value of the stack to D (result of the comparison)
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("M=M+1"); // Increments the stack pointer
         writer.writeLine();
        } 
        "lt" { 
         // Compares the top two values on the stack to determine if the second is less than the top
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("AM=M-1"); // Decrements SP and sets A and M to the new top of stack value
         writer.writeLine("D=M"); // Stores the top value of the stack into the D register (D = *SP)
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("AM=M-1"); // Decrements SP and sets A and M to the new top of stack value
         writer.writeLine("D=M-D"); // Subtracts the second top value from the top value (D = M-D)
         writer.writeLine("@IF_TRUE" + i.toString()); // Jumps to IF_TRUE if D is less than zero
         writer.writeLine("D; JLT"); // Jump if D is less than zero
         writer.writeLine("D=0"); // Set D to 0 (false)
         writer.writeLine("@IF_FALSE" + i.toString()); // Jump to IF_FALSE
         writer.writeLine("0; JMP"); // Unconditional jump
         writer.writeLine("(IF_TRUE" + i.toString() + ")"); // Label for IF_TRUE
         writer.writeLine("D=-1"); // Set D to -1 (true)
         writer.writeLine("(IF_FALSE" + i.toString() + ")"); // Label for IF_FALSE
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("A=M"); // Sets A to the current top of the stack
         writer.writeLine("M=D"); // Sets the top value of the stack to D (result of the comparison)
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("M=M+1"); // Increments the stack pointer
         writer.writeLine();
        }
        
        "gt" {
         // Compares the top two values on the stack to determine if the second is greater than the top
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("AM=M-1"); // Decrements SP and sets A and M to the new top of stack value
         writer.writeLine("D=M"); // Stores the top value of the stack into the D register (D = *SP)
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("AM=M-1"); // Decrements SP and sets A and M to the new top of stack value
         writer.writeLine("D=M-D"); // Subtracts the second top value from the top value (D = M-D)
         writer.writeLine("@IF_TRUE" + i.toString()); // Jumps to IF_TRUE if D is greater than zero
         writer.writeLine("D; JGT"); // Jump if D is greater than zero
         writer.writeLine("D=0"); // Set D to 0 (false)
         writer.writeLine("@IF_FALSE" + i.toString()); // Jump to IF_FALSE
         writer.writeLine("0; JMP"); // Unconditional jump
         writer.writeLine("(IF_TRUE" + i.toString() + ")"); // Label for IF_TRUE
         writer.writeLine("D=-1"); // Set D to -1 (true)
         writer.writeLine("(IF_FALSE" + i.toString() + ")"); // Label for IF_FALSE
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("A=M"); // Sets A to the current top of the stack
         writer.writeLine("M=D"); // Sets the top value of the stack to D (result of the comparison)
         writer.writeLine("@SP"); // Sets register A to the stack pointer
         writer.writeLine("M=M+1"); // Increments the stack pointer
         writer.writeLine();
        }
         
        "add" {
       // Adds the top two values on the stack
        writer.writeLine ("@SP");//sets register A to the stack pointer
        writer.writeLine ("AM=M-1");//sp=sp-1, a=sp , m=ram[sp]=*sp-Stores the new value of SP in both the A register and the M register.
        writer.writeLine ("D=M");// stores the value currently pointed to by SP into the D register (i.e., D = *SP). Purpose: It saves the top value of the stack into the D register for further operations.
        writer.writeLine ("A=A-1");//It moves the A register to point to the next-to-top value of the stack (the second-to-top value).
        writer.writeLine ("M=D+M"); //adds the value in the D register to the value in the memory location currently pointed to by the A register, and stores the result back into that memory location (i.e., *A = D + *A).
        writer.writeLine();
        }
        "sub" {
       // Subtracts the top value on the stack from the second top value
        writer.writeLine ("@SP");//sets register A to the stack pointer 
        writer.writeLine ("AM=M-1");//sp=sp-1, a=sp , m=ram[sp]=*sp-Stores the new value of SP in both the A register and the M register.
        writer.writeLine ("D=M");// stores the value currently pointed to by SP into the D register (i.e., D = *SP). Purpose: It saves the top value of the stack into the D register for further operations.
        writer.writeLine ("A=A-1");//It moves the A register to point to the next-to-top value of the stack (the second-to-top value).
        writer.writeLine ("M=M-D");//subtraction operation where the current value in the memory location pointed to by the A register is decreased by the value in the D register 
        writer.writeLine();
        }
        "neg" {
        // Negates the top value on the stack
        writer.writeLine ("@SP");//sets register A to the stack pointer 
        writer.writeLine ("A=M");//It moves the A register to point to the top of the stack.
        writer.writeLine ("A=A-1");//It moves the A register to point to the next-to-top value of the stack (the current top value is one address above the desired value).
        writer.writeLine ("M=-M");//This line negates the value in the memory location currently pointed to by the A register (i.e., *A = -*A). Purpose: It negates the value at the top of the stack.
        writer.writeLine();
        } 
        "and" {
       // Performs a bitwise AND operation on the top two values on the stack
        writer.writeLine("@SP"); // Sets register A to the stack pointer
        writer.writeLine("AM=M-1"); // Decrements SP and sets A and M to the new top of stack value
        writer.writeLine("D=M"); // Stores the top value of the stack into the D register (D = *SP)
        writer.writeLine("A=A-1"); // Moves the A register to point to the next-to-top value of the stack (the second-to-top value)
        writer.writeLine("M=D&M"); // Performs a bitwise AND between D and *A, storing the result in the memory location pointed to by A (i.e., *A = D & *A)
        writer.writeLine();
        } 
        "or" {
       // Performs a bitwise OR operation on the top two values on the stack
        writer.writeLine("@SP"); // Sets register A to the stack pointer
        writer.writeLine("AM=M-1"); // Decrements SP and sets A and M to the new top of stack value
        writer.writeLine("D=M"); // Stores the top value of the stack into the D register (D = *SP)
        writer.writeLine("A=A-1"); // Moves the A register to point to the next-to-top value of the stack (the second-to-top value)
        writer.writeLine("M=D|M"); // Performs a bitwise OR between D and *A, storing the result in the memory location pointed to by A (i.e., *A = D | *A)
        writer.writeLine();
        } 
        "not" {
        // Performs a bitwise NOT operation on the top value on the stack
        writer.writeLine("@SP"); // Sets register A to the stack pointer
        writer.writeLine("A=M"); // Moves A to the top value of the stack
        writer.writeLine("A=A-1"); // Moves the A register to point to the next-to-top value of the stack (the current top value is one address above the desired value)
        writer.writeLine("M=!M"); // Performs a bitwise NOT on the value at the memory location currently pointed to by the A register (i.e., *A = !*A)
        writer.writeLine();
        };
         /*
                "END"
                (END)
                @END
                0;JMP              
                */        
}

public program()    
{
        // Assign the directory to work with. Uncomment the appropriate line for the desired test.
    
    //var dir := Directory.assign("C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\7\MemoryAccess\BasicTest");
    //var dir := Directory.assign("C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\7\MemoryAccess\PointerTest");
    //var dir := Directory.assign("C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\7\MemoryAccess\StaticTest");
    //var dir := Directory.assign("C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\7\StackArithmetic\StackTest");
    //var dir := Directory.assign("C:\Users\Dabush\Desktop\EKRONOT\nand2tetris\projects\7\StackArithmetic\SimpleAdd");
    
    
    // Get all VM files in the specified directory
    var files := dir.getFiles("*.vm");
    
    // Iterate over the VM files in the directory
    for (var j := 0, j < files.Length, j:=j+1)
    {
        
    var fileName :=files[j]; // Get the current file name
    console.printLine(files[j]);
    
    
    // Generate the corresponding .asm file name by replacing the .vm extension with .asm
    var fileName2 :=(files[j].delete(files[j].indexOf(1, ".vm"),1)
                              .delete(files[j].indexOf(2, ".vm"),1)
                              .delete(files[j].indexOf(3, ".vm"),1)
                              .insert(files[j].indexOf(1, "."), ".asm"));
    
     // Open the VM file for reading
    using(auto reader := File.assign(fileName).textreader())
    {
      int i:=0;
       // Open the corresponding ASM file for writing
      using(auto writer := File.assign(fileName2).textwriter())
       // Repeat until all lines are read from the VM file
        while (reader.Available)
        {
            
            // Read a line from the VM file
            string line := reader.readLine();
            
             // Split the line into its components
                   var items:=line.splitBy:" ";
                   var op:= items[0];// Get the operation (first item)
                   // Determine the operation and call the appropriate function
                   op =>
                         "//" {    }// Comment line, do nothing
                         "push" {writePush (items,writer) }// Handle push operation
                         "pop"  {writePop (items,writer) }// Handle pop operation
                         "eq" {Arithmetic(items,writer,i) } // Handle equality operation
                         "lt" {Arithmetic(items,writer,i) } // Handle less than operation
                         "gt" { Arithmetic(items,writer,i)} // Handle greater than operation
                         "add" {Arithmetic(items,writer,i) } // Handle add operation
                         "sub" {Arithmetic(items,writer,i) } // Handle subtract operation
                         "neg" {Arithmetic(items,writer,i) } // Handle negation operation
                         "and" {Arithmetic(items, writer,i) } // Handle bitwise AND operation
                         "or" {Arithmetic(items, writer,i) } // Handle bitwise OR operation
                         "not" {Arithmetic(items,writer,i) };  // Handle bitwise NOT operation
        
        i:= i+1;
        console.printLine(line);          // Print the current line to the console
                       
        };
        };
       console.readChar(); // Wait for user input to proceed
    } 
      
}
