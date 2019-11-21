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

%%%% ---- start pseudo code ----

%% caso ricorsivo 'or' 
regexp_comp(FA_Id, or, [Arg | Args], QIn, QF) :-
    Args != [],
    regexp_comp(FA_Id, or, Args, QIn, QF),
    crea_caso_base(FA_Id, Arg, QIn2, QF2),
    assert(nfa_delta(FA_Id, QIn, ε, QIn2)),
    assert(nfa_delta(FA_Id, QF2, ε, QF)).

%% caso base 'or'
regexp_comp(FA_Id, or, [Arg | []], QIn, QF) :-
    crea_caso_base(FA_Id, Arg, QIn2, QF2), 
    gensym(q, QIn),
    gensym(q, QF), 
    assert(nfa_delta(FA_Id, QIn, ε, QIn2)), 
    assert(nfa_delta(FA_Id, QF2, ε, QF)).

%% caso base singolo nodo
crea_caso_base(FA_Id, Arg, QIn, QF) :-
    gensym(q, QIn),
    gensym(q, QF),
    assert(nfa_delta(FA_Id, QIn, Arg, QF)).

%%%% ---- end pseudo code ----