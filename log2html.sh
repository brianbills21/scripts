#!/bin/bash
exec >"$2"
cat <<HERE
<html><body><h1>Log output for: $1</h1>
<pre>
HERE
grep "${3:-^}" "$1"
echo '</pre></body></html>'