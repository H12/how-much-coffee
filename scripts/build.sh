#!/bin/bash

output="dist/index.html"

mkdir -p dist
elm make src/Main.elm --optimize --output=dist/elm.js
uglifyjs dist/elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=dist/elm.min.js

echo '<!DOCTYPE HTML>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Main</title>
<meta name="Description" content="A simple coffee calculator.">
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<div id="elm-app"></div>
<script>' > $output
cat dist/elm.min.js >> $output
echo 'var app = Elm.Main.init({ node: document.getElementById("elm-app") });
</script>
</body>
</html>' >> $output

rm dist/elm.js
rm dist/elm.min.js
