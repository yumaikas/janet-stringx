# Tests for stringx
(use testament)
(import ../stringx :as "str")

(deftest padding-basics
  (assert-equal " 1" (str/pad-left 1 2))
  (assert-equal "01" (str/pad-left 1 2 "0"))
  (assert-equal "...add" (str/pad-left "add" 6 "."))
  (assert-equal "1 " (str/pad-right 1 2))
  (assert-equal "10" (str/pad-right 1 2 "0"))
  (assert-equal "add..." (str/pad-right "add" 6 ".")))

(deftest string/replace-pairs-works
    (assert-equal (str/replace-pairs ["&" "-" "|" "-"] "a&b|c") "a-b-c"))

(deftest empty-or-whitepace
  (assert-equal true (str/empty-or-whitespace? "  \t"))
  (assert-equal true (str/empty-or-whitespace? ""))
  (assert-equal true (str/empty-or-whitespace? @""))
  (assert-equal true (str/empty-or-whitespace? @"  \r\t\n"))

  (assert-equal false (str/empty-or-whitespace? @"  .\r\t\n"))
  (assert-equal false (str/empty-or-whitespace? "This is a string...")))
(deftest replace-described 
  (assert-equal "BAB" (str/replace ".A." :patt "." :with "B")))
(deftest replace-described-buffers 
  (assert-equal "BAB" (str/replace @".A." :patt @"." :with @"B")))
