%%%% -*- Mode: Prolog -*-
%%%% test_nfa_regexp_comp.pl

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

%% scompatta l'input correttamente, il primo caso serve per la compound di arietà 0, il secondo per il resto

scompatta(FA_Id, [Arg], QIn, QF) :-
    not_atom(Arg),
    compound_name_arity(Arg, _, Arity),
    Arity = 0,
    regexp_comp(FA_Id, Arg, [], QIn, QF).
    
scompatta(FA_Id, [Arg], QIn, QF) :-
    Arg =.. [Op | Args],
    regexp_comp(FA_Id, Op, Args, QIn, QF).
