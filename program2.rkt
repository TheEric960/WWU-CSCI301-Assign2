
(define read-input-file
  (lambda (name)
         (let ((p (open-input-file name)))
           (define read-file
             (lambda (x)
               (if (eof-object? x)
                   (begin
                     (close-input-port p)
                     '())
                   (cons x (read-file (read p))))))
           (read-file (read p)))))