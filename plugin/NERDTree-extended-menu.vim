if exists("g:loaded_nerdtree_ack")
    finish
endif

let g:loaded_nerdtree_ack = 1

call NERDTreeAddMenuItem({
    \ 'text': '(s)earch files, case insensitive',
    \ 'shortcut': 's',
    \ 'callback': 'NERDTreeAck' })

call NERDTreeAddMenuItem({
    \ 'text': 'Replace (g)',
    \ 'shortcut': 'g',
    \ 'callback': 'NERDTreeReplace' })

function! NERDTreeReplace() 
    " get the current dir from NERDTree
    let cd = g:NERDTreeDirNode.GetSelected().path.str()
    " get the pattern
    let pattern = input("Enter the pattern: ")
    let flags = ''     " TODO
    if pattern == ''
        return
    endif
    let replacement = input("Enter the replacement: ")
    :hi Pattern cterm=bold gui=inverse
    call ack#Ack('grep!', "-i ".shellescape(pattern)." ".shellescape(cd))


    if empty(getqflist())
      return
    endif

    let yesAll = 0

    :cfirst

    let lines = getqflist()


    let i = -1

    for line in lines
      let i += 1

      let lnum = line.lnum
      let startCol = line.col
      let fullText = getline(lnum)
      let preText = strpart(fullText, 0, startCol - 1)
      let text = strpart(fullText, startCol - 1)
      let newText = substitute(text, pattern, replacement, flags) 
      let newFullText = preText . newText
      let endCol = matchend(fullText, pattern, line.col - 1)
      let delta = len(newText) - len(text)

      if yesAll == 0
        let ms = startCol - 1
        let me = endCol + 1
        execute 'match Pattern /\%<'.me.'v\%>'.ms.'v\%'.lnum.'l/'
        redraw
        echo "Replace with ". replacement ."? (y/n/a/q)"
        let ans = '-'
        while ans !~? '[ynab]'
          let ans = nr2char(getchar())
          if ans == 'q' || ans == "\<Esc>"
            redraw " see :h echo-redraw
            echo
            :match
            return
          endif
        endwhile
        
        if ans == 'n'
        elseif ans == 'a'
          let yesAll = 1
        endif
      endif

      if (ans == 'y' || yesAll)
        call setline(lnum, newFullText)
        let lia = i + 1
        while (lia < len(lines) && lines[lia].bufnr == line.bufnr)
          let lines[lia].bufnr += delta
          let lia += 1
        endwhile
      endif

      redraw " see :h echo-redraw
      echo
      :match

      try
        :cnext
      catch /^Vim\%((\a\+)\)\=:E553/ " no more lines
      endtry        
    endfor
endfunction

function! NERDTreeReplaceLine(line, pattern, replacement) 
  lnext:
endfunction

function! NERDTreeAck()
    " get the current dir from NERDTree
    let cd = g:NERDTreeDirNode.GetSelected().path.str()

    " get the pattern
    let pattern = input("Enter the pattern: ")
    let flags = '' " TODO
    if pattern == ''
        return
    endif
    call ack#Ack('grep!', "-i ".shellescape(pattern)." ".shellescape(cd))
endfunction

