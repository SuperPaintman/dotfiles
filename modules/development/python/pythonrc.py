################################################################################
# Setup.
################################################################################
def _repl_setup():
    ENV_PYTHON_HISTORY = "PYTHON_HISTORY"
    ENV_PYTHON_HISTORY_SIZE = "PYTHON_HISTORY_SIZE"
    ENV_XDG_STATE_HOME = "XDG_STATE_HOME"

    def pre_3_13_fallback():
        import sys

        if sys.version_info >= (3, 13):
            return

        import os
        import atexit
        import readline

        histfile = os.environ.get(
            ENV_PYTHON_HISTORY,
            os.path.join(
                os.environ.get(ENV_XDG_STATE_HOME, os.path.expanduser("~/.local/state")),
                "python",
                "history",
            ),
        )

        os.makedirs(os.path.dirname(histfile), exist_ok=True)

        try:
            readline.read_history_file(histfile)
        except FileNotFoundError:
            pass

        atexit.register(readline.write_history_file, histfile)

        # Tab completion (automatic in 3.13+ PyREPL)
        import rlcompleter
        readline.parse_and_bind("tab: complete")
    pre_3_13_fallback()

    def setup_history():
        import os
        import readline

        readline.set_history_length(int(os.environ.get(ENV_PYTHON_HISTORY_SIZE, "10000")))
    setup_history()

_repl_setup()
del _repl_setup

################################################################################
# Conveniences
################################################################################
import json

