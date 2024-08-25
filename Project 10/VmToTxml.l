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

/*
//---------------------------boolean functions------------------------------------------------

public isKeyword(var word)
{
    var keywords := "class constructor function method field static var int char boolean void true false null this let do if else while return";
    var keywordsList := keywords.splitBy: " ";
    for (var j := 0, j < keywordsList.Length, j+=1)
    {
        if (word == keywordsList[j])
        {
            ^true;
        };   
    };
    ^false;     
}

public isWhitespace(var char)
{
    if (char == " ")
    {
        ^true;
    };
    ^false;
}

public isDigit(var char)
{
    if (char.toInt() >= 48 && char.toInt() <= 57)
    {
        ^true;
    };
    ^false;
}

public isLetterOrUnderScore(var char)
{
    if (char == "")
    {
        ^false;
    };
    if (char == "_")
    {
        ^true;
    };
    if (char.toInt() >= 65 && char.toInt() <= 90)
    {
        ^true;
    };
    if (char.toInt() >= 97 && char.toInt() <= 122)
    {
        ^true;
    };
    ^false;   
}

public isSymbol(var char)
{
    var symbols := "{ } ( ) [ ] . , ; + - * & | < > = ~ /";         //without "
    var symbolList := symbols.splitBy: " ";
    for (var j := 0, j < symbolList.Length, j+=1)
    {
        if (char == symbolList[j])
        {
            ^true;
        };  
    };
    ^false;           
}

public isApostrophes(var char)
{
    if (char.toInt() == 34)
    {
        ^true;
    };
    ^false;           
}

public isSlash(var char)
{
    if (char.toInt() == 47)
    {
        ^true;
    };
    ^false;           
}

public isStar(var char)
{
    if (char == "*")
    {
        ^true;
    };
    ^false;           
}

//--------------------------------write functions and helper functions---------------------------------------------------

public writeKeyword(var writer, var keyword)
{
    writer.writeLine("<keyword> " + keyword + " </keyword>" );  
}

public writeSymbol(var writer, var symbol)
{
    writer.writeLine("<symbol> " + symbol + " </symbol>");
}

public writeIdentifier(var writer, var id)
{
    writer.writeLine("<identifier> " + id + " </identifier>");
}

public writeIntegerConstant(var writer, var intConst)
{
    writer.writeLine("<integerConstant> " + intConst + " </integerConstant>");
}

public writeStringConstant(var writer, var strConst)
{
    writer.writeLine("<stringConstant> " + strConst + " </stringConstant>");
}

public escapeSymbol(var symbol)
{
    if (symbol.toInt() == 34)
    {
        ^ "&quot;";
    };
    symbol =>
    "<" 
    {
        ^ "&lt;"
    }
    ">" 
    {
        ^ "&gt;"
    }
    "&" 
    {
        ^ "&amp;"
    };
    ^symbol;
}


public trimComments(string line)
{
    var slashIndex := line.indexOf(0, "//");
    var blockIndex := line.indexOf(0, "/*");
    
    // If neither comment type is found, just trim whitespace
    if (slashIndex == -1 && blockIndex == -1)
    {
        ^line.trim();
    };
    
    // If only block comment is found, or it comes first
    if (blockIndex != -1 && (slashIndex == -1 || blockIndex < slashIndex))
    {
        ^line.Substring(0, blockIndex).trim();
    };
    
    // If only single-line comment is found, or it comes first
    if (slashIndex != -1 && (blockIndex == -1 || slashIndex < blockIndex))
    {
        ^line.Substring(0, slashIndex).trim();
    };
    
    // This line should never be reached, but just in case:
    ^line.trim();
}





//---------------------code------------------------

public getToken(var reader, var writer)
{
    var tempNum := "";
    var tempStr := "";
    var tempWord := "";
    var position := 0;

    while (reader.Available)
    {
        // Read a line from the jack file
        string bigLine := reader.readLine();
        
        
        var lines := bigLine.splitBy:$10;
        for (var i := 0, i<lines.Length,i+=1)
        {
            var line:=lines[i];
            line:=line.trim();
            if (line[0] =="*")
            {
                line:="";
            };
            line := trimComments(line);

              
        // Split the line into its components
        var currentChar := line[position];

        int length := line.Length;

        for (var j := 0, j < length, j+=1)
        {
            currentChar := line[j];
            console.writeLine("the current char is " + currentChar);

            //---------------------------number- integerConstant--------------------
            if(isDigit(currentChar))
            {
                tempNum += currentChar;
            }
            else if (tempNum != "")
            {
                writeIntegerConstant(writer, tempNum);
                tempNum := "";
            };

            //---------------------------string- stringConstant----------------------- 
            if(isApostrophes(currentChar) && tempStr == "")
            {
                j += 1;
                while (j < length && isApostrophes(line[j]) == false)
                {
                    tempStr += line[j];
                    j += 1;
                };
                writeStringConstant(writer, tempStr);
                tempStr := "";      
            };
            
            
            //----------------------------keyword+identifier-----------------------------------          
            if(isLetterOrUnderScore(currentChar) && tempWord == "")
            {
                tempWord += currentChar;   
            }
            else if((isLetterOrUnderScore(currentChar) || isDigit(currentChar)) && tempWord != "" )
            {
                tempWord += currentChar;
            };                                                                           
            if(isLetterOrUnderScore(currentChar)==false && isDigit(currentChar)==false && tempWord != "")
            {
                tempWord := tempWord.trim();
                if(isKeyword(tempWord))
                {
                    writeKeyword(writer, tempWord);    
                }
                else
                {
                    writeIdentifier(writer, tempWord);
                };
                tempWord := "";
            };            

            //---------------------------symbol not //-----------------------------------
            if(isSymbol(currentChar))
            {
                var symbol := escapeSymbol(currentChar);
                writeSymbol(writer, symbol); 
            };
            

        }; 
        
       };         
    };
}





public tokenFile(var dir)
{
    // Get all jack files in the specified directory
    var files := dir.getFiles("*.jack");

    // Iterate over the jack files in the directory
    for (var j := 0, j < files.Length, j+=1)
    {
        var fileName := files[j]; // Get the current file name
        console.printLine(files[j]);

        // Generate the corresponding .asm file name by replacing the .jack extension with T.xml
        var fileName2 := fileName.replace(".jack", "W.xml");

        // Open the jack file for reading
        using(auto reader := File.assign(fileName).textreader())
        {
            int i := 0;
            // Open the corresponding xml file for writing
            using(auto writer := File.assign(fileName2).logger())
            {
                writer.writeLine("<tokens>");
                // Repeat until all lines are read from the VM file
                getToken(reader, writer);
                writer.writeLine("</tokens>");
            };
        };
        console.readChar(); // Wait for user input to proceed
    }     
}
*/
public program()    
{
    // Assign the directory to work with. Uncomment the appropriate line for the desired test.
    //---------------------------------------------------project 10------------------------------------------------------
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\10\\ArrayTest");
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\10\\ExpressionLessSquare");
    //var dir := Directory.assign("C:\\Users\\Dabush\\Desktop\\EKRONOT\\nand2tetris\\projects\\10\\Square");
    //-------------------------------------------------------------------------------------------------------------------

    
    /*var input := "";
    while (input != "x")
    {
            
    console.writeLine("please enter path of file to tokenize: / press x to get out");
    var path := console.readLine();
    var dir := Directory.assign(path);
    tokenFile(dir);
    };*/
    
    var symbols := "{ } ( ) [ ] . , ; + - * & | < > = ~ /";         //without "
    var symbolList := symbols.splitBy: " ";
    console.writeLine(symbolList.Length);
    
    
    
 console.readChar(); // Wait for user input to proceed
}
