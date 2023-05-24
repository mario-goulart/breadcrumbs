(module breadcrumbs

  (;; parameters
   breadcrumbs-home-path
   breadcrumbs-home-label
   breadcrumbs-separator
   breadcrumbs-link
   breadcrumbs

   ;; procedures
   add-breadcrumb!
   get-breadcrumb)

(import scheme)
(cond-expand
  (chicken-4
   (import chicken)
   (use data-structures extras files srfi-1))
  (chicken-5
   (import (chicken base)
           (chicken pathname)
           (chicken string))
   (import srfi-1))
  (else
   (error "Unsupported CHICKEN version.")))


(define breadcrumbs-home-path (make-parameter "/"))

(define breadcrumbs-home-label (make-parameter "Home"))

(define breadcrumbs (make-parameter '()))

(define breadcrumbs-separator (make-parameter " > "))

(define (path-join parts)
  (string-intersperse parts "/"))

(define (ensure-web-dir path)
  (if (eq? (string-ref path (sub1 (string-length path))) #\/)
      path
      (string-append path "/")))

(define (path-split path)
  (string-split path "/"))

(define (path-diff path)
  (let ((path (path-split path)))
    (lset-difference equal? path (path-split (breadcrumbs-home-path)))))

(define breadcrumbs-link
  (make-parameter
   (lambda (uri text)
     `(a (@ (href ,(ensure-web-dir uri))) ,text))))

(define (add-breadcrumb! path title)
  (let ((diff (path-diff path)))
    (unless (alist-ref diff (breadcrumbs) equal?)
      (breadcrumbs (cons (cons diff title) (breadcrumbs))))))

(define (get-breadcrumb path)
  (let ((diff (path-diff path)))
    (if (null? diff)
        '()
        (intersperse
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
