# Lab 6: Parser generators

In this lab, you'll be working with `ocamllex` (a lexer generator) and `menhir`
(a parser generator) to lex and parse an arithmetic language.

## References

Menhir: http://gallium.inria.fr/~fpottier/menhir/manual.html

## Starting point

We've provided a lexer (`syntax/lex.mll`) and parser (`syntax/parse.mly`) for a
simple language supporting integers, infix addition, and a `print` operator.
Programs are composed of statements of the form `print <expr>`. For example, the
following are valid programs as of now:

-   `print 1`
-   `print 1 + 2`
-   ```
    print 1 + 2
    print 4
    ```

### Running the interpreter

To run the interpreter, execute the `interp` binary as follows:

```
dune exec ./bin/interp.exe -- -e "<PROGRAM>"
```

This will parse the program `<PROGRAM>` with your parser and interpret the AST
that is produced. For instance, you could use the following to test the starter
code:

```
dune exec ./bin/interp.exe -- -e "print 1 + 2"
```

Once the programs you want to run become more complex, it'll be easier to write
them as files. To run the interpreter on a file, execute:

```
dune exec ./bin/interp.exe -- <FILE>
```

## Part 1: Extending the language

First, extend the lexer and parser to support the following:

-   Float literals e.g. `1.23`
-   Scientific notation literals e.g. `3.47e5` (`3.47 * 10^5 = 347000`)
    -   OCaml's `float_of_string` function will accept these literals as input,
        so you just have to extend the number parse rule to recognize the new
        literal form
-   `(` and `)` for grouping expressions e.g. `print (1 + 2) * 3`
-   `-`, `*`, `/`, and `^` (exponentiation) binary infix operators e.g. `5 - 3`,
    `1 * 2`, `4 / 2`, `2 ^ 3`
    -   `-` should also be usable as a unary prefix operator for negation e.g.
        `-5`
-   Prefix `log`, `sin`, `cos`, `tan` operators e.g. `log 5`
-   Variable assignments e.g. `foo = 1` (corresponding to `Assign` in the AST)
    -   Variable names may contain letters, underscores, or numbers, but must
        start with a letter
    -   The statements that make up a program may now either be `print`
        statements or variable assignments

### Associativity

-   `-`, `*`, and `/` should be left-associative (similar to `+`)
    -   When used for negation, `-` should be non-associative
-   `^` should be right-associative (i.e. `2 ^ 3 ^ 4 = 2 ^ (3 ^ 4)`)

### Precedence

Of all the operators, `log`, `sin`, `cos`, `tan`, and negation should have the
highest precedence, followed by exponentiation, then multiplication and
division, then addition and subtraction.

**Note:** You may not use Menhir's `%left`, `%right`, `%nonassoc`, or `%prec`
declarations yet, since we'll be using them in the next part. Instead, you
should encode associativity and precedence explicitly using production rules,
similar to how we've encoded the left-associativity of addition.

**Checkoff:** Call over a TA to go over your solution.

## Part 2: Simplifying the parser

Next, we'll be simplifying the parser using some of Menhir's useful features.
**Before beginning work on this section, save a copy of `parse.mly` -- you'll
need it again for part 3.**

Using Menhir's `%left`, `%right`, and `%nonassoc` declarations (see the
reference linked above, and note that it calls precedence "priority"), establish
the same associativity and precedence rules for the operators in our language.
This should reduce the number of parse rules you need to represent the language.

**Hint:** You may need to use the `%prec` declaration to override the precedence
of the `-` operator when it is used for negation.

**Checkoff:** Call over a TA to go over your solution.

## Part 3: Implicit multiplication

When writing mathematical expressions in non-programming contexts, it's common
to write expressions like `3 (4 + 5)` to implicitly mean `3 * (4 + 5)`. Add
support for this form of expressions to your parser, converting them into the
same ASTs that the explicit forms would parse to e.g.
`Times (Num 3) (Plus (Num 4) (Num 5))` for the previous example.

In order to add support for this form of expression in the parse rules, we'll
need to go back to manually describing precedence and associativity instead of
using Menhir's succinct declarations, so swap your current `parse.mly` file with
the copy saved at the beginning of part 2. The reason for this is that Menhir's
precedence and associativity hints help the parser generator resolve
shift-reduce conflicts. There's a set of rules that it uses to do this and they
involve looking at the token being parsed (e.g. `PLUS`). In the case of implicit
multiplication, however, there isn't any such token to look at.

**Checkoff:** Call over a TA to get checked off for the lab.
