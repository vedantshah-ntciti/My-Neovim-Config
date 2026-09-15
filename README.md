# My Neovim Config

Personal Neovim setup. This README covers how to get a fresh machine (Ubuntu)
ready to run this config from scratch.

## Prerequisites

Before installing this config, make sure the following are set up.

### 1. Neovim (Ubuntu)

Install the latest stable release via the official tarball:

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

Then add this to your shell config (`~/.bashrc`, `~/.zshrc`, …):

```bash
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
```

Reload your shell and verify:

```bash
source ~/.bashrc   # or ~/.zshrc
nvim --version
```

### 2. ripgrep

Used for fast in-editor searching (e.g. Telescope live grep).

```bash
sudo apt install ripgrep -y
rg --version
```

### 3. Node.js + npm (via nvm)

Needed for several LSP servers and tools that run on Node.

Install [nvm](https://github.com/nvm-sh/nvm):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```

Reload your shell, then:

```bash
source ~/.bashrc   # or ~/.zshrc
nvm install --lts
nvm use --lts
node -v
npm -v
```

> Check the [nvm releases page](https://github.com/nvm-sh/nvm/releases) for
> the latest install script version before running the command above.

### 4. Tree-sitter CLI

Needed for parsing/highlighting via `nvim-treesitter`. Installed via `cargo`
(Rust's package manager), not npm.

If you don't have Rust/cargo installed yet:

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
cargo --version
```

Then install tree-sitter CLI:

```bash
cargo install tree-sitter-cli
tree-sitter --version
```

### 5. Clipboard support (Ubuntu)

Neovim needs a clipboard provider to sync yanks/pastes with the system
clipboard (`"+y`, `"+p`). Which one you need depends on whether your
session is running X11 or Wayland.

**Check which display server you're running:**

```bash
echo $XDG_SESSION_TYPE
```

This prints either `x11` or `wayland`. Alternatively:

```bash
loginctl show-session $(loginctl | grep $(whoami) | awk '{print $1}') -p Type
```

- **X11:**
  ```bash
  sudo apt install xclip -y
  ```
- **Wayland:**
  ```bash
  sudo apt install wl-clipboard -y
  ```

If you're unsure or switch between the two, it's safe to install both —
Neovim will auto-detect and use whichever one matches your session.

**Check it's working:**

1. Verify the clipboard tool itself is installed and on PATH:
   ```bash
   which xclip       # X11
   which wl-copy      # Wayland
   ```
   Each should print a path (e.g. `/usr/bin/xclip`). No output means it's
   not installed or not on PATH.

2. Verify Neovim detects it:
   ```bash
   nvim -c 'checkhealth provider'
   ```
   Look for the clipboard section — it should report a working provider
   (`xclip` or `wl-copy`/`wl-paste`), not "clipboard tool not found."

3. Functional test inside Neovim:
   - Open any file, yank a line with `"+yy`
   - Paste into another app (browser, terminal, etc.) — it should appear
   - Copy some text externally, then paste into Neovim with `"+p`

If step 3 fails but step 2 shows a provider, double check you're on the
right session type (`echo $XDG_SESSION_TYPE` — should say `x11` or
`wayland`) and that the matching tool is installed for that session.

## Installation of config

```bash
git clone https://github.com/vedantshah-ntciti/My-Neovim-Config.git ~/.config/nvim
nvim
```

On first launch, the plugin manager should bootstrap itself and install all
configured plugins. Run `:checkhealth` afterward to confirm everything is
wired up correctly.

## Post-install checklist

- [ ] `:checkhealth` shows no critical errors
- [ ] Clipboard yank/paste works across apps (`"+y` then paste outside nvim)
- [ ] Fuzzy search / live grep works (tests ripgrep integration)
- [ ] READ the remaps, sets. Also read the lsp files, and treesitter files, as you may have to manually added parsers, and lsp for requirements.

## Notes

- If switching machines/accounts, re-run the Prerequisites section — none of
  this is bundled with the dotfiles themselves.
- `nvm` is per-shell-profile; if you use multiple shells (bash/zsh), make
  sure the `nvm` init lines are in both.
