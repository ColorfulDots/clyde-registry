# Clyde Registry

The official registry for [Clyde](https://clydecommands.com), a macOS command launcher that acts as an intent dispatcher. It's an app that opens everything.

This repo is the source of truth for all user-commands and user-scripts available at **clydecommands.com/registry**. Every merged PR automatically appears on the site.

---

## What is a user-command?

A user-command is a single JSON file containing an array of related commands that Clyde loads from `~/.clyde/user-commands/`.

```json
{
  "id": "obsidian",
  "displayName": "Obsidian",
  "description": "Commands for your Obsidian vaults.",
  "version": "1.0.0",
  "author": "your-github-username",
  "homepage": "https://obsidian.md",
  "registry": "https://github.com/ColorfulDots/clyde-registry",
  "appStore": null,
  "color": "purple",
  "icon": "note.text",
  "tags": ["productivity", "notes"],
  "commands": [
    {
      "name": "Open Daily Journal",
      "keywords": ["journal", "daily", "obsidian"],
      "executor": "urlScheme",
      "target": "obsidian://daily",
      "description": "Open today's daily note in Obsidian"
    }
  ]
}
```

AI can generate this reliably — try it at [clydecommands.com/generate](https://clydecommands.com/generate).

---

## What is a user-script?

A user-script is a shell script installed at `~/.clyde/user-scripts/`. Use scripts for interactive commands, multi-step flows, or anything that needs more than a single shell one-liner.

---

## Registry structure

```
official/
  user-commands/    ← JSON command modules
  user-scripts/     ← shell scripts
_template.json
_template.sh
```

All contributions go through a PR. Once approved and merged by the Clyde team, they appear in the registry.

---

## Submit a user-command

### 1. Fork this repo

```
https://github.com/ColorfulDots/clyde-registry
```

### 2. Copy the template

```bash
cp _template.json official/user-commands/your-module-name.json
```

### 3. Fill it in

The `id` field must match the filename exactly:

```
your-module-name.json  →  "id": "your-module-name"
```

### 4. Validate locally

```bash
node validate.mjs
```

### 5. Open a pull request

CI runs validation automatically. The PR template will walk you through the checklist.

---

## Submit a user-script

```bash
cp _template.sh official/user-scripts/your-script-name.sh
```

Fill in the header block and your script logic, then open a pull request.

---

## Schema reference

### User-command fields

| Field         | Required | Type     | Notes                                          |
| ------------- | -------- | -------- | ---------------------------------------------- |
| `id`          | ✅       | string   | Must match filename                            |
| `displayName` | ✅       | string   | Shown in Clyde and on the website              |
| `description` | ✅       | string   | One sentence                                   |
| `color`       | ✅       | string   | See colors below                               |
| `icon`        | ✅       | string   | SF Symbol name (e.g. `star`, `globe`)          |
| `tags`        | ✅       | string[] | Category tags (e.g. `["developer", "productivity"]`) |
| `commands`    | ✅       | array    | At least one                                   |
| `version`     | —        | string   | e.g. `"1.0.0"`                                 |
| `author`      | —        | string   | Your GitHub username                           |
| `homepage`    | —        | string   | The service or tool's own website              |
| `registry`    | —        | string   | Link back to this registry repo                |
| `appStore`    | —        | string   | Mac App Store URL, or `null` if not available  |

### Command fields

| Field         | Required | Type     | Notes                           |
| ------------- | -------- | -------- | ------------------------------- |
| `name`        | ✅       | string   | Shown in Clyde's results list   |
| `keywords`    | ✅       | string[] | Words that trigger this command |
| `executor`    | ✅       | string   | See executor types below        |
| `target`      | ✅       | string   | What to run                     |
| `description` | ✅       | string   | One sentence subtitle           |

### Executor types

| Executor      | What it does                          | Example target                                 |
| ------------- | ------------------------------------- | ---------------------------------------------- |
| `urlScheme`   | Opens a URL or deep link              | `https://github.com`, `obsidian://daily`       |
| `shell`       | Runs a shell command                  | `open -a Terminal`, `kill -9 $(lsof -ti:3000)` |
| `applescript` | Runs AppleScript source               | `tell application "Finder" to empty trash`     |
| `shortcut`    | Runs a Shortcuts.app shortcut by name | `My Morning Routine`                           |

### Colors

`blue` `green` `orange` `red` `purple` `teal` `yellow` `gray` `indigo` `cyan`

---

## Security

The following patterns are **automatically blocked** by CI:

- `curl ... | bash` / `wget ... | bash`
- `rm -rf /`
- `dd if=` (disk writes)
- Fork bombs

Commands that download and execute arbitrary code will be rejected regardless of intent.

---

## Installing a user-command locally

```bash
curl -o ~/.clyde/user-commands/spotify.json \
  https://raw.githubusercontent.com/ColorfulDots/clyde-registry/main/official/user-commands/spotify.json
```

Or browse and install at [clydecommands.com/registry](https://clydecommands.com/registry).

---

## Generate with AI

Describe what you want at [clydecommands.com/generate](https://clydecommands.com/generate) — AI generates the JSON for you. Copy, save, submit.

---

## License

MIT — [Colorful Dots, LLC](https://github.com/ColorfulDots)
