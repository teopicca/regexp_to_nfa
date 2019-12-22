(defun is-regexp (RE)
  (if (atom RE)
      T
    (if (null RE) 
        NIL

      (if (or (equalp (car RE) 'star) (equalp (car RE) 'plus))
          (if (equalp (list-length (cdr RE)) 1)
              (is-regexp-body (cdr RE))
            NIL)

        (if (or (equalp (car RE) 'seq)(equalp (car RE) 'or))
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
