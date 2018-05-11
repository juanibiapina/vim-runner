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
  else
    call s:echo_failure('No last runner command')
  endif
endfunction

function! s:run(type) abort
  let alternate_file = get(filter(projectionist#query_file('alternate'), 'filereadable(v:val)'), 0, '')

  if s:has_runner(expand('%'))
    let position = { "file": expand('%:.'), "line": line('.') }
  elseif !empty(alternate_file) && s:has_runner(alternate_file)
    let position = { "file": fnamemodify(alternate_file, ':.'), "line": "" }
  else
    call s:echo_failure("Couldn't determine runner") | return
  endif

  let args = s:build_arg(a:type, position)

  let executable = s:executable(position["file"])
  let cmd = [executable] + args
  call filter(cmd, '!empty(v:val)')

  let g:runner#last_command = join(cmd)
  return join(cmd)
endfunction

function! s:has_runner(file) abort
  let file = fnamemodify(a:file, ":p")
  for [root, value] in projectionist#query('runner', { "file": l:file })
    return 1
  endfor

  return 0
endfunction

function! s:echo_failure(message) abort
  echohl WarningMsg
  echo a:message
  echohl None
endfunction

function! s:build_arg(type, position) abort
  if a:type ==# 'nearest'
    let arg = a:position['file']

    if a:position['line'] !=# ''
      let arg = arg . ":" . a:position["line"]
    endif

    return [arg]
  elseif a:type ==# 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! s:executable(file) abort
  let file = fnamemodify(a:file, ":p")
  for [root, value] in projectionist#query('runner', { "file": l:file })
    return value
  endfor
endfunction
