# dog-nose config

Mac 用の個人 dotfiles (zsh / nvim / ghostty / git)。Homebrew + 読み取り専用の世代管理 (`bin/dotfiles`) で管理する。Nix は廃止 (旧構成は `legacy-nix` ブランチ)。

## Apply configuration

```bash
bin/dotfiles apply
```

- 管理対象は `links.conf`、パッケージは `Brewfile`。
- 設定を編集するのは repo 側。`~/.config/...` は読み取り専用の世代へのリンクなので直接編集しない。
- 環境固有の設定は `~/.config/<app>/local.*` に書き、repo には入れない。
- `installer-for-mac.sh` の `GHQ_ROOT` と `git/.gitconfig` の `ghq.root` は同じ値に保つこと。
