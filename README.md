# dog-nose config

Mac 用の個人設定 (zsh / nvim / ghostty / git)。Homebrew + 読み取り専用の世代管理で構築する。

## Installation

```bash
curl -fsSL https://raw.githubusercontent.com/dog-nose/config/main/installer-for-mac.sh | bash
```

1. Homebrew / git がなければ導入
2. `~/.ssh/id_ed25519` がなければ作成し、GitHub への登録を促す
3. `~/Documents/Repositories/src/github.com/dog-nose/config` に SSH で clone (ghq root と同じ)
4. `brew bundle`、oh-my-zsh の導入
5. `dotfiles apply` で設定を適用

前提: `~/Documents` は iCloud 同期を切っておくこと。

## 仕組み

- 管理対象は `links.conf` に宣言する。
- `dotfiles apply` は対象ファイルを `~/.local/share/dotfiles/generations/<日時>/` に **読み取り専用** でコピーし、`current` を差し替える。`~/.config/...` の各ファイルは `current` 経由のシンボリックリンク (ファイル単位)。
- 既存の実ファイルは `~/.local/share/dotfiles/backup/` に退避する。
- 環境ごとの設定は `~/.config/<app>/local.*` に書く (管理対象外、`apply` で空テンプレートを生成)。

| 設定 | local ファイル |
|---|---|
| zsh | `~/.config/zsh/local.zsh` |
| nvim | `~/.config/nvim/local.lua` |
| ghostty | `~/.config/ghostty/local` |
| git | `~/.config/git/local.gitconfig` |
| brew | `~/.config/dotfiles/Brewfile.local` |

## コマンド

| コマンド | 内容 |
|---|---|
| `dotfiles apply` | 新しい世代を作って切り替える (最後に gc) |
| `dotfiles update` | `git pull --ff-only` → apply |
| `dotfiles status` | 現在の世代、リンク状況、local の状況 |
| `dotfiles rollback` | 1 つ前の世代に戻す |
| `dotfiles gc [-n] [--keep N]` | 古い世代を削除 (既定は 5 世代保持。`current` と直前は必ず残す) |
| `dotfiles review` | `local.*` の内容を config に昇格するか判断する |

7 日以上レビューしておらず local に設定があれば、zsh 起動時に 1 日 1 回だけ通知する。

## 既存マシン (Nix からの移行)

`home-manager` が作った `/nix/store` へのリンクは `dotfiles apply` で張り替わる。tmux / fish は管理対象外になった (履歴は `legacy-nix` ブランチ)。Nix のアンインストールは任意。

## Claude Desktop の mod (任意・手動)

このリポジトリは Claude のマーケットプレイスも兼ねている。インストーラには組み込んでいないので、必要なときに手動で実行する。

| mod | 内容 |
|---|---|
| `night-sky-bg` | デスクトップの背景に、富士山と桜のイラストを表示 (ダークモード固定。名前は旧星空の名残) |
| `usage-meter` | 入力欄の上に、5 時間枠・週間枠の使用率を表示 (デスクトップ画面のみ) |

**シェルから**

```bash
claude plugin marketplace add dog-nose/config
claude plugin install usage-meter@dog-nose-mods
claude plugin install night-sky-bg@dog-nose-mods
```

**ターミナルの Claude Code から**

```
/plugin marketplace add dog-nose/config
/plugin install usage-meter@dog-nose-mods
/plugin install night-sky-bg@dog-nose-mods
```

**デスクトップアプリから**: プロンプト横の「+」→ Plugins → Add marketplace に `dog-nose/config` を入力し、Add plugin で mod を選ぶ。

- 導入した mod は、以降に開く新しいセッションから読み込まれる。
- 手元で試すだけなら `claude --plugin-dir claude-mods/usage-meter` が使える。
- `usage-meter` の数値は、サブスクリプション利用時の最初の応答後に表示される。
- mod の更新は、`claude-mods/` を編集して push し、`claude plugin marketplace update dog-nose-mods` で取り込む。
- `marketplace add` には GitHub のリポジトリ名 (`dog-nose/config`)、`install` には `プラグイン名@dog-nose-mods` を指定する。マーケットプレイス名は `dog-nose-mods`、定義は [.claude-plugin/marketplace.json](.claude-plugin/marketplace.json)。
