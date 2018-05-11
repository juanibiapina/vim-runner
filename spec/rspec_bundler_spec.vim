source spec/support/helpers.vim

describe "Rspec bundler"

  before
    cd spec/fixtures/rspec-bundler
  end

  after
    call Teardown()
    cd -
  end

  it "runs nearest tests"
    view +1 spec/normal_spec.rb

    Expect runner#nearest() == 'bundle exec rspec spec/normal_spec.rb:1'
  end

  it "runs file tests"
    view spec/normal_spec.rb

    Expect runner#file() == 'bundle exec rspec spec/normal_spec.rb'
  end

end
