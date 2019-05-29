
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

(define basic-parse
  (lambda (name)
    (define read-next
      (lambda (word word-ls str-ls)
        (cond ((null? str-ls) word-ls)
              ((char=? #\return (car (string->list (car str-ls))))
               (read-next word word-ls (cdr str-ls)))
              ((or (char-whitespace? (car (string->list (car str-ls))))
                   (char=? #\newline (car (string->list (car str-ls)))))
               (read-next "" (append word-ls (list word)) (cdr str-ls)))
              (else (read-next (string-append word (car str-ls)) word-ls (cdr str-ls))))))
    (read-next "" '() (map string (read-input-file "code")))))

