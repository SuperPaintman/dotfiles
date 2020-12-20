interface String {
  /** @tupleReturn */
  match(pattern: string): string[];
}

declare namespace awesome {
  /**
   * Add a global signal.
   */
  export function connect_signal(
    name: string,
    callback: (...args: unknown[]) => void
  ): void;

  /**
   * Emit a global signal.
   */
  export function emit_signal(name: string, ...args: unknown[]): void;
}
