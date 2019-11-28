#!/bin/bash

output="public/index.html"

mkdir -p public
elm make src/Main.elm --optimize --output=public/elm.js
uglifyjs public/elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=public/elm.min.js

echo '<!DOCTYPE HTML>
<html lang="en">
<head>
<title>How much coffee?</title>
<link rel="icon" type="image/png" href="icons-256.png">
<link rel="manifest" href="manifest.json">
<meta charset="UTF-8">
<meta name="Description" content="A simple coffee calculator.">
<meta name="theme-color" content="#e7decd" />
<meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
<div id="elm-app"></div>
<script>' > $output
cat public/elm.min.js >> $output
echo 'var app = Elm.Main.init({ node: document.getElementById("elm-app") });
</script>
</body>
</html>' >> $output

rm public/elm.js
rm public/elm.min.js

cp -r images/. public/
cp manifest.json ./public/manifest.json
