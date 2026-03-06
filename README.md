# Clyde User Command Registry

The official user command registry for [Clyde](https://clydecommands.com), a macOS command launcher that acts as an intent dispatcher. It's an app that opens everything.

This repo is the source of truth for all User Commands available at **clydecommands.com/user-commands**. Every merged PR automatically appears on the site. No deployment needed.

---

## What is a user-command?

A user-command is a single JSON file. It contains an array of related commands that Clyde loads from `~/.clyde/user-commands/`.

```json
{
  "id": "obsidian",
  "displayName": "Obsidian",
  "description": "Commands for your Obsidian vaults.",
  "version": "1.0.0",
  "author": "your-github-username",
  "homepage": "https://github.com/ColorfulDots/clyde-registry",
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

That's it. Five fields per command. AI can generate this reliably — try it at [clydecommands.com/generate](https://clydecommands.com/generate).

---

## Registry structure

```
registry/
  official/       ← maintained by the Clyde team
  community/      ← user-submitted (submit your user-command here)
  _template.json  ← copy this to get started
```

**Official** User Commands are maintained by [@ColorfulDots](https://github.com/ColorfulDots). **Community** User Commands are user-submitted and reviewed before merging.

---

## Submit a user-command

### 1. Fork this repo

```
https://github.com/ColorfulDots/clyde-registry
```

### 2. Copy the template

```bash
cp registry/_template.json registry/community/your-user-command-name.json
```

### 3. Fill it in

The `id` field must match the filename exactly:

```
your-user-command-name.json  →  "id": "your-user-command-name"
```

### 4. Validate locally

```bash
node scripts/validate-registry.mjs
```

### 5. Open a pull request

The PR template will walk you through the checklist. CI runs validation automatically.

---

## Schema reference

### User-command fields

| Field         | Required | Type     | Notes                             |
| ------------- | -------- | -------- | --------------------------------- |
| `id`          | ✅       | string   | Must match filename               |
| `displayName` | ✅       | string   | Shown in Clyde and on the website |
| `description` | ✅       | string   | One sentence                      |
| `color`       | ✅       | string   | See colors below                  |
| `icon`        | ✅       | string   | SF Symbol name                    |
| `commands`    | ✅       | array    | At least one                      |
| `version`     | —        | string   | e.g. `"1.0.0"`                    |
| `author`      | —        | string   | Your GitHub username              |
| `homepage`    | —        | string   | Link to your repo or docs         |
| `tags`        | —        | string[] | Categorization tags               |

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

## Shell scripts

For interactive commands — dialogs, file pickers, multi-step flows — use a `.sh` script alongside your JSON:

```
registry/community/
  my-module.json
  scripts/
    my-script.sh
```

Reference it in your command:

```json
{
  "name": "Search Google",
  "keywords": ["search", "google"],
  "executor": "shell",
  "target": "bash ~/.clyde/scripts/my-script.sh",
  "description": "Ask for a query, open in Google"
}
```

Users install the script to `~/.clyde/scripts/` alongside the JSON user-command.

---

## Duplicates and alternatives

Duplicates are allowed and encouraged. A `finance.json` and a `finance-eu.json` can coexist — users pick what fits them. Name variants clearly:

```
finance-uk.json
dev-python.json
productivity-notion.json
```

---

## Security

The following patterns are **automatically blocked** by CI and will fail validation:

- `curl ... | bash` / `wget ... | bash`
- `rm -rf /`
- `dd if=` (disk writes)
- Fork bombs

Shell commands are reviewed manually before merge. Keep targets focused and minimal. Commands that download and execute arbitrary code will be rejected regardless of intent.

---

## Validation

CI runs on every PR touching `registry/community/`. It checks:

- Valid JSON
- All required fields present
- `id` field matches filename
- Valid `color` and `executor` values
- No blocked shell patterns

Run it locally before opening a PR:

```bash
node scripts/validate-registry.mjs
```

---

## Generate a user-command with AI

Not sure how to write the JSON? Describe what you want at [clydecommands.com/generate](https://clydecommands.com/generate) — AI generates it for you. Copy, save, submit.

---

## Installing a user-command locally

```bash
# Download a user-command
curl -o ~/.clyde/user-commands/spotify.json \
  https://raw.githubusercontent.com/ColorfulDots/clyde-registry/main/registry/official/spotify.json

# Then in Clyde
reload user-commands
```

Or browse and download at [clydecommands.com/user-commands](https://clydecommands.com/user-commands).

---

## License

MIT — [Colorful Dots, LLC](https://github.com/ColorfulDots)
