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

// Singleton class to maintain parser state
singleton ParserState
{
    static int currentIndex := 0;

    getCurrentIndex() {
        ^currentIndex;
    }

    incrementIndex() {
        currentIndex := currentIndex + 1;
    }

    setIndex(int index) {
        currentIndex := index;
    }
}

// Function to parse the tokens
parse(List<string> tokens, string outputPath) {
    //console.printLine("The 2").readChar();
    ParserState.setIndex(0);
    using(auto writer := File.assign(outputPath).logger()) {
    //console.printLine("The 1").readChar();
    parseClass(tokens, writer);
    //console.printLine("The 3").readChar();
    }
}

// Function to parse class
parseClass(List<string> tokens, var writer) {
    writer.writeLine("<class>");
    //console.printLine("The 4").readChar();
    ParserState.incrementIndex();
    expectSingleToken(tokens, "<keyword> class </keyword>", writer);
    expectIdentifier(tokens, writer); // className
    expectSingleToken(tokens, "<symbol> { </symbol>", writer);
    while (matchSingleToken(tokens, "<keyword> static </keyword>") || matchSingleToken(tokens, "<keyword> field </keyword>")) {
        //console.printLine("The 5").readChar();
        parseClassVarDec(tokens, writer);
        
    };
    while (matchSingleToken(tokens, "<keyword> constructor </keyword>") || matchSingleToken(tokens, "<keyword> function </keyword>") || matchSingleToken(tokens, "<keyword> method </keyword>")) {
        //console.printLine("The 6").readChar();
        parseSubroutineDec(tokens, writer);
        
    };
    expectSingleToken(tokens, "<symbol> } </symbol>", writer);
    //console.printLine("The 7").readChar();
    writer.writeLine("</class>");
}

// Function to parse class variable declarations
parseClassVarDec(List<string> tokens, var writer) {
    writer.writeLine("<classVarDec>");
    expectTwoTokens(tokens, "<keyword> static </keyword>", "<keyword> field </keyword>", writer);
    expectType(tokens, writer);
    expectIdentifier(tokens, writer); // varName
    while (matchSingleToken(tokens, "<symbol> , </symbol>")) {
        expectSingleToken(tokens, "<symbol> , </symbol>", writer);
        expectIdentifier(tokens, writer); // varName
    };
    expectSingleToken(tokens, "<symbol> ; </symbol>", writer);
    writer.writeLine("</classVarDec>");
}

// Function to parse subroutine declarations
parseSubroutineDec(List<string> tokens, var writer) {
    writer.writeLine("<subroutineDec>");
    //ADD WRITER.WRITELINE(TOKENS[ParserState.getCurrentIndex()])
    writer.writeLine(tokens[ParserState.getCurrentIndex()]);
    ParserState.incrementIndex();
    //console.printLine(ParserState.getCurrentIndex()).readChar();
    //console.printLine("<subroutineDec>").readChar();
    expectMultipleTokens(tokens, writer);
    if (matchSingleToken(tokens, "<keyword> void </keyword>")) {
        expectSingleToken(tokens, "<keyword> void </keyword>", writer);
    } else {
        expectType(tokens, writer);
    };
    expectIdentifier(tokens, writer); // subroutineName
    expectSingleToken(tokens, "<symbol> ( </symbol>", writer);
    //console.printLine("AFTER THE OPEN (").readChar();
    parseParameterList(tokens, writer);
    //console.printLine("AFTER THE OPEN (").readChar();
    expectSingleToken(tokens, "<symbol> ) </symbol>", writer);
    parseSubroutineBody(tokens, writer);
    writer.writeLine("</subroutineDec>");
}

// Function to parse parameter list
parseParameterList(List<string> tokens, var writer) {
    writer.writeLine("<parameterList>");
    if (matchSingleToken(tokens, "<symbol> ) </symbol>")==false) {
        expectType(tokens, writer);
        expectIdentifier(tokens, writer); // varName
        while (matchSingleToken(tokens, "<symbol> , </symbol>")) {
            //console.printLine("THE 15").readChar();
            expectSingleToken(tokens, "<symbol> , </symbol>", writer);
            expectType(tokens, writer);
            expectIdentifier(tokens, writer); // varName
        };
        //console.printLine("THE 16").readChar();
    };
    writer.writeLine("</parameterList>");
    //console.printLine("THE 17").readChar();
}

// Function to parse subroutine body
parseSubroutineBody(List<string> tokens, var writer) {
    writer.writeLine("<subroutineBody>");
    expectSingleToken(tokens, "<symbol> { </symbol>", writer);
    while (matchSingleToken(tokens, "<keyword> var </keyword>")) {
        parseVarDec(tokens, writer);
    };
    parseStatements(tokens, writer);
    expectSingleToken(tokens, "<symbol> } </symbol>", writer);
    writer.writeLine("</subroutineBody>");
}

// Function to parse variable declarations
parseVarDec(List<string> tokens, var writer) {
    writer.writeLine("<varDec>");
    expectSingleToken(tokens, "<keyword> var </keyword>", writer);
    expectType(tokens, writer);
    expectIdentifier(tokens, writer); // varName
    while (matchSingleToken(tokens, "<symbol> , </symbol>")) {
        expectSingleToken(tokens, "<symbol> , </symbol>", writer);
        expectIdentifier(tokens, writer); // varName
    };
    expectSingleToken(tokens, "<symbol> ; </symbol>", writer);
    writer.writeLine("</varDec>");
    
    
}

// Function to parse statements
parseStatements(List<string> tokens, var writer) {
    writer.writeLine("<statements>");
    //console.writeLine("<statementsssss>").readChar();
    while (matchStatement(tokens)) {
        //console.writeLine("<AAAAAsssss>").readChar();
        parseStatement(tokens, writer);
    };
    writer.writeLine("</statements>");
}

// Function to parse a single statement
parseStatement(List<string> tokens, var writer) {
    if (matchSingleToken(tokens, "<keyword> let </keyword>")) {
        //console.writeLine("A1").readChar();
        parseLetStatement(tokens, writer);
    } else if (matchSingleToken(tokens, "<keyword> if </keyword>")) {
        //console.writeLine("A2").readChar();
        parseIfStatement(tokens, writer);
    } else if (matchSingleToken(tokens, "<keyword> while </keyword>")) {
        //console.writeLine("A3").readChar();
        parseWhileStatement(tokens, writer);
    } else if (matchSingleToken(tokens, "<keyword> do </keyword>")) {
        //console.writeLine("A4").readChar();
        parseDoStatement(tokens, writer);
    } else if (matchSingleToken(tokens, "<keyword> return </keyword>")) {
        //console.writeLine("A5").readChar();
        parseReturnStatement(tokens, writer);
    } else {
        console.printLine("Unknown statement");
    }
}

// Functions to parse individual statements
parseLetStatement(List<string> tokens, var writer) {
    writer.writeLine("<letStatement>");
    expectSingleToken(tokens, "<keyword> let </keyword>", writer);
    expectIdentifier(tokens, writer); // varName
    if (matchSingleToken(tokens, "<symbol> [ </symbol>")) {
        expectSingleToken(tokens, "<symbol> [ </symbol>", writer);
        parseExpression(tokens, writer);
        expectSingleToken(tokens, "<symbol> ] </symbol>", writer);
    };
    expectSingleToken(tokens, "<symbol> = </symbol>", writer);
    parseExpression(tokens, writer);
    expectSingleToken(tokens, "<symbol> ; </symbol>", writer);
    writer.writeLine("</letStatement>");
}

parseIfStatement(List<string> tokens, var writer) {
    writer.writeLine("<ifStatement>");
    expectSingleToken(tokens, "<keyword> if </keyword>", writer);
    expectSingleToken(tokens, "<symbol> ( </symbol>", writer);
    parseExpression(tokens, writer);
    expectSingleToken(tokens, "<symbol> ) </symbol>", writer);
    expectSingleToken(tokens, "<symbol> { </symbol>", writer);
    parseStatements(tokens, writer);
    expectSingleToken(tokens, "<symbol> } </symbol>", writer);
    if (matchSingleToken(tokens, "<keyword> else </keyword>")) {
        expectSingleToken(tokens, "<keyword> else </keyword>", writer);
        expectSingleToken(tokens, "<symbol> { </symbol>", writer);
        parseStatements(tokens, writer);
        expectSingleToken(tokens, "<symbol> } </symbol>", writer);
    };
    writer.writeLine("</ifStatement>");
}

parseWhileStatement(List<string> tokens, var writer) {
    writer.writeLine("<whileStatement>");
    expectSingleToken(tokens, "<keyword> while </keyword>", writer);
    expectSingleToken(tokens, "<symbol> ( </symbol>", writer);
    parseExpression(tokens, writer);
    expectSingleToken(tokens, "<symbol> ) </symbol>", writer);
    expectSingleToken(tokens, "<symbol> { </symbol>", writer);
    parseStatements(tokens, writer);
    expectSingleToken(tokens, "<symbol> } </symbol>", writer);
    writer.writeLine("</whileStatement>");
}

parseDoStatement(List<string> tokens, var writer) {
    writer.writeLine("<doStatement>");
    expectSingleToken(tokens, "<keyword> do </keyword>", writer);
    parseSubroutineCall(tokens, writer);
    expectSingleToken(tokens, "<symbol> ; </symbol>", writer);
    writer.writeLine("</doStatement>");
}

parseReturnStatement(List<string> tokens, var writer) {
    writer.writeLine("<returnStatement>");
    expectSingleToken(tokens, "<keyword> return </keyword>", writer);
    if (matchSingleToken(tokens, "<symbol> ; </symbol>")==false) {
        parseExpression(tokens, writer);
    };
    expectSingleToken(tokens, "<symbol> ; </symbol>", writer);
    writer.writeLine("</returnStatement>");
}

// Function to parse expressions
parseExpression(List<string> tokens, var writer) {
    writer.writeLine("<expression>");
    parseTerm(tokens, writer);
    //console.writeLine("A10").readChar();
    while (matchOperator(tokens)) {
        //console.writeLine("A7").readChar();
        expectOperator(tokens, writer);
        //console.writeLine("A8").readChar();
        parseTerm(tokens, writer);
    };
    //console.writeLine("A9").readChar();
    writer.writeLine("</expression>");
}

// Function to parse a term
parseTerm(List<string> tokens, var writer) {
    writer.writeLine("<term>");
    if (matchIntegerConstant(tokens)) {
        //console.writeLine("B1").readChar();
        expectIntegerConstant(tokens, writer);
    } else if (matchStringConstant(tokens)) {
        //console.writeLine("B2").readChar();
        expectStringConstant(tokens, writer);
    } else if (matchKeywordConstant(tokens)) {
        //console.writeLine("B3").readChar();
        expectKeywordConstant(tokens, writer);
    } else if (matchIdentifier(tokens)) {
        //console.writeLine("B4").readChar();
        expectIdentifier(tokens, writer);
        if (matchSingleToken(tokens, "<symbol> [ </symbol>")) {
            expectSingleToken(tokens, "<symbol> [ </symbol>", writer);
            parseExpression(tokens, writer);
            expectSingleToken(tokens, "<symbol> ] </symbol>", writer);
        } else if (matchSingleToken(tokens, "<symbol> ( </symbol>")) {
            expectSingleToken(tokens, "<symbol> ( </symbol>", writer);
            parseExpressionList(tokens, writer);
            expectSingleToken(tokens, "<symbol> ) </symbol>", writer);
        } else if (matchSingleToken(tokens, "<symbol> . </symbol>")) {
            expectSingleToken(tokens, "<symbol> . </symbol>", writer);
            expectIdentifier(tokens, writer); // subroutineName
            expectSingleToken(tokens, "<symbol> ( </symbol>", writer);
            parseExpressionList(tokens, writer);
            expectSingleToken(tokens, "<symbol> ) </symbol>", writer);
        }
    } else if (matchSingleToken(tokens, "<symbol> ( </symbol>")) {
        expectSingleToken(tokens, "<symbol> ( </symbol>", writer);
        parseExpression(tokens, writer);
        expectSingleToken(tokens, "<symbol> ) </symbol>", writer);
    } else if (matchUnaryOperator(tokens)) {
        //console.writeLine("B7").readChar();
        expectUnaryOperator(tokens, writer);
        parseTerm(tokens, writer);
    } else {
        console.printLine("Unknown term");
    };
    writer.writeLine("</term>");
}

// Function to parse a list of expressions
parseExpressionList(List<string> tokens, var writer) {
    writer.writeLine("<expressionList>");
    if (matchSingleToken(tokens, "<symbol> ) </symbol>")==false) {
        parseExpression(tokens, writer);
        while (matchSingleToken(tokens, "<symbol> , </symbol>")) {
            expectSingleToken(tokens, "<symbol> , </symbol>", writer);
            parseExpression(tokens, writer);
        };
    };
    writer.writeLine("</expressionList>");
}

// Helper functions to match and expect tokens
matchStatement(List<string> tokens) {
    string token := tokens[ParserState.getCurrentIndex()];
    if (token == "<keyword> let </keyword>" || token == "<keyword> if </keyword>" || token == "<keyword> while </keyword>" || token == "<keyword> do </keyword>" || token == "<keyword> return </keyword>") {
        ^true;
    } else {
        ^false;
    };
}


matchSingleToken(List<string> tokens, string expectedToken) {//---------------------------------------------------
    //console.printLine("match single token").readChar();
    //console.printLine(ParserState.getCurrentIndex()).readChar();
    //console.printLine(tokens[ParserState.getCurrentIndex()]).readChar();
    //console.printLine(expectedToken).readChar();
    if(tokens[ParserState.getCurrentIndex()] == expectedToken){
        
        ^true;
    } else {
        ^false;
    };
    
}

matchOperator(List<string> tokens) {
    //console.printLine("GG &lt;");
    string token := tokens[ParserState.getCurrentIndex()];
    if (token == "<symbol> + </symbol>" || token == "<symbol> - </symbol>" || token == "<symbol> * </symbol>" || token == "<symbol> / </symbol>" || token == "<symbol> &lt; </symbol>" || token == "<symbol> | </symbol>" || token == "<symbol> < </symbol>" || token == "<symbol> > </symbol>" || token == "<symbol> = </symbol>") {
        ^true;
    } else {
        ^false;
    }
}


matchUnaryOperator(List<string> tokens) {
    string token := tokens[ParserState.getCurrentIndex()];
    if (token == "<symbol> - </symbol>" || token == "<symbol> ~ </symbol>") {
        ^true;
    } else {
        ^false;
    }
}


matchIntegerConstant(List<string> tokens) {
    
    if (tokens[ParserState.getCurrentIndex()].startingWith:"<integerConstant>") {
        ^true;
    } else {
        ^false;
    };
}

matchStringConstant(List<string> tokens) {
    if (tokens[ParserState.getCurrentIndex()].startingWith:"<stringConstant>") {
        ^true;
    } else {
        ^false;
    };
}

matchKeywordConstant(List<string> tokens) {
    string token := tokens[ParserState.getCurrentIndex()];
    if (token == "<keyword> true </keyword>" || token == "<keyword> false </keyword>" || token == "<keyword> null </keyword>" || token == "<keyword> this </keyword>") {
        ^true;
    } else {
        ^false;
    };
}


matchIdentifier(List<string> tokens) {
    //console.printLine("The 13").readChar();
    //console.printLine(ParserState.getCurrentIndex()).readChar();
    //console.printLine(tokens[ParserState.getCurrentIndex()]).readChar();
    if(tokens[ParserState.getCurrentIndex()].startingWith:"<identifier>"){
    ^true;
    } else {
        ^false;
    };
}

expectSingleToken(List<string> tokens, string expectedToken, var writer) {//checked------------
    //console.printLine("The 77").readChar();
    //console.printLine(expectedToken).readChar();
    //console.printLine(ParserState.getCurrentIndex()).readChar();
    //console.printLine(tokens[ParserState.getCurrentIndex()]).readChar();
    //console.printLine(tokens[ParserState.getCurrentIndex()] == expectedToken).readChar();
    
    if (tokens[ParserState.getCurrentIndex()] == expectedToken) {
        //console.printLine("The 8").readChar();
        writer.writeLine(tokens[ParserState.getCurrentIndex()]);
        ParserState.incrementIndex();
    } else {
        //console.printLine("The 11").readChar();
        console.printLine("Expected: " + expectedToken + ", found: " + tokens[ParserState.getCurrentIndex()].token);
    };
    //console.printLine("The 12").readChar();
}

expectTwoTokens(List<string> tokens, string option1, string option2, var writer) {
    if (tokens[ParserState.getCurrentIndex()] == option1 || tokens[ParserState.getCurrentIndex()] == option2) {
        writer.writeLine(tokens[ParserState.getCurrentIndex()].toString());
        ParserState.incrementIndex();
    } else {
        console.printLine("Expected: " + option1 + " or " + option2 + ", found: " + tokens[ParserState.getCurrentIndex()].token);
    }
}

expectMultipleTokens(List<string> tokens, var writer) {
    //console.printLine("MULTY TOKEN").readChar();
    
    if (tokens[ParserState.getCurrentIndex()] == "<keyword> constructor </keyword>" || tokens[ParserState.getCurrentIndex()] == "<keyword> function </keyword>" || tokens[ParserState.getCurrentIndex()] == "<keyword> method </keyword>") {
        writer.writeLine(tokens[ParserState.getCurrentIndex()]);
        ParserState.incrementIndex();
    };
}

expectType(List<string> tokens, var writer) {
    //console.printLine("expectType").readChar();
    //console.printLine("expectType").readChar();
    if (matchSingleToken(tokens, "<keyword> int </keyword>") || matchSingleToken(tokens, "<keyword> char </keyword>") || matchSingleToken(tokens, "<keyword> boolean </keyword>") || matchIdentifier(tokens)) {
        writer.writeLine(tokens[ParserState.getCurrentIndex()]);
        ParserState.incrementIndex();
    } else {
        console.printLine("Expected type, found: " + tokens[ParserState.getCurrentIndex()].token);
    }
}

expectIdentifier(List<string> tokens, var writer) {
    //console.printLine("The 9").readChar();
    if (matchIdentifier(tokens)) {
        //console.printLine("The 10").readChar();
        writer.writeLine(tokens[ParserState.getCurrentIndex()]);
        ParserState.incrementIndex();
    } else {
        console.printLine("Expected identifier, found: " + tokens[ParserState.getCurrentIndex()].token);
    }
}

expectIntegerConstant(List<string> tokens, var writer) {
    if (matchIntegerConstant(tokens)) {
        writer.writeLine(tokens[ParserState.getCurrentIndex()].toString());
        ParserState.incrementIndex();
    } else {
        console.printLine("Expected integer constant, found: " + tokens[ParserState.getCurrentIndex()].token);
    }
}

expectStringConstant(List<string> tokens, var writer) {
    if (matchStringConstant(tokens)) {
        writer.writeLine(tokens[ParserState.getCurrentIndex()]);
        ParserState.incrementIndex();
    } else {
        console.printLine("Expected string constant, found: " + tokens[ParserState.getCurrentIndex()].token);
    }
}

expectKeywordConstant(List<string> tokens, var writer) {
    if (matchKeywordConstant(tokens)) {
        writer.writeLine(tokens[ParserState.getCurrentIndex()]);
        ParserState.incrementIndex();
    } else {
        console.printLine("Expected keyword constant, found: " + tokens[ParserState.getCurrentIndex()].token);
    }
}

expectOperator(List<string> tokens, var writer) {
    if (matchOperator(tokens)) {
        writer.writeLine(tokens[ParserState.getCurrentIndex()].toString());
        ParserState.incrementIndex();
    } else {
        console.printLine("Expected operator, found: " + tokens[ParserState.getCurrentIndex()].token);
    }
}

expectUnaryOperator(List<string> tokens, var writer) {
    if (matchUnaryOperator(tokens)) {
        writer.writeLine(tokens[ParserState.getCurrentIndex()].toString());
        ParserState.incrementIndex();
    } else {
        console.printLine("Expected unary operator, found: " + tokens[ParserState.getCurrentIndex()].token);
    }
}

// Function to parse a subroutine call
parseSubroutineCall(List<string> tokens, var writer) {
    expectIdentifier(tokens, writer); // className or varName
    if (matchSingleToken(tokens, "<symbol> . </symbol>")) {
        expectSingleToken(tokens, "<symbol> . </symbol>", writer);
        expectIdentifier(tokens, writer); // subroutineName
    };
    expectSingleToken(tokens, "<symbol> ( </symbol>", writer);
    //console.printLine("the 666").readChar();
    parseExpressionList(tokens, writer);
    //console.printLine("the 888").readChar();
    expectSingleToken(tokens, "<symbol> ) </symbol>", writer);
}
public program() {
    var string pathDir := console.write:"Enter a path:".readLine(); 
    var dir := Directory.assign(pathDir);                                
    var files := dir.getFiles();                                   
    for (var i := 0, i < files.Length, i += 1)                      
    {
        if (files[i].endingWith:"T.xml")                                                
        {
            var Path := files[i].splitBy("\");
            var lengthList := Path.Length;  
            var newPath := Path[lengthList-1];
            var Name := newPath.splitBy(".");
            var lengthSplit := Name.Length;
            var fileSetter := Name[0].Substring(0,(Name[0].Length-1));
            var pathXml := pathDir.toString() + "\" + fileSetter + ".xml";    
            File.assign(pathXml).textwriter().close();              
            var linesList := new List<string>();
            var stringLine;
            File.assign:(files[i]).forEachLine:(line)                
            {
                
                linesList.append:line;
            };
            
            parse(linesList, pathXml);
        };    
    };

   


}