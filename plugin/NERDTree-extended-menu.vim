if exists("g:loaded_nerdtree_extended_menu")
    finish
endif

let g:loaded_nerdtree_extended_menu = 1

let searchSubmenu = NERDTreeAddSubmenu({
    \ 'text': '(s)earch files',
    \ 'shortcut': 's',
    \ })

call NERDTreeAddMenuItem({
    \ 'parent': searchSubmenu,
    \ 'text': 'Case (i)nsensitive',
    \ 'shortcut': 'i',
    \ 'callback': 'NEMSearchCaseInsensetive'
    \ })

call NERDTreeAddMenuItem({
    \ 'parent': searchSubmenu,
    \ 'text': 'Case (s)ensetive',
    \ 'shortcut': 's',
    \ 'callback': 'NEMSearchCaseSensetive'
    \ })

let replaceSubmenu = NERDTreeAddSubmenu({
    \ 'text': '(g)replace',
    \ 'shortcut': 'g',
    \ })

call NERDTreeAddMenuItem({
    \ 'parent': replaceSubmenu,
    \ 'text': 'Case (i)nsensitive',
    \ 'shortcut': 'i',
    \ 'callback': 'NEMReplaceCaseInsensetive'
    \ })

call NERDTreeAddMenuItem({
    \ 'parent': replaceSubmenu,
    \ 'text': 'Case (s)ensetive',
    \ 'shortcut': 's',
    \ 'callback': 'NEMReplaceCaseSensetive'
    \ })

function! NEMSearchCaseSensetive()
  call nem#Search(0)
endfunction

function! NEMSearchCaseInsensetive()
  call nem#Search(1)
endfunction

function! NEMReplaceCaseSensetive()
  call nem#Replace(0)
endfunction

function! NEMReplaceCaseInsensetive()
  call nem#Replace(1)
endfunction


