from xontrib.utils import yieldify

@yieldify
def main():
    import xonsh

    execx($(zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')

    yield "zoxide init"
