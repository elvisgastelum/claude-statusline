#!/usr/bin/env bash
# Installs the claude-statusline script and registers it in Claude Code settings.
# Usage: curl -fsSL https://raw.githubusercontent.com/elvisgastelum/claude-statusline/main/install.sh | bash
set -euo pipefail

REPO_RAW="${CLAUDE_STATUSLINE_RAW_URL:-https://raw.githubusercontent.com/elvisgastelum/claude-statusline/main}"
CLAUDE_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
TARGET="$CLAUDE_DIR/statusline.sh"
SETTINGS="$CLAUDE_DIR/settings.json"

info() { printf '\033[36m==>\033[0m %s\n' "$1"; }
fail() { printf '\033[31merror:\033[0m %s\n' "$1" >&2; exit 1; }

command -v jq >/dev/null 2>&1 || fail "jq is required (macOS: brew install jq, Debian/Ubuntu: sudo apt install jq)"
command -v curl >/dev/null 2>&1 || fail "curl is required"

mkdir -p "$CLAUDE_DIR"

info "Downloading statusline to $TARGET"
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
curl -fsSL "$REPO_RAW/statusline.sh" -o "$tmp" || fail "could not download $REPO_RAW/statusline.sh"
[ -f "$TARGET" ] && cp "$TARGET" "$TARGET.bak"
mv "$tmp" "$TARGET"
chmod +x "$TARGET"

info "Registering statusLine in $SETTINGS"
[ -s "$SETTINGS" ] || echo '{}' > "$SETTINGS"
jq empty "$SETTINGS" 2>/dev/null || fail "$SETTINGS is not valid JSON; fix it and re-run"
cp "$SETTINGS" "$SETTINGS.bak"
updated=$(mktemp)
jq --arg cmd "bash $TARGET" '.statusLine = {type: "command", command: $cmd}' "$SETTINGS" > "$updated"
mv "$updated" "$SETTINGS"

info "Done. Restart Claude Code to see the new status line (backup: $SETTINGS.bak)"
