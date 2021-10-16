// ==UserScript==
// @name     leetcode-timer
// @version  3
// @grant    none
// @match    https://leetcode.com/*
// ==/UserScript==

function injectScript() {
  function onReady() {
    document.removeEventListener('readystatechange', onReady);

    const script = document.createElement('script');
    script.type = 'text/javascript';
    script.async = '';
    script.src = `http://127.0.0.1:29999/leetcode-timer/leetcode-timer.dynamic.js?t=${Date.now()}`;

    document.body.appendChild(script);
  }

  document.addEventListener('readystatechange', onReady);
}

function main() {
  injectScript();
}

try {
  main();
} catch (err) {
  console.error('Grease Monkey: leetcode-timer:', err);
}
