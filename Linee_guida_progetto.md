Alfabeto
  L'alfabeto utilizzato non è noto, possiamo assumere inizialmente che sia formato da {a, ..., z}.
  Riguardo al progetto "L'alfabeto è composto da tutto ciò che soddisfa compound/1 o atomic/1.
  
Tipi di regexps:
  1.  Concatenazione                (ab)
  2.  Unione                        (a+b)
  3.  Chiusura di Kleene            (a*)
  4.  Un solo simbolo               (a)
  5.  Ripetizione una o più volte   (a+)
  
Rappresentazione regexps:
  1.  seq(a, b)
  2.  or(a, b)
  3.  star(a)
  4.
  5.  plus(a)
  
Predicati:
  è importante premettere che "ab" è inteso come un vero e proprio simbolo.
  Infatti "ab" è diverso da seq(a, b). Questo vuol dire che "ab" non è inteso come "a" concatenato a "b".
  is_regexp(RE)
      viene usata per riconoscere se l'input è un'espressione regolare o no.
      può accettare sia strighe (ossia RE scritta come insieme di simboli) sia predicati (seq, or, star, plus)
  nfa_regexp_comp(FA_Id, RE)
      FA_Id è un identificatore dell'automa.
      Prima verifica che RE sia una regexp e poi crea la base di dati.
      Deve usare il predicato assert/1 o sue varianti.
      L'identificatore deve essere passato da chi chiama.
  nfa_test(FA_Id, Input)
      è vero quando la stringa passata come Input arriva ad uno stato finale di accettazione.
      Input deve essere una lista, altrimenti deve fallire.
  nfa_clear, nfa_clear(FA_Id)
      il primo cancella tutta la base di dati prolog, il secondo cancella solo l'automa DA_Id
  --------------------------
  nfa_delta/4
      come primo argomento ha FA_Id
  nfa_initial/2
      come primo argomento ha FA_Id
  nfa_final/2
      come primo argomento ha FA_Id
  --------------------------
  nfa_list/0
      lista (elenca) tutte le conoscenze del database
  nfa_list/1
      lista (elenca) le conoscenze di un determinato FA_Id
  --------------------------
  avere un predicato che associ ad ogni stato un identificatore unico, per farlo si può usare il predicato gensym/2.
  
Considerazioni aggiuntive:
  Non sappiamo ancora da cosa sia composto l'alfabeto.
