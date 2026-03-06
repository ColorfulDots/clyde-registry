# Contributing to the Clyde Command Registry

The registry is a collection of JSON files. Each file is a user-command — a named group of commands that Clyde loads from `~/.clyde/user-commands/`.

Because commands are simple JSON, anyone can contribute one. No coding required.

---

## How to submit a user-command

1. Fork [github.com/ColorfulDots/clyde-registry](https://github.com/ColorfulDots/clyde-registry)
2. Copy `public/registry/_template.json` into `public/registry/community/`
3. Rename it to match your user-command name (e.g. `my-tools.json`)
4. Fill it in — see the schema below
5. Open a pull request

That's it. The PR template will walk you through the checklist.

---

## Folder structure

```
public/registry/
  official/     ← maintained by the Clyde team
  community/    ← user-submitted user-commands (submit here)
  _template.json
```

---

## User-command schema

```json
{
  "id": "my-module",
  "displayName": "My Module",
  "description": "Commands for doing useful things.",
  "color": "blue",
  "author": "your-github-username",
  "homepage": "https://github.com/ColorfulDots/clyde-registry",
  "version": "1.0",
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
| `description` | string | One sentence describing the user-command |
| `color` | string | One of: `blue green orange red purple teal yellow gray indigo cyan` |
| `commands` | array | At least one command |

### Optional fields

| Field | Type | Notes |
|---|---|---|
| `author` | string | Your GitHub username |
| `homepage` | string | Link to your repo or docs |
| `version` | string | Semver string, e.g. `"1.0"` |

### Command fields

| Field | Type | Notes |
|---|---|---|
| `name` | string | Shown in Clyde's results list |
| `keywords` | string[] | Words that trigger this command |
| `executor` | string | See executor types below |
| `target` | string | What to run — URL, shell command, script, or shortcut name |
| `description` | string | One sentence shown as a subtitle |

### Executor types

| Executor | Target format | Example |
|---|---|---|
| `urlScheme` | Full URL or deep link | `https://github.com`, `obsidian://daily` |
| `shell` | Shell command string | `open -a Terminal`, `kill -9 $(lsof -ti:3000)` |
| `applescript` | AppleScript source | `tell application "Finder" to empty trash` |
| `shortcut` | Shortcuts.app shortcut name | `My Morning Routine` |

---

## Duplicates and alternatives

Duplicates are allowed. A `finance.json` and a `finance-eu.json` can coexist — users pick what fits them. If your user-command is a regional or personal variant of an existing one, name it clearly (e.g. `finance-uk.json`, `dev-python.json`).

---

## Security rules

Shell and AppleScript commands are powerful. The following patterns are **automatically rejected** by CI:

- `curl ... | bash` or `wget ... | bash`
- `rm -rf /`
- `dd if=` (disk writes)
- Fork bombs

Commands that download and execute arbitrary code will be rejected regardless of intent. Keep targets focused and minimal.

---

## Validation

CI runs automatically on every PR touching `public/registry/community/`. You can run it locally:

```bash
node scripts/validate-registry.mjs
```

Fix any errors before opening your PR.

---

## Review

PRs are reviewed for:
- Schema correctness (caught by CI)
- Security (no destructive commands)
- Usefulness (does it do something real?)

We don't moderate taste. If it works and it's safe, it ships.
