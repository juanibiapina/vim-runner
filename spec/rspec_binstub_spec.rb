RSpec.describe "Rspec binstub" do

  before do
    FileUtils.copy_entry(File.expand_path("../../spec/fixtures/rspec-binstub", __FILE__), ".")
  end

  it "runs nearest tests" do
    vim.edit "spec/normal_spec.rb"
    vim.feedkeys "1G"

    expect(vim.command("echo runner#nearest()")).to eq("bin/rspec spec/normal_spec.rb:1")
  end

  it "runs file tests" do
    vim.edit "spec/normal_spec.rb"

    expect(vim.command("echo runner#file()")).to eq("bin/rspec spec/normal_spec.rb")
  end

end
