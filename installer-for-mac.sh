#!/usr/bin/env bash
# Mac 用ブートストラップ。何度実行しても安全 (冪等)。
#   curl -fsSL https://raw.githubusercontent.com/dog-nose/config/main/installer-for-mac.sh | bash
set -euo pipefail

OWNER_REPO="dog-nose/config"
GHQ_ROOT="$HOME/Documents/Repositories/src"   # git/.gitconfig の ghq.root と一致させること
REPO_DIR="$GHQ_ROOT/github.com/$OWNER_REPO"
SSH_KEY="$HOME/.ssh/id_ed25519"

log() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# curl | bash では stdin がスクリプト本体なので、対話入力は /dev/tty から読む
ask() { [ -r /dev/tty ] || die "対話端末がありません。端末から実行してください"; read -r "$@" < /dev/tty; }

[ "$(uname)" = "Darwin" ] || die "macOS 専用です"
[ "$(uname -m)" = "arm64" ] || die "Apple Silicon (arm64) 専用です"

# 1. Homebrew
if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
  log "Homebrew をインストールします"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/tty
fi
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
command -v brew >/dev/null 2>&1 || die "brew が見つかりません"

# 2. git
if ! brew list git >/dev/null 2>&1 && ! command -v git >/dev/null 2>&1; then
  log "git をインストールします"
  brew install git
fi

# 3. SSH 鍵
if [ ! -f "$SSH_KEY" ]; then
  log "SSH 鍵を作成します: $SSH_KEY"
  mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
  ask -p "鍵に付けるコメント (例: メールアドレス): " comment
  ssh-keygen -t ed25519 -C "${comment:-$(whoami)@$(hostname -s)}" -f "$SSH_KEY"
fi

ssh_ok() {  # GitHub は認証成功でも終了コード 1 を返す (pipefail で落ちないよう出力を変数に取る)
  SSH_OUT="$(ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 || true)"
  case "$SSH_OUT" in *"successfully authenticated"*) return 0;; *) return 1;; esac
}
if ! ssh_ok; then
  log "公開鍵を GitHub に登録してください (クリップボードにコピー済み)"
  cat "$SSH_KEY.pub"
  pbcopy < "$SSH_KEY.pub"
  open "https://github.com/settings/ssh/new" || true
  until ssh_ok; do
    echo "ssh の結果: $SSH_OUT"
    ask -p "登録したら Enter (再確認します): " _
  done
fi

# 4. ghq + clone (ghq root を gitconfig と揃える)
brew list ghq >/dev/null 2>&1 || brew install ghq
if [ -d "$REPO_DIR/.git" ]; then
  log "既存の clone を更新します: $REPO_DIR"
  git -C "$REPO_DIR" pull --ff-only
else
  log "clone します: $REPO_DIR"
  mkdir -p "$(dirname "$REPO_DIR")"
  git clone "git@github.com:$OWNER_REPO.git" "$REPO_DIR"
fi
actual_root="$(GIT_CONFIG_GLOBAL="$REPO_DIR/git/.gitconfig" ghq root 2>/dev/null || true)"
[ "${actual_root%/}" = "$GHQ_ROOT" ] || log "警告: ghq root ($actual_root) が想定 ($GHQ_ROOT) と異なります"

# 5. パッケージ
log "brew bundle"
brew bundle --file="$REPO_DIR/Brewfile"
LOCAL_BREWFILE="$HOME/.config/dotfiles/Brewfile.local"
[ -f "$LOCAL_BREWFILE" ] && brew bundle --file="$LOCAL_BREWFILE"

# 6. oh-my-zsh と zsh プラグイン (.zshrc は触らない)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  log "oh-my-zsh をインストールします"
  RUNZSH=no KEEP_ZSHRC=yes CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
[ -d "$custom/zsh-completions" ] || git clone --depth 1 https://github.com/zsh-users/zsh-completions "$custom/zsh-completions"
[ -d "$custom/zsh-syntax-highlighting" ] || git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$custom/zsh-syntax-highlighting"

# 7. 設定の適用と dotfiles コマンドの配置
mkdir -p "$HOME/.local/bin"
ln -sfn "$REPO_DIR/bin/dotfiles" "$HOME/.local/bin/dotfiles"
"$REPO_DIR/bin/dotfiles" apply

log "完了しました。新しいシェルを開いてください。(PATH に ~/.local/bin が必要です)"
