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

class JackTokenizer
{
    field inputFile;
    field currentToken;
    field currentLine;
    field tokenType;
    field tokenValue;
    
    constructor(var reader)
    {
        console.writeLine("this is the jack tokenizer");
        console.readChar();
        
        auto fileReader := File.assign(reader).textreader();

        //inputFile := File.assign(fileName).textreader();
        inputFile := fileReader;

        currentLine := "";
        console.readChar();
         
        self.advance(); // Read the first token
        if (tokenType == "NONE")
            {
                console.writeLine("Warning: No valid tokens found in the file.");
            };
        console.writeLine("this ends the jack tokenizer constructor");
    }
    


    hasMoreTokens()// -> bool
    {
        if(inputFile.Available==true)
        {
        ^true;
        };
        ^false;
    }
    
    
    /*advance()// Read the next token from the XML
    {
    while (self.hasMoreTokens())
    {
        currentLine := inputFile.readLine();
        if (currentLine == null)
        {
            // End of file reached
            tokenType := "NONE";
            tokenValue := "";
            return;
        };
        
        currentLine := currentLine.trim();
        if (currentLine.startsWith("<"))
        {
            tokenType := currentLine.substring(1, currentLine.indexOf(">") - 1);
            var startIndex := currentLine.indexOf(">") + 1;
            var endIndex := currentLine.lastIndexOf("<");
            tokenValue := currentLine.substring(startIndex, endIndex - startIndex).trim();
            return;  // Successfully read a token
        };
        // If the line doesn't start with "<", continue to the next line
    };
    
    // If we've reached here, there are no more tokens
    tokenType := "NONE";
    tokenValue := "";
    }*/

    advance()// Read the next token from the XML
    {
        if (self.hasMoreTokens())
        {
            currentLine := inputFile.readLine().trim();
            if (currentLine.startsWith("<"))
            {
                tokenType := currentLine.substring(1, currentLine.indexOf(">") - 1);
                var startIndex := currentLine.indexOf(">") + 1;
                var endIndex := currentLine.lastIndexOf("<");
                tokenValue := currentLine.substring(startIndex, endIndex - startIndex).trim();
            }
            else
            {
                self.advance(); // Skip non-token lines
            }
        }
    }

    tokenType()// -> string// Return the type of the current token
    {
        if (tokenType == "keyword") { ^ "KEYWORD"; }
        else if (tokenType == "symbol") { ^ "SYMBOL"; }
        else if (tokenType == "identifier") { ^ "IDENTIFIER"; }
        else if (tokenType == "integerConstant") { ^ "INT_CONST"; }
        else if (tokenType == "stringConstant") { ^ "STRING_CONST"; }
        else { ^ "NONE"; }
    }

    keyword()// -> string // Return the keyword of the current token
    {
        if (tokenType == "keyword")
        {
            ^ tokenValue.toUpper();
        }
        else
        {
            ^ "";
        }
    }

    symbol()// -> char// Return the symbol of the current token
    {
        if (tokenType == "symbol")
        {
            ^ tokenValue[0];
        }
        else
        {
            ^ 0;
        }
    }

    identifier() //-> string// Return the identifier of the current token
    {
        if (tokenType == "identifier")
        {
            ^ tokenValue;
        }
        else
        {
            ^ "";
        }
    }

    intVal()// -> int// Return the integer value of the current token
    {
        if (tokenType == "integerConstant")
        {
            ^ tokenValue.toInt();
        }
        else
        {
            ^ 0;
        }
    }

    stringVal()// -> string // Return the string value of the current token
    {
        if (tokenType == "stringConstant")
        {
            ^ tokenValue;
        }
        else
        {
            ^ "";
        }
    }

    close()
    {
        inputFile.close();
    }
}