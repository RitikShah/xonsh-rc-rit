"""
Awesome snippets of code to make your awesome xonsh RC.
Source: https://github.com/anki-code/xontrib-rc-awesome
If you like the idea click ⭐ on the repo and stay tuned. 
""" 

from .utils import yieldify, aliasify

@yieldify
def main():
    # print("Loading .xonshrc")

    from pathlib import Path
    from importlib import resources

    yield "imports"

    $PATH = [
        '~/.local/bin',
        '~/.cargo/bin',
        '/usr/local/bin',
    ] + $PATH

    yield "path"

    # https://github.com/prompt-toolkit/python-prompt-toolkit/issues/1696
    __import__('warnings').filterwarnings('ignore', 'There is no current event loop', DeprecationWarning, 'prompt_toolkit')

    yield "filterwarning"

    $PROMPT_FIELDS['prompt_end'] = '@'

    # Do not write the command to the history if it was ended by `###`
    $XONSH_HISTORY_IGNORE_REGEX = '.*(\\#\\#\\#\\s*)$'

    # Remove front dot in multiline input to make the code copy-pastable.
    $MULTILINE_PROMPT = ' '

    # Suppress line "xonsh: For full traceback set: $XONSH_SHOW_TRACEBACK = True" 
    # in case of exceptions or wrong command.
    $XONSH_SHOW_TRACEBACK = False

    # Suppress line "Did you mean one of the following?"
    $SUGGEST_COMMANDS = False

    # Flag for automatically pushing directories onto the directory stack
    #  i.e. `dirs -p` (https://xon.sh/aliases.html#dirs).
    $AUTO_PUSHD = True

    $XONTRIB_CD_LONG_DURATION = 5  # default

    # defaults
    $PYTHON_MODE = False
    $LAST_DIR = []
    $RUNNING_BACK = False

    # iPython
    $PYTHONBREAKPOINT = 'IPython.core.debugger.set_trace'

    # Use sqlite for history and ignore duplicate commands
    $XONSH_HISTORY_BACKEND = 'sqlite'
    $HISTCONTROL='ignoredups'

    # change to pyenv
    $PYENV_ROOT = p"~/.pyenv".resolve()
    $PIPX_DEFAULT_PYTHON=f"{$PYENV_ROOT}/shims/python"

    $ENABLE_ASYNC_PROMPT = True

    yield "envs"


    # Xontribs - https://github.com/topics/xontrib
    # print("  xontribs:")
    for _xontrib in (
        # Command abbreviations for auto-complete
        "abbrevs",

        # enter environments inside folders
        "autovox",

        # # autovox for poetry
        "avox_poetry",

        # enable some bash stuff, !! to rerun last cmd for example
        "bashisms",

        # cd is now cd! aka bash compliant
        "cd",

        # reimplement some util stuff like echo and cat in python
        "coreutils",

        # homebrew
        "homebrew",

        # python auto-complete
        "jedi",

        # lazily load python modules
        # https://github.com/agoose77/xontrib-mod
        "mod",

        # allows u to "double-click" stuff, open files, navigate, pandas read
        "onepath",

        # build in debugger w/ xonsh?
        "pdb",

        # starship custom shell look
        "prompt_starship",

        # pyenv
        "pyenv",

        # self-explanatory
        "readable-traceback",

        # start with ! to run copy and pasted shell cmds
        "sh",

        # virtual environments, required
        "vox",
        "voxapi",
        "vox_tabcomplete",

        # jump between words, same keyboard shortcut as ide's
        "whole_word_jumping",

        # fancy af `ls` cmd
        "xlsd",

        # temp traceback log file somewhere?
        "xog",
    ):
        xontrib load @(_xontrib)
        yield f"  loading {_xontrib}"


    # Adding aliases from dict
    global aliases
    aliases |= {
        '-': 'cd -',
        '..': 'cd ..',
        '....': 'cd ../..',

        # List all files: sorted, with colors, directories will be first (Midnight Commander style).
        'll': "$LC_COLLATE='C' ls --group-directories-first -lAh --color @($args)",
        
        # Make directory and cd into it.
        # Example: md /tmp/my/awesome/dir/will/be/here
        'md': 'mkdir -p $arg0 && cd $arg0',
        
        # Grepping string occurrences recursively starting from current directory.
        # Example: cd ~/git/xonsh && greps environ
        'greps': 'grep -ri',

        # `grep` with color output.
        # This is distinct alias to keep output clean in case `var = $(echo 123 | grep 12)`
        'grepc': 'grep --color=always',

        # SSH: Suppress "Connection close" message.
        'ssh': 'ssh -o LogLevel=QUIET',

        # Run http server in the current directory.
        'http-here': 'python3 -m http.server',
        
        # history search macro
        'history-search': """sqlite3 $XONSH_HISTORY_FILE @("SELECT inp FROM xonsh_history WHERE inp LIKE '%" + $arg0 + "%' AND inp NOT LIKE 'history-%' ORDER BY tsb DESC LIMIT 10");""",

        # vscode
        'code': 'open -a "Visual Studio Code"',

        # reconfig xonsh
        'config': 'code ~/Life/Things/MC2/dev/xonsh-rc',

        # yoink
        'yoink': 'open -a Yoink',
        
        # cat bat
        'cat': 'bat',
        'batdiff': 'git diff --name-only --relative --diff-filter=d | xargs bat --diff',
        
        # poe the poet
        'poe': 'poetry poe',
        
        # ye
        'deactivate': 'vox deactivate',
        
        # quick access to the python of xonsh for hunter, etc
        'xpython': '~/.local/pipx/venvs/xonsh/bin/python',

        # with auto-pushd, this is easy
        "back": "popd > /dev/null",
    }

    yield "aliases"

    addons = resources.files(__package__) / "addons"
    for file in addons.glob("*.xsh"):
        source @(file.resolve())
        yield f"  addon [{file.stem}]"

    yield "all addons"
