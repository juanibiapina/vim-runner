source spec/support/helpers.vim

describe "Rspec zeus"

  before
    cd spec/fixtures/rspec-zeus
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 spec/normal_spec.rb

    Expect runner#nearest() == 'zeus rspec spec/normal_spec.rb:1'
  end

  it "runs file tests"
    view spec/normal_spec.rb

    Expect runner#file() == 'zeus rspec spec/normal_spec.rb'
  end

end
