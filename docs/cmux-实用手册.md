# cmux 实用手册：从终端窗口到 AI 工作台

> 面向你的当前环境：cmux `0.64.22 (102)`、macOS、Zsh + Oh My Zsh + Powerlevel10k。<br>
> 生成日期：2026-08-27。cmux 更新较快，新增功能以文末官方文档和本机 `cmux --help` 为准。

## 先记住这 8 个操作

| 目标 | 快捷键 |
|---|---|
| 打开命令面板 | `⌘⇧P` |
| 新建工作区 | `⌘N` |
| 新建当前 Pane 内的标签 | `⌘T` |
| 向右分屏 | `⌘D` |
| 向下分屏 | `⌘⇧D` |
| 在 Pane 间移动焦点 | `⌥⌘` + 方向键 |
| 打开嵌入式浏览器 | `⌘⇧L` |
| 重新加载配置 | `⌘⇧,` |

如果只想快速上手：为每个项目建一个 Workspace，在里面用 Pane 分出“主任务、测试/日志、浏览器”，用 Surface 保存同一 Pane 下的多个相关终端。

## 1. cmux 到底是什么

cmux 不只是“带标签的终端”。更准确的理解是：它是一层围绕终端、浏览器、文件和 AI Agent 构建的工作区管理器，底层终端渲染使用 Ghostty。

它的层级是：

```text
Window
└── Workspace：左侧边栏中的项目/任务
    └── Pane：Workspace 内的分屏区域
        └── Surface：Pane 顶部的标签
            └── Panel：真正显示的终端或浏览器内容
```

最容易混淆的是下面三层：

| 名称 | 直观理解 | 推荐用途 |
|---|---|---|
| Workspace | 一个独立任务桌面 | 一个仓库、一个需求或一个远程机器 |
| Pane | 桌面中的一个分区 | 主开发、测试日志、浏览器分别放置 |
| Surface | 分区内部的标签 | 同类任务之间快速切换，不占额外屏幕空间 |

经验法则：

- 需要同时看见：使用 Pane。
- 只需快速切换：使用 Surface。
- 工作目录、目标或上下文已经不同：使用 Workspace。

官方的完整层级说明见 [Concepts](https://cmux.com/docs/concepts)。

## 2. 一套适合 AI 开发的组织方式

### 2.1 一个项目一个 Workspace

建议用项目名或任务目标命名，例如：

```text
ROLL-release-audit
public-api-debug
dataset-normalization
```

避免把所有项目放在一个 Workspace 的十几个 Surface 里。这样会让工作目录、Agent 上下文和通知来源很难区分。

### 2.2 一个 Workspace 的推荐布局

```text
┌────────────────────────┬──────────────────┐
│ 主终端 / Codex         │ 浏览器 / 文档    │
│                        │                  │
├────────────────────────┼──────────────────┤
│ 测试、日志、服务进程   │ 辅助 Agent       │
└────────────────────────┴──────────────────┘
```

操作顺序：

1. `⌘N` 新建 Workspace。
2. `⌘D` 创建右侧 Pane。
3. `⌘⇧D` 在当前 Pane 下方继续分屏。
4. `⌥⌘` + 方向键切换 Pane。
5. `⌘⇧↩` 临时放大当前 Pane，再按一次恢复。

屏幕较小时不要强行保留四格。主终端 + 浏览器两格通常比四格更高效，其余任务放入 Surface。

### 2.3 Workspace 与 Surface 的命名

- `⌘⇧R`：重命名 Workspace。
- `⌘R`：重命名当前 Surface。
- `⌘;`：把 Workspace 标记为完成。
- `⌘⇧;`：循环切换 Workspace 状态。

命名时写“目标”而不是“工具”：`login-bug` 比 `codex-2` 更容易找回上下文。

## 3. 高频快捷键速查

### 3.1 应用与 Workspace

| 操作 | 快捷键 |
|---|---|
| 设置 | `⌘,` |
| 重新加载配置 | `⌘⇧,` |
| 命令面板 | `⌘⇧P` |
| 显示/隐藏左侧栏 | `⌘B` |
| 显示/隐藏右侧栏 | `⌥⌘B` |
| 新建 Workspace | `⌘N` |
| Workspace 切换器 | `⌘P` |
| 选择第 1～9 个 Workspace | `⌘1`～`⌘9` |
| 上一个/下一个 Workspace | `⌃⌘[` / `⌃⌘]` |
| 关闭 Workspace | `⌘⇧W` |
| 恢复上次应用会话 | `⌘⇧O` |

### 3.2 Surface 与 Pane

| 操作 | 快捷键 |
|---|---|
| 新建 Surface | `⌘T` |
| 上一个/下一个 Surface | `⌘⇧[` / `⌘⇧]` |
| 选择第 1～9 个 Surface | `⌃1`～`⌃9` |
| 关闭 Surface | `⌘W` |
| 恢复刚关闭的 Surface | `⌘⇧T` |
| 向右分屏 | `⌘D` |
| 向下分屏 | `⌘⇧D` |
| Pane 间移动焦点 | `⌥⌘` + 方向键 |
| 放大/恢复当前 Pane | `⌘⇧↩` |
| 平均分配 Pane 尺寸 | `⌃⌘⇧=` |

### 3.3 浏览器、查找和通知

| 操作 | 快捷键 |
|---|---|
| 打开浏览器 | `⌘⇧L` |
| 浏览器地址栏 | `⌘L` |
| 向右分出浏览器 | `⌥⌘D` |
| 向下分出浏览器 | `⌥⌘⇧D` |
| 浏览器开发者工具 | `⌥⌘I` |
| 查找 | `⌘F` |
| 目录内查找 | `⌘⇧F` |
| 打开通知 | 当前版本为 `⌘I` |
| 跳到最新未读通知 | `⌘⇧U` |
| 打开 Diff Viewer | `⌃⌘⇧D` |

完整列表见 [Keyboard Shortcuts](https://cmux.com/docs/keyboard-shortcuts)。所有 cmux 自有快捷键都可以在设置或 `cmux.json` 中修改。

## 4. 充分利用你现在的 Shell 配置

当前 Zsh 已经配置了下面这些增强：

| 命令/操作 | 用途 |
|---|---|
| `ls` | 使用 `eza`，带图标并让目录优先显示 |
| `ll` | 详细列表、隐藏文件、Git 状态和图标 |
| `la` | 包含隐藏文件的简洁列表 |
| `tree` | 带图标的目录树 |
| `z <关键词>` | 使用 zoxide 跳到经常访问的目录 |
| `Ctrl+R` | 用 Atuin 搜索带目录、时间、状态信息的本地历史命令 |
| `Ctrl+T` | 用 FZF 查找并插入文件路径 |
| `Alt+C` | 用 FZF 预览并切换目录 |
| `preview <文件>` | 使用 bat 彩色预览文件 |
| `git diff` | 自动使用 delta，支持行号和并排显示 |
| `y` | 打开 Catppuccin 风格的 Yazi；按 `q` 退出后进入所选目录 |
| `lg` | 打开 Lazygit，可视化管理暂存、分支、提交、stash 和 worktree |
| `btop` | 打开 Catppuccin 风格的系统资源面板；Pane 太窄时先放大 |
| `ff` | 运行 fastfetch，快速查看当前机器和系统信息 |

Powerlevel10k、FZF、bat、Yazi、btop 和 Lazygit 已统一为 Catppuccin Mocha。提示符采用两行布局：第一行显示目录和 Git，第二行提供简洁的绿色输入符；旧命令会折叠为 transient prompt，减少视觉噪声。

Atuin 当前为纯本地模式：不开启账号、云同步、后台服务和 Atuin AI，也没有导入可能包含敏感内容的旧历史。`Enter` 默认把搜索结果放回命令行供检查，不会立即执行。

本次终端改造前的配置备份位于：

```text
/Users/tbsg/.terminal-config-backups/20260827-204014
```

NVM、Conda 和 Mamba 采用延迟加载。新终端启动很快，但第一次执行 `node`、`npm`、`nvm`、`conda` 或 `mamba` 时会有一次初始化延迟，这是预期行为。

真实 PTY 下的 Zsh 启动测试结果为 `0.197 ± 0.019 s`，样本数为 7。

## 5. cmux CLI：把界面变成可编程工作台

### 5.1 先理解当前安全边界

你的 cmux 当前使用“仅允许 cmux 内部进程连接”的默认安全模式。因此：

- 在 cmux 自己的终端里执行 `cmux ...`：正常。
- 从 Codex 桌面应用或其他外部进程执行：可能看到 `Access denied - only processes started inside cmux can connect`。

这不是安装错误。建议保留该安全模式，在 cmux 终端里运行自动化命令。不要为了方便随意开启 `allowAll`，尤其是在共享机器上。官方说明见 [CLI Access Modes](https://cmux.com/docs/api#access-modes)。

### 5.2 识别当前位置

```bash
echo "$CMUX_WORKSPACE_ID"
echo "$CMUX_SURFACE_ID"
cmux current-workspace --json
cmux tree --all
```

CLI 支持 UUID，也支持 `window:1`、`workspace:2`、`pane:3`、`surface:4` 这种短引用。交互操作时短引用更方便，长期脚本应优先使用 JSON 输出中的稳定 ID。

### 5.3 查看和创建

```bash
# 查看结构
cmux list-workspaces --json
cmux list-panes
cmux list-pane-surfaces

# 新建
cmux new-workspace --name "API Debug"
cmux new-split right
cmux new-split down
cmux new-surface --type terminal

# 直接以目录创建 Workspace
cmux ~/leekaimao/yewu/ROLL
```

### 5.4 向终端发送操作

```bash
# 只发送文本，不等于按下回车
cmux send --surface surface:2 "npm test"

# 单独发送回车
cmux send-key --surface surface:2 enter

# 读取可见输出
cmux read-screen --surface surface:2 --lines 100

# 包含滚动历史
cmux read-screen --surface surface:2 --scrollback --lines 300
```

发送命令时把“文本”和“回车”分开，能减少误执行风险。对删除、发布、提交或线上操作，先读取 Surface 内容确认目标窗口和工作目录。

### 5.5 状态、进度和通知

```bash
cmux notify --title "Tests" --body "All tests passed"
cmux set-status build running --icon hammer --color '#89b4fa'
cmux set-progress 0.5 --label "Evaluation 50%"
cmux clear-progress
```

这些命令适合长时间训练、评测、构建和多 Agent 任务。你可以继续做别的事，完成或需要输入时再通过通知回到对应 Workspace。

## 6. 嵌入式浏览器：开发与验证闭环

### 6.1 日常使用

推荐把本地服务和浏览器放在同一 Workspace：

1. 主 Pane 运行服务或 Agent。
2. `⌥⌘D` 在右侧创建浏览器 Pane。
3. `⌘L` 输入 `http://localhost:3000`。
4. `⌥⌘I` 打开开发者工具。

这样日志、代码操作和页面结果都在同一任务上下文中。

### 6.2 浏览器自动化

```bash
# 打开页面
cmux browser open http://localhost:3000

# 获取可交互 DOM 快照
cmux browser surface:2 snapshot --interactive --compact

# 等待页面就绪
cmux browser surface:2 wait --load-state complete --timeout-ms 15000
cmux browser surface:2 wait --selector "#dashboard" --timeout-ms 10000

# 操作并立即验证
cmux browser surface:2 fill "#search" --text "cmux"
cmux browser surface:2 click "button[type='submit']" --snapshot-after

# 获取调试证据
cmux browser surface:2 console list
cmux browser surface:2 errors list
cmux browser surface:2 screenshot --out /tmp/cmux-page.png
```

推荐顺序是：`open → wait → snapshot → action → snapshot/get`。不要只发送点击后就假设成功。

浏览器配置会保留 Cookie 和登录状态。不要把包含 Cookie 的 `state save` 文件提交到 Git，也不要把密码和 Token 直接写进命令历史。完整接口见 [Browser Automation](https://cmux.com/docs/browser-automation)。

## 7. Markdown、Diff 和文件查看

cmux 可以直接把文档和代码审查结果放入侧边 Panel：

```bash
# 打开 Markdown 阅读器
cmux markdown README.md

# 查看当前仓库未暂存修改
cmux diff --unstaged

# 查看已暂存修改
cmux diff --staged

# 与某个基线比较
cmux diff --branch --base main
```

Diff Viewer 中可以使用 `J/K` 滚动、`gg/G` 跳到顶部/底部、`/` 搜索文件、`]f/[f` 切换文件。

## 8. 配置分为两层

### 8.1 终端渲染层：Ghostty 配置

负责字体、主题、背景、光标、透明度和 Pane 分隔线。

你的 cmux `0.64.22` 当前使用新版标准路径：

```text
~/.config/ghostty/config
```

当前主要设置：

```ini
theme = Catppuccin Mocha
font-family = JetBrainsMono Nerd Font Mono
font-size = 14
cursor-style = bar
background-opacity = 0.96
background-blur = 20
```

旧的 `~/Library/Application Support/com.cmuxterm.app/config.ghostty` 已停止作为主配置使用，其原始内容保存在本地备份目录。以后只维护 `~/.config/ghostty/config`，避免两份配置互相覆盖。

可用下面的只读命令确认当前构建实际报告的配置路径：

```bash
cmux config paths
```

### 8.2 应用行为层：cmux.json

负责 Workspace、快捷键、侧边栏、浏览器、通知、自动化和自定义工作区布局：

```text
~/.config/cmux/cmux.json
```

修改前先备份，然后验证并重载：

```bash
cmux config doctor
cmux reload-config
```

也可以直接按 `⌘⇧,` 重载。详细字段见 [Configuration](https://cmux.com/docs/configuration)。

## 9. Agent 会话与恢复

cmux 会恢复 Window、Workspace、Pane、工作目录和部分滚动历史，但不会保存任意进程的内存状态。普通 Shell、Vim 或没有集成的程序重启后只是重新打开终端。

Codex 等受支持 Agent 可以通过原生 session ID 恢复。需要时可在 cmux 终端中安装对应 Hook：

```bash
cmux hooks setup codex
```

这会改变 Agent 集成配置，执行前应先确认是否符合你的工作流。安装后，cmux 可以记录 Codex session，并在恢复 Workspace 时调用 `codex resume <id>`。详细机制和支持矩阵见 [Session Restore](https://cmux.com/docs/session-restore)。

手动恢复上一次应用布局：

```bash
cmux restore-session
```

或使用 `⌘⇧O`。

## 10. SSH 和远程开发

cmux 可以把远程主机直接组织成 Workspace：

```bash
cmux ssh my-server
cmux ssh dev@example.com --name "GPU Server"
cmux ssh dev@example.com --command 'cd ~/project && codex'
```

建议把主机、用户、密钥和 ProxyJump 写进 `~/.ssh/config`，日常只使用稳定别名：

```sshconfig
Host gpu-dev
    HostName example.com
    User dev
    IdentityFile ~/.ssh/id_ed25519
```

之后运行：

```bash
cmux ssh gpu-dev
```

网络经常切换时可以研究 Mosh；需要把远程 tmux 映射为 cmux 原生 Workspace/Pane 时，可以研究仍处于 Beta 的 `cmux ssh-tmux`。详见 [SSH](https://cmux.com/docs/ssh) 和 [Remote tmux](https://cmux.com/docs/remote-tmux)。

## 11. 常见问题

### CLI 报 `Access denied`

原因：命令不是从 cmux 内部启动，当前 socket 策略只允许 cmux 子进程。

处理：在 cmux 的 Terminal Surface 内运行命令。通常不需要降低 socket 安全级别。

### 配置修改后没有变化

1. 按 `⌘⇧,`。
2. 确认编辑的是当前版本实际读取的 Ghostty 配置。
3. 检查是否有另一份配置覆盖当前值。
4. 对 `cmux.json` 运行 `cmux config doctor`。

### 图标显示为方框

确认字体是 `JetBrainsMono Nerd Font Mono`，并重新加载配置。普通 JetBrains Mono 不包含完整 Nerd Font 图标。

### 第一次运行 Node 或 Conda 比较慢

这是延迟加载的结果。慢只发生在当前 Shell 第一次调用相关命令时；换来的收益是每次打开终端不再无条件初始化 NVM 和 Conda。

### cmux 提示内存压力

你当前界面曾出现 macOS 严重内存压力提示。优先：

```bash
cmux top --all --processes --sort mem
cmux memory --all
```

然后关闭不再使用的 Workspace、浏览器 Surface 和长期空闲 Agent。不要在未确认任务状态时批量关闭。若仍持续，保存工作后重启 cmux，并检查可用更新。

### 重启后程序没有继续运行

布局恢复不等于进程快照。为长时间服务使用进程管理器、tmux 或受支持的 Agent session resume，而不是只依赖 cmux 界面恢复。

## 12. 建议的七天练习顺序

1. 第一天：只练 `⌘N`、`⌘T`、`⌘D`、`⌘⇧D` 和 Pane 导航。
2. 第二天：坚持一个项目一个 Workspace，并给 Workspace/Surface 命名。
3. 第三天：把本地服务和嵌入式浏览器放在同一 Workspace。
4. 第四天：使用 `cmux tree`、`read-screen` 和 `--json` 理解 CLI 对象。
5. 第五天：为长任务加入 `notify`、`set-status` 和 `set-progress`。
6. 第六天：尝试 Browser 的 `snapshot → action → verify` 流程。
7. 第七天：根据真实痛点再决定是否修改快捷键、安装 Codex Hook 或增加项目级 `.cmux/cmux.json`。

不要在第一天就重写全部快捷键。先形成 Workspace/Pane/Surface 的稳定心智模型，再定制才不会越改越乱。

## 官方资料

- [Getting Started](https://cmux.com/docs/getting-started)
- [Concepts](https://cmux.com/docs/concepts)
- [Keyboard Shortcuts](https://cmux.com/docs/keyboard-shortcuts)
- [Configuration](https://cmux.com/docs/configuration)
- [CLI Reference](https://cmux.com/docs/api)
- [Browser Automation](https://cmux.com/docs/browser-automation)
- [Notifications](https://cmux.com/docs/notifications)
- [Session Restore](https://cmux.com/docs/session-restore)
- [SSH](https://cmux.com/docs/ssh)
- [Ghostty Configuration](https://ghostty.org/docs/config)
- [Yazi Quick Start](https://yazi-rs.github.io/docs/quick-start/)
- [Lazygit](https://github.com/jesseduffield/lazygit)
- [Atuin](https://github.com/atuinsh/atuin)
- [Delta](https://github.com/dandavison/delta)
