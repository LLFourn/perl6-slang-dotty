use nqp;
use QAST:from<NQP>;
sub EXPORT(*@ops){

    my $gram = role Dotty::Slang::Grammar {};
    my $role =  role Dotty::Slang::Actions {};

    sub lk(Mu \h, \k) {
        nqp::atkey(nqp::findmethod(h, 'hash')(h), k);
    }

    #no clue why but QAST::SVal.new won't work inside eval
    sub sval($str){
        QAST::SVal.new(:value($str));
    }

    for @ops -> $op {

        my $meth_name = 'dotty' ~ $op;

        my $gram_regex = EVAL q|my token dotty:sym«| ~ $op ~ q|» {
            <sym> <dottyop>
            <O('%methodcall')>
        }|;

        $gram.^add_method( $gram_regex.name,$gram_regex);


        my $action_meth = EVAL q|my method dotty:sym«| ~ $op ~ q|»(Mu $/ is rw) {
            my $past := lk($/,'dottyop').ast;
            my $name := $past.name;
            $past.op('call');
            $past.name('&infix:<| ~ $op ~ q|>');
            $past.unshift(sval($name));
            return $/.'!make'($past);
        }|;

        $role.^add_method( $meth_name, $action_meth);
    }

    my Mu $MAIN-grammar := nqp::atkey(%*LANG, 'MAIN');
    nqp::bindkey(%*LANG, 'MAIN', $MAIN-grammar.HOW.mixin($MAIN-grammar, $gram));
    nqp::bindkey(%*LANG, 'MAIN-actions', %*LANG<MAIN-actions>.HOW.mixin(%*LANG<MAIN-actions>, $role));
    {}
}
