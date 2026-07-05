{ lib, pkgs, ... }:

with lib;

let
  noop = _: id;

  makeLogger = args: let
    domain = if args ? domain then args.domain else "";
    enable = {
      trace = if args ? trace then args.trace else true;
      warn = if args ? warn then args.warn else true;
    };

    log = f: msg: let 
      pos = if domain != "" then builtins.unsafeGetAttrPos "domain" args else null;
      prefix = if domain != "" then "[${domain}]: " else "";
      # suffix = if pos != null then " at ${pos.file}:${toString pos.line}:${toString pos.column}" else "";
      suffix = if pos != null then " at ${pos.file}:${toString pos.line}" else "";
    in f "${prefix}${msg}${suffix}";

    logIf = f: cond: msg: if cond then log f msg else id;

    logIfNot = f: cond: logIf f (!cond);
  in rec {
    trace = log (if enable.trace then lib.trace else noop);
    traceIf = logIf (if enable.trace then lib.trace else noop);
    traceIfNot = logIfNot (if enable.trace then lib.trace else noop);

    warn = log (if enable.warn then lib.warn else noop);
    warnIf = logIf (if enable.warn then lib.warn else noop);
    warnIfNot = logIfNot (if enable.warn then lib.warn else noop);
  };

  logger = makeLogger { };
in

rec {
  inherit makeLogger;
  inherit (logger)
    trace
    traceIf
    traceIfNot
    warn
    warnIf
    warnIfNot;
}
