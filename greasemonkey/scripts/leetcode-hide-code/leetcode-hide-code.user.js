// ==UserScript==
// @name     leetcode-hide-code
// @version  1
// @grant    none
// @match    https://leetcode.com/*
// ==/UserScript==

function injectScript() {
  function onReady() {
    document.removeEventListener('readystatechange', onReady);

    const script = document.createElement('script');
    script.type = 'text/javascript';
    script.async = '';
    script.src = `http://127.0.0.1:29999/leetcode-hide-code/leetcode-hide-code.dynamic.js?t=${Date.now()}`;

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
  console.error('Grease Monkey: leetcode-hide-code:', err);
}
