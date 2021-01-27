(defn pad-right 
  "Right-pads a string, so that it has at least len chars. fill is a single char string"
  [str len &opt fill] 
  (def str (string str))
  (def len (max (length str) len))
  (default fill " ")
  (as-> (buffer/new-filled len (fill 0)) it
        (buffer/blit it str 0)
        (string it)))

(defn pad-left 
  "Left-pads a string so that it has at least len chars. fill should be a single char string"
  [str len &opt fill]
  (def str (string str))
  (def len (max (length str) len))
  (default fill " ")
  (as-> (buffer/new-filled len (fill 0)) it
        (buffer/blit it str (- len (length str)))
        (string it)))

# @task[ replace/pairs preformance review 
# |notes:
# Figure out a way that this might be done more efficiently? This works, and isn't
# any slower than an obvious way of doing thing, but currently does create a non-zero amount
# of garbage. For an app, not a huge cost, but for a library, 
# the consideration becomes important |status: to-do]

(defn replace-pairs [replacements str] 
  (assert 
    (indexed? replacements)
    (string "expected replacemanet to be array|tuple, got " (type replacements)))
  (assert 
    (even? (length replacements)) 
    "Expected an even number of replacements, got and odd one")
  (var retval str)
  (each (patt subst) (partition 2 replacements)
    (set retval (string/replace-all patt subst retval)))
  retval)

