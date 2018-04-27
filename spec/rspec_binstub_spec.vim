source spec/support/helpers.vim

describe "Rspec binstub"

  before
    cd spec/fixtures/rspec-binstub
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 spec/normal_spec.rb

    Expect runner#nearest() == 'bin/rspec spec/normal_spec.rb:1'
  end

  it "runs file tests"
    view spec/normal_spec.rb

    Expect runner#file() == 'bin/rspec spec/normal_spec.rb'
  end

  it "runs test suites"
    view spec/normal_spec.rb

    Expect runner#suite() == 'bin/rspec'
  end

end
