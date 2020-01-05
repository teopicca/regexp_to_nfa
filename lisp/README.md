# NFA COMPILER

NFA COMPILER allows you to compile a regular expression in to an nfa that recognize it in LISP.

# Regexp Format
The alfabet is made up of s-expression

 ```sh   
    - (seq <re1> <re2> ... <rek>) #concatenation
    - (or <re1> <re2> ... <rek>)  #alternation
    - (star <re>) #Kleene star
    - (plus <re>) #Kleene plus
```

# Practical Examples
```
[1]> (load "nfa.lisp")
;; Loaded file nfa.lisp
[2]> (is-regexp 'a)
T
[3]> (defparameter nfa1 (nfa_regexp_comp nfa1 '(seq a b))). #compile regexp
NFA1
[4]> (nfa-test nfa '(a b)) #test input
T
[5]> (nfa-test nfa '(a c))
NIL
```
