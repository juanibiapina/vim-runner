source spec/support/helpers.vim

describe 'Main'

  before
    cd spec/fixtures/rspec-other
  end

  after
    call Teardown()
    cd -
  end

  it "runs tests on different granularities"
    view +2 spec/normal_spec.rb

    Expect runner#nearest() == 'rspec spec/normal_spec.rb:2'

    Expect runner#file() == 'rspec spec/normal_spec.rb'
  end

  it "runs last test"
    edit spec/normal_spec.rb
    call runner#nearest()

    edit bar_spec.rb

    Expect runner#last() == 'rspec spec/normal_spec.rb:1'
  end

  it "runs tests for files in quickfix list with runners (uniquely)"
    edit spec/normal_spec.rb
    let &g:errorformat = '%f:%l'
    caddexpr "spec/file1_spec.rb:10"
    caddexpr "spec/file2_spec.rb:20"
    caddexpr "spec/file1_spec.rb:30"
    caddexpr "other:30"

    Expect runner#quickfix() == 'rspec spec/file1_spec.rb spec/file2_spec.rb'
  end

  it "runs tests on different granularities on alternate file"
    view lib/normal.rb

    Expect runner#nearest() == 'rspec spec/normal_spec.rb'

    Expect runner#file() == 'rspec spec/normal_spec.rb'
  end
end
