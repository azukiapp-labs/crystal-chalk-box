require "../spec_helper"

module ChalkBox::SpecHelpers
  class MockFD < IO::FileDescriptor
    def initialize(@tty, *args)
      super(*args)
    end

    def tty?
      return @tty
    end
  end
end

spec_mod ChalkBox::Supports do
  let(:argv) { [] of String }
  let(:env) { {} of String => String }
  let(:stdout) { MockFD.new(true, File.open(__FILE__).fd) }

  it "should not raise exception with default args" do
    support = subject.new
    expect(support.hasBasic).must_equal(STDOUT.tty?)
  end

  it "should return true if `COLORTERM` is in env" do
    env = {"COLORTERM": "true"}
    support = subject.new(env, argv, stdout)
    expect(support.hasBasic).must_equal(true)
    expect(support.level).must_equal(1)
  end

  describe "if basics TERMS" do
    it "should not support by default" do
      support = subject.new(env, argv)
      expect(support.hasBasic).must_equal(false)
      expect(support.level).must_equal(0)
    end

    it "should not support if dump term" do
      env = {"TERM": "dump"}
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(false)
      expect(support.level).must_equal(0)
    end

    it "should support basics TERM" do
      env = {"TERM": "xterm"}
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)
      expect(support.level).must_equal(1)
    end
  end

  describe "if xterm is 256 colors" do
    let(:env) { {"TERM": "xterm-256color"} }

    it "should support by default" do
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)
      expect(support.has256).must_equal(true)
    end

    it("should return false if --no-color or --no-colors flag is used") do
      argv = ["--no-color"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(false)

      argv = ["--no-colors"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(false)
    end

    it "should return true if --color or --colors flag is used" do
      argv = ["--color"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)

      argv = ["--colors"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)
    end

    it "should support `--color=true` or `--colors=always` flag" do
      argv = ["--color=true"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)

      argv = ["--color=1"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)

      argv = ["--colors=always"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)
    end

    it "should support `--color=false` or `--colors=0` flag" do
      argv = ["--color=false"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(false)

      argv = ["--color=0"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(false)
    end

    it "should support `--color=256` flag" do
      argv = ["--color=256"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)
      expect(support.level).must_equal(2)
      expect(support.has256).must_equal(true)
    end

    it "should support `full`, `16m` or `truecolor` flag" do
      argv = ["--color=full"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)
      expect(support.level).must_equal(3)
      expect(support.has256).must_equal(true)
      expect(support.has16m).must_equal(true)

      argv = ["--color=16m"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)
      expect(support.level).must_equal(3)

      argv = ["--colors=truecolor"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)
      expect(support.level).must_equal(3)
    end

    it "should ignore post-terminator flags" do
      argv = ["--color", "--", "--no-color"]
      support = subject.new(env, argv, stdout)
      expect(support.hasBasic).must_equal(true)
    end
  end

  it("should return false if not TTY") do
    stdout = MockFD.new(false, File.open(__FILE__).fd)
    support = subject.new(env, argv, stdout)
    expect(support.hasBasic).must_equal(false)
  end

  it("should return true if `FORCE_COLOR` is in env") do
    env = {"FORCE_COLOR": "true"}
    argv = ["--color=false"]
    support = subject.new(env)
    expect(support.hasBasic).must_equal(true, "FORCE_COLOR")
    expect(support.level).must_equal(1)
  end

  it "should allow tests of the properties on false" do
    env = {"TERM": "xterm-256color"}
    argv = ["--color=false"]
    support = subject.new(env, argv)
    expect(support.hasBasic).must_equal(false)
    expect(support.has256).must_equal(false)
    expect(support.has16m).must_equal(false)
    expect(support.level).must_equal(0)
  end
end
