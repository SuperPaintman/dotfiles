const localStorageKey = (id) => `leetcode::${id}::timer`;

function loadTimer(id) {
  try {
    const data = JSON.parse(localStorage.getItem(localStorageKey(id)));
    if (data !== null) {
      return data;
    }
  } catch (err) {
    console.error('Grease Monkey: leetcode-timer: loadTimer:', err);
  }

  return { started: false, elapsed: 0 };
}

function storeTimer(id, data) {
  try {
    localStorage.setItem(localStorageKey(id), JSON.stringify(data));
  } catch (err) {
    console.error('Grease Monkey: leetcode-timer: storeTimer:', err);
  }
}

const delay = (n) => new Promise((resolve) => setTimeout(resolve, n));

function formatTimer(elapsed) {
  const format = (n) => ('' + n).padStart(2, '0');
  const formatMS = (n) => (n / 1000).toFixed(3).split('.')[1].padEnd(3, '0');

  const milliseconds = elapsed % 1000;
  elapsed /= 1000;
  const seconds = Math.floor(elapsed % 60);
  elapsed /= 60;
  const minutes = Math.floor(elapsed % 60);
  elapsed /= 60;
  const hours = Math.floor(elapsed);

  return `${format(hours)}:${format(minutes)}:${format(seconds)}`;
  // return `${format(hours)}:${format(minutes)}:${format(seconds)}.${formatMS(
  //   milliseconds
  // )}`;
}

async function tryInjectTimer() {
  for (let i = 0; i < 10; i++) {
    if (injectTimer()) {
      console.log('Grease Monkey: leetcode-timer: timer injected');
      return;
    }

    await delay(100 + 500 * i);
  }
}

function injectTimer() {
  const container = document.querySelector(
    `#app [class^='main'] [class^='code-area'] [class^='btns']`
  );
  if (!container) {
    return false;
  }

  const questionTitle = document.querySelector(`[data-cy="question-title"]`);
  if (!questionTitle) {
    return false;
  }

  const problemID = parseInt(questionTitle.textContent.split('.')[0], 10);
  if (isNaN(problemID) || problemID <= 0) {
    return false;
  }

  const data = loadTimer(problemID);
  storeTimer(problemID, { ...data, started: false });
  // let { started, elapsed } = data;
  let { elapsed } = data;
  let started = false;
  let last = Date.now();
  let lastStore = Date.now();

  const timerContainer = document.createElement('div');
  timerContainer.className = 'x-timer-container';
  container.prepend(timerContainer);

  const timer = document.createElement('div');
  timer.className = 'x-timer';
  timer.innerHTML = formatTimer(elapsed);
  timerContainer.appendChild(timer);

  const stopBTN = document.createElement('div');
  stopBTN.className = 'x-timer-stop';
  stopBTN.innerHTML = started ? '⏸' : '▶';
  timerContainer.appendChild(stopBTN);
  stopBTN.addEventListener('click', () => {
    started = !started;
    last = Date.now();
    stopBTN.innerHTML = started ? '⏸' : '▶';
    storeTimer(problemID, { started, elapsed });
  });

  const resetBTN = document.createElement('div');
  resetBTN.className = 'x-timer-reset';
  resetBTN.innerHTML = '🗑';
  timerContainer.appendChild(resetBTN);
  resetBTN.addEventListener('click', () => {
    elapsed = 0;
    timer.innerHTML = formatTimer(elapsed);
    storeTimer(problemID, { started, elapsed });
  });

  const submitBTN = document.querySelector(
    `#app [class^='main'] [class^='action'] [class^='submit']`
  );
  if (submitBTN) {
    submitBTN.addEventListener('click', () => {
      started = false;
      last = Date.now();
      stopBTN.innerHTML = started ? '⏸' : '▶';
      storeTimer(problemID, { started, elapsed });
    });
  }

  setInterval(() => {
    const now = Date.now();

    if (started) {
      elapsed += now - last;

      // Skip saving iterations.
      if (now - lastStore > 3000) {
        storeTimer(problemID, { started, elapsed });
        lastStore = now;
      }

      timer.innerHTML = formatTimer(elapsed);
    }

    last = now;
  }, 100);

  return true;
}

async function injectStyles() {
  const style = document.createElement('style');
  style.innerHTML = `.x-timer-container { display: none; }`;
  document.head.appendChild(style);

  const link = document.createElement('link');
  link.type = 'text/css';
  link.rel = 'stylesheet';
  link.href = `http://127.0.0.1:29999/leetcode-timer/leetcode-timer.user.css?t=${Date.now()}`;
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

  await Promise.all([injectStyles(), tryInjectTimer()]);
}

main().catch((err) => {
  console.error('Grease Monkey: leetcode-timer: injectTimer:', err);
});
