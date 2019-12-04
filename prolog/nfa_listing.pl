:- discontiguous nfa_final/2.
:- discontiguous nfa_initial/2.
:- discontiguous nfa_delta/4.

nfa_list :-
    findall( X, nfa_initial(X, _), L),
    nfa_list(L).

nfa_list([]) :-
    nl,
    !.

nfa_list([X | Xs]):-
    write_nfa(X),   
    nfa_list(Xs),
    !.

nfa_list(X) :-
    nfa_initial(X, _),
    write_nfa(X),!.

write_nfa(X) :-
	nl,
	listing(nfa_initial(X, _)),
	listing(nfa_delta(X, _, _, _)),
	listing(nfa_final(X, _)),
	nl.

