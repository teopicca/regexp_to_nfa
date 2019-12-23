;;;; -*- mode: Lisp -*-

;;;; nfa-regexp-comp.lisp

(defun nfa-regexp-comp (RE)
  (if (is-regexp RE)             
      (let ((Regexp (scompatta RE)))
        (list (get-qiniziale Regexp)  Regexp (get-qfinale Regexp)))
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
                    (list (list (third (car (last Regexp))) 'epsilon QF))))
        (if (equalp (car RE) 'star)
            (let ((QIn (gensym))
                  (QF (gensym))
                  (Regexp (regexp_comp_star (cdr RE))))
              (append (list (list QIn 'epsilon QF))
                      (list (list QIn 'epsilon (get-qiniziale Regexp)))
                      Regexp
                      (list (list (get-qfinale Regexp) 'epsilon (get-qiniziale Regexp)))
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
                (list (list (get-qfinale primoElem) 'epsilon (get-qiniziale resto)))
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
        (append (list (list (get-qiniziale resto) 'epsilon (get-qiniziale primoElem)))
                primoElem
                resto
                (list (list (get-qfinale primoElem) 'epsilon (get-qfinale resto))))))))


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