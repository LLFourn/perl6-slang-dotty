# Slang::Dotty

Make custom method call operators. The arguments you pass to use will
allow make them method call operators. When perl sees one it will call
the corresponding infix for it with:

1. The object it was called on
2. The method name as a string
3. All the arguments it was called with as is

comments and suggestions welcome :)

```perl6

#defines the operators
use Slang::Dotty '~>','<(^_^)>';

#the callbacks -- this one just mimics vanilla '.' method call
sub infix:«~>» ($obj,$method,|args){

    $obj."$method"(|args);
}

#this one wraps the result in a kirby dance
sub infix:«<(^_^)>»($obj,$method,|args) {
    q|(>'-')> ^('-')^|
    ~ $obj."$method"(|args)
    ~ q|<('-'<) (>'-')>|;
}

#normal dotty
my $string = "hello world";

say $string~>uc; #HELLO WORLD

say $string<(^_^)>subst("world","kirby")~>uc; # kirby dance + HELLO KIRBY

```
