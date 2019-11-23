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
  1.  is_regexp(RE)
  
      viene usata per riconoscere se l'input è un'espressione regolare o no.
      può accettare sia strighe (ossia RE scritta come insieme di simboli) sia predicati (seq, or, star, plus)
  2.  nfa_regexp_comp(FA_Id, RE)
  
      FA_Id è un identificatore dell'automa.
      Prima verifica che RE sia una regexp e poi crea la base di dati.
      Deve usare il predicato assert/1 o sue varianti.
      L'identificatore deve essere passato da chi chiama.
  3.  nfa_test(FA_Id, Input)
  
      è vero quando la stringa passata come Input arriva ad uno stato finale di accettazione.
      Input deve essere una lista, altrimenti deve fallire.
  4.  nfa_clear, nfa_clear(FA_Id)
  
      il primo cancella tutta la base di dati prolog, il secondo cancella solo l'automa DA_Id
      
Altri predicati:
  1.  nfa_delta/4
  
      come primo argomento ha FA_Id
  2.  nfa_initial/2
  
      come primo argomento ha FA_Id
      Lo stato iniziale ha uno o più nfa_delta, corrispondenti ai suoi collegamenti.
  3.  nfa_final/2
  
      come primo argomento ha FA_Id

  4.  nfa_list/0
  
      lista (elenca) tutte le conoscenze del database
  5.  nfa_list/1
  
      lista (elenca) le conoscenze di un determinato FA_Id

  Avere un predicato che associ ad ogni stato un identificatore unico, per farlo si può usare il predicato gensym/2.
  
Considerazioni aggiuntive:
  Non sappiamo ancora da cosa sia composto l'alfabeto. Per ora tutto ciò che è atomic.
  L'automa può essere implementato sia con sia senza epsilon transazioni.
  "?- is_regexp(X)" dovrebbe (forse) elencare tutte le espressioni regolari accettate, ma essendo infinite, genera errore.
  Si può assumere che 'or'abbia sempre almeno due argomenti.
