from xontrib.utils import yieldify, aliasify

@yieldify
def main():
    import rich
    from pathlib import Path
    from rich.console import Console
    from rich.syntax import Syntax
    import nbtlib
    import re
    import time
    from prompt_toolkit import prompt

    from contextlib import suppress

    @aliasify
    def toggle_python():
        global _cache, _to_remove
        $PYTHON_MODE = not $PYTHON_MODE
        if $PYTHON_MODE:
            rich.print(
                '\n'
                '[bold]Python Mode Activating[/bold]\n\n'
                'Python ' + sys.version
            )
            $OLD_PROMPT = $PROMPT
            $PROMPT = '>>> '
            $MULTILINE_PROMPT = '... '
            _cache = set(globals().keys())
            aliases['exit_backup'] = aliases['exit']
            aliases['exit'] = aliases['toggle-python']
            $XONSH_SHOW_TRACEBACK = True
            globals()["__IPYTHON__"] = True
            $TOGGLE_PYTHON_INCR = 0

        else:
            rich.print(
                '\n'
                '[bold]Python Mode Deactivating[/bold]\n'
                'Resetting environment..'
            )

            for var in _to_remove:
                # print(f'removing {var}')
                if not var.startswith('_'):
                    if var not in globals():
                        rich.print(f'  [bold red]Error[/bold red]: {var} not in globals..')
                    else:
                        del globals()[var]

            $PROMPT = $OLD_PROMPT
            $MULTILINE_PROMPT = ' '
            _to_remove = set()

            aliases['exit'] = aliases['exit_backup']
            $XONSH_SHOW_TRACEBACK = False
            del globals()["__IPYTHON__"]

            $TOGGLE_PYTHON_LAST_SESSION = $(history show ::@($TOGGLE_PYTHON_INCR))
    
    


    @aliasify
    def prune(args):
        d = args[0]
        console = Console()
        paths = list(Path(d).glob('**/.DS_Store'))

        if ((num := len(paths)) > 0):
            ans = console.input(
                f"[green] Are you sure you want to prune {num} files in the '{d}' folder? (y/n): ")
            ans = ans[0].lower()

            if ans == 'y':
                for path in paths:
                    rich.print(f'[green] {path} [red] deleted')
                    path.unlink()
            else:
                rich.print('[red] Canceled')
        else:
            rich.print('[green] No .DS_Store to worry about [bold]:)')


    @aliasify
    def todos(args):
        x0 = time.perf_counter()
        folder = p'.' if len(args) < 1 else Path(args[0])
        # ext = 'mcfunction' if len(args) < 2 else args[1]

        pat = 'TODO:'
        count = 0

        console = Console()

        for path in folder.rglob(f'*'):
            if not path.is_file() or any(part.startswith(".") for part in path.parts):
                continue

            count += 1
            if count > 10000:
                rich.print('[dark red]ERROR[/dark red]:[red]10,000+ files checked')
                break

            with suppress(UnicodeDecodeError):
                with path.open() as file:
                    print_file = False
                    for line in file.readlines():
                        if pat in (line := line.lstrip()):
                            if not print_file:
                                rich.print(f'[bold red]{str(path)}[/bold red]')
                                print_file = True
                            console.print(Syntax(
                                line,
                                path.suffix[1:],
                                theme="material",
                            ))

        x1 = time.perf_counter()
        rich.print(
            f'[dim bold blue]{count}[/dim bold blue] [dim blue]files checked in [bold]{x1 - x0:.3f}[/bold] seconds[/dim blue]'
        )


    @aliasify
    def rename(args):
        if len(args) > 2:
            paths = Path(args[0])
            pat = re.compile(args[1])
            repl = args[2]
        elif len(args) > 1:
            paths = Path('.')
            pat = re.compile(args[0])
            repl = args[1]
        else:
            rich.print('[red]Error: Requires 3 arguments[/red]')
            return

        for path in paths.glob('*'):
            if path.exists() and path.is_file() and pat.search(src := str(path)):
                path.rename(res := pat.sub(repl, src))
                rich.print(f'[dim]{src} renamed to {res}[/dim]')


    @aliasify
    def snbt():
        s = prompt('type raw snbt > ')
        print(nbtlib.serialize_tag(nbtlib.parse_nbt(s), indent=2))


    # @alias
    # def rgb_to_hex(rgb, with_hashtag=False):
    #     out = '%02x%02x%02x' % rgb
    #     if with_hashtag:
    #         return f'#{out}'
    #     return out

    # @alias
    # def hex_to_rgb(hex):
    #     return tuple(int(hex.lstrip('#')[i:i+2], 16) for i in (0, 2, 4))


    # @alias
    # def pastel(hex=None):
    #     # if hex is None:
    #     #     color = _rgb_to_hex(tuple(c // 2 for c in _randcolor()), True)
    #     # else:
    #     color = rgb_to_hex(tuple(c // 2 for c in _hex_to_rgb(hex[0])), True)
    #     rich.print(f"[{color}]{color}")
