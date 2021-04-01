%{ open Ast %}

%token <float> NUMBER
%token PRINT NEWLINE
%token PLUS
%token EOF

%start <stmt list> main

%%

main:
| s = stmt NEWLINE rest = main
    { s :: rest }
| s = stmt EOF
  { [s] }
| EOF
  { [] }

stmt:
| PRINT e = expr1
  { Print e }

expr1:
| e1 = expr1 PLUS e2 = expr0
  { Plus (e1, e2) }
| e = expr0 { e }

expr0:
| n = NUMBER
  { Num n }
