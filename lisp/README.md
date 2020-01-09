# NFA COMPILER

NFA COMPILER allows you to compile a regular expression in to an nfa that recognize it in LISP.

# Regexp Notation
The alfabet is made up of s-expression

 ```sh   
    - (seq <re1> <re2> ... <rek>) #concatenation
    - (or <re1> <re2> ... <rek>)  #alternation
    - (star <re>) #Kleene star
    - (plus <re>) #Kleene plus
```
# Functions Documentation

```
[1]> (is-regexp RE)
```

Return true if RE is a regular expression. 

Since the alphabet is the set of s-exp, you are not allowed to use **seq**, **or**, **star**, **plus** as first element.


```
[2]> (nfa-regexp-comp RE)
```
Return the e-nfa built using **Tompson's construction** for the input regexp. 
The e-nfa has the following structure:
```
( Qin ((Q transition Q) ... )) Qf) 
```
Qin ... Qf are created using gensym [http://clhs.lisp.se/Body/f_gensym.htm]

If the regexp can't be compiled the function return NIL



```
[3]> (nfa-test FA Input)
```
Return true if the given input is consumed by the e-nfa FA, i.e it's in a final state Qf.
The input format has to be expressed as a list.


# Practical Examples
```
[1]> (load "nfa.lisp")
;; Loaded file nfa.lisp
[2]> (is-regexp '(seq a b)) # '(seq a b) is a s-exp for the regexp a conc b
T
[3]> (defparameter nfa1 (nfa-regexp-comp nfa1 '(seq a b))) #compile regexp and store it in nfa1
NFA1
[4]> (nfa-test nfa1 '(a b)) #test input
T
[5]> (nfa-test nfa1 '(a c))
NIL
```



