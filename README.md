# claude-statusline

A compact [Claude Code](https://claude.com/claude-code) status line, styled after zap-prompt.

```
⚡➜ my-project (* main) | Opus 5.5 | ctx 42% | 5h:12% 7d:30%
```

It shows:

- current directory name
- git branch, with a red `*` when the working tree is dirty
- active model
- context window usage
- 5-hour and 7-day rate-limit usage (when available)

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/elvisgastelum/claude-statusline/main/install.sh | bash
```

Then restart Claude Code.

The installer:

1. downloads `statusline.sh` to `~/.claude/statusline.sh`
2. sets `statusLine` in `~/.claude/settings.json` to run it
3. backs up any previous files as `*.bak`

It respects `CLAUDE_CONFIG_DIR` if you use a non-default config directory.

### Requirements

- `bash`, `curl`, `git`
- [`jq`](https://jqlang.org/) — `brew install jq` or `sudo apt install jq`

## Uninstall

```bash
jq 'del(.statusLine)' ~/.claude/settings.json > /tmp/s.json && mv /tmp/s.json ~/.claude/settings.json
rm ~/.claude/statusline.sh
```

## Customize

Edit `~/.claude/statusline.sh`. Claude Code pipes a JSON payload to the script on stdin; see the
[status line docs](https://docs.claude.com/en/docs/claude-code/statusline) for the available fields.
