'use strict';

import watch = require('awful.widget.watch');

export const signal_name = 'daemons::wifi';

export const status_connected = 'connected';
export const status_disconnected = 'disconnected';
export const status_error = 'error';

const home = os.getenv('HOME') || '~';

/** @tupleReturn */
function parse_result(
  stdout: string | null,
  exitcode: number
): [string, string, number, boolean] {
  if (exitcode !== 0) {
    return [status_error, '', 0, true];
  }

  if (typeof stdout !== 'string') {
    return ['', '', 0, false];
  }

  const [name, signal] = stdout.match('connected%s+([^%s]+)%s+([0-9]+)');
  if (signal === null) {
    const [v] = stdout.match('disconnected');
    if (v) {
      return [status_disconnected, '', 0, true];
    }

    return ['', '', 0, false];
  }

  return [status_connected, name, tonumber(signal) || 0, true];
}

watch(home + '/bin/wifistatus', 10, (_w, stdout, _stderr, _r, exitcode) => {
  const [status, name, signal, ok] = parse_result(stdout, exitcode);
  if (!ok) {
    return;
  }

  awesome.emit_signal(signal_name, status, name, signal);
});

export const _private = {
  parse_result
};
