(defun is-regexp (RE)
  (if (atom RE)
      T
    (cond

     ((null RE) 
      NIL)

     

     ((or (equalp (car RE) 'star) (equalp (car RE) 'plus))
      (if (equalp (list-length (cdr RE)) 1)
          (is-regexp (cdr RE))
        NIL))

     ((or (equalp (car RE) 'seq)(equalp (car RE) 'or))
      (if (>= (list-length (cdr RE)) 2)
          (is-regexp-body-mul (cdr RE))
        NIL))

     ((atom (car RE)) 
      T)

     ((listp (car RE)) 
      T))))


(defun is-regexp-body-mul (RE)
(if (not (null (cdr RE)))
    (and (is-regexp (car RE))
         (is-regexp-body-mul (cdr RE)))
  (is-regexp (car RE))))
