<p align="center">
🐚 Rit's Xonsh-RC
</p>

<p align="center">
If you like my <code>xonsh-rc</code> file, click the ⭐ on the repo.
</p>

# Hello 👋🏽

I've been a `xonsh` user for nearly 3 years now and have developed my `.xonshrc` file and setup over that time, adding various tweaks and quirks.

As I started to optimize, I realized my setup is a bit jank and hard to replicate which led me to [xontrib-rc-awesome](https://github.com/anki-code/xontrib-rc-awesome).


## Setup

Generally, I follow these steps when setting up xonsh (and my python).

I use [brew](brew.sh) as my MacOS package manager and [pyenv](https://github.com/pyenv/pyenv) to help manage my multitude of python versions.

> *Note*: I want to explore the [rtx](https://github.com/jdxcode/rtx#comparison-to-asdf) project as an alternative, but haven't gotten around to it yet!

```bash
brew install pyenv

pyenv install <latest-python>
pyenv global <latest-python>
```

I use `pipx` to help manage my python tools and apps!

```bash
brew install pipx

pipx install poetry
pipx install "xonsh[full]"
```

Lastly, I change my favorite terminals to use my `xonsh` executable on start-up! I use `xpip` to help install more things into my `xonsh` environment. Note `pipx inject xonsh <deps>` works as well.

Other dependencies..

```bash
brew install starship
brew install zoxide
```

Finally, to load my `rc`:

```bash
xpip install -U "git+https://github.com/RitikShah/xonsh-rc"
echo 'xontrib load rc_yourname' >> ~/.xonshrc
xonsh  # or close and reopen
```

🎉 Welcome to **`xonsh`** 🎉

## Structure

My entrypoint is `rc.xsh`, which I try to keep as *light* as possible.

I then source everything within my mods folder kinda like an extension. These are loaded async which means my prompt may load before every extension is loaded!


## FAQ

> What is [xonsh](xon.sh)?

Xonsh is a python-bash hybrid shell-alternative. It is python-based with a warm and friendly community, with lots to explore.

> Why do I use xonsh?

Xonsh lets me use my shell with my most comfortable language, Python. Rather than stumbling through bash commands, I can confidently write python to fufill my daily shell needs. I also can tinker and add fancy or useful new features in python as well, which lets me personalize my execution environment.

*If you have heard of unix or android ricing, `xonsh` is my form of "shell ricing"* 

> But my shell is cool too!

It probably is and also could have cooler features than mine. This is just the shell *I* use!

> I'm curious, but what's the catch?

*In Python-land, speed is no fair maiden.*

Xonsh does startup a bit slower than your favorite shell. While, this *is* due to using python, it's also due to the amount of bloat we casually add to our rc-files (which is not exclusive to `xonsh`).

The slowdown isn't that determintal to my workflow and once loaded, you feel no different 🙂.

Xonsh also isn't purely bash-compatible, even much less so than [zsh](https://zsh.sourceforge.io/) and [fish](https://fishshell.com/). While I do think 100% bash-compatibility isn't *that* useful in my daily shell, it might be for you.
