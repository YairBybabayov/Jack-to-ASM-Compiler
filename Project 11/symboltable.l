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

class symbolTableItem
{
   field name;
   field type;
   field kind;
   field index;
   
   
   constructor(string name_input, string type_input, string kind_input, int index_input)
    {
        name:=name_input;
        type:=type_input;
        kind:=kind_input;
        index:=index_input; 
    }
    
    getName()
    {
        ^name;
    }
    
    getType()
    {
        ^type;
    }
    
    getKind()
    {
        ^kind;
    }
    
    getIndex()
    {
        ^index;    
    }
    
    printDetails()
    {

    console.writeLine("Name: " + name + ", Type: " + type + ", Kind: " + kind + ", Index: " + index.toInt().toString());
    }
    

}


class symbolTable
{
    field _symbolItems:=new List<symbolTableItem>();
    field numOfItems:=0;
    
    constructor()
    { 
      _symbolItems:=new List<symbolTableItem>();
    }
    
    addItem(symbolTableItem newItem)
    {

        console.writeLine("Adding new item: " + newItem.getName());
        numOfItems:=numOfItems+1;
        _symbolItems.append(newItem);
        console.writeLine("Current number of items: " + numOfItems.toString());
        
    }
    

    getNumOfSymbols()
    {
      ^numOfItems;
    }

    
    clearTable()
    {
        _symbolItems:=new List<symbolTableItem>(); 
    }
    
    startSubroutine()
    {
        _symbolItems := new List<symbolTableItem>();
        numOfItems := 0;
    }

    define(string name, string type, string kind)
    {
        var index := self.varCount(kind);
        var newItem := new symbolTableItem(name, type, kind, index);
        self.addItem(newItem);
    }

    varCount(string kind)
    {
        var count := 0;
        _symbolItems.forEach:(item)
        {
            if (item.getKind() == kind)
            {
                count += 1;
            }
        };
        ^ count;
    }

    kindOf(string name)
    {
        _symbolItems.forEach:(item)
        {
            if (item.getName() == name)
            {
                ^ item.getKind();
            }
        };
        ^ "NONE";
    }

    typeOf(string name)
    {
        _symbolItems.forEach:(item)
        {
            if (item.getName() == name)
            {
                ^ item.getType();
            }
        };
        ^ "NONE";
    }

    indexOf(string name)
    {
        _symbolItems.forEach:(item)
        {
            if (item.getName() == name)
            {
                ^ item.getIndex();
            }
        };
        ^ -1;
    }
   
    printTable()
    {
      console.writeLine("the table contains of: ");
      _symbolItems.forEach:(item)
      {
          item.printDetails();
      };
       
            
      console.readChar();   
    
    }
        
}

