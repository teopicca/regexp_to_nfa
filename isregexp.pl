%%%% -*- Mode: Prolog -*-
%%%% isregexp.pl




is_regexp([star | [X]]):-
    is_regexp(X).

is_regexp([plus | [X]]):-
    is_regexp(X).

is_regexp([or | Xs]):-
    is_regexp(Xs).

is_regexp([seq | Xs]):-
    is_regexp(Xs).

is_regexp([X|Xs]):-
    is_regexp(X),
    is_regexp(Xs).

is_regexp([]).


is_regexp(X):-
    atomic(X),
    is_alpha(X).

is_regexp(RE):-
    RE =.. REList,
    is_regexp(REList).

