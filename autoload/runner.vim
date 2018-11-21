function! runner#nearest() abort
  return s:run('nearest')
endfunction

function! runner#file() abort
  return s:run('file')
endfunction

function! runner#last() abort
  if exists('g:runner#last_command')
    return g:runner#last_command
  endif

  throw 'vim-runner: no last runner command'
endfunction

function! runner#cached() abort
  let cmds = {}
  let items = systemlist("git diff --cached --name-only")
  for item in items
    let position = { "file": item }

    if !s:has_runner(position["file"])
      let alternate_file = s:query_alternate(position["file"])

      if s:has_runner(alternate_file)
        let position = { "file": alternate_file }
      else
        continue
      endif
    endif

    let cmd = s:determine_command('file', position)

    if !has_key(cmds, cmd["runner"])
      let cmds[cmd["runner"]] = []
    endif

    call add(cmds[cmd["runner"]], cmd["file"])
  endfor

  call map(values(cmds), "uniq(sort(v:val))")

  let result = ""
  for entry in items(cmds)
    let result .= entry[0]
    for file in entry[1]
      let result .= " " . file
    endfor
  endfor

  let g:runner#last_command = result
  return result
endfunction

function! runner#quickfix() abort
  let cmds = {}
  let items = getqflist()
  for item in items
    let position = { "file": bufname(item.bufnr) }

    if !s:has_runner(position["file"])
      let alternate_file = s:query_alternate(position["file"])

      if s:has_runner(alternate_file)
        let position = { "file": alternate_file }
      else
        continue
      endif
    endif

    let cmd = s:determine_command('file', position)

    if !has_key(cmds, cmd["runner"])
      let cmds[cmd["runner"]] = []
    endif

    call add(cmds[cmd["runner"]], cmd["file"])
  endfor

  call map(values(cmds), "uniq(sort(v:val))")

  let result = ""
  for entry in items(cmds)
    let result .= entry[0]
    for file in entry[1]
      let result .= " " . file
    endfor
  endfor

  let g:runner#last_command = result
  return result
endfunction

function! s:run(type) abort
  let position = s:determine_position()
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

function! s:query_alternate(file) abort
  let file = fnamemodify(a:file, ":p")

  return get(filter(map(projectionist#query("alternate", { "file": file }), "v:val[1]"), "filereadable(v:val)"), 0, "")
endfunction

function! s:determine_position() abort
  let alternate_file = s:query_alternate(expand('%'))

  if s:has_runner(expand('%'))
    return { "file": expand('%:.'), "line": line('.') }
  elseif !empty(alternate_file) && s:has_runner(alternate_file)
    return { "file": fnamemodify(alternate_file, ':.') }
  endif

  throw "vim-runner: couldn't determine runner"
endfunction

function! s:determine_command(type, position)
  let command = {}

  let command["runner"] = s:determine_runner(a:position["file"])

  if has_key(a:position, "file")
    let command["file"] = a:position["file"]
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
