function! nem#doReplace(caseInsensetive)
    let cd = g:NERDTreeDirNode.GetSelected().path.str()
    let pattern = nem#Search(a:caseInsensetive)

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
      let substituteFlags = a:caseInsensetive ? 'I' : 'i'
      let newText = substitute(text, pattern, replacement, substituteFlags)
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


function! nem#Replace(caseInsensetive)

    " ALE echoes errors. Interferes with promt
    let shouldToggleALE = exists('g:ale_enabled') && g:ale_enabled
    if shouldToggleALE
      ALEDisable
    endif

    call nem#doReplace(a:caseInsensetive)

    if shouldToggleALE
      ALEEnable
    endif
endfunction


function! nem#Search(caseInsensetive)
    let cd = g:NERDTreeDirNode.GetSelected().path.str()
    let pattern = input("Enter the pattern: ")
    if pattern == ''
        return
    endif
    let ackFlags = a:caseInsensetive ? '-i' : ''
    call ack#Ack('grep!', ackFlags . " " . shellescape(pattern) . " " . shellescape(cd))
    return pattern
endfunction

function! nem#Terminal()
    let cd = g:NERDTreeDirNode.GetSelected().path.str()
    silent execute "!open -a Terminal " . cd
endfunction

