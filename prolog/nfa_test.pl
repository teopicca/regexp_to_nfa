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

