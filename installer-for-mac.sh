#!/usr/bin/env bash
# Mac 用ブートストラップ。何度実行しても安全 (冪等)。
#   curl -fsSL https://raw.githubusercontent.com/dog-nose/config/main/installer-for-mac.sh | bash
set -Eeuo pipefail

OWNER_REPO="dog-nose/config"
GHQ_ROOT="$HOME/Documents/Repositories/src"   # git/.gitconfig の ghq.root と一致させること
REPO_DIR="$GHQ_ROOT/github.com/$OWNER_REPO"
SSH_KEY="$HOME/.ssh/id_ed25519"
TOTAL=9
STEP_NAME="開始前"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
info() { printf '    %s\n' "$*"; }
step() { STEP_NAME="$2"; printf '\n\033[1;32m[%s/%s]\033[0m %s\n' "$1" "$TOTAL" "$2"; }
die()  { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }

# どこで止まったか分かるように、失敗時はステップ名・行番号・コマンドを表示する
trap 'rc=$?; printf "\n\033[1;31m失敗しました\033[0m ステップ: %s / %s行目: %s (終了コード %s)\n" "$STEP_NAME" "$LINENO" "$BASH_COMMAND" "$rc" >&2' ERR

# curl | bash では stdin がスクリプト本体なので、対話入力は /dev/tty から読む
ask() { [ -r /dev/tty ] || die "対話端末がありません。端末から実行してください"; read -r "$@" < /dev/tty; }

# curl | bash では stdin がスクリプト本体になり、ssh や brew が残りを読み捨てると
# 何も出力せずに終了する。全体を関数にして、末尾の呼び出しまで読み込み終えてから実行する。
main() {
  step 1 "実行環境を確認"
  [ "$(uname)" = "Darwin" ] || die "macOS 専用です"
  [ "$(uname -m)" = "arm64" ] || die "Apple Silicon (arm64) 専用です"
  info "macOS $(sw_vers -productVersion) / arm64 / HOME=$HOME"

  step 2 "Homebrew を確認"
  if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
    log "Homebrew をインストールします"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/tty
  else
    info "インストール済み"
  fi
  if [ -x /opt/homebrew/bin/brew ]; then eval "$(/opt/homebrew/bin/brew shellenv)"; fi
  command -v brew >/dev/null 2>&1 || die "brew が見つかりません"
  info "brew: $(command -v brew)"

  step 3 "git を確認"
  if ! brew list git >/dev/null 2>&1 && ! command -v git >/dev/null 2>&1; then
    log "git をインストールします"
    brew install git
  else
    info "インストール済み: $(git --version)"
  fi

  step 4 "SSH 鍵を確認"
  if [ ! -f "$SSH_KEY" ]; then
    log "SSH 鍵を作成します: $SSH_KEY"
    mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
    ask -p "鍵に付けるコメント (例: メールアドレス): " comment
    ssh-keygen -t ed25519 -C "${comment:-$(whoami)@$(hostname -s)}" -f "$SSH_KEY"
  else
    info "既にあります: $SSH_KEY"
  fi

  ssh_ok() {  # GitHub は認証成功でも終了コード 1 を返す (pipefail で落ちないよう出力を変数に取る)
    SSH_OUT="$(ssh -n -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1 || true)"
    case "$SSH_OUT" in *"successfully authenticated"*) return 0;; *) return 1;; esac
  }
  info "GitHub への SSH 接続を確認中..."
  if ssh_ok; then
    info "接続 OK"
  else
    log "公開鍵を GitHub に登録してください (クリップボードにコピー済み)"
    cat "$SSH_KEY.pub"
    pbcopy < "$SSH_KEY.pub"
    open "https://github.com/settings/ssh/new" || true
    until ssh_ok; do
      echo "ssh の結果: $SSH_OUT"
      ask -p "登録したら Enter (再確認します): " _
    done
    info "接続 OK"
  fi

  step 5 "ghq を確認し、リポジトリを clone"
  if brew list ghq >/dev/null 2>&1; then info "ghq: インストール済み"; else log "ghq をインストールします"; brew install ghq; fi
  if [ -d "$REPO_DIR/.git" ]; then
    log "既存の clone を更新します: $REPO_DIR"
    git -C "$REPO_DIR" pull --ff-only
  else
    log "clone します: $REPO_DIR"
    mkdir -p "$(dirname "$REPO_DIR")"
    git clone "git@github.com:$OWNER_REPO.git" "$REPO_DIR"
  fi
  actual_root="$(GIT_CONFIG_GLOBAL="$REPO_DIR/git/.gitconfig" ghq root 2>/dev/null || true)"
  if [ "${actual_root%/}" = "$GHQ_ROOT" ]; then info "ghq root: $actual_root"; else log "警告: ghq root ($actual_root) が想定 ($GHQ_ROOT) と異なります"; fi

  step 6 "brew bundle でパッケージを導入"
  # 公式以外の tap の formula は信頼設定が必要 (tap 全体ではなく、使う formula だけを信頼する)
  info "サードパーティ formula を信頼: olets/tap/zsh-abbr"
  brew tap olets/tap
  brew trust --formula olets/tap/zsh-abbr
  brew bundle --file="$REPO_DIR/Brewfile"
  LOCAL_BREWFILE="$HOME/.config/dotfiles/Brewfile.local"
  if [ -f "$LOCAL_BREWFILE" ]; then
    info "Brewfile.local を適用します"
    brew bundle --file="$LOCAL_BREWFILE"
  fi

  step 7 "oh-my-zsh と zsh プラグインを確認"
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "oh-my-zsh をインストールします"
    RUNZSH=no KEEP_ZSHRC=yes CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    info "oh-my-zsh: インストール済み"
  fi
  custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
  for plugin in zsh-completions zsh-syntax-highlighting; do
    if [ -d "$custom/$plugin" ]; then
      info "$plugin: インストール済み"
    else
      log "$plugin を clone します"
      git clone --depth 1 "https://github.com/zsh-users/$plugin" "$custom/$plugin"
    fi
  done

  step 8 "dotfiles コマンドを配置し、設定を適用"
  mkdir -p "$HOME/.local/bin"
  ln -sfn "$REPO_DIR/bin/dotfiles" "$HOME/.local/bin/dotfiles"
  info "リンク: ~/.local/bin/dotfiles"
  "$REPO_DIR/bin/dotfiles" apply

  step 9 "nvim のプラグインと LSP ツールを導入 (初回起動時の待ちをなくす)"
  # 失敗しても致命的ではないので警告にとどめる (nvim を起動すれば lazy.nvim / mason が続きを行う)
  if nvim --headless "+Lazy! sync" +qa; then info "プラグイン: OK"; else log "警告: プラグインの導入に失敗しました"; fi
  if nvim --headless "+luafile $REPO_DIR/bin/nvim-mason.lua" +qa; then info "mason ツール: 完了"; else log "警告: mason ツールの導入に失敗しました"; fi

  printf '\n'
  log "完了しました。新しいシェルを開いてください。(PATH に ~/.local/bin が必要です)"
}

main "$@"
