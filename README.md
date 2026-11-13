# mPursa dotfiles configuration

Dotfiles linked into `~` with [GNU Stow](https://www.gnu.org/software/stow/).

| Package                      | What                                                  | Machines    |
| ---------------------------- | ----------------------------------------------------- | ----------- |
| `nvim`, `tmux`               | Neovim, tmux                                          | all         |
| `shell`                      | aliases and environment shared by zsh and bash        | all         |
| `zsh` / `bash`               | shell startup files                                   | Mac / Linux |
| `git/shared`                 | Git config, global ignore, allowed signers            | all         |
| `git/asm` / `git/mpursa`     | Git name, email and commit signing: work / personal   | one each    |
| `ssh`                        | SSH client config, no keys                            | all         |
| `starship`, `ripgrep`, `bat` | prompt, search, `cat`                                 | all         |
| `btop`                       | system monitor                                        | all         |
| `yazi`                       | file manager                                          | all         |
| `tealdeer`                   | `tldr` pages, updated automatically                   | all         |
| `bin`                        | scripts for `~/.local/bin`, such as `dotfiles-update` | all         |
| `ghostty`                    | Ghostty settings                                      | Mac / Linux |
| `karabiner`                  | Karabiner rules: Linux-style Ctrl, Alt+Tab            | Mac         |
| `tools`                      | installers for the tools above (not stowed)           | —           |

Settings for one machine only go in untracked `.local` files, which load last so they win: `~/.zshrc.local` or `~/.bashrc.local`, `~/.config/git/config.local`, `~/.ssh/config.local`, `~/.tmux.conf.local`, `~/.config/nvim/init.local.lua` and `~/.config/ghostty/config.ghostty.local`.

## Install

1. **Clone** to `~/dotfiles`, where `dotfiles-update` expects it. On a fresh Debian, Fedora or Arch, install `git` first.

   ```bash
   git clone git@github.com:mpursa/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

   The same repo is on Forgejo: `https://git.mpursa.com/mpursa/dotfiles.git`.

   **Quick setup:** `./setup` does steps 2 to 4 for you (Mac, Bazzite, Debian, Fedora, Arch), installing Homebrew first on a Mac that lacks it. Add `--optional` for the optional tools too. It moves a stock `~/.gitconfig` and `~/.zshrc` or `~/.bashrc` aside as `.bak`, and lists what's left to do by hand at the end. The steps below are what it runs.

2. **Tools:**
   - Mac or Bazzite, with [Homebrew](https://brew.sh): `brew bundle --file=tools/Brewfile`, then `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`; on Bazzite also [ble.sh](https://github.com/akinomyoga/ble.sh) (the three lines in `setup`)
   - Debian: `tools/debian.sh`
   - Fedora: `tools/fedora.sh`
   - Arch: `tools/arch.sh`
   - Optional, only where needed (VS Code): `brew bundle --file=tools/optional/Brewfile` on the Mac, `tools/optional/debian.sh`, `fedora.sh` or `arch.sh` on Linux

3. **Link** the dotfiles. Move `~/.gitconfig` aside first: Git reads it after the config in this repo, so its values would win.

   ```bash
   test -f ~/.gitconfig && mv ~/.gitconfig ~/.gitconfig.bak
   ./install            # detects the OS; ./install mac or ./install linux to choose
   ./install --git=asm  # git identity: a folder in git/, default mpursa
   ```

   The identity sticks: later runs, and `dotfiles-update`, keep the one already linked until you pass another `--git=`. `./setup` takes `--git=` too.

   Stow never overwrites a real file. If `./install` stops and names one, move that file aside (`mv ~/.bashrc ~/.bashrc.bak`) and run it again.

4. **Finish:**
   - Open a new terminal.
   - In tmux, press `Ctrl-a` then `I` (capital i) to install the plugins.
   - On a Mac, turn on the Karabiner rules: in Karabiner-Elements, open Complex Modifications, then Add predefined rule, and click Enable All under "Windows-style Ctrl".
   - Add the machine's key to the allowed signers, so Git can verify the commits it signs, then commit the change:

     ```bash
     echo "$(git config user.email) namespaces=\"git\" $(cat ~/.ssh/id_ed25519.pub)" >> git/shared/.config/git/allowed_signers
     ```

## Update

```bash
dotfiles-update
```

It pulls the repo (`git pull --ff-only`) and runs `./install`, which relinks every package and picks up new files. Open a new terminal for shell changes. `./install` is safe to run at any time, for example after adding a file to a package.

`dotfiles-update` doesn't install tools. When an update adds one to `tools/`, run the installer from step 2 again; it's safe to repeat.

To add a package, create its folder with the paths as they are under `~`, add its name to `common` (or to the `mac` or `linux` line) in `install`, and run `./install`.
