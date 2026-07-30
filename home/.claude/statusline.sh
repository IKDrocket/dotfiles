#!/bin/bash
input=$(cat)

# ── Color helpers ──────────────────────────────────────────────────────────
GREEN='\e[38;2;151;201;195m'
YELLOW='\e[38;2;229;192;123m'
RED='\e[38;2;224;108;117m'
GRAY='\e[38;2;74;88;92m'
RESET='\e[0m'
DIM='\e[2m'

color_for_pct() {
    local pct=$1
    if [ "$pct" -ge 80 ]; then echo -n "$RED"
    elif [ "$pct" -ge 50 ]; then echo -n "$YELLOW"
    else echo -n "$GREEN"
    fi
}

format_tokens() {
    local tokens=$1
    if [ "$tokens" -ge 1000000 ] 2>/dev/null; then
        awk "BEGIN{printf \"%.0fM\", $tokens / 1000000}"
    elif [ "$tokens" -ge 1000 ] 2>/dev/null; then
        awk "BEGIN{printf \"%.0fK\", $tokens / 1000}"
    else
        echo -n "$tokens"
    fi
}

progress_bar() {
    local pct=$1
    local filled=$((pct / 10))
    local bar=""
    for i in $(seq 1 10); do
        if [ "$i" -le "$filled" ]; then bar="${bar}▰"
        else bar="${bar}▱"
        fi
    done
    echo -n "$bar"
}

# ── Parse stdin ────────────────────────────────────────────────────────────
MODEL=$(echo "$input" | jq -r '.model.display_name // "-"')
CONTEXT_SIZE=$(echo "$input" | jq -r '.context_window.context_window_size // 0')
CWD=$(echo "$input" | jq -r '.cwd // "."')
CTX_PCT=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | awk '{printf "%d", $1}')
CURRENT=$(echo "$input" | jq -r 'if .context_window.current_usage then .context_window.current_usage | .input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens else 0 end')

# Git diff stats (session-only)
ADDED=$(echo "$input" | jq -r '.cost.total_lines_added // 0' 2>/dev/null)
REMOVED=$(echo "$input" | jq -r '.cost.total_lines_removed // 0' 2>/dev/null)
[ -z "$ADDED" ] && ADDED=0
[ -z "$REMOVED" ] && REMOVED=0

# Branch
BRANCH=$(echo "$input" | jq -r '.git.branch // empty' 2>/dev/null)
if [ -z "$BRANCH" ]; then
    BRANCH=$(git -C "$CWD" branch --show-current 2>/dev/null || echo "-")
    [ -z "$BRANCH" ] && BRANCH="-"
fi

TOTAL_COST=$(echo "$input" | jq -r '.cost.total_cost_usd // empty' 2>/dev/null)
RL5H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
RL7D=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# ── Line 1 ─────────────────────────────────────────────────────────────────
CTX_COLOR=$(color_for_pct "$CTX_PCT")
printf "🤖 ${CTX_COLOR}%s${RESET} ${GRAY}│${RESET} 📊 ${CTX_COLOR}%s%%${RESET} ${GRAY}│${RESET} ✏️ ${CTX_COLOR}+%s/-%s${RESET} ${GRAY}│${RESET} 🔀 ${CTX_COLOR}%s${RESET}\n" \
    "$MODEL" "$CTX_PCT" "$ADDED" "$REMOVED" "$BRANCH"

# ── Line 2 ─────────────────────────────────────────────────────────────────
CTX_BAR=$(progress_bar "$CTX_PCT")
CTX_SIZE_DISPLAY=$(format_tokens "$CONTEXT_SIZE")
USED_DISPLAY=$(format_tokens "${CURRENT:-0}")
printf "${CTX_COLOR}📐 CTX  %s  %s%%${RESET}" "$CTX_BAR" "$CTX_PCT"
if [ "$CONTEXT_SIZE" != "0" ] && [ "$CONTEXT_SIZE" != "null" ]; then
    printf "  ${DIM}%s / %s tokens${RESET}" "$USED_DISPLAY" "$CTX_SIZE_DISPLAY"
fi
printf "\n"

# ── Line 3 ─────────────────────────────────────────────────────────────────
if [ -n "$TOTAL_COST" ] && [ "$TOTAL_COST" != "0" ]; then
    COST_DISPLAY=$(awk "BEGIN{printf \"\$%.2f\", $TOTAL_COST}" 2>/dev/null)
    printf "${GREEN}💰 %s${RESET}" "$COST_DISPLAY"
else
    printf "${DIM}💰 --${RESET}"
fi
if [ -n "$RL5H" ] || [ -n "$RL7D" ]; then
    [ -n "$RL5H" ] && printf "  ${GRAY}│${RESET} ⏱ ${YELLOW}5h: %d%%${RESET}" "$RL5H"
    [ -n "$RL7D" ] && printf "  ${GRAY}│${RESET} 📅 ${YELLOW}7d: %d%%${RESET}" "$RL7D"
fi
printf "\n"
