
(load "nfa.lisp")
(defparameter nfa-hash (make-hash-table))

(defun print-nfa (key value)
  (format t "key: ~S , value: ~S~%" key value)) 

(defun nfa-compiler (RE)
  (setq exist 0)
  (loop
   (print "choose a name for your e-nfa")
   (setq name (read))
   (if (null (find-nfa name))
       (progn
	 (setf (gethash name nfa-hash) (nfa-regexp-comp RE))
	 (setq exist 1)
	 ))
     
   (when (> exist 0) (return exist))
  ))


(defun nfa-listing ()
  (loop for i being the hash-keys of nfa-hash using (hash-value val)
	nconc (print-nfa i val))
  )

(defun nfa-remove (key)
  (remhash key nfa-hash)
  (format t " REMOVED: ~S" key)
  )


(defun nfa-clear ()
  (maphash (lambda (key value)
	     (nfa-remove key))
	   nfa-hash
	   )
  )

(defun find-nfa (query)
  (gethash query nfa-hash)
  )


(defun test-input (key value input)
  (if (nfa-test value input)
      (format t  "the input is compatible with the nfa ~S" key) 
    )
  )
   

(defun nfa-test-loop (Input)
    (loop for i being the hash-keys of nfa-hash using (hash-value val)
	  nconc (test-input i val Input))
  )






