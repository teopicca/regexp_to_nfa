# NFA COMPILER

NFA COMPILER allows you to compile a regular expression in to an nfa in Prolog.

# Regexp Format
 The alfabet is all that satisfy compound/1 or atomic/1
    - <re1><re2> ... <rek> --> seq(<re1>, <re2>, ..., <rek>)
    - <re1>|<re2>| ... | <rek> --> or(<re1>, <re2>, ..., <rek>)
    - <re>* --> star(<re>)
    - <re>+ --> plus(<re>)
# General Usage
```sh
$ prolog nfa.pl
?- nfa_regexp_comp(FA_Id, RE). #compile the regexp
?- nfa_test(FA_Id, input). # test the input
?- nfa_clear. #remove all nfa
?- nfa_clear(FA_Id) #remove a specific nfa
```

# Other Predicates
```sh
?- is_regexp(RE) #True if RE is a regular expression
?- nfa_list #list all nfa 
?- nfa_list(FA_Id). #list a specific nfa
```
