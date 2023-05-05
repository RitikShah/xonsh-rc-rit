from xonsh.built_ins import XSH

ctx = XSH.ctx
rtx_init = $(rtx activate xonsh)

XSH.builtins.execx(rtx_init, 'exec', ctx, filename='rtx')
