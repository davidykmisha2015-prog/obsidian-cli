# obsidian-cli

A minimal and fast CLI tool written in Lua to interact with your Obsidian vault directly from the Linux terminal.

## Features

- Read notes instantly in terminal
- Append text/thoughts on the fly
- Zero heavy dependencies (only Lua runtime required)

## Installation

1. Clone the repository:
```bash
git clone [https://github.com/davidykmisha2015-prog/obsidian-cli.git](https://github.com/davidykmisha2015-prog/obsidian-cli.git)
cd obsidian-cli
```

2. Ensure your vault path is set in `main.lua`:
```lua
local VAULT_PATH = os.getenv("HOME") .. "/Documents/ObsidianVault"
```

3. Make it executable and move to your PATH:
```bash
chmod +x main.lua
mkdir -p ~/.local/bin
cp main.lua ~/.local/bin/ob
```

## Usage

# Read a note
ob read test

# Add text to a note
ob add test "Quick thought from terminal"
