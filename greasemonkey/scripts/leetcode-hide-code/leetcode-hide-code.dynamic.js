(function () {
  const delay = (n) => new Promise((resolve) => setTimeout(resolve, n));

  async function tryInjectCodeCover() {
    for (let i = 0; i < 10; i++) {
      if (injectCodeCover()) {
        console.log('Grease Monkey: leetcode-hide-code: code cover injected');
        return;
      }

      await delay(100 + 500 * i);
    }
  }

  function injectCodeCover() {
    const container = document.querySelector(
      `#app [class^='main'] [class^='code-area'] [class*='code-editor-with-breakpoint']`
    );
    if (!container) {
      return false;
    }

    container.style.position = 'relative';

    const codeCover = document.createElement('div');
    codeCover.className = 'x-code-cover';
    codeCover.innerHTML = 'Show! 👁️';
    container.appendChild(codeCover);

    codeCover.addEventListener('click', () => {
      codeCover.remove();
    });

    return true;
  }

  async function injectStyles() {
    const style = document.createElement('style');
    style.innerHTML = `.x-code-cover { display: none; }`;
    document.head.appendChild(style);

    const link = document.createElement('link');
    link.type = 'text/css';
    link.rel = 'stylesheet';
    link.href = `http://127.0.0.1:29999/leetcode-hide-code/leetcode-hide-code.user.css?t=${Date.now()}`;
    document.head.appendChild(link);

    return new Promise((resolve) => {
      function onLoad() {
        link.removeEventListener('load', onLoad);
        style.remove();
        resolve();
      }

      link.addEventListener('load', onLoad);
    });
  }

  async function main() {
    if (!document.URL.includes('//leetcode.com/problems/')) {
      return;
    }

    await Promise.all([injectStyles(), tryInjectCodeCover()]);
  }

  main().catch((err) => {
    console.error('Grease Monkey: leetcode-hide-code: injectCodeCover:', err);
  });
})();
