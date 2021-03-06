%%%% -*- Mode: Prolog -*-

%%%% is_regexp.pl



    

operator(star).

operator(plus).

operator(or).

operator(seq).





not_op(Goal) :- call(Goal), !, fail.

not_op(_).



is_regexp([star | Xs]):-

    length(Xs, Y),

    !,

    Y == 1,

    is_regexp(Xs).



is_regexp([plus | Xs]):-

    length(Xs, Y),

    !,

    Y == 1,

    is_regexp(Xs).



is_regexp([or | Xs]):-

    length(Xs, Y),

    !,

    Y >=2,

    is_regexp(Xs). 



is_regexp([seq | Xs]):-

    length(Xs, Y),

    !,

    Y >=2,

    is_regexp(Xs). 





is_regexp([X|Xs]):-

    is_regexp(X),

    is_regexp(Xs),

    !.



is_regexp([]):- !.



is_regexp(X):-

    atomic(X),

    !.



is_regexp(X):-

    compound(X),

    compound_name_arity(X, F, _),

    not_op(operator(F)),

    !.



is_regexp(RE):-

    RE =.. REList,

    is_regexp(REList),

    !.
