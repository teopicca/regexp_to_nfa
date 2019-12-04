:- dynamic nfa_initial/2.
:- dynamic nfa_final/2.
:- dynamic nfa_delta/4.

nfa_clear :-
    findall( X, nfa_initial(X, _), L),
    nfa_clear(L).

nfa_clear([]) :-
    nl,
    !.

nfa_clear([X | Xs]):-
    erase_nfa(X),   
    nfa_clear(Xs),
    !.

nfa_clear(X) :-
    nfa_initial(X, _),
    erase_nfa(X),!.

erase_nfa(X) :-
	retract(nfa_initial(X, _)),
	retract(nfa_delta(X, _, _, _)),
	retract(nfa_final(X, _)).
