#!/usr/bin/env zsh
# Headroom-based token savers. Sourced from ~/.zshrc via ~/.token_savers.
# Manages the local headroom proxy and tooling so codex/cursor route through it.

# PATH: pick up ~/bin (where headroom-proxy script lives via dotfiles symlink)
case ":$PATH:" in *":$HOME/bin:"*) ;; *) export PATH="$HOME/bin:$PATH" ;; esac

# CA bundle for uv-managed Python (headroom tools install, etc.)
export SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
export REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# NOTE: cursor agent talks to api2.cursor.sh / cursor.com, NOT to OpenAI directly.
# Setting OPENAI_BASE_URL would not route cursor through the proxy and could
# mis-route unrelated OpenAI-SDK scripts. Keep it unset by default. Tools that
# DO honor OPENAI_BASE_URL (ad-hoc scripts, codex without its own config) can
# opt in per-shell:
#   export OPENAI_BASE_URL="http://127.0.0.1:8787/v1"

# Auto-start proxy if not running. Idempotent; no-op when already up.
if command -v headroom-proxy >/dev/null 2>&1; then
  pgrep -f "headroom proxy" >/dev/null 2>&1 || headroom-proxy start >/dev/null
fi

# Wrappers: proxy is always-on, so no per-call startup needed.
# codex reads ~/.codex/config.toml which already points at the proxy.
unalias hcodex 2>/dev/null || true
hcodex() { HEADROOM_PROJECT="${HEADROOM_PROJECT:-${PWD:t}}" codex "$@"; }

# hagent kept as a thin pass-through; cursor agent cannot be routed via OPENAI_BASE_URL.
unalias hagent 2>/dev/null || true
hagent() { HEADROOM_PROJECT="${HEADROOM_PROJECT:-${PWD:t}}" cursor agent "$@"; }

# Quick stats peeks.
hr-stats() { curl -sS "http://127.0.0.1:${HEADROOM_PORT:-8787}/stats" | jq .summary; }
hr-savings() { curl -sS "http://127.0.0.1:${HEADROOM_PORT:-8787}/stats" | jq "{session: .display_session, total_tokens_saved: .savings.total_tokens, per_project: .savings.per_project}"; }
