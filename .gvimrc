"全般
set t_Co=256
"colorscheme rdark
"colorscheme desert
colorscheme edark
let edark_current_line=1
let edark_ime_cursor=1
let edark_insert_status_line=1

"edark
"http://eureka.pasela.org/

"Low-Contrast Color Schemes
"http://www.vim.org/scripts/script.php?script_id=1448

"rdark
"http://www.vim.org/scripts/script.php?script_id=1732

"ChocolateLiquor
"http://www.vim.org/scripts/script.php?script_id=592

"81桁目以降を強調表示
"hi over80column guibg=dimgray
"match over80column /.\%>81v/

"ウィンドウ関係
set guioptions-=T
if hostname() ==? 'LUNA'
  set columns=160
  set lines=65
  winpos 70 70
elseif hostname() ==? 'SATELLA'
  set columns=110
  set lines=35
  winpos 100 15
else
  set columns=140
  set lines=55
  winpos 70 70
endif
set cmdheight=2  "コマンドラインの高さ(GUI使用時)
if has('win32')
"  set guifont=MS_Gothic:h10:cSHIFTJIS
"  set guifont=Consolas:h9:cSHIFTJIS
"  set guifont=MeiryoKe_Console:h10:cSHIFTJIS,M+1VM+IPAG_circle:h10:cSHIFTJIS,MS_Gothic:h10:cSHIFTJIS
  set guifont=M+1VM+IPAG_circle:h10:cSHIFTJIS,MS_Gothic:h10:cSHIFTJIS
else
  set guifont=M+1VM+IPAG\ circle\ 10
endif

"メニュー関係
set winaltkeys=no "Alt+xでメニューをフォーカスしない
" Alt+Spaceでウィンドウのシステムメニュー
nnoremap <silent> <M-Space> :<C-u>simalt ~<CR>

"タブ関係
set guitablabel=%M\ %-20.20t

"マウス関係
set mouse=a
" マウスの移動でフォーカスを自動的に切替えない (mousefocus:切替る)
set nomousefocus
" 入力時にマウスポインタを隠す (nomousehide:隠さない)
set mousehide

"IME関係
if has('multi_byte_ime') || has('xim')
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
"    set imactivatekey=C-space
    set imactivatekey=Zenkaku_Hankaku
  endif
  " 挿入モードでのIME状態を記憶させない
  inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

"クリップボード関係
inoremap <S-Insert> <C-R><C-O>+
nnoremap <S-Insert> "+P
vnoremap <S-Insert> "+p
vnoremap <C-Insert> "+y
vnoremap <S-Delete> "+x

"URLをブラウザで開く
"Chaliceからfunction拝借
"let BrowserPath = 'C:\Program Files\Mozilla Firefox\firefox.exe'
function! AL_execute(cmd)
  if 0 && exists('g:AL_option_nosilent') && g:AL_option_nosilent != 0
    execute a:cmd
  else
    silent! execute a:cmd
  endif
endfunction

function! s:AL_open_url_win32(url)
  let url = substitute(a:url, '%', '%25', 'g')
  if url =~# ' '
    let url = substitute(url, ' ', '%20', 'g')
    let url = substitute(url, '^file://', 'file:/', '')
  endif
  " If 'url' has % or #, all of those characters are expanded to buffer name
  " by execute().  Below escape() suppress this.  system() does not expand
  " those characters.
  let url = escape(url, '%#')
  " Start system related URL browser
  if !has('win95') && url !~ '[&!]'
    " for Win NT/2K/XP
    call AL_execute('!start /min cmd /c start ' . url)
    " MEMO: "cmd" causes some side effects.  Some strings like "%CD%" is
    " expanded (may be environment variable?) by cmd.
  else
    " It is known this rundll32 method has a problem when opening URL that
    " matches http://*.html.  It is better to use ShellExecute() API for
    " this purpose, open some URL.  Command "cmd" and "start" on NT/2K?XP
    " does this.
    call AL_execute("!start rundll32 url.dll,FileProtocolHandler " . url)
  endif
endfunction

function! Browser()
    let line0 = getline(".")
    let line = matchstr(line0, "http[^ ]*")
    if line==""
      let line = matchstr(line0, "ftp[^ ]*")
    endif
    if line==""
      let line = matchstr(line0, "file[^ ]*")
    endif
"    exec ":silent !start \"" . g:BrowserPath . "\" \"" . line . "\""
    call s:AL_open_url_win32(line)
endfunction
map <Leader>w :<C-u>call Browser()<CR>

" vim:set ts=2 sts=2 sw=2 et:
