#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="$DOTFILES_DIR/claude/skills-manifest.txt"
# Claude Code は ~/.claude/skills/<name>/SKILL.md の1階層のみをスキャンするため、
# サブディレクトリではなく claude/skills/ 直下にインストールする（.gitignore で個別に無視）
SKILLS_DIR="$DOTFILES_DIR/claude/skills"

if ! command -v gh &>/dev/null; then
  echo "==> gh CLI not found. Install gh and re-run." >&2
  exit 1
fi

mkdir -p "$SKILLS_DIR"

echo "==> Syncing external Claude Code skills..."
while IFS=' ' read -r repo skill path_in_repo || [[ -n "$repo" ]]; do
  [[ "$repo" =~ ^#|^$ ]] && continue

    # 標準リポジトリ: gh skill install でインストール
    echo "    Installing: $repo $skill"
    gh skill install "$repo" "$skill" --dir "$SKILLS_DIR" \
      || echo "    Failed: $repo $skill (skipping)"

  # if [[ -n "$path_in_repo" ]]; then
  #   # 非標準リポジトリ: スパースクローン → --from-local でインストール
  #   echo "    Installing (local): $repo $skill ($path_in_repo)"
  #   TMP_DIR="$(mktemp -d)"
  #   git clone --filter=blob:none --sparse --depth=1 "https://github.com/$repo" "$TMP_DIR" -q
  #   git -C "$TMP_DIR" sparse-checkout set "$path_in_repo"
  #   gh skill install "$TMP_DIR/$path_in_repo" "$skill" --from-local --dir "$SKILLS_DIR" \
  #     || echo "    Failed: $repo $skill (skipping)"
  #   rm -rf "$TMP_DIR"
  # else
  #   # 標準リポジトリ: gh skill install でインストール
  #   echo "    Installing: $repo $skill"
  #   gh skill install "$repo" "$skill" --dir "$SKILLS_DIR" \
  #     || echo "    Failed: $repo $skill (skipping)"
  # fi
done < "$MANIFEST"

echo "==> Done."
