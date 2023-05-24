(import scheme)
(cond-expand
  (chicken-4
   (import chicken)
   (use breadcrumbs test))
  (chicken-5
   (import breadcrumbs test))
  (else
   (error "Unsupported CHICKEN version.")))

(test-begin "breadcrumbs")

(add-breadcrumb! "/a" "A")
(test '() (get-breadcrumb "/"))
(test '((a (@ (href "/")) "Home") " > " "A") (get-breadcrumb "/a"))

(add-breadcrumb! "/a/b" "B")
(test '((a (@ (href "/")) "Home") " > " (a (@ (href "/a/")) "A") " > " "B")
      (get-breadcrumb "/a/b"))

;; Changing the home path
(breadcrumbs '())
(breadcrumbs-home-path "/a")
(add-breadcrumb! "/a" "A")
(add-breadcrumb! "/a/b" "B")
(test '() (get-breadcrumb "/a"))
(test '((a (@ (href "/a/")) "Home") " > " "B")
      (get-breadcrumb "/a/b"))

(test-end "breadcrumbs")
(test-exit)
