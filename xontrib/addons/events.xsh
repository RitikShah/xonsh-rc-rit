from xonsh.events import events
from pathlib import Path
from xlsd.icons import STAT_ICONS, LS_ICONS

XLSD_EMOJIS = set(STAT_ICONS._icons.values()) | set(LS_ICONS._icons.values())


@events.on_chdir
def _source_rc(olddir, newdir, **kw):
    old = Path(olddir)
    new = Path(newdir)

    if (path := new / '.dir_rc_enter.xsh').exists() and old in new.parents:
        source @(path)

    if (path := old / '.dir_rc_exit.xsh').exists() and new in old.parents:
        source @(path)


@events.on_transform_command
def _default_command_transform(cmd):
    """Run a default command when no command is given"""
    if not $PYTHON_MODE and (not cmd or cmd.strip() == ""):
        return defaultcmd()
    return cmd

@events.on_transform_command
def _source_activate_patch(cmd):
    """Run a default command when no command is given"""
    if cmd.startswith("source") and cmd.endswith(".venv/bin/activate\n"):
        return ""
    return cmd

@events.on_transform_command
def _strip_emoji(cmd):
    """Run a default command when no command is given"""
    for emoji in XLSD_EMOJIS:
        if cmd.startswith(emoji):
            return cmd.strip(emoji)
    return cmd

def defaultcmd():
    cmd = "ls"

    if p'$PWD/.git'.exists():
        return f"{cmd} && git status"

    return cmd
