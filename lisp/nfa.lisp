;;;; -*- mode: Lisp -*-


;;;; Progetto svolto da 3 studenti

;;;; Piccapietra Matteo 845013

;;;; Potertì Daniele 844892

;;;; Ruocco Enzo Mattia 844875


;;;; nfa.lisp


(defun is-regexp (RE)
  (if (atom RE)
      T
    (if (null RE) 
        NIL
      (if (or (equalp (car RE) 'star)
              (equalp (car RE) 'plus))
          (if (equalp (list-length (cdr RE)) 1)
              (is-regexp-body (cdr RE))
            NIL)
        (if (or (equalp (car RE) 'seq)
                (equalp (car RE) 'or))
            (if (>= (list-length (cdr RE)) 2)
                (is-regexp-body-mul (cdr RE))
              NIL)
          (if (atom (car RE)) 
              T
            (if (listp (car RE)) 
                T)))))))


(defun is-regexp-body-mul (RE)
  (if (not (null (cdr RE)))
      (and (is-regexp-body (car RE))
           (is-regexp-body-mul (cdr RE)))
    (is-regexp (car RE))))


(defun is-regexp-body (RE)
  (if (atom RE)
      T
    (if (listp (car RE))
        (is-regexp (car RE))
      T)))


;;;; nfa-regexp-comp


(defun nfa-regexp-comp (RE)
  (if (is-regexp RE)             
      (let ((Regexp (scompatta RE)))
        (list (get-qiniziale Regexp)
              Regexp (get-qfinale Regexp)))
    NIL))


(defun crea_mossa (&optional carlettura)
  (let ((QIn (gensym))
        (QF (gensym)))
    (if (null carlettura)
        (list QIn 'epsilon QF)
      (list QIn carlettura QF))))


(defun scompatta (RE)
  (if (atom RE)
      (list (crea_mossa RE))
    (if (null RE)
        NIL
      (if (equalp (car RE) 'seq)
          (let ((QIn (gensym))
                (QF (gensym))
                (Regexp (regexp_comp_seq (cdr RE))))
            (append (list (list QIn 'epsilon  (car (car Regexp))))
                    Regexp
                    (list
                     (list (third (car (last Regexp))) 'epsilon QF))))
        (if (equalp (car RE) 'star)
            (let ((QIn (gensym))
                  (QF (gensym))
                  (Regexp (regexp_comp_star (cdr RE))))
              (append (list (list QIn 'epsilon QF))
                      (list (list QIn 'epsilon (get-qiniziale Regexp)))
                      Regexp
                      (list
                       (list (get-qfinale Regexp) 'epsilon
                             (get-qiniziale Regexp)))
                      (list (list (get-qfinale Regexp) 'epsilon QF))))
          (if (equalp (car RE) 'or)
              (regexp_comp_or (cdr RE))
            (if (equalp (car RE) 'plus)
                (regexp_comp_plus (cdr RE))
              (list (crea_mossa RE)))))))))


(defun regexp_comp_seq (RE)
  (if (null RE)
      NIL
    (let ((primoElem (scompatta (car RE)))
          (resto (regexp_comp_seq (cdr RE))))                 
      (if (null resto)
          (append primoElem
                  resto)
        (append primoElem
                (list
                 (list (get-qfinale primoElem) 'epsilon
                       (get-qiniziale resto)))
                resto)))))


(defun regexp_comp_star (RE)
  (if (null RE)
      NIL
    (let ((Regexp (scompatta (car RE))))
      Regexp)))


(defun regexp_comp_or (RE)
  (if (null RE)
      NIL
    (let ((primoElem (scompatta (car RE)))
          (resto (regexp_comp_or (cdr RE))))                 
      (if (null resto)
          (let ((QIn (gensym))
                (QF (gensym))
                (QIn2 (get-qiniziale primoElem))
                (QF2 (get-qfinale primoElem)))
            (append (list (list QIn 'epsilon QIn2))
                    primoElem
                    (list (list QF2 'epsilon QF))))
        (append (list
                 (list (get-qiniziale resto) 'epsilon
                       (get-qiniziale primoElem)))
                primoElem
                resto
                (list
                 (list (get-qfinale primoElem) 'epsilon
                       (get-qfinale resto))))))))


(defun regexp_comp_plus (RE)
  (if (null RE)
      NIL
    (scompatta (list 'seq (car RE) (list 'star (car RE))))))


(defun get-qiniziale (RE)
  (if (listp RE)
      (get-qiniziale (car RE))
    RE))


(defun get-qfinale (RE)
  (if (listp RE)
      (get-qfinale (car (last RE)))
    RE))


;;;; nfa-test


(defun nfa-depth (nfa)
  (cond ((null nfa) 1)
        ((atom nfa) 0)
        (T (max (+ (nfa-depth (car nfa)) 1)
                (nfa-depth (rest nfa))))))


(defun is-nfa (nfa)
  (if (equalp (nfa-depth nfa) 3)
      T
    (progn
      (print "not a valid nfa")
      NIL)))


(defun nfa-test (FA Input)
  (if (and (is-nfa FA) (listp Input)) 
      (let ((QIn (first FA))
            (Stati (second FA))
            (QF (third FA)))
        (nodo-attuale QIn Stati QF Input))
    NIL))


(defun nodo-attuale (QIn Automa QF Input)
  (if (and (string-equal QIn QF) (null Input))
      T
    (let ((stati-epsilon (passi-trovati-epsilon QIn Automa))
          (stati (passi-trovati-lettura QIn (first Input) Automa)))
      
      (if (equal (prova-stati stati-epsilon Automa QF Input) T)
          T
        (if (equal (prova-stati stati Automa QF (cdr Input)) T)
            T
          NIL)))))


(defun prova-stati (stati Automa QF Input)
  (if (null stati)
      NIL
    (if (null (nodo-attuale (car stati) Automa QF Input))
        (prova-stati (cdr stati) Automa QF Input)
      T)))


(defun passi-trovati-epsilon (QIn Automa)
  (if (null Automa)
      NIL
    (if (and (string-equal QIn (first (first Automa)))
             (equal 'epsilon (second (first Automa))))
        (append (list (third (first Automa)))
                (passi-trovati-epsilon (third (first Automa)) Automa)
                (passi-trovati-epsilon QIn (cdr Automa)))
      (passi-trovati-epsilon QIn (cdr Automa)))))


(defun passi-trovati-lettura (QIn Lettura Automa)
  (if (null Automa)
      NIL
    (if (and (string-equal QIn (first (first Automa)))
             (equal Lettura (second (first Automa))))
        (append (list (third (first Automa))))
      (passi-trovati-lettura QIn Lettura (cdr Automa)))))