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

    Expect runner#suite() == 'rspec'
  end

  it "remembers the last test-run position when not on test file"
    edit spec/normal_spec.rb
    call runner#file()

    edit foo.txt

    Expect runner#file() == 'rspec spec/normal_spec.rb'
  end

  it "runs last test"
    edit spec/normal_spec.rb
    call runner#nearest()

    edit bar_spec.rb

    Expect runner#last() == 'rspec spec/normal_spec.rb:1'
  end

  it "doesn't raise an error when unable to run tests"
    edit foo.txt
    call runner#nearest() | call runner#file() | call runner#suite() | call runner#last()
  end

  it "can go to the last run test"
    edit +3 spec/normal_spec.rb
    call runner#nearest()

    edit foo.txt
    call runner#visit()

    Expect expand('%') == 'spec/normal_spec.rb'
    Expect line('.') == 3
  end

  it "runs tests on different granularities on alternate file"
    view lib/normal.rb

    Expect runner#nearest() == 'rspec spec/normal_spec.rb'

    Expect runner#file() == 'rspec spec/normal_spec.rb'

    Expect runner#suite() == 'rspec'
  end
end
