# VS Code

## VS Code Workspace

When you open the FeatherCMS workspace folder in VS Code for the first time,
it may open more slowly because `"swift.searchSubfoldersForPackages": true`
searches for Swift packages in subfolders. This is expected.

## VS Code Keybindings

You can add the FeatherCMS shortcuts to VS Code's `keybindings.json` file:

1. Press `Cmd+Shift+P` to open the Command Palette.
2. Search for and select `Preferences: Open Keyboard Shortcuts (JSON)`.
3. Add these entries inside the JSON array:

```json
[
{
  "key": "cmd+ctrl+r",
  "command": "workbench.action.debug.selectandstart"
},
{
  "key": "cmd+ctrl+i",
  "command": "workbench.action.tasks.runTask",
  "args": "Ensure Local Dependencies"
},
{
  "key": "cmd+ctrl+.",
  "command": "workbench.action.debug.stop",
  "when": "inDebugMode"
},
{
  "key": "cmd+ctrl+s",
  "command": "workbench.action.tasks.runTask",
  "args": "FeatherCMS: Stop Local Runtime and Free Ports"
},
{
  "key": "cmd+ctrl+o",
  "command": "workbench.action.tasks.runTask",
  "args": "FeatherCMS: Open FeatherCMS"
}
]
```

### Development Workflow

**Before running the application, run `Ensure Local Dependencies` first. Run it only once per development session to avoid errors.**

- `cmd+ctrl+i` — Run `Ensure Local Dependencies` once per session.
- `cmd+ctrl+r` — Select and start the debug session, such as `Debug Server + Worker + WebApp + WebStatic`.
- `cmd+ctrl+o` — Open FeatherCMS in the browser.
- `cmd+ctrl+.` — Stop the debug session while in debug mode.
- `cmd+ctrl+s` — Stop the FeatherCMS local runtime and free the ports for other applications. Run this when you finish the development session.

### Test Explorer

Run module and backend tests from VS Code's Test Explorer.
