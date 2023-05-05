from xonsh.events import events

_cache = set(globals().keys())
_to_remove = set()

@events.on_postcommand
def _post_command(cmd: str, rtn: int, out: str or None, ts: list):
    global _cache
    if $PYTHON_MODE:
        $TOGGLE_PYTHON_INCR += 1
        if _cache:
            c = set(globals().keys())
            additive_difference = c - _cache
            additive_difference = {item for item in additive_difference if not item.startswith('_')}
            # if additive_difference:
            #     print(f'found {additive_difference}')
            _to_remove.update(additive_difference)
            _cache = c
