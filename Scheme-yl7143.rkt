#|Number 1|#
(define A
  (lambda ()
    (let* ((x 2)
           (C (lambda (P)
                (let ((x 4))
                  (P))))
           (D (lambda ()
                x))
           (B (lambda ()
                (let ((x 3))
                  (C D)))))
      (B))))

;(A)

#|Answer
- What does this program print?
  : The above code will print 2. For the let* in scheme, "Bindings are performed sequentially from left to right, and each binding is done in an environment in which the previous bindings are visible." (Lecture slide 35)
    In addition, scheme is statically scoped language, so from procedure D, it will use x=2 from (x 2).
- What would it print if Scheme used dynamic scoping and shallow binding?
  : The above code will print 4. For the dynamic scoping and shallow binding, x is the value of most recent value (if we draw the stack frame for dynamic scoping, the nearest value).
    In procedure C (where procedure D is called), 4 is assigned for x before calling procedure D, which means x in procedure D is 4.
- Dynamic scoping and deep binding?
  : The above code will print 3. For the deep binding, it takes the environment of the parent procedure.
    Based on this concept, procedure D will get the environment of procedure B where it is called.
    Accordingly, procedure D will get the value of x from procedure B, which is 3.
|#



#|Number 2|#
(define (findremove list value)
  (cond
    ((null? list) list)
    ((= value (car list)) (findremove (cdr list) value))
    (else (cons (car list) (findremove (cdr list) value)))))

; exmaples
;(findremove '(1 2 2 3 3) 2)



#|Number 3|#
(define (zip . args)
  (dozip args '()))


(define (dozip inputs result)
  (if (null? inputs)
      (list result) ; todo fix return
      (dozip (cdr inputs) (cons (car inputs) result))))

;(zip '(1 2 3) '(2 3 5) '(5 6 7))



#|Number 4|#
(define (unzip list n)
  (cond
    ((null? list) list)
    ((= n 0) (car list))
    (else (unzip (cdr list) (- n 1)))))

;exmaples
;(unzip `((1 2 3) (5 6 7) (5 9 2 1)) 2)



#|Number 5|#
(define iscontain
  (lambda (list value)
    (if (null? list)
        #f
        (if (= value (car list))
            #t
            (iscontain (cdr list) value)))))

(define (findremove list value)
  (cond
    ((null? list) list)
    ((= value (car list)) (findremove (cdr list) value))
    (else (cons (car list) (findremove (cdr list) value)))))

(define docancellist
  (lambda (list1 list2 result)
    (if (null? list1)
        (list result list2)
        (if (iscontain list2 (car list1))
            (docancellist (cdr list1) (findremove list2 (car list1)) result) 
            (docancellist (cdr list1) list2 (cons (car list1) result)))))) ; todo check order

(define (cancellist list1 list2)
  (docancellist list1 list2 '()))

;(cancellist '(1 2 3) '(1 2 2 3 4))



#|Number 6|#
(define compose
  (lambda (function1 function2)
    (lambda (x)
      (function2 (function1 x)))))

; inc is just for testing
(define (inc n) (+ n 1))

;((compose inc inc) 5)



#|Number 7|#
(define (isequal jlist llist)
  (if (and (null? jlist) (null? llist))
        #t 
        (if (or (null? jlist) (null? llist))
            #f
            (isequal (cdr jlist) (cdr llist)))))

(define (domap2 jlist llist p f)
    (if (null? llist)
        llist
        (if (p (car jlist))
            (cons (f (car llist)) (domap2 (cdr jlist) (cdr llist) p f))
            (cons (car llist) (domap2 (cdr jlist) (cdr llist) p f)))))

(define map2
  (lambda (jlist llist p f)
    (if (not (isequal jlist llist))
        "Wrong Input: The length of j and l are different."
        (domap2 jlist llist p f))))

; inc is just for testing
(define (inc n) (+ n 1))

;(domap2 '(1 2 3 4) '(2 3 4 5) (lambda (x) (> x 2)) inc)



#|Number 8|#
(define (getitem list idx)
  (cond
    ((null? list) #f)
    ((= idx 0) (car list))
    (else (getitem (cdr list) (- idx 1)))))

;examples
;(getitem '(1 2 3 4 5) 6)



#|Number 9|#
;(a) tail-recursive version of log2

; From 11.6 (a) for checking
(define log2_book
  (lambda (n)
    (if (= n 1) 1 (+ 1 (log2_book (quotient n 2))))))
;   (if (= n 1) 0 (+ 1 (log2_book (quotient n 2))))))
#|In the textbook, the code is if (= n 1) 1, but I think it should be 0 for calculating integer part of log2|#

; tail-recursive version
(define (log2 n result)
    (if (= n 1)
        (+ result 1) ; it should be 'result', if changed to 0 in above.
        (log2 (quotient n 2)
              (+ result 1))))

;(log2_book 16)
;(log2 16 0)



;(b) tail-recursive version of min

; From 11.6 (b) for checking
(define minbook
  (lambda (l)
    (cond
      ((null? l) '())
      ((null? (cdr l)) (car l))
      (#t (let ((a (car l))
                (b (minbook (cdr l))))
            (if (< b a) b a))))))

; tail-recursion version
(define (min2 l result)
  (cond ((null? l)
         (list result)
        ((< (car l) result)
         (min2 ((cdr l) (car l))))
        (else (min2 ((cdr l) (list result)))))))


(minbook '(2 3 4 5 0))
;(min2 '(2 3 4 5 0) 0)



#|Number 10|#
; let
(let ((v1 1) (v2 2))
  (let ((v1 v2) (v2 v1))
    (list v1 v2)))
; let*
(let ((v1 1) (v2 2))
  (let* ((v1 v2) (v2 v1))
    (list v1 v2)))
#|
For the "let", after v1=1, v2=2 from the first line, v1 get value of 2 from v2 and v2 get value of 1 from v1
For the "let*", after v1=1, v2=2 from the first line, v1 get value of 2 from v2 and v2 get value of 2 from v1
Through let*, v2 can get value of v1 from (let* ((v1 v2) (v2 v1))
|#

; letrec
(letrec ((v1 1) (v2 2)) (+ v1 v2)) 