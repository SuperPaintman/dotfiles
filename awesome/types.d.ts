declare type Widget = unknown;

declare type GearsTimer = unknown;

/** @noResolution */
declare module 'awful.widget.watch' {
  /**
   * Create a textbox that shows the output of a command and updates it at
   * a given time interval.
   *
   * @see https://awesomewm.org/doc/api/classes/awful.widget.watch.html#awful.widget.watch:new
   *
   * @tupleReturn
   */
  function watch(
    command: string,
    timeout?: number,
    callback?: (
      widget: unknown,
      stdout: string,
      stderr: string,
      exitreason: string,
      exitcode: number
    ) => void
  ): [Widget, GearsTimer];

  export = watch;
}
