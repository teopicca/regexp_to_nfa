;;;; -*- mode: Lisp -*-



;;;; test.lisp



(defun nfa-test (Automa Input)

 (if (listp Input) 
     (let ((QIn (first Automa))

           (Stati (second Automa))

           (QF (third Automa)))

       (nodo-attuale QIn Stati QF Input))
   (NIL)))





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