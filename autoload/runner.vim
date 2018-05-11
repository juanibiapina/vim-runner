function! runner#nearest() abort
  return s:run('nearest')
endfunction

function! runner#file() abort
  return s:run('file')
endfunction

function! runner#suite() abort
  return s:run('suite')
endfunction

function! runner#last() abort
  if exists('g:runner#last_command')
    return g:runner#last_command
  endif

  throw 'vim-runner: no last runner command'
endfunction

function! s:run(type) abort
  let alternate_file = get(filter(projectionist#query_file('alternate'), 'filereadable(v:val)'), 0, '')

  if s:has_runner(expand('%'))
    let position = { "file": expand('%:.'), "line": line('.') }
  elseif !empty(alternate_file) && s:has_runner(alternate_file)
    let position = { "file": fnamemodify(alternate_file, ':.') }
  else
    throw "vim-runner: couldn't determine runner"
  endif

  let cmd = s:determine_command(a:type, position)

  let cmd_str = s:to_string(cmd)

  let g:runner#last_command = cmd_str

  return cmd_str
endfunction

function! s:to_string(cmd)
  let result = a:cmd["runner"]

  if has_key(a:cmd, "file")
    let result .= " " . a:cmd["file"]

    if has_key(a:cmd, "line")
      let result .= ":" . a:cmd["line"]
    endif
  endif

  return result
endfunction

function! s:has_runner(file) abort
  let file = fnamemodify(a:file, ":p")
  for [root, value] in projectionist#query('runner', { "file": l:file })
    return 1
  endfor

  return 0
endfunction

function! s:determine_command(type, position)
  let command = {}

  let command["runner"] = s:determine_runner(a:position["file"])

  if a:type !=# 'suite'
    if has_key(a:position, "file")
      let command["file"] = a:position["file"]
    endif
  endif

  if a:type ==# 'nearest'
    if has_key(a:position, "line")
      let command["line"] = a:position["line"]
    endif
  endif

  return command
endfunction

function! s:determine_runner(file) abort
  let file = fnamemodify(a:file, ":p")
  for [root, value] in projectionist#query('runner', { "file": l:file })
    return value
  endfor
endfunction
