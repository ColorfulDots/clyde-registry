# Contributing to the Clyde Registry

The registry contains two types of contributions: **user-commands** (JSON) and **user-scripts** (shell scripts).

User-commands are loaded by Clyde from `~/.clyde/user-commands/`.
User-scripts are installed at `~/.clyde/user-scripts/`.

Because commands are simple JSON, anyone can contribute one. No coding required. Scripts require basic shell knowledge.

---

## Folder structure

```
official/
  user-commands/    ← JSON command modules
  user-scripts/     ← shell scripts
_template.json
_template.sh
```

---

## How to submit a user-command

1. Fork [github.com/ColorfulDots/clyde-registry](https://github.com/ColorfulDots/clyde-registry)
2. Copy `_template.json` into `official/user-commands/`
3. Rename it to match your module (e.g. `my-tools.json`)
4. Fill it in — see the schema below
5. Open a pull request

## How to submit a user-script

1. Fork [github.com/ColorfulDots/clyde-registry](https://github.com/ColorfulDots/clyde-registry)
2. Copy `_template.sh` into `official/user-scripts/`
3. Rename it to match your script (e.g. `my-script.sh`)
4. Fill it in — keep it focused and safe
5. Open a pull request

PRs are reviewed by the Clyde team. Once approved and merged, your contribution appears in the registry.

---

## User-command schema

```json
{
  "id": "my-module",
  "displayName": "My Module",
  "description": "Commands for doing useful things.",
  "version": "1.0.0",
  "author": "your-github-username",
  "homepage": "https://example.com",
  "registry": "https://github.com/ColorfulDots/clyde-registry",
  "appStore": "https://apps.apple.com/app/my-app/id000000000",
  "color": "blue",
  "icon": "star",
  "tags": ["productivity"],
  "commands": [
    {
      "name": "Open Something",
      "keywords": ["something", "open"],
      "executor": "urlScheme",
      "target": "https://example.com",
      "description": "Opens example.com"
    }
  ]
}
```

### Required fields

| Field | Type | Notes |
|---|---|---|
| `id` | string | Must match the filename (e.g. `finance.json` → `"id": "finance"`) |
| `displayName` | string | Human-readable name shown in Clyde |
| `description` | string | One sentence describing the module |
| `color` | string | One of: `blue green orange red purple teal yellow gray indigo cyan` |
| `icon` | string | SF Symbol name (e.g. `star`, `globe`, `terminal.fill`) |
| `tags` | string[] | Array of category tags (e.g. `["developer", "productivity"]`) |
| `commands` | array | At least one command |

### Optional fields

| Field | Type | Notes |
|---|---|---|
| `author` | string | Your GitHub username |
| `homepage` | string | The service or tool's own website |
| `registry` | string | Link back to this registry repo |
| `appStore` | string | Mac App Store URL, or `null` if not available |
| `version` | string | Semver string, e.g. `"1.0.0"` |

### Command fields

| Field | Type | Notes |
|---|---|---|
| `name` | string | Shown in Clyde's results list |
| `keywords` | string[] | Words that trigger this command |
| `executor` | string | See executor types below |
| `target` | string | What to run — URL, shell command, AppleScript, or shortcut name |
| `description` | string | One sentence shown as a subtitle |

### Executor types

| Executor | Target format | Example |
|---|---|---|
| `urlScheme` | Full URL or deep link | `https://github.com`, `obsidian://daily` |
| `shell` | Shell command string | `open -a Terminal`, `kill -9 $(lsof -ti:3000)` |
| `applescript` | AppleScript source | `tell application "Finder" to empty trash` |
| `shortcut` | Shortcuts.app shortcut name | `My Morning Routine` |

---

## User-script guidelines

- Use `#!/bin/bash` as the shebang
- Include the header block from `_template.sh`
- Accept arguments where it makes sense — document usage in the header
- Keep scripts focused on a single task

---

## Security rules

Shell and AppleScript commands are powerful. The following patterns are **automatically rejected** by CI:

- `curl ... | bash` or `wget ... | bash`
- `rm -rf /`
- `dd if=` (disk writes)
- Fork bombs

Commands that download and execute arbitrary code will be rejected regardless of intent.

---

## Validation

CI runs automatically on every PR. You can run it locally:

```bash
node validate.mjs
```

---

## Review

PRs are reviewed for:
- Schema correctness (caught by CI)
- Security (no destructive commands)
- Usefulness (does it do something real?)

We don't moderate taste. If it works and it's safe, it ships.
