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


class JackCompiler
{
    field _symbolTable;
    field vmWriter;
    field tokenizer;
    field labelCounter;
    field className;
    
    constructor(var reader,var writer)
    {
        _symbolTable := new symbolTable();
        tokenizer := new JackTokenizer(reader);
        vmWriter := new VMWriter(writer);
        labelCounter := 0;
        className := "";
        //compiler.compileClass(tokenFileName);
    }
    
    
   
    compileClass(string fileName)
    {
        // Open the input file and set up the output file
        tokenizer.openFile(fileName);
        vmWriter.openFile(fileName.replace(".jack", ".vm"));

        // Parse the class structure
        tokenizer.advance(); // class
        tokenizer.advance(); // class name
        className := tokenizer.identifier();
        tokenizer.advance(); // {

        // Compile class variable declarations
        while (tokenizer.tokenType() == "KEYWORD" && 
               (tokenizer.keyWord() == "STATIC" || tokenizer.keyWord() == "FIELD"))
        {
            self.compileClassVarDec();
        };

        // Compile subroutines
        while (tokenizer.tokenType() == "KEYWORD" && 
               (tokenizer.keyWord() == "CONSTRUCTOR" || tokenizer.keyWord() == "FUNCTION" || tokenizer.keyWord() == "METHOD"))
        {
            self.compileSubroutine();
        };

        tokenizer.advance(); // }

        // Close files
        tokenizer.close();
        vmWriter.close();
    }

    compileClassVarDec()
    {
        var kind := tokenizer.keyWord(); // STATIC or FIELD
        tokenizer.advance();
        //var type := tokenizer.tokenType() == "KEYWORD" ? tokenizer.keyWord() : tokenizer.identifier();
        
        // Declare the type variable
        var type;

    // Conditional check
        if (tokenizer.tokenType() == "KEYWORD") 
        {
        type := tokenizer.keyWord()
        } 
        else    
        {
            type := tokenizer.identifier()
        };
        tokenizer.advance();

        var continueLoop := true;
        while (continueLoop)
        {
            var name := tokenizer.identifier();
            _symbolTable.define(name, type, kind);
            tokenizer.advance();

            if (tokenizer.symbol() == ";")
            {
                continueLoop := false;
            }
            else
            {
                tokenizer.advance(); // ,
            };
        };
        tokenizer.advance(); // ;
    }
    
 

    compileSubroutine()
    {
        _symbolTable.startSubroutine();

        var subroutineType := tokenizer.keyWord(); // CONSTRUCTOR, FUNCTION, or METHOD
        tokenizer.advance();
        tokenizer.advance(); // return type
        var subroutineName := tokenizer.identifier();
        tokenizer.advance();

        tokenizer.advance(); // (
        self.compileParameterList();
        tokenizer.advance(); // )

        self.compileSubroutineBody(subroutineType, subroutineName);
    }

    compileParameterList()
    {
        if (tokenizer.tokenType() != "SYMBOL" || tokenizer.symbol() != ")")
        {
            var continueLoop := true;
            while (continueLoop)
            {
                //var type := tokenizer.tokenType() == "KEYWORD" ? tokenizer.keyWord() : tokenizer.identifier();
                // Declare the type variable
                var type;

                // Conditional check
                if (tokenizer.tokenType() == "KEYWORD") 
                    {
                    type := tokenizer.keyWord()
                    } 
               else    
                    {
                    type := tokenizer.identifier()
                    };
                tokenizer.advance();
                var name := tokenizer.identifier();
                _symbolTable.define(name, type, "ARG");
                tokenizer.advance();

                if (tokenizer.tokenType() != "SYMBOL" || tokenizer.symbol() != ",")
                {
                    continueLoop:=false;
                }
                else
                {
                tokenizer.advance(); // ,
                };
            };
        };
    }

    compileSubroutineBody(string subroutineType, string subroutineName)
    {
        tokenizer.advance(); // {
        
        // Compile variable declarations
        while (tokenizer.tokenType() == "KEYWORD" && tokenizer.keyWord() == "VAR")
        {
            self.compileVarDec();
        };

        var nLocals := _symbolTable.varCount("VAR");
        vmWriter.writeFunction(subroutineName, nLocals);

        if (subroutineType == "METHOD")
        {
            vmWriter.writePush("argument", 0);
            vmWriter.writePop("pointer", 0);
        }
        else if (subroutineType == "CONSTRUCTOR")
        {
            var nFields := _symbolTable.varCount("FIELD");
            vmWriter.writePush("constant", nFields);
            vmWriter.writeCall("Memory.alloc", 1);
            vmWriter.writePop("pointer", 0);
        };

        self.compileStatements();
        tokenizer.advance(); // }
    }

    compileVarDec()
    {
        tokenizer.advance(); // var
        //var type := tokenizer.tokenType() == "KEYWORD" ? tokenizer.keyWord() : tokenizer.identifier();
        // Declare the type variable
                var type;

                // Conditional check
                if (tokenizer.tokenType() == "KEYWORD") 
                    {
                    type := tokenizer.keyWord()
                    } 
               else    
                    {
                    type := tokenizer.identifier()
                    };
        tokenizer.advance();
        var continueLoop:=true;
        while (true)
        {
            var name := tokenizer.identifier();
            _symbolTable.define(name, type, "VAR");
            tokenizer.advance();

            if (tokenizer.symbol() == ";")
            {
                continueLoop:=false;
            }
            else
            {
            tokenizer.advance(); // ,
            };
        };
        tokenizer.advance(); // ;
    }

    compileStatements()
    {
        var continueLoop:=true;
        while (tokenizer.tokenType() == "KEYWORD" && continueLoop==true)
        {
            if (tokenizer.keyWord() == "LET")
            {
                self.compileLet();
            }
            else if (tokenizer.keyWord() == "IF")
            {
                self.compileIf();
            }
            else if (tokenizer.keyWord() == "WHILE")
            {
                self.compileWhile();
            }
            else if (tokenizer.keyWord() == "DO")
            {
                self.compileDo();
            }
            else if (tokenizer.keyWord() == "RETURN")
            {
                self.compileReturn();
            }
            else
            {
                continueLoop:=false;
            };
        };
    }
    
 
    isOperator(string symbol) //-> bool
    {
    // Define the list of operators
    var operators :=new string[]{"+", "-", "*", "/", "&", "|", "<", ">", "="};

    // Iterate through the operators
    for(int i := 0, i < operators.Length, i+=1)
    {
        // Check if the symbol matches the current operator
        if(symbol == operators[i])
        {
            ^ true;
        };
    };

    // If no match is found, return false
    ^ false;
    }

       

    isUnaryOp(string symbol) //-> bool
    {
        var UnaryOperators :=new string[]{"-", "~"};
        for(int i := 0, i < UnaryOperators.Length, i+=1)
        {
            // Check if the symbol matches the current operator
            if(symbol == UnaryOperators[i])
            {
                ^ true;
            };
        };

        // If no match is found, return false
        ^ false;
    }

    isKeywordConstant(string keyword) //-> bool
    {
        var KeywordConstants :=new string[]{"TRUE", "FALSE", "NULL", "THIS"};
        for(int i := 0, i < KeywordConstants.Length, i+=1)
        {
            // Check if the symbol matches the current operator
            if(keyword == KeywordConstants[i])
            {
                ^ true;
            };
        };

        // If no match is found, return false
        ^ false;
    }    
 

    compileLet()
    {
        tokenizer.advance(); // let
        var varName := tokenizer.identifier();
        tokenizer.advance();

        var isArray := false;
        if (tokenizer.symbol() == "[")
        {
            isArray := true;
            tokenizer.advance(); // [
            self.compileExpression();
            tokenizer.advance(); // ]

            vmWriter.writePush(_symbolTable.kindOf(varName), _symbolTable.indexOf(varName));
            vmWriter.writeArithmetic("add");

            tokenizer.advance(); // =
            self.compileExpression();

            vmWriter.writePop("temp", 0);
            vmWriter.writePop("pointer", 1);
            vmWriter.writePush("temp", 0);
            vmWriter.writePop("that", 0);
        }
        else
        {
            tokenizer.advance(); // =
            self.compileExpression();
            vmWriter.writePop(_symbolTable.kindOf(varName), _symbolTable.indexOf(varName));
        };

        tokenizer.advance(); // ;
    }

    compileIf()
    {
        var labelTrue := "IF_TRUE" + labelCounter.toString();
        var labelFalse := "IF_FALSE" + labelCounter.toString();
        var labelEnd := "IF_END" + labelCounter.toString();
        labelCounter += 1;

        tokenizer.advance(); // if
        tokenizer.advance(); // (
        self.compileExpression();
        tokenizer.advance(); // )

        vmWriter.writeIf(labelTrue);
        vmWriter.writeGoto(labelFalse);
        vmWriter.writeLabel(labelTrue);

        tokenizer.advance(); // {
        self.compileStatements();
        tokenizer.advance(); // }

        if (tokenizer.tokenType() == "KEYWORD" && tokenizer.keyWord() == "ELSE")
        {
            vmWriter.writeGoto(labelEnd);
            vmWriter.writeLabel(labelFalse);
            tokenizer.advance(); // else
            tokenizer.advance(); // {
            self.compileStatements();
            tokenizer.advance(); // }
            vmWriter.writeLabel(labelEnd);
        }
        else
        {
            vmWriter.writeLabel(labelFalse);
        };
    }

    compileWhile()
    {
        var labelLoop := "WHILE_EXP" + labelCounter.toString();
        var labelEnd := "WHILE_END" + labelCounter.toString();
        labelCounter += 1;

        vmWriter.writeLabel(labelLoop);

        tokenizer.advance(); // while
        tokenizer.advance(); // (
        self.compileExpression();
        tokenizer.advance(); // )

        vmWriter.writeArithmetic("not");
        vmWriter.writeIf(labelEnd);

        tokenizer.advance(); // {
        self.compileStatements();
        tokenizer.advance(); // }

        vmWriter.writeGoto(labelLoop);
        vmWriter.writeLabel(labelEnd);
    }

    compileDo()
    {
        tokenizer.advance(); // do
        self.compileSubroutineCall();
        vmWriter.writePop("temp", 0); // Discard the return value
        tokenizer.advance(); // ;
    }

    compileReturn()
    {
        tokenizer.advance(); // return

        if (tokenizer.tokenType() != "SYMBOL" || tokenizer.symbol() != ";")
        {
            self.compileExpression();
        }
        else
        {
            vmWriter.writePush("constant", 0);
        };

        vmWriter.writeReturn();
        tokenizer.advance(); // ;
    }

    compileExpression()
    {
        self.compileTerm();

        while (tokenizer.tokenType() == "SYMBOL" && self.isOperator(tokenizer.symbol()))
        {
            var operator := tokenizer.symbol();
            tokenizer.advance();
            self.compileTerm();
            self.writeOperator(operator);
        };
    }

    compileTerm()
    {
        if (tokenizer.tokenType() == "INT_CONST")
        {
            vmWriter.writePush("constant", tokenizer.intVal());
            tokenizer.advance();
        }
        else if (tokenizer.tokenType() == "STRING_CONST")
        {
            var strVal := tokenizer.stringVal();
            vmWriter.writePush("constant", strVal.length());
            vmWriter.writeCall("String.new", 1);
            for (var i := 0, i < strVal.length(), i += 1)
            {
                vmWriter.writePush("constant", strVal[i].toInt());
                vmWriter.writeCall("String.appendChar", 2);
            };
            tokenizer.advance();
        }
        else if (tokenizer.tokenType() == "KEYWORD" && self.isKeywordConstant(tokenizer.keyWord()))
        {
            if (tokenizer.keyWord() == "TRUE")
            {
                vmWriter.writePush("constant", 0);
                vmWriter.writeArithmetic("not");
            }
            else if (tokenizer.keyWord() == "FALSE" || tokenizer.keyWord() == "NULL")
            {
                vmWriter.writePush("constant", 0);
            }
            else if (tokenizer.keyWord() == "THIS")
            {
                vmWriter.writePush("pointer", 0);
            };
            tokenizer.advance();
        }
        else if (tokenizer.tokenType() == "IDENTIFIER")
        {
            var name := tokenizer.identifier();
            tokenizer.advance();
            if (tokenizer.tokenType() == "SYMBOL" && tokenizer.symbol() == "[")
            {
                vmWriter.writePush(_symbolTable.kindOf(name), _symbolTable.indexOf(name));
                tokenizer.advance(); // [
                self.compileExpression();
                tokenizer.advance(); // ]
                vmWriter.writeArithmetic("add");
                vmWriter.writePop("pointer", 1);
                vmWriter.writePush("that", 0);
            }
            else if (tokenizer.tokenType() == "SYMBOL" && (tokenizer.symbol() == "(" || tokenizer.symbol() == "."))
            {
                tokenizer.moveBack();
                self.compileSubroutineCall();
            }
            else
            {
                vmWriter.writePush(_symbolTable.kindOf(name), _symbolTable.indexOf(name));
            };
        }
        else if (tokenizer.tokenType() == "SYMBOL" && tokenizer.symbol() == "(")
        {
            tokenizer.advance(); // (
            self.compileExpression();
            tokenizer.advance(); // )
        }
        else if (tokenizer.tokenType() == "SYMBOL" && self.isUnaryOp(tokenizer.symbol()))
        {
            var operator := tokenizer.symbol();
            tokenizer.advance();
            self.compileTerm();
            if (operator == "-")
            {
                vmWriter.writeArithmetic("neg");
            }
            else if (operator == "~")
            {
                vmWriter.writeArithmetic("not");
            };
        };
    }

    compileSubroutineCall()
    {
        var name := tokenizer.identifier();
        tokenizer.advance();
        var nArgs := 0;

        if (tokenizer.symbol() == "(")
        {
            vmWriter.writePush("pointer", 0);
            nArgs += 1;
            tokenizer.advance(); // (
            nArgs += self.compileExpressionList();
            tokenizer.advance(); // )
            vmWriter.writeCall(className + "." + name, nArgs);
        }
        else if (tokenizer.symbol() == ".")
        {
            tokenizer.advance(); // .
            var subroutineName := tokenizer.identifier();
            tokenizer.advance();
            tokenizer.advance(); // (
            if (_symbolTable.kindOf(name) != "NONE")
            {
                vmWriter.writePush(_symbolTable.kindOf(name), _symbolTable.indexOf(name));
                nArgs += 1;
                vmWriter.writeCall(_symbolTable.typeOf(name) + "." + subroutineName, nArgs + self.compileExpressionList());
            }
            else
            {
                vmWriter.writeCall(name + "." + subroutineName, self.compileExpressionList());
            };
            tokenizer.advance(); // )
        };
    }

    compileExpressionList()// -> int
    {
        var nArgs := 0;
        if (tokenizer.tokenType() != "SYMBOL" || tokenizer.symbol() != ")")
        {
            self.compileExpression();
            nArgs += 1;
            while (tokenizer.tokenType() == "SYMBOL" && tokenizer.symbol() == ",")
            {
                tokenizer.advance(); // ,
                self.compileExpression();
                nArgs += 1;
            };
        };
        ^ nArgs;
    }


    writeOperator(string operator)
    {
        if (operator == "+") { vmWriter.writeArithmetic("add"); }
        else if (operator == "-") { vmWriter.writeArithmetic("sub"); }
        else if (operator == "*") { vmWriter.writeCall("Math.multiply", 2); }
        else if (operator == "/") { vmWriter.writeCall("Math.divide", 2); }
        else if (operator == "&") { vmWriter.writeArithmetic("and"); }
        else if (operator == "|") { vmWriter.writeArithmetic("or"); }
        else if (operator == "<") { vmWriter.writeArithmetic("lt"); }
        else if (operator == ">") { vmWriter.writeArithmetic("gt"); }
        else if (operator == "=") { vmWriter.writeArithmetic("eq"); }
    }
    
}


