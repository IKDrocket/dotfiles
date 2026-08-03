<!--
このファイルは ~/.claude/CLAUDE.md の実体（link.sh がリンクする）。

Claude Code が読むのは CLAUDE.md のみで AGENTS.md は読まないため、
共通指示の実体である shared/AGENTS.md を import して両ツールで同じ内容を共有する。
Codex 側は shared/AGENTS.md を ~/.codex/AGENTS.md として直接読む。

import パスを ~/.claude/AGENTS.md（= shared/AGENTS.md への symlink）にしているのは、
相対パス @AGENTS.md だと symlink 経由で読まれたときの解決基準（リンク自身の
ディレクトリか実体のディレクトリか）に依存してしまうため。~ 起点なら clone 先が
どこでも壊れない。

Claude Code 固有の指示（Codex には効かせたくないもの）はこの下に追記する。
-->

@~/.claude/AGENTS.md
