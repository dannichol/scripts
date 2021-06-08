# Purpose
central store for generic scripts

# Shellcheck

```
Did you mean: 
    && status=$(echo "$net" | cut -d' ' -f7 | tr '[:lower:]' '[:upper:]') \

For more information:
  https://www.shellcheck.net/wiki/SC2015 -- Note that A && B || C is not if-t...
  https://www.shellcheck.net/wiki/SC2086 -- Double quote to prevent globbing ...
In statusbar.sh line 6:
    && status=$(echo $net | cut -d' ' -f7 | tr '[:lower:]' '[:upper:]') \
    ^-- SC2015: Note that A && B || C is not if-then-else. 
    C may run when A is true.
                     ^--^ SC2086: Double quote to prevent globbing and 
                     word splitting.
```
- SC2015: this is expected behaviour
- SC2086: flattening the format allows for calling less binaries
