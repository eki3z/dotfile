" ==========================================
" 旧版 Vimscript 配置 (.vimrc)
" ==========================================

" --- 基础显示设置 ---
set number              " 显示行号
set cursorline          " 高亮当前行
set showmatch           " 显示匹配的括号
set laststatus=2        " 总是显示状态栏
set ruler               " 显示光标位置
set wildmenu            " 命令行补全菜单
set mouse=a             " 开启鼠标支持
set termguicolors       " 开启真彩色支持

" --- 模式切换：光标形状 ---
" 在旧版中，修改 &t_xx 变量必须使用 let
let &t_SI = "\<Esc>[6 q" " 插入模式：细线
let &t_EI = "\<Esc>[2 q" " 普通模式：块状
let &t_SR = "\<Esc>[4 q" " 替换模式：下划线

" --- 搜索设置 ---
set ignorecase          " 搜索时忽略大小写
set smartcase           " 如果搜索词包含大写，则不忽略大小写
set incsearch           " 边输入边高亮
set hlsearch            " 高亮搜索结果
set wrapscan            " 循环搜索

" --- 高亮样式修改 ---
" 让当前行行号与普通行号样式一致（取消下划线）
highlight! link CursorLineNr LineNr

" --- 交互与行为 ---
set backspace=indent,eol,start  " 更好的退格键行为
set hidden              " 切换缓冲区时不保存
set autoread            " 文件在外部改变时自动读入
" set autowrite         " 自动保存 (按需开启)
set confirm             " 退出前确认
set history=2000        " 历史记录条数
set scrolloff=5         " 光标上下至少保留5行
set sidescrolloff=5     " 左右滑动同理

" --- 文件与撤销 ---
set nobackup            " 不创建备份文件
set noswapfile          " 不创建交换文件
set undofile            " 开启持久化撤销
set fileformat=unix     " 强制以 unix 换行符保存

" --- 映射 (Mappings) ---

" 视觉行移动 (处理折行)
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" 快捷键简化
nnoremap D d$
nnoremap U <C-r>

" 搜索高亮清除 (按 Esc 清除高亮)
nnoremap <silent> <Esc> :noh<CR>

" --- 自动化：插入模式禁用 cursorline ---
" 这是为了满足你之前提到的“不希望在插入模式生效”的需求
augroup CursorLineControl
    autocmd!
    autocmd InsertEnter * set nocursorline
    autocmd InsertLeave * set cursorline
augroup END

" --- 开启语法高亮 ---
syntax on
filetype plugin indent on
