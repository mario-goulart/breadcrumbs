(module breadcrumbs

  (;; parameters
   breadcrumbs-home-path
   breadcrumbs-home-label
   breadcrumbs-separator
   breadcrumbs-link
   debug-breadcrumbs
   breadcrumbs

   ;; procedures
   add-breadcrumb!
   get-breadcrumb)

(import scheme chicken data-structures extras)
(use files srfi-1)

(define breadcrumbs-home-path (make-parameter "/"))

(define breadcrumbs-home-label (make-parameter "Home"))

(define breadcrumbs (make-parameter '()))

(define breadcrumbs-separator (make-parameter " &gt; "))

(define debug-breadcrumbs (make-parameter #f))

(define (path-join parts)
  (string-intersperse parts "/"))

(define (path-split path)
  (string-split path "/"))

(define (path-diff path)
  (let ((path (path-split path)))
    (lset-difference equal? path (path-split (breadcrumbs-home-path)))))

(define breadcrumbs-link
  (make-parameter
   (lambda (uri text)
     (string-append "<a href='" uri "'>" text "</a>"))))

(define (add-breadcrumb! path title)
  (let ((diff (path-diff path)))
    (unless (alist-ref diff (breadcrumbs) equal?)
      (breadcrumbs (cons (cons diff title) (breadcrumbs))))))

(define (get-breadcrumb path)
  (let ((diff (path-diff path)))

    (when (debug-breadcrumbs)
      (print "Current breadcrumbs table:")
      (pp (breadcrumbs))
      (display "\nRequested path: ")
      (pp path)
      (display "Diff: ")
      (pp diff))

    (if (null? diff)
        ""
        (string-intersperse
         (append
          (list ((breadcrumbs-link) (breadcrumbs-home-path) (breadcrumbs-home-label)))
          (reverse
           (let loop ((parts (butlast diff)))
             (if (null? parts)
                 '()
                 (let ((bc (alist-ref parts (breadcrumbs) equal?)))
                   (if bc
                       (cons ((breadcrumbs-link)
                              (make-pathname (breadcrumbs-home-path) (path-join parts))
                              bc)
                             (loop (butlast parts)))
                       (loop (cdr parts)))))))
          (list (alist-ref  diff (breadcrumbs) equal?)))
         (breadcrumbs-separator)))))

) ; end module
