use nqp;
use QAST:from<NQP>;
sub EXPORT(*@ops){

    my $gram = role Dotty::Slang::Grammar {};
    my $actions =  role Dotty::Slang::Actions {};

    sub lk(Mu \h, \k) {
        nqp::atkey(nqp::findmethod(h, 'hash')(h), k);
    }

    #no clue why but QAST::SVal.new won't work inside eval
    sub sval($str){
        QAST::SVal.new(:value($str));
    }

    for @ops -> $op {

        #add the custom operator to the grammar
        my $gram_dotty = EVAL q|my token dotty:sym«| ~ $op ~ q|» {
            <sym> <dottyop>
            <O('%methodcall')>
        }|;

        $gram.^add_method($gram_dotty.name, $gram_dotty);

        #add the custom action to the actions
        my $action = EVAL q|my method dotty:sym«| ~ $op ~ q|»(Mu $/ is rw) {
            my $past := lk($/,'dottyop').ast;
            my $name := $past.name;
            $past.op('call');
            $past.name('&infix:<| ~ $op ~ q|>');
            $past.unshift(sval($name));
            return $/.'!make'($past);
        }|;

        $actions.^add_method( $action.name, $action);
    }

    my Mu $MAIN-grammar := nqp::atkey(%*LANG, 'MAIN');
    nqp::bindkey(%*LANG, 'MAIN', $MAIN-grammar.HOW.mixin($MAIN-grammar, $gram));
    nqp::bindkey(%*LANG, 'MAIN-actions', %*LANG<MAIN-actions>.HOW.mixin(%*LANG<MAIN-actions>, $actions));
    {}
}
