describe user('david') do
  it { should exist }
end

describe directory('/home/david') do
  it { should exist }
end

describe user('oscar') do
  it { should_not exist }
end

[
  "emacs",
  "python",
  "wget",
  "vim-enhanced",
  "tmux",
].each do |item|
  describe package(item) do
    it { should be_installed }
  end
end
