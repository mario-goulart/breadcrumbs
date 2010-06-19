#!/usr/bin/csi -script

(load "breadcrumbs.scm")
(import breadcrumbs)

(use test)

(test-begin "breadcrumbs")

(add-breadcrumb! "/a" "A")
(test "" (get-breadcrumb "/"))
(test "<a href='/'>Home</a> &gt; A" (get-breadcrumb "/a"))

(add-breadcrumb! "/a/b" "B")
(test "<a href='/'>Home</a> &gt; <a href='/a'>A</a> &gt; B"
      (get-breadcrumb "/a/b"))

;; Changing the home path
(breadcrumbs '())
(breadcrumbs-home-path "/a")
(add-breadcrumb! "/a" "A")
(add-breadcrumb! "/a/b" "B")
(test "" (get-breadcrumb "/a"))
(test "<a href='/a'>Home</a> &gt; B" (get-breadcrumb "/a/b"))

(test-end "breadcrumbs")
