# Slang::Dotty

Make custom method call operators. The arguments you pass to use will
create a allow you to use those strings as method call operators. When
one is called it will call an infix with the object it was called on,
the name of the method and all the arguments.

comments and suggestions welcome :)

```perl6

use Slang::Dotty '~>','<(^_^)>';

sub infix:«~>» ($obj,$method,|args){
    $obj."$method"(|args);
}

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
