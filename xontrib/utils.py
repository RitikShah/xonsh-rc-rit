import os
from collections.abc import Callable
from contextlib import suppress
from itertools import count
from time import perf_counter as perf
from typing import Generator

__all__ = ["yieldify", "_time_iterable"]

indents = 0

def timing(title: str, t0: float, t1: float):
    delta = 1000 * (t1-t0)
    print(" " * indents, f"{title}: {delta: 0.2f}ms", sep="")

    return delta

def yieldify(func: Callable[[], Generator[str | None, None, None]]):
    out = func()
    list(out) if out is not None else ""
    return
    global indents
    indents += 2

    def _wrapper():
        gen, counter, t0 = func(), (f"Timings {i}" for i in count()), perf()

        if gen is None:
            return

        for title in gen:
            yield timing(title or next(counter), t0, perf())
            t0 = perf()

        yield timing(title or next(counter), t0, perf())

    total = sum(_wrapper())
    indents -= 2
    print(" " * indents, f"total: {total: 0.2f}ms", sep="")


def aliasify(name_or_func):
    global aliases

    def decorator(func):
        aliases[name] = func
    
    match name_or_func:
        case str(name):
            return decorator

        case func:
            aliases[func.__name__] = func
