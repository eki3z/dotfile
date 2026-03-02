vim9script

# --- 基础显示设置 ---
set number              # 显示行号
set cursorline          # (可选) 高亮当前行，视觉更清晰
set showmatch           # 显示匹配的括号
set laststatus=2        # 总是显示状态栏
set ruler               # 显示光标位置
set wildmenu            # 命令行补全菜单
set mouse=a             # 开启鼠标支持
set termguicolors       # 开启真彩色支持 (现代终端必备)

# 进入插入模式时，光标变为竖线 (vertical bar)
# 退出插入模式回到普通模式时，光标变为块状 (block)
# (可选) 进入替换模式时，光标变为下划线 (underscore)
&t_SI = "\e[6 q"
&t_EI = "\e[2 q"
&t_SR = "\e[4 q"

# --- 搜索设置 ---
set ignorecase          # 搜索时忽略大小写
set smartcase           # 如果搜索词包含大写，则不忽略大小写
set incsearch           # 边输入边高亮
set hlsearch            # 高亮搜索结果
set wrapscan            # 循环搜索

# 取消cursorline高亮
hi! link CursorLineNr LineNr

# --- 交互与行为 ---
set backspace=indent,eol,start  # 更好的退格键行为
set hidden              # 切换缓冲区时不保存
set autoread            # 文件在外部改变时自动读入
set autowrite           # 自动保存 (慎用，按需开启)
set confirm             # 退出前确认
set history=2000        # 历史记录条数
set scrolloff=5         # 光标上下至少保留5行
set sidescrolloff=5     # 左右滑动同理

# --- 文件与撤销 ---
set nobackup            # 不创建备份文件
set noswapfile          # 不创建交换文件
set undofile            # 开启持久化撤销
set fileformat=unix     # 强制以 unix 换行符保存

# --- 映射 (Mappings) ---

# 视觉行移动 (处理折行)
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

# 快捷键简化
nnoremap D d$
nnoremap U <C-r>

# 搜索高亮清除 (按 Esc 清除高亮，很方便)
nnoremap <silent> <Esc> :noh<CR>

# 开启语法高亮
syntax on
filetype plugin indent on
