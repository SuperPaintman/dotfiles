// ==UserScript==
// @name     leetcode-dark
// @version  22
// @grant    none
// @match    https://leetcode.com/*
// ==/UserScript==

const delay = (n) => new Promise((resolve) => setTimeout(resolve, n));

function injectStyles() {
  // Before loading script.
  document.body.style.backgroundColor = 'rgba(34, 35, 37, 1)';

  const link = document.createElement('link');
  link.type = 'text/css';
  link.rel = 'stylesheet';
  link.href = 'http://127.0.0.1:29999/leetcode-dark/leetcode-dark.user.css';
  link.addEventListener('load', () => {
    document.body.style.backgroundColor = '';
  });
  document.head.appendChild(link);
}

function injectWhiteLogo() {
  async function tryInjectLogo() {
    for (let i = 0; i < 3; i++) {
      if (injectLogo()) {
        return;
      }

      await delay(100 + 500 * i);
    }
  }

  function injectLogo() {
    const newLogoAlreadyInDOM = document.querySelector('.x-logo');
    if (newLogoAlreadyInDOM) {
      return false;
    }

    const logo = document.querySelector(
      `#navbar-root > [class^='navbar'] img[class^='logo']`
    );
    if (!logo) {
      return false;
    }

    const newLogo = document.createElement('img');
    newLogo.src =
      '/_next/static/images/logo-dark-c96c407d175e36c81e236fcfdd682a0b.png';
    newLogo.alt = 'LeetCode Logo';
    newLogo.className = logo.className;
    newLogo.classList.add('x-logo');

    logo.parentElement.appendChild(newLogo);

    return true;
  }

  function tryInjectLogoOnce() {
    document.removeEventListener('readystatechange', tryInjectLogoOnce);

    tryInjectLogo().catch((err) => {
      console.error('Grease Monkey: leetcode-dark: tryInjectLogo: ', err);
    });
  }

  document.addEventListener('readystatechange', tryInjectLogoOnce);
}

function main() {
  injectStyles();
  injectWhiteLogo();
}

try {
  main();
} catch (err) {
  console.error('Grease Monkey: leetcode-dark:', err);
}
