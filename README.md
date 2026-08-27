# terminal-dotfiles

macOS 上的现代终端配置仓库，覆盖 cmux、Ghostty、Zsh、Powerlevel10k、Atuin、Yazi、Lazygit、Delta 和 btop。

仓库采用“配置快照 + 幂等安装器”方式，不与当前 HOME 建立符号链接。安装前会备份被替换的文件，真实密钥、Token、Git 身份和旧 Shell 历史不会进入 Git。

## 快速开始

```zsh
git clone https://github.com/leekaimao/terminal-dotfiles.git
cd terminal-dotfiles

brew bundle
./install.sh --dry-run
./install.sh --apply
./doctor.sh
exec zsh
```

`install.sh` 默认只预览。只有显式传入 `--apply` 才会写入 HOME。

## 新机器的 Zsh 基础

仓库不自动执行网络安装脚本。首次使用时，按官方仓库安装 Oh My Zsh、Powerlevel10k 和两个插件：

```zsh
git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
```

如果新机器还没有 `.zshrc`，可以先使用安全模板：

```zsh
cp config/zsh/zshrc.example "$HOME/.zshrc"
./install.sh --apply
```

已有 `.zshrc` 时不要覆盖。安装器只会追加一次现代终端配置入口。

## 仓库内容

| 路径 | 安装目标 | 用途 |
|---|---|---|
| `config/cmux/cmux.json` | `~/.config/cmux/cmux.json` | cmux 文件和 Markdown 打开方式 |
| `config/ghostty/config` | `~/.config/ghostty/config` | 字体、主题、透明度、光标 |
| `config/powerlevel10k/.p10k.zsh` | `~/.p10k.zsh` | 两行提示符和 Catppuccin 配色 |
| `config/zsh/modern-terminal.zsh` | `~/.config/terminal-dotfiles/modern-terminal.zsh` | fzf、zoxide、eza、bat、Atuin、Yazi 等 |
| `config/atuin/config.toml` | `~/.config/atuin/config.toml` | 本地历史搜索，不启用同步 |
| `config/yazi/*` | `~/.config/yazi/*` | 三栏文件管理和主题 |
| `config/lazygit/config.yml` | `~/Library/Application Support/lazygit/config.yml` | Git TUI 配色和行为 |
| `config/git/delta.gitconfig` | `~/.config/git/delta.gitconfig` | Git diff 高亮 |
| `config/btop/*` | `~/.config/btop/*` | 系统监控和主题 |
| `Brewfile` | 不直接复制 | Homebrew 工具清单 |

完整使用说明：

- [现代终端配置与使用手册](docs/现代终端配置与使用手册.md)
- [cmux 实用手册](docs/cmux-实用手册.md)

## 安装器行为

预览：

```zsh
./install.sh --dry-run
```

应用：

```zsh
./install.sh --apply
```

测试其他 HOME：

```zsh
./install.sh --apply --home /absolute/test/home
```

发生覆盖时，原文件保存在：

```text
~/.terminal-config-backups/terminal-dotfiles-YYYYMMDD-HHMMSS/
```

重复执行不会重复添加 `.zshrc` 和 `.gitconfig` 入口。

## Git 身份与凭证

仓库只管理 Delta，不管理个人 Git 身份。新机器可参考：

```zsh
cp config/git/user.gitconfig.example ~/.gitconfig.local
```

再根据需要手动填写，但不要提交该文件。macOS 推荐继续使用 `osxkeychain` credential helper。

## 本机私密配置

需要机器专属环境变量时：

```zsh
mkdir -p ~/.config/terminal-dotfiles
cp config/zsh/local.zsh.example ~/.config/terminal-dotfiles/local.zsh
chmod 600 ~/.config/terminal-dotfiles/local.zsh
```

`local.zsh` 已被 `.gitignore` 排除。真实凭证优先存入 macOS Keychain 或企业密钥系统，不要直接写进仓库。

## 验证

```zsh
make test
make doctor
```

测试会在独立临时 HOME 中验证：

- dry-run 不写文件
- 覆盖前创建备份
- 所有映射文件正确安装
- `.zshrc` 和 `.gitconfig` 幂等
- Git include 语法有效
- Zsh 配置语法有效
- 常见密钥格式没有进入配置目录

## 更新配置

修改仓库中的配置后，依次运行：

```zsh
make test
./install.sh --dry-run
./install.sh --apply
./doctor.sh
```

不要直接把完整的 `~/.zshrc`、`~/.gitconfig`、`~/.zsh_history` 或备份目录复制进仓库。

## 当前快照

创建时使用的核心版本：

```text
cmux      0.64.22 (102)
Zsh       5.9
Lazygit   0.64.1
Atuin     18.19.0
Yazi      26.5.6
btop      1.4.7
fzf       0.73.1
zoxide    0.9.9
eza       0.23.5
bat       0.26.1
Delta     0.19.2
```
