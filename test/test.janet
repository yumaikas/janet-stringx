# Tests for stringx
(use testament)
(import ../stringx :as "str")

(exercise! 
  []
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
    (assert-equal true (str/blank? "  \t"))
    (assert-equal true (str/blank? ""))
    (assert-equal true (str/blank? @""))
    (assert-equal true (str/blank? @"  \r\t\n"))

    (assert-equal false (str/blank? @"  .\r\t\n"))
    (assert-equal false (str/blank? "This is a string...")))
  (deftest replace-described 
    (assert-equal "BAB" (str/replace ".A." :patt "." :with "B")))
  (deftest replace-described-buffers 
    (assert-equal "BAB" (str/replace @".A." :patt @"." :with @"B")))

  (deftest trim-both
    (assert-equal "abc" (str/trim "  abc \r\n"))
    (assert-equal "  abc " (str/trim "\n\n  abc \r\n" "\r\n")))
  (deftest trim-left
    (assert-equal "abc \r\n" (str/trim-left "  abc \r\n"))
    (assert-equal "  abc \r\n" (str/trim-left "\n\n  abc \r\n" "\r\n")))

  (deftest trim-right
    (assert-equal "  abc" (str/trim-right "  abc \r\n"))
    (assert-equal "\n\n  abc " (str/trim-right "\n\n  abc \r\n" "\r\n")))

  (deftest prefix-suffix
    (assert-expr (str/has-prefix? "123" "123dfg"))
    (assert-expr (str/has-suffix? "fg" "123dfg"))
    (assert-expr (not (str/has-suffix? "fge" "123dfg")))
    (assert-expr (not (str/has-prefix? "fge" "123dfg"))))

  (deftest inserting
    (assert-equal "To form a more perfect union." 
                  (str/insert "more " 10 "To form a perfect union."))
    (assert-thrown-message "end index 40 out of range [-1,0]" (str/insert "abcded" 40 "")))

  (deftest str-mapping 
    (assert-equivalent [".ab" ".ac" ".ad"] (str/prefix-each ["b" "c" "d"] ".a"))
    (assert-equivalent ["baa" "caa" "daa"] (str/suffix-each ["b" "c" "d"] "aa")))

  (deftest resttest
    (assert-equal nil (str/rest ""))
    (assert-equal "234" (str/rest "1234")))

  (deftest nth
    (assert-equal "a" (str/nth 0 "abc"))
    (assert-equal "b" (str/nth 1 "abc"))
    (assert-equal "c" (str/nth 2 "abc"))
    (assert-thrown (str/nth -50 "abc")))

  (deftest shorten 
    (assert-equal "This is a te..." (str/shorten 15 "This is a test of shortening"))
    (assert-equal "This is a tes--" (str/shorten 15 "This is a test of shortening" 
                                                 :ellipsis "--"))
    (assert-equal "This is a test" (str/shorten 15 "This is a test")))

  (deftest wordy-tests 
    (assert-equivalent ["This" "is" "a" "test"] (str/words "This  is a test"))
    (assert-equal "This is a test" (str/unwords "This" "is" "a" "test"))
    (assert-equivalent ["This" "is" "a" "test"] (str/words "  This is a test"))
    )

  (deftest lines
    (assert-equivalent ["" "1" "2" "3"] (str/lines "\n\r1\r2\n3\n"))
    (assert-equivalent ["1" "2" "3"] (str/lines "\n\r1\r2\n3\n" :omit-empty true))
    # A little trick to know how best to test this in a cross
    (assert-expr (string? (str/unlines "1" "2" "3"))))

  (deftest contains?
    (assert-expr (str/contains? "a" "abc"))))
