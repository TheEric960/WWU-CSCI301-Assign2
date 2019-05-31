
(define read-input-file
  (lambda (name)
    (let ((p (open-input-file name)))
      (define read-file
        (lambda (x)
          (if (eof-object? x)
              (begin
                (close-input-port p)
                '())
              (cons x (read-file (read-char p))))))
      (read-file (read-char p)))))


(define make-stack
  (let ((stack '()))
    (lambda (cmd . args)
      (cond 
        ((eq? cmd 'pop!)
         (if (null? stack) '()
             (let ((pop (car stack)))
               (set! stack (cdr stack))
               pop)))
        ((eq? cmd 'push!) (set! stack (append (reverse args) stack)))
        ((eq? cmd 'reverse!) (set! stack (reverse stack)))
        ((eq? cmd 'get-stack) stack)
        (else "Invalid stack command.")))))


(define prog-stack
  (let ((name "code"))
    (define read-next
      (lambda (word word-ls str-ls)
        (define get-char
          (if (not (null? str-ls)) (car (string->list (car str-ls)))))
        
        (cond ((null? str-ls) (if (number? (string->number word))
                   (read-next "numeric" word-ls str-ls)
                   (append word-ls (list word))))
              ((char=? #\return get-char)
               (read-next word word-ls (cdr str-ls)))
              ((or (char-whitespace? get-char)
                   (char=? #\newline get-char))
               (if (number? (string->number word))
                   (read-next "numeric" word-ls str-ls)
                   (read-next "" (append word-ls (list word)) (cdr str-ls))))
              ((char-upper-case? get-char)
               (read-next (string-append word "id") word-ls (cdr str-ls)))
              (else (read-next (string-append word (car str-ls)) word-ls (cdr str-ls))))))
    (let ((ls (read-next "" '() (map string (read-input-file name)))))
      (define stack make-stack)
      (map (lambda x (stack 'push! (car x))) ls)
      (stack 'reverse!)
      stack)))


;(define parse-table
;  (let ((name "table.csv"))
;    (define read-next
;      (lambda (word word-ls str-ls table-ls)
;        (define get-char
;          (if (not (null? str-ls)) (car (string->list (car str-ls)))))
;        
;        (cond ((null? str-ls) table-ls)
;              ;((string=? word "nan") (read-next "" word-ls (cdr str-ls) table-ls)) <- this works
;              ((char=? #\return get-char)
;               (read-next word word-ls (cdr str-ls) table-ls))
;              ((char=? #\newline get-char)
;               (read-next "" '() (cdr str-ls) (cons word-ls table-ls)))
;              ((char=? #\, get-char)
;               (read-next "" (append word-ls (list word)) (cdr str-ls) table-ls))
;              (else (read-next (string-append word (car str-ls)) word-ls (cdr str-ls) table-ls)))))
;    (read-next "" '() (map string (read-input-file name)) '())))
;    




  
