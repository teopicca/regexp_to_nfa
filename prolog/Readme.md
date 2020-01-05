# NFA COMPILER

NFA COMPILER allows you to compile a regular expression in to an nfa that recognize it in Prolog.

# Regexp Format
The alfabet is all that satisfy compound/1 or atomic/1

 ```sh   
    - seq(<re1>, <re2>, ..., <rek>) #concatenation
    - or(<re1>, <re2>, ..., <rek>)  #alternation
    - star(<re>) #Kleene star
    - plus(<re>) #Kleene plus
```

# Pratical Examples
```sh
$ prolog nfa.pl
?- nfa_regexp_comp(nfa1, seq(a,b)). #compile regexp
true.

?- nfa_test(nfa1, [a,b]). # test input
true.

?- nfa_test(nfa1, [a,c]).
false.

```

# Other Predicates
```sh
?- is_regexp(RE). #True if RE is a regular expression
?- nfa_list. #list all nfa 
?- nfa_list(FA_Id). #list a specific nfa
?- nfa_clear. # erase all nfa
?- nfa_clear(FA_Id). erase a specific nfa
```
