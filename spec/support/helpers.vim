runtime! plugin/projectionist.vim

let g:projectionist_heuristics = {
  \  "*.gemspec" : {
  \    "spec/*_spec.rb" : {
  \      "alternate": "lib/{}.rb",
  \    },
  \    "lib/*.rb" : {
  \      "alternate": "spec/{}_spec.rb",
  \    }
  \  },
  \  "bin/rspec" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "bin/rspec"
  \    },
  \  },
  \  ".zeus.sock" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "zeus rspec"
  \    },
  \  },
  \  "Gemfile" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "bundle exec rspec"
  \    },
  \  },
  \  "!bin/rspec&!.zeus.sock&!Gemfile" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "rspec"
  \    },
  \  }
  \}

function! Teardown() abort
  bufdo! bdelete!
  unlet! g:runner#last_command g:runner#last_position
endfunction
