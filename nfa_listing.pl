:- discontiguous nfa_final/2.
:- discontiguous nfa_initial/2.
:- discontiguous nfa_delta/4.

nfa_initial(1, a).
nfa_delta(1, a, a, a).
nfa_delta(1, w, w, w).
nfa_final(1, a).

nfa_initial(2, a).
nfa_delta(2, a, a, a).
nfa_final(2, a).

nfa_initial(3, a).
nfa_delta(3, a, a, a).
nfa_final(3, a).

nfa_initial(4, a).
nfa_delta(4, a, a, a).
nfa_final(4, a).

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

