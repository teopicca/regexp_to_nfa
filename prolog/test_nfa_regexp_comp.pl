%%%% -*- Mode: Prolog -*-
%%%% isregexp.pl

nfa_regexp_comp(FA_Id, RE):-
    is_regexp(RE),
    nonvar(FA_Id),
    RE =.. [OP | Args],
    regexp_comp(FA_Id, OP, Args,QIn, QF),
    asserta(nfa_final(FA_Id, QF)),
    asserta(nfa_initial(FA_Id, QIn)).

regexp_comp(FA_Id, or, [ Arg | Args], QIn, QF):-
    atomic(Arg),
    regexp_comp(FA_Id, atomic, Arg),
    
    regexp_comp(FA_Id, or, Args).

%% caso ricorsivo 'or' 
regexp_comp(FA_Id, or, [Arg | Args], QIn, QF) :-
    Args \= [],
    regexp_comp(FA_Id, or, Args, QIn, QF),
    caso_base(FA_Id, Arg, QIn2, QF2),
    assert(nfa_delta(FA_Id, QIn, ε, QIn2)),
    assert(nfa_delta(FA_Id, QF2, ε, QF)).

%% caso base 'or'
regexp_comp(FA_Id, or, [Arg | []], QIn, QF) :-
    caso_base(FA_Id, Arg, QIn2, QF2), 
    gensym(q, QIn),
    gensym(q, QF), 
    assert(nfa_delta(FA_Id, QIn, ε, QIn2)), 
    assert(nfa_delta(FA_Id, QF2, ε, QF)).

%% caso 'star'    
regexp_comp(FA_Id, star, Arg, QIn, QF) :-
    caso_base(FA_Id, Arg, QIn2, QF2),
    gensym(q, QIn),
    gensym(q, QF),
    assert(nfa_delta(FA_Id, QIn, ε, QIn2)),
    assert(nfa_delta(FA_Id, QIn, ε, QF)),
    assert(nfa_delta(FA_Id, QF2, ε, QIn2)),
    assert(nfa_delta(FA_Id, QF2, ε, QF)).

%% Controlla se il caso base passato è un caso finale oppure un caso ricorsivo (or, star, plus seq)
caso_base(FA_Id, Arg, QIn, QF) :-
    Arg =.. [Op | Args], 
    caso_base_scelta(FA_Id, Op, Args, QIn, QF).

%% Se il caso base è un 'or', richiama la funzione corretta
caso_base_scelta(FA_Id, or, Args, QIn, QF) :-
    Args \= [],
    regexp_comp(FA_Id, or, Args, QIn, QF).

%% Se il caso base è una 'star', richiama la funzione corretta
caso_base_scelta(FA_Id, star, Args, QIn, QF) :-
    Args \= [],
    regexp_comp(FA_Id, star, Args, QIn, QF).

%% Se il caso base è una 'plus', richiama la funzione corretta
caso_base_scelta(FA_Id, plus, Args, QIn, QF) :-
    Args \= [],
    regexp_comp(FA_Id, plus, Args, QIn, QF).
    
%% Se il caso base è una 'seq', richiama la funzione corretta
caso_base_scelta(FA_Id, seq, Args, QIn, QF) :-
    Args \= [],
    regexp_comp(FA_Id, seq, Args, QIn, QF).

%% Quando Arg nel predicato caso_base è un atomo, viene eseguito questo predicato (creazione di un singolo nodo).
caso_base_scelta(FA_Id, Op, [], QIn, QF) :-
    gensym(q, QIn),
    gensym(q, QF),
    assert(nfa_delta(FA_Id, QIn, Op, QF)).
