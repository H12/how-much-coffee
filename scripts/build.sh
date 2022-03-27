#!/bin/bash

output="public/index.html"

rm -rf public; mkdir public
elm make src/Main.elm --optimize --output=public/elm.js
uglifyjs public/elm.js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output=public/elm.min.js

echo '<!DOCTYPE HTML>
<html lang="en">
<head>
<title>Coffee Ratios - Simple Calculator | howmuch.coffee</title>
<link rel="author" href="https://github.com/sponsors/h12"/>
<link rel="icon" type="image/png" href="/icons-192.png">
<link rel="manifest" href="manifest.json">
<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon-180x180.png">
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="default">
<meta name="apple-mobile-web-app-title" content="Coffee Calculator">
<meta charset="UTF-8">
<meta name="description" content="Find the ideal coffee-to-water ratio for pour over or french press! Simply select brew type, then specify your desired yield and strength. Coffee made simple!">
<meta name="theme-color" content="#e7decd">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta property="og:title" content="Coffee Ratios - Simple Calculator | howmuch.coffee">
<meta property="og:type" content="website">
<meta property="og:url" content="https://howmuch.coffee">
<meta property="og:image:url" content="http://howmuch.coffee/icons-1024.png">
<meta property="og:image:secure_url" content="https://howmuch.coffee/social-1200x630.png">
<meta property="og:image:type" content="image/png">
<meta property="og:image:width" content="1200">
<meta property="og:image:height" content="630">
<meta property="og:image:alt" content="Cartoon Coffee Beans">
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
