# NFA COMPILER

NFA COMPILER allows you to compile a regular expression in to an nfa that recognize it in Prolog.

# Regexp Notation
The alfabet is all that satisfy compound/1 or atomic/1

 ```sh   
    - seq(<re1>, <re2>, ..., <rek>) #concatenation
    - or(<re1>, <re2>, ..., <rek>)  #alternation
    - star(<re>) #Kleene star
    - plus(<re>) #Kleene plus
```

# Predicates Documentation

```sh
?- is_regexp(RE).
```
Return true if RE is a regular expression. 

Notice if you use **STAR** or **PLUS** in a RE you must use only one argument, to respect the arity of these operands.
Notice if you use **OR** or **SEQ** in a RE you must use only 2+ arguments, to respect the arity of these operands.


```sh
?- nfa_regexp_comp(FA_Id, RE).
```
Return true if RE can be compiled into an e-nfa using **Tompson's costruction**. 
FA_Id is an identifier that is associated with the regexp given as second argumet. 
It has to be a prolog term without variable

The structure of the e-nfa is made up of the following predicates:
```
nfa_initial(FA_Id, Qin)
nfa_delta(Fa_Id, Q, transition, Q)
nfa_final(FA_Id, Qf)
```
The whole automa structure is asserted in the prolog database.


```sh
?- nfa_test(FA_Id, Input).
```
Return true if RE is consumed in the e-nfa FA_id. 
The input has to be a prolog list of Alphabet's symbols. 

```sh
?- nfa_list. 
?- nfa_list(FA_Id).
```
- nfa_list/0: return all e-nfa asserted in the prolog database.
- nfa_list/1: return a specific e-nfa 

```sh
?- nfa_clear. 
?- nfa_clear(FA_Id).
```
- nfa_clear/0:  wipe all e-nfa from the prolog database
- nfa_clear/1:  wipe a specific e-nfa.


# Practical Examples
```sh
$ prolog nfa.pl
?- nfa_regexp_comp(nfa1, seq(a,b)). #compile regexp
true.

?- nfa_test(nfa1, [a,b]). # test input
true.

?- nfa_test(nfa1, [a,c]).
false.

```
