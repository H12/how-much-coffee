#!/bin/bash

output="public/index.html"

rm -rf public; mkdir public
elm make src/Main.elm --optimize --output=public/elm.js
uglifyjs public/elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=public/elm.min.js

echo '<!DOCTYPE HTML>
<html lang="en">
<head>
<title>How much coffee?</title>
<link rel="icon" type="image/png" href="icons-192.png">
<link rel="manifest" href="manifest.json">
<link rel="apple-touch-icon" href="/images/icons/icons-152.png">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="apple-mobile-web-app-title" content="Coffee PWA">
<meta charset="UTF-8">
<meta name="description" content="A simple coffee calculator.">
<meta name="theme-color" content="#e7decd">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta property="og:title" content="How much coffee?">
<meta property="og:type" content="website">
<meta property="og:url" content="https://howmuch.coffee">
<meta property="og:image:url" content="http://howmuch.coffee/images/icons/icons-512.png">
<meta property="og:image:secure_url" content="https://howmuch.coffee/images/icons/icons-512.png">
<meta property="og:image:type" content="image/png">
</head>
<body style="overscroll-behavior-y: none;">
<div id="elm-app"></div>
<script>' > $output
cat public/elm.min.js >> $output
echo 'var app = Elm.Main.init({ node: document.getElementById("elm-app") });
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/service-worker.js")
        .then((reg) => {
          console.log("Service worker registered.", reg);
        });
  });
}
</script>
<noscript style="font-family:monospace;">howmuch.coffee cannot function without java(script)</noscript>
</body>
</html>' >> $output

rm public/elm.js
rm public/elm.min.js

cp -r assets/images/. public/
cp -r assets/vectors/. public/
cp manifest.json ./public/manifest.json
cp scripts/service-worker.js ./public/service-worker.js
