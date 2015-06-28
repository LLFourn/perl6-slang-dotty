use v6;
use lib 'lib';
use Slang::Dotty '~>','<(^_^)>';
use Test;

sub infix:«~>» ($obj,$method,|args){
    $obj."$method"(|args);
}

sub infix:«<(^_^)>»($obj,$method,|args) {
    q|(>'-')> ^('-')^|
    ~ $obj."$method"(|args)
    ~ q|<('-'<) (>'-')>|;
}

my $string = "hello world";
ok $string~>uc eq "HELLO WORLD", "~> works";
ok $string<(^_^)>subst("world","kirby")~>uc eq
    "(>'-')> ^('-')^HELLO KIRBY<('-'<) (>'-')>","<(^_^)> works";
