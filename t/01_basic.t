use lib 'lib';
use Slang::Dotty '~>','<(^_^)>';
use Test;

sub infix:«~>» ($obj,$method,|args){
    $obj."$method"(|args);
}

sub infix:«<(^_^)>»($obj,$method,|args) {
    $obj."$method"(|args);
}

ok "hello"~>uc eq "HELLO", "~> works";
ok "hello"<(^_^)>uc eq "HELLO","<(^_^)> works";
