# Janet stringx: String extras for janet

## Overview

This library provides some string utlity functions for Janet, and will be added to as useful missing functionality is discovered. Pull Requests are welcome!

## Usage

Time formatting example

```janet
(import stringx :as "str")

(def {:hour hour :minute minute } (os/date (os/time) :local))

# Prints time in HHMM, akin to military time
(print (str/pad-left hour "0" 2) (str/pad-left minute "0" 2))
```

Cleaning out disallowed chars from a file

```janet
(defn clean-path-string [mypath] 
  (string/replace-pairs 
    [
     # Based on https://docs.microsoft.com/en-us/windows/win32/fileio/naming-a-file
     # Either remove, or change unsafe chars
     "<" ""
     ">" ""
     ":" "."
     "\"" ""
     "/" ""
     "\\" "+"
     "?" ""
     "|" "+"
     "*" "+"
     ] mypath))
```

## Status

v0.1. Feel free to use this, but APIs are subject to change for the time being.

