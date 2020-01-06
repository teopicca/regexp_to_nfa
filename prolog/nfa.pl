%%%% -*- Mode: Prolog -*-


%%is regexp

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

not_nfa(Goal) :-
    call(Goal),
    !,
    fail.

not_nfa(_).

not_atom(Arg) :-
    atom(Arg),
    !,
    fail.

not_atom(_).


%%nfa regexp comp

nfa_regexp_comp(FA_Id, RE):-
    is_regexp(RE),
    nonvar(FA_Id),
    not_nfa(nfa_initial(FA_Id, _)),
    scompatta(FA_Id, [RE], QIn, QF),
    asserta(nfa_final(FA_Id, QF)),
    asserta(nfa_initial(FA_Id, QIn)).

%% caso ricorsivo 'or'
regexp_comp(FA_Id, or, [Arg | Args], QIn, QF) :-
    Args \= [],
    regexp_comp(FA_Id, or, Args, QIn, QF),
    scompatta(FA_Id, [Arg], QIn2, QF2),
    asserta(nfa_delta(FA_Id, QIn, epsilon, QIn2)),
    asserta(nfa_delta(FA_Id, QF2, epsilon, QF)),
    !.

%% caso base 'or'
regexp_comp(FA_Id, or, Arg, QIn, QF) :-
    scompatta(FA_Id, Arg, QIn2, QF2),
    gensym(q, QIn),
    gensym(q, QF),
    asserta(nfa_delta(FA_Id, QIn, epsilon, QIn2)),
    asserta(nfa_delta(FA_Id, QF2, epsilon, QF)),
    !.

%% caso 'star'
regexp_comp(FA_Id, star, Arg, QIn, QF) :-
    scompatta(FA_Id, Arg, QIn2, QF2),
    gensym(q, QIn),
    gensym(q, QF),
    asserta(nfa_delta(FA_Id, QIn, epsilon, QIn2)),
    asserta(nfa_delta(FA_Id, QIn, epsilon, QF)),
    asserta(nfa_delta(FA_Id, QF2, epsilon, QIn2)),
    asserta(nfa_delta(FA_Id, QF2, epsilon, QF)),
    !.

%% caso 'plus' in questo caso vengono creati anche uno stato iniziale e
%% uno finale
regexp_comp(FA_Id, plus, Arg, QIn, QF) :-
    scompatta(FA_Id, Arg, QIn2, QF2),
    gensym(q, QIn),
    gensym(q, QF),
    regexp_comp(FA_Id, star, Arg, QIn3, QF3),
    asserta(nfa_delta(FA_Id, QIn, epsilon, QIn2)),
    asserta(nfa_delta(FA_Id, QF2, epsilon, QIn3)),
    asserta(nfa_delta(FA_Id, QF3, epsilon, QF)),
    !.

%% caso iniziale 'seq'
regexp_comp(FA_Id, seq, Arg, QIn, QF) :-
    regexp_comp_rec(FA_Id, seq, Arg, QIn2, QF2),
    gensym(q, QIn),
    gensym(q, QF),
    assert(nfa_delta(FA_Id, QIn, epsilon, QIn2)),
    assert(nfa_delta(FA_Id, QF2, epsilon, QF)),
    !.

%%  caso base
regexp_comp(FA_Id, Op, [], QIn, QF) :-
    gensym(q, QIn),
    gensym(q, QF),
    assert(nfa_delta(FA_Id, QIn, Op, QF)),
    !.

regexp_comp(FA_Id, X, Xs, QIn, QF) :-
    Arg =.. [X | Xs],
    gensym(q, QIn),
    gensym(q, QF),
    assert(nfa_delta(FA_Id, QIn, Arg, QF)),
    !.


%% caso ricorsivo 'seq'
regexp_comp_rec(FA_Id, seq, [Arg | Args], QIn, QF2) :-
    Args \= [],
    scompatta(FA_Id, [Arg], QIn, QF3),
    regexp_comp_rec(FA_Id, seq, Args, QIn2, QF2),
    assert(nfa_delta(FA_Id, QF3, epsilon, QIn2)).

%%  caso base 'seq'
regexp_comp_rec(FA_Id, seq, [Arg], QIn, QF) :-
    scompatta(FA_Id, [Arg], QIn, QF).

%% scompatta l'input correttamente,
%% il primo caso serve per la compound di arietà 0, il secondo per il resto

scompatta(FA_Id, [Arg], QIn, QF) :-
    not_atom(Arg),
    compound_name_arity(Arg, _, Arity),
    Arity = 0,
    regexp_comp(FA_Id, Arg, [], QIn, QF).

scompatta(FA_Id, [Arg], QIn, QF) :-
    Arg =.. [Op | Args],
    regexp_comp(FA_Id, Op, Args, QIn, QF).

%% nfa test
nfa_test(FA_Id, In):-
    nfa_initial(FA_Id, S),
    nfa_test_accept(FA_Id, In, S).

nfa_test_accept(FA_Id, [], Q):-
    nfa_final(FA_Id, Q),
    !.

nfa_test_accept(FA_Id, [In | Ins], S):-
    nfa_delta(FA_Id, S, In, N),
    nfa_test_accept(FA_Id, Ins, N),
    !.

nfa_test_accept(FA_Id, Ins, S):-
    nfa_delta(FA_Id, S, epsilon, N),
    nfa_test_accept(FA_Id, Ins, N),
    !.

%%%nfa listing

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

%%nfa clear
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
