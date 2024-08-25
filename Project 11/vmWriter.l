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





class VMWriter
{
    field outputFile;
    


    constructor(string fileWriter)
    {
        auto writer := File.assign(fileWriter).logger();
        outputFile := writer;
    }

    writePush(string segment, int index)
    {
        outputFile.writeLine("push " + segment + " " + index.toString());
    }

    writePop(string segment, int index)
    {
        outputFile.writeLine("pop " + segment + " " + index.toString());
    }

    writeArithmetic(string command)
    {
        outputFile.writeLine(command);
    }

    writeLabel(string label)
    {
        outputFile.writeLine("label " + label);
    }

    writeGoto(string label)
    {
        outputFile.writeLine("goto " + label);
    }

    writeIf(string label)
    {
        outputFile.writeLine("if-goto " + label);
    }

    writeCall(string name, int nArgs)
    {
        outputFile.writeLine("call " + name + " " + nArgs.toString());
    }

    writeFunction(string name, int nLocals)
    {
        outputFile.writeLine("function " + name + " " + nLocals.toString());
    }

    writeReturn()
    {
        outputFile.writeLine("return");
    }

    close()
    {
        outputFile.close();
    }
}
