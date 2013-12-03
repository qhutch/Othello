(defun main-standalone (first)
  (let ((tab (init-tab)) (partiefinie NIL))
    (if first
	(do ((i 0 (+ i 1)))(partiefinie)
	  (jouer-coup-ia tab 1)
	  (lire-coup tab 2)
	  (if (fin-partie tab)
		(setf partiefinie T)))
	(do ((i 0 (+ i 1)))(partiefinie)
	  (lire-coup tab 1)
	  (jouer-coup-ia tab 2)
	  (if (fin-partie tab)
		(setf partiefinie T)
	      )))))

(defun init-tab()
  (make-array '(8 8) :initial-contents
	      '((0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0)
		(0 0 0 1 2 0 0 0)
		(0 0 0 2 1 0 0 0)
		(0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0)
		(0 0 0 0 0 0 0 0))))

(defun coup-valide(tab joueur x y)
  (if (case-vide tab x y)
      (if (or (prise-possible-droite tab joueur x y)
	      (prise-possible-bas-droite tab joueur x y)
	      (prise-possible-bas tab joueur x y)
	      (prise-possible-bas-gauche tab joueur x y)
	      (prise-possible-gauche tab joueur x y)
	      (prise-possible-haut-gauche tab joueur x y)
	      (prise-possible-haut tab joueur x y)
	      (prise-possible-haut-droite tab joueur x y))
	  T
	  NIL)
      NIL))

(defun adversaire (joueur)
  (if (= joueur 1)
      2
      1))

(defun case-vide (tab x y)
  (if (or (zerop y) (zerop x) (< x 8) (< y 8)) ;; si on est dans le tableau
      (if (= 0 (aref tab x y)) ;; si la case est vide
	  T
	  NIL)
      NIL))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;;   PRISES POSSIBLES !!
;;;

(defun prise-possible-droite (tab joueur x y)
      (if (< x 6)
	  (if (= (adversaire joueur) (aref tab (+ x 1) y))
	      (do ((i (+ 1 x) (+ 1 i)))((= 8 i))
		(if (= (aref tab i y) joueur)
		    (return T)
		    (if (case-vide tab i y)
			NIL)))
	      NIL)
	  NIL))


(defun prise-possible-gauche (tab joueur x y)
      (if (> x 1)
	  (if (= (adversaire joueur) (aref tab (- x 1) y))
	      (do ((i (- x 1) (- i 1)))((= (- 0 1) i))
		(if (= (aref tab i y) joueur)
		    (return T)
		    (if (case-vide tab i y)
			NIL)))
	      NIL)
	  NIL))

(defun prise-possible-haut (tab joueur x y)
      (if (> y 1)
	  (if (= (adversaire joueur) (aref tab x (- y 1)))
	      (do ((i (- y 1) (- i 1)))((= (- 0 1) i))
		(if (= (aref tab x i) joueur)
		    (return T)
		    (if (case-vide tab x i)
			NIL)))
	      NIL)
	  NIL))

(defun prise-possible-bas (tab joueur x y)
      (if (< y 6)
	  (if (= (adversaire joueur) (aref tab x (+ y 1)))
	      (do ((i (+ 1 y) (+ i 1)))((= 8 i))
		(if (= (aref tab x i) joueur)
		    (return T)
		    (if (case-vide tab x i)
			NIL)))
	      NIL)
	  NIL))

(defun prise-possible-bas-droite (tab joueur x y)
      (if (and (< y 6) (< x 6))
	  (if (= (adversaire joueur) (aref tab (+ x 1) (+ y 1)))
	      (do ((i (+ 1 x) (+ i 1))(j (+ 1 y) (+ j 1)))
		  ((or (= 8 i) (= 8 j)))
		(if (= (aref tab i j) joueur)
		    (return T)
		    (if (case-vide tab i j)
			NIL)))
	      NIL)
	  NIL))

(defun prise-possible-bas-gauche (tab joueur x y)
      (if (and (< y 6) (> x 1))
	  (if (= (adversaire joueur) (aref tab (- x 1) (+ y 1)))
	      (do ((i (- x 1) (- i 1))(j (+ y 1) (+ j 1)))
		  ((or (= (- 0 1) i) (= 8 j)))
		(if (= (aref tab i j) joueur)
		    (return T)
		    (if (case-vide tab i j)
			NIL)))
	      NIL)
	  NIL))

(defun prise-possible-haut-gauche (tab joueur x y)
      (if (and (> y 1) (> x 1))
	  (if (= (adversaire joueur) (aref tab (- x 1) (- y 1)))
	      (do ((i (- x 1) (- i 1))(j (- y 1) (- j 1)))
		  ((or (= (- 0 1) i) (= (- 0 1) j)))
		(if (= (aref tab i j) joueur)
		    (return T)
		    (if (case-vide tab i j)
			NIL)))
	      NIL)
	  NIL))

(defun prise-possible-haut-droite (tab joueur x y)
      (if (and (> y 1) (< x 6))
	  (if (= (adversaire joueur) (aref tab (+ x 1) (- y 1)))
	      (do ((i (+ x 1) (+ i 1))(j (- y 1) (- j 1)))
		  ((or (= 8 i) (= (- 0 1) j)))
		(if (= (aref tab i j) joueur)
		    (return T)
		    (if (case-vide tab i j)
			NIL)))
	      NIL)
	  NIL))

                                                        ;;;
                                                        ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun jouer-coup (tab joueur x y)
  (assert (coup-valide tab joueur x y))
  (setf (aref tab x y) joueur)
  (prise tab joueur x y)
)

(defun prise (tab joueur x y)
;droite
  (if (prise-possible-droite tab joueur x y)
      (do ((i (+ 1 x) (+ 1 i)))((> i 6))
	(if (= (aref tab i y) (adversaire joueur))
	    (setf (aref tab i y) joueur)
	    (setf i 7))))
;gauche
  (if (prise-possible-gauche tab joueur x y)
      (do ((i (- x 1) (- i 1)))((< i 1))
	(if (= (aref tab i y) (adversaire joueur))
	    (setf (aref tab i y) joueur)
	    (setf i 0)
	    )))
;haut
 (if (prise-possible-haut tab joueur x y)
     (do ((i (- y 1) (- i 1)))((< i 1))
       (if (= (aref tab x i) joueur)
	   (setf i 0)
	   (setf (aref tab x i) joueur))))
;bas
  (if (prise-possible-bas tab joueur x y)
      (do ((i (+ 1 y) (+ i 1)))((> i 6))
	(if (= (aref tab x i) joueur)
	   (setf i 7)
	   (setf (aref tab x i) joueur)))) 
;bas droite
  (if (prise-possible-bas-droite tab joueur x y)
      (do ((i (+ 1 x) (+ i 1))(j (+ 1 y) (+ j 1)))
	  ((or (> i 6) (> j 6)))
	(if (= (aref tab i j) joueur)
	    (setf i 7)
	    (setf (aref tab i j) joueur)))) 
;bas gauche
  (if (prise-possible-bas-gauche tab joueur x y)
      (do ((i (- x 1) (- i 1))(j (+ y 1) (+ j 1)))
	  ((or (< i 1) (> j 6)))
	(if (= (aref tab i j) joueur)
	    (setf i 0)
	    (setf (aref tab i j) joueur)))) 
;haut gauche
  (if (prise-possible-haut-gauche tab joueur x y)
      (do ((i (- x 1) (- i 1))(j (- y 1) (- j 1)))
	  ((or (< i 1) (< j 1)))
	(if (= (aref tab i j) joueur)
	    (setf i 0)
	    (setf (aref tab i j) joueur)))) 
;haut droite
  (if (prise-possible-haut-droite tab joueur x y)
      (do ((i (+ x 1) (+ i 1))(j (- y 1) (- j 1)))
	  ((or (> i 6) (< j 1)))
	(if (= (aref tab i j) joueur)
	    (setf i 7)
	    (setf (aref tab i j) joueur)))))

(defun fin-partie (tab)
  (and (ne-peut-pas-jouer tab 1) (ne-peut-pas-jouer tab 2)))

(defun ne-peut-pas-jouer (tab joueur)
  (let ((bool T))
    (do ((i 0 (+ i 1)))((= i 8))
      (do ((j 0 (+ j 1)))((or (= j 8) (not bool)))
	(if (coup-valide tab joueur i j)
	    (setf bool nil))))
    bool))

(defun convert-abscisse ()
  (let ((abscisse (read-char)))
    (if (char-equal abscisse #\Newline)
	(setf abscisse (read-char)))
    (if (char-equal abscisse #\a)
	0
	(if (char-equal abscisse #\b)
	    1
	    (if (char-equal abscisse #\c)
		2
		(if (char-equal abscisse #\d)
		    3
		    (if (char-equal abscisse #\e)
			4
			(if (char-equal abscisse #\f)
			    5
			    (if (char-equal abscisse #\g)
				6
				(if (char-equal abscisse #\h)
				    7
				    8))))))))))

(defun convert-ordonnee ()
  (let ((ordonnee (read-char)))
  (if (char-equal ordonnee #\1)
      0
      (if (char-equal ordonnee #\2)
	  1
	  (if (char-equal ordonnee #\3)
	      2
	      (if (char-equal ordonnee #\4)
		  3
		  (if (char-equal ordonnee #\5)
		      4
		      (if (char-equal ordonnee #\6)
			  5
			  (if (char-equal ordonnee #\7)
			      6
			      (if (char-equal ordonnee #\8)
				  7
				  8))))))))))

;TODO
(defun jouer-coup-ia (tab joueur)
  (let ((x 8)(y 8))
    (if (not (ne-peut-pas-jouer tab joueur))
	(progn
	  (do ((i 0 (+ i 1)))((coup-valide tab joueur x y))
	    (setf x (random 8))
	    (setf y (random 8)))
	  (char-abscisse x)
	  (char-ordonnee y)
	  (jouer-coup tab joueur x y)
	  )
	)
    ))

(defun lire-coup (tab joueur)
  (let ((coupvalide NIL) (x 0) (y 0))
    (if (not (ne-peut-pas-jouer tab joueur))
	(progn
	  (do ()(coupvalide)
	    (setf x (convert-abscisse))
	    (setf y (convert-ordonnee))
	    (if (coup-valide tab joueur x y)
		(progn
		  (jouer-coup tab joueur x y)
		  (setf coupvalide T))
		))
	  (setf coupvalide NIL))
	)))

(defun compter-pions (tab joueur)
  (let ((pions 0))
    (do ((i 0 (+ i 1)))((= i 8))
      (do ((j 0 (+ j 1)))((= j 8))
	(if (= (aref tab i j) joueur)
	    (setf pions (+ pions 1)))))
    pions))

(defun char-abscisse (x)
  (assert (and (< x 8) (>= x 0)))
  (if (= 0 x)
      (write-char #\A)
      (if (= 1 x)
	  (write-char #\B)
	  (if (= 2 x)
	      (write-char #\C)
	      (if (= 3 x)
		  (write-char #\D)
		  (if (= 4 x)
		      (write-char #\E)
		      (if (= 5 x)
			  (write-char #\F)
			  (if (= 6 x)
			      (write-char #\G)
			      (if (= 7 x)
				  (write-char #\H))))))))))


(defun char-ordonnee (y)
  (assert (and (< y 8) (>= y 0)))
  (if (= 0 y)
      (write-char #\1)
      (if (= 1 y)
	  (write-char #\2)
	  (if (= 2 y)
	      (write-char #\3)
	      (if (= 3 y)
		  (write-char #\4)
		  (if (= 4 y)
		      (write-char #\5)
		      (if (= 5 y)
			  (write-char #\6)
			  (if (= 6 y)
			      (write-char #\7)
			      (if (= 7 y)
				  (write-char #\8))))))))))