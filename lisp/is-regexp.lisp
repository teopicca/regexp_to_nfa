(defun is-regexp (RE)
  (cond
 
   ((null RE) 
    NIL)
 
   ((atom RE) 
    (if (and (not (equalp RE 'seq))
             (not (equalp RE 'or))
             (not (equalp RE 'star))
             (not (equalp RE 'plus)))
         T 
       NIL))

   ((or (equalp (car RE) 'star) (equalp (car RE) 'plus))
    (if (equalp (list-length (cdr RE)) 1)
        (is-regexp-body (cdr RE))
      NIL))

    ((or (equalp (car RE) 'seq)(equalp (car RE) 'or))
     (if (>= (list-length (cdr RE)) 2)
         (is-regexp-body-mul (cdr RE))
       NIL))

    ((atom (car RE)) 
     (is-regexp-body-mul RE))

    ( T 
      (and (is-regexp RE)
           (if (not (null (cdr RE )))
               (is-regexp (cdr RE)) 
                 T)))))

(defun is-regexp-body (RE)
  (cond
   ((atom RE) 
    (if (and (not (equalp RE 'seq))
             (not (equalp RE 'or))
             (not (equalp RE 'star))
             (not (equalp RE 'plus)))
         T 
       NIL))
   (T (is-regexp RE))
   ))

(defun is-regexp-body-mul (RE)
(if (not (null (cdr RE)))
    (and (is-regexp-body (car RE))
         (is-regexp-body-mul (cdr RE)))
  (is-regexp-body (car RE))))
