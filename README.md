# runner.vim

Determine runner commands based on [projectionist](https://github.com/tpope/vim-projectionist) configuration.

## Usage

This plugin allows you to configure runner commands using the power of [projectionist](https://github.com/tpope/vim-projectionist). All you need to do is define a `runner` for a file pattern.

For instance with these heuristics:

```vimscript
let g:projectionist_heuristics = {
  \  "bin/rspec" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "bin/rspec",
  \    },
  \  },
  \  "Gemfile" : {
  \    "spec/*_spec.rb" : {
  \      "runner" : "bundle exec rspec",
  \    },
  \  },
  \  "*.gemspec" : {
  \    "spec/*_spec.rb" : {
  \      "alternate": "lib/{}.rb",
  \    },
  \    "lib/*.rb" : {
  \      "alternate": "spec/{}_spec.rb",
  \    },
  \  },
  \}
```

- When on a gem without binstubs, editing an `rspec` file on line 10:
  - `runner#nearest`: `bundle exec rspec spec/file_spec.rb:10`
  - `runner#file`: `bundle exec rspec spec/file_spec.rb`

- When on a gem without binstubs, editing a `lib` file on line 20:
  - `runner#nearest`: `bundle exec rspec spec/file_spec.rb`
  - `runner#file`: `bundle exec rspec spec/file_spec.rb`

- When on a gem with binstubs, editing an `rspec` file on line 10:
  - `runner#nearest`: `bin/rspec spec/file_spec.rb:10`
  - `runner#file`: `bin/rspec spec/file_spec.rb`

- When on a gem with binstubs, editing a `lib` file on line 20:
  - `runner#nearest`: `bin/rspec spec/file_spec.rb`
  - `runner#file`: `bin/rspec spec/file_spec.rb`

Note how it automatically detects the alternate file.

There is also `runner#last` which just returns the last command built.

To actually run the command, use any runner of your choice. You can find a list of interesting implementations here: https://github.com/janko-m/vim-test/blob/master/autoload/test/strategy.vim

For more options on how to configure runner commands per project, check out [projectionist](https://github.com/tpope/vim-projectionist) documentation.

## Credits

Much of the inspiration for this projection came from [vim-test](https://github.com/janko-m/vim-test). If you're looking for an out of the box, zero configuration (but customizable) solution that works for many languages, try that instead.
