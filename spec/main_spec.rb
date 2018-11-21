RSpec.describe 'Main' do
  before do
    FileUtils.copy_entry(File.expand_path("../../spec/fixtures/rspec-other", __FILE__), ".")
  end

  it "runs tests on different granularities" do
    vim.edit "spec/normal_spec.rb"
    vim.feedkeys "2G"

    expect(vim.command("echo runner#nearest()")).to eq("rspec spec/normal_spec.rb:2")
    expect(vim.command("echo runner#file()")).to eq("rspec spec/normal_spec.rb")
  end

  it "runs last test" do
    vim.edit "spec/normal_spec.rb"
    vim.command("call runner#nearest()")

    vim.edit "bar_spec.rb"

    expect(vim.command("echo runner#last()")).to eq("rspec spec/normal_spec.rb:1")
  end

  it "runs tests for files in quickfix list with runners (uniquely)" do
    vim.edit "spec/normal_spec.rb"
    vim.command "let &g:errorformat = '%f:%l'"
    vim.command "caddexpr 'spec/file1_spec.rb:10'"
    vim.command "caddexpr 'spec/file2_spec.rb:20'"
    vim.command "caddexpr 'spec/file1_spec.rb:30'"
    vim.command "caddexpr 'other:30'"

    expect(vim.command("echo runner#quickfix()")).to eq("rspec spec/file1_spec.rb spec/file2_spec.rb")
  end

  it "runs tests on different granularities on alternate file" do
    vim.edit "lib/normal.rb"

    expect(vim.command("echo runner#nearest()")).to eq("rspec spec/normal_spec.rb")
    expect(vim.command("echo runner#file()")).to eq("rspec spec/normal_spec.rb")
  end
end
