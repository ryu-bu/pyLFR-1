grammar lfrX;

skeleton: moduledefinition body 'endmodule';

moduledefinition: 'module' ID ('(' ioblock ')')? ';';

body
   :   ( statements | distributionBlock ) +
   ;

ioblock
   :    vectorvar (',' vectorvar)*
   |    explicitIOBlock ( ',' explicitIOBlock)?
   ;

vectorvar : ID vector? ;

explicitIOBlock
   :   'finput' declvar (','declvar)*
   |   'foutput' declvar (',' declvar)*
   |   'control' declvar (','declvar)*
   ;

declvar : vector? ID ;

distributionBlock
   :  'distribute@' '(' signallist ')' 'begin' distributionBody 'end'
   ;

distributionBody
//TODO: modify the distribute block to be more precise
   :  (distributionassignstat)*
   |  caseBlock
   ;

caseBlock
   :  'case' '(' lhs ')' casestat 'endcase'
   ;

casestat
   :  distributionassignstat
   ;

distributionassignstat
   :  lhs '=' (number | variables | expression) ';'
   //TODO: Have a switch->case block
   ;

signallist : ID vector? (',' ID vector?)* ;

statements
   :   statement
//    |   (blocks)+ //Uncomment this once we are making the distribute and always blocks
   |   technologydirectives
   ;

statement
   :   ioassignstat  //This needs ot be replaced by any number different kinds of statements that will
   |   assignstat
   |   tempvariablesstat
   ;

tempvariablesstat
   :   fluiddeclstat
   |   reactorstat
   |   nodestat
   |   storagestat
   |   numvarstat
   ;

nodestat : 'node' ID (',' ID)* ;

reactorstat : 'reactor' ID (',' ID)* ;

fluiddeclstat : 'fluid' declvar (',' declvar)* ';' ;

storagestat : 'storage' vector? ID (',' ID)* ';';

numvarstat : 'number' ID '=' number (',' ID '=' number)* ';';

assignstat
   :   'assign' lhs '=' (number | variables | expression)  ';'
   ;


//TODO: Look up how the grammar is given for Verilog. This will have be to correct for actually solving the logic things
expression
   :   (variables | number) (binary_operator (variables | number))+
   |   unary_operator (variables)
   ;

vector
   :   '[' start=Decimal_number ':' end=Decimal_number  ']'
   ;

variables
   : vectorvar
   | concatenation
   ;

concatenation : '{' vectorvar (',' vectorvar)* '}' vector? ;

lhs : variables;

ioassignstat
   :   explicitIOBlock ';'
   ;

technologydirectives
   :   '#' directive  (('|' | '&') directive)* ;

directive
   :   performancedirective
   |   technologymappingdirective
   ;

technologymappingdirective : 'MAP' ('\'' ID+ '\'' | '"' ID+ '\'') operator=binary_operator ;

performancedirective : ID   '='  number unit? ;

unit: ID;

ID
   :   ('a'..'z' | 'A'..'Z'|'_')('a'..'z' | 'A'..'Z'|'0'..'9'|'_')*
   ;

WS : [ \t\r\n]+ -> skip ;


One_line_comment
   : '//' .*? '\r'? '\n' -> channel (HIDDEN)
   ;


Block_comment
   : '/*' .*? '*/' -> channel (HIDDEN)
   ;

// Operators - Taken from Verilog2001
unary_operator
   : '+'
   | '-'
   | '!'
   | '~'
   | '&'
   | '~&'
   | '|'
   | '~|'
   | '^'
   | '~^'
   | '^~'
   ;

binary_operator
   : '+'
   | '-'
   | '*'
   | '/'
   | '%'
   | '=='
   | '!='
   | '==='
   | '!=='
   | '&&'
   | '||'
   | '**'
   | '<'
   | '<='
   | '>'
   | '>='
   | '&'
   | '|'
   | '^'
   | '^~'
   | '~^'
   | '>>'
   | '<<'
   | '>>>'
   | '<<<'
   ;

unary_module_path_operator
   : '!'
   | '~'
   | '&'
   | '~&'
   | '|'
   | '~|'
   | '^'
   | '~^'
   | '^~'
   ;

binary_module_path_operator
   : '=='
   | '!='
   | '&&'
   | '||'
   | '&'
   | '|'
   | '^'
   | '^~'
   | '~^'
   ;



//Numbers - Taken from the Verilog 2001
number
   : Decimal_number
   | Octal_number
   | Binary_number
   | Hex_number
   | Real_number
   ;


Real_number
   : Unsigned_number '.' Unsigned_number | Unsigned_number ('.' Unsigned_number)? [eE] ([+-])? Unsigned_number
   ;


Decimal_number
   : Unsigned_number | (Size)? Decimal_base Unsigned_number | (Size)? Decimal_base X_digit ('_')* | (Size)? Decimal_base Z_digit ('_')*
   ;


Binary_number
   : (Size)? Binary_base Binary_value
   ;


Octal_number
   : (Size)? Octal_base Octal_value
   ;


Hex_number
   : (Size)? Hex_base Hex_value
   ;


fragment Sign
   : [+-]
   ;


fragment Size
   : Non_zero_unsigned_number
   ;


fragment Non_zero_unsigned_number
   : Non_zero_decimal_digit ('_' | Decimal_digit)*
   ;


fragment Unsigned_number
   : Decimal_digit ('_' | Decimal_digit)*
   ;


fragment Binary_value
   : Binary_digit ('_' | Binary_digit)*
   ;


fragment Octal_value
   : Octal_digit ('_' | Octal_digit)*
   ;


fragment Hex_value
   : Hex_digit ('_' | Hex_digit)*
   ;


fragment Decimal_base
   : '\'' [sS]? [dD]
   ;


fragment Binary_base
   : '\'' [sS]? [bB]
   ;


fragment Octal_base
   : '\'' [sS]? [oO]
   ;


fragment Hex_base
   : '\'' [sS]? [hH]
   ;


fragment Non_zero_decimal_digit
   : [1-9]
   ;


fragment Decimal_digit
   : [0-9]
   ;


fragment Binary_digit
   : X_digit | Z_digit | [01]
   ;


fragment Octal_digit
   : X_digit | Z_digit | [0-7]
   ;


fragment Hex_digit
   : X_digit | Z_digit | [0-9a-fA-F]
   ;


fragment X_digit
   : [xX]
   ;


fragment Z_digit
   : [zZ?]
   ;