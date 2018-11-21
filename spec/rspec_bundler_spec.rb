RSpec.describe "Rspec bundler" do

  before do
    FileUtils.copy_entry(File.expand_path("../../spec/fixtures/rspec-bundler", __FILE__), ".")
  end

  it "runs nearest tests" do
    vim.edit "spec/normal_spec.rb"
    vim.feedkeys "1G"

    expect(vim.command("echo runner#nearest()")).to eq("bundle exec rspec spec/normal_spec.rb:1")
  end

  it "runs file tests" do
    vim.edit "spec/normal_spec.rb"

    expect(vim.command("echo runner#file()")).to eq("bundle exec rspec spec/normal_spec.rb")
  end

end
