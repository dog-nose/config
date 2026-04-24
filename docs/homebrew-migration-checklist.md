# Homebrew Migration Checklist

Migration of Homebrew-installed packages to Nix/home-manager.

---

## Casks (GUI Applications)

| Done | Package | Notes |
|------|---------|-------|
| [ ] | 1password | |
| [ ] | alfred | |
| [ ] | arc | |
| [ ] | clickup | |
| [ ] | cmux | nixpkgs未収録のため移行不可。Homebrew caskで継続管理 |
| [ ] | cyberduck | |
| [ ] | docker | |
| [ ] | docker-desktop | |
| [ ] | firefox | |
| [ ] | font-hack-nerd-font | |
| [ ] | gcloud-cli | |
| [ ] | ghostty | |
| [ ] | github | |
| [ ] | google-chrome | |
| [ ] | google-japanese-ime | |
| [ ] | intellij-idea | |
| [ ] | iterm2 | |
| [ ] | itsycal | |
| [ ] | medis | |
| [ ] | mongodb-compass | |
| [ ] | notion | |
| [ ] | raycast | |
| [ ] | sequel-ace | |
| [ ] | slack | |
| [ ] | sourcetree | |
| [ ] | wezterm | |

---

## Shell & Terminal

| Done | Package | Notes |
|------|---------|-------|
| [ ] | fish | |
| [ ] | fisher | |
| [ ] | zsh | |
| [ ] | zsh-abbr | |
| [ ] | tmux | |
| [ ] | htop | |
| [ ] | tree | |

---

## CLI Utilities

| Done | Package | Notes |
|------|---------|-------|
| [ ] | bat | |
| [ ] | fd | |
| [x] | fzf | |
| [x] | jq | |
| [x] | ripgrep | |
| [ ] | the_silver_searcher | |
| [x] | ghq | |
| [ ] | git | |
| [ ] | tig | |
| [x] | lazygit | |
| [ ] | nkf | |
| [x] | wget | |
| [x] | curl | |
| [x] | telnet | pkgs.inetutils として追加 |
| [ ] | httpie | |
| [ ] | ctop | |
| [ ] | oxker | |
| [ ] | pwgen | |
| [ ] | marp-cli | |
| [ ] | universal-ctags | |

---

## Editor & Neovim

| Done | Package | Notes |
|------|---------|-------|
| [ ] | neovim-remote | |
| [ ] | tree-sitter | |
| [ ] | luajit | |
| [ ] | luv | |
| [ ] | lpeg | |
| [ ] | unibilium | |

---

## Languages & Runtimes

| Done | Package | Notes |
|------|---------|-------|
| [ ] | node | |
| [ ] | deno | |
| [ ] | python@3.11 | |
| [ ] | python@3.12 | |
| [ ] | python@3.13 | |
| [ ] | php | |
| [ ] | perl | |

---

## Version Managers

| Done | Package | Notes |
|------|---------|-------|
| [ ] | anyenv | |
| [ ] | nodebrew | |
| [ ] | pyenv | |
| [ ] | phpbrew | |

---

## Database Tools

| Done | Package | Notes |
|------|---------|-------|
| [ ] | mysql-client | |
| [ ] | mycli | |
| [ ] | lazysql | |
| [ ] | libpq | |
| [ ] | sqlite | |
| [ ] | sqlcipher | |
| [ ] | mongosh | |
| [ ] | mongocli | |
| [ ] | libmemcached | |
| [ ] | freetds | |
| [ ] | unixodbc | |

---

## Cloud & Infrastructure

| Done | Package | Notes |
|------|---------|-------|
| [ ] | awscli | |
| [ ] | aliyun-cli | |
| [ ] | terraform | |

---

## Build Tools & Compilers

| Done | Package | Notes |
|------|---------|-------|
| [ ] | autoconf | |
| [ ] | automake | |
| [ ] | cmake | |
| [ ] | make | |
| [ ] | bison | |
| [ ] | m4 | |
| [ ] | clang-format | |
| [ ] | re2c | |
| [ ] | pkgconf | |

---

## QMK / Firmware / Embedded

| Done | Package | Notes |
|------|---------|-------|
| [ ] | qmk | |
| [ ] | avr-binutils | |
| [ ] | avr-gcc@8 | |
| [ ] | avr-gcc@9 | |
| [ ] | arm-none-eabi-binutils | |
| [ ] | arm-none-eabi-gcc | |
| [ ] | arm-none-eabi-gcc@8 | |
| [ ] | avrdude | |
| [ ] | dfu-programmer | |
| [ ] | dfu-util | |
| [ ] | bootloadhid | |
| [ ] | hid_bootloader_cli | |
| [ ] | hidapi | |
| [ ] | libftdi | |
| [ ] | libfido2 | |
| [ ] | libcbor | |
| [ ] | libusb | |
| [ ] | libusb-compat | |
| [ ] | mdloader | |
| [ ] | teensy_loader_cli | |
| [ ] | net-snmp | |
| [ ] | confuse | |

---

## Python Packages (via Homebrew)

| Done | Package | Notes |
|------|---------|-------|
| [ ] | certifi | |
| [ ] | cffi | |
| [ ] | cryptography | |
| [ ] | pillow | |
| [ ] | pycparser | |

---

## Libraries (Dependencies)

> These are typically pulled in automatically; migrate only if explicitly required.

| Done | Package | Notes |
|------|---------|-------|
| [ ] | aom | |
| [ ] | apr | |
| [ ] | apr-util | |
| [ ] | argon2 | |
| [ ] | berkeley-db@5 | |
| [ ] | boost | |
| [ ] | brotli | |
| [ ] | bzip2 | |
| [ ] | c-ares | |
| [ ] | ca-certificates | |
| [ ] | cairo | |
| [ ] | composer | |
| [ ] | dav1d | |
| [ ] | expat | |
| [ ] | fontconfig | |
| [ ] | freetype | |
| [ ] | fribidi | |
| [ ] | gd | |
| [ ] | gdbm | |
| [ ] | gettext | |
| [ ] | giflib | |
| [ ] | glib | |
| [ ] | gmp | |
| [ ] | graphite2 | |
| [ ] | harfbuzz | |
| [ ] | highway | |
| [ ] | icu4c@76 | |
| [ ] | icu4c@77 | |
| [ ] | icu4c@78 | |
| [ ] | imagemagick | |
| [ ] | imath | |
| [ ] | isl | |
| [ ] | jansson | |
| [ ] | jasper | |
| [ ] | jpeg | |
| [ ] | jpeg-turbo | |
| [ ] | jpeg-xl | |
| [ ] | krb5 | |
| [ ] | libavif | |
| [ ] | libde265 | |
| [ ] | libdeflate | |
| [ ] | libedit | |
| [ ] | libevent | |
| [ ] | libgcrypt | |
| [ ] | libgit2 | |
| [ ] | libgpg-error | |
| [ ] | libheif | |
| [ ] | libiconv | |
| [ ] | libidn2 | |
| [ ] | libimagequant | |
| [ ] | liblqr | |
| [ ] | libmpc | |
| [ ] | libnghttp2 | |
| [ ] | libnghttp3 | |
| [ ] | libngtcp2 | |
| [ ] | libomp | |
| [ ] | libpng | |
| [ ] | libraqm | |
| [ ] | libraw | |
| [ ] | libsodium | |
| [ ] | libssh2 | |
| [ ] | libtiff | |
| [ ] | libtool | |
| [ ] | libunistring | |
| [ ] | libuv | |
| [ ] | libvmaf | |
| [ ] | libx11 | |
| [ ] | libxau | |
| [ ] | libxcb | |
| [ ] | libxdmcp | |
| [ ] | libxext | |
| [ ] | libxml2 | |
| [ ] | libxrender | |
| [ ] | libxslt | |
| [ ] | libyaml | |
| [ ] | libzip | |
| [ ] | little-cms2 | |
| [ ] | lpeg | |
| [ ] | lz4 | |
| [ ] | lzo | |
| [ ] | mpdecimal | |
| [ ] | mpfr | |
| [ ] | ncurses | |
| [ ] | oniguruma | |
| [ ] | openexr | |
| [ ] | openjpeg | |
| [ ] | openjph | |
| [ ] | openldap | |
| [ ] | openssl@1.1 | |
| [ ] | openssl@3 | |
| [ ] | pcre | |
| [ ] | pcre2 | |
| [ ] | pixman | |
| [ ] | readline | |
| [ ] | rtmpdump | |
| [ ] | shared-mime-info | |
| [ ] | simdjson | |
| [ ] | tidy-html5 | |
| [ ] | utf8proc | |
| [ ] | uvwasi | |
| [ ] | webp | |
| [ ] | x265 | |
| [ ] | xorgproto | |
| [ ] | xz | |
| [ ] | zlib | |
| [ ] | zstd | |
