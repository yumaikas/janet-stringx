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


(defn replace [str &keys { :patt patt :with subst }]
  (unless (bytes? patt)
    (error "A pattern is required!"))
  (unless (bytes? subst)
    (error "A substitution is required!"))
  (string/replace-all patt subst str))

# These functions are defined as wrappers around the stdlib functions,
# just so that if you're importing this as str/, they're easy to access.
(defmacro- trim-via [trim-fn str &opt _set] 
  ~(if ,_set 
     (,trim-fn ,str ,_set)
     (,trim-fn ,str)))

(defn trim 
  ```
  Trims a string, optionally using `set` as the list of characters to trim off
  `set` defaults to acsii whitespace if not provided.
  ```
  [str &opt set] (trim-via string/trim str set))
  
(defn trim-left 
  ```
  Trims the left side of a string, optionally using `set` as the set of characters trim off
  `set` defaults to ascii whitepsacec if not provided.
  ``` 
  [str &opt set] (trim-via string/triml str set))

(defn trim-right 
  ```
  Trims the right side string, optionally using `set` as the set of characters to trim off
  `set` defaults to ascii whitespace if not provided.
  ```
  [str &opt set] (trim-via string/trimr str set))

(defn has-prefix?
  "Tests if `str` starts with `pfx`"
  [pfx str] (string/has-prefix? pfx str))

(defn has-suffix? 
  "Tests if `str` ends with `suff`"
  [suff str] (string/has-suffix? suff str))

(defn insert 
  "Inserts `inserted` at `index` into `str`. If `index` is outside of `str`, throws an error."
  [inserted index str] 
  # TODO Handle out of bounds index
  (string
    (slice str 0 index)
    inserted
    (slice str index)))

(defn prefix-each 
  "Prepends a prefix to each element in `items`"
  [items str] (map |(string str $) items))
(defn suffix-each 
  "Appends a suffice to each element in `items`"
  [items str] (map |(string $ str) items))

(defn rest 
  ```
  Returns a string of all of the characters after the first,
  returning nil if there are no characters after the first one.
  ```
  [str] 
  (if (> (length str) 1)
    (string/slice str 1)
    nil))

(defn nth
  ``` 
  Retrieve the nth character from a string, as string.
  ```
  [str idx] (string/from-bytes (str idx)))

(defn shorten 
  ```
  If `str` is longer than `len` chars, shorten it down to len chars, and replace 
  the last chars with ellipsis, for however long ellipsis is.
  ```
  [len str &keys { :ellipsis ellipsis }]
  (default ellipsis "...")
  (if (> (length str) len)
    (string
      (slice str 0 (- len (length ellipsis)))
      ellipsis)
    str))

(def- ws-pat (peg/compile ~{ :main (<- :s*) }))
(defn blank? [str]
  "Tests if str is null or whitespace?"
  (unless str (break true))
  (when (empty? str) (break true))

  (def ws-str (peg/match ws-pat (string str)))
  (match ws-str 
    @[m] (= (string str) (string m))
    _ false))

(def- ws/split-pat 
  (peg/compile ~(any (* :s* (<- (any (if-not :s 1))) :s*))))
(defn words 
  "Splits a string on whitespaces, giving an array of words"
  [str] (peg/match ws/split-pat str))

(defn unwords [& words] (string/join words " "))

(def- nl/split-pat-omit-empty
  # There is a little repetition here, it's *just* on the edge 
  # of making grammer with a custom rule, but not quite.
  (peg/compile ~(any (* 
                       (any (set "\r\n"))
                       (<- (any (if-not (set "\r\n") 1))) 
                       (any (set "\r\n"))))))
(def- nl/split-pat
  (peg/compile 
    ~{:line (+ 
              (<- (any (if-not (set "\r\n") 1)))
              (constant ""))
      :nl (+ "\r\n" "\n" "\r")
      :main (any (* :line (any :nl)))}))

(defn lines 
  ```
  Splits a string on newlines.
  If :omit-empty is true, skips empty lines.
  ```
  [str &keys {:omit-empty omit-empty}] 
  (default omit-empty false)
  (if omit-empty
   (peg/match nl/split-pat-omit-empty str)
   (peg/match nl/split-pat str)))

(defn newline [] 
  (match (os/which)
    :windows "\r\n"
    _ "\n"))

(defn unlines 
  ```
  Joins strings using the platform-specific newline
  ```
  [& lines] 
  (string/join lines (newline)))

(defn contains?
  "Tests if `s` contains `patt`"
  [patt s] (not (not (string/find patt s))))



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

(defn empty? [str] 
  (unless str (break true))
  ((comptime empty?) str))

(defn last [str] (string/from-bytes ((comptime last) str)))
(defn first [str] (string/from-bytes ((comptime first) str)))


