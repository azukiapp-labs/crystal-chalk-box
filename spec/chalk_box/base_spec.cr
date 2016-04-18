require "../spec_helper"

spec_mod ChalkBox::Base do
  it "should not raise exception with default args" do
    chalk = subject.new
    if STDOUT.tty? # is default for supports
      expect(chalk.red("foo")).must_equal "\e[31mfoo\e[39m"
    else
      expect(chalk.red("foo")).must_equal "foo"
    end
  end

  it "should not output colors when manually disabled" do
    chalk = subject.new(enable: false)
    expect(chalk.red("foo")).must_equal "foo"
  end

  it "should create a isolated context where colors can be disabled" do
    chalk_disabled = subject.new(enable: false)
    chalk_enabled = subject.new(enable: true)

    expect(chalk_disabled.red("foo")).must_equal "foo"
    expect(chalk_enabled.red("foo")).must_equal "\u001b[31mfoo\u001b[39m"
  end

  it "should expose the styles as ANSI escape codes" do
    chalk = subject.new
    expect(chalk.styles.red.open).must_equal "\u001b[31m"
  end

  describe "with support test object" do
    it "should format with colors if COLORTERM env is set" do
      env = {"FORCE_COLOR": "true"}
      support = ChalkBox::Supports.new(env)
      chalk = subject.new(enable: support)
      expect(chalk.underline("foo")).must_equal "\u001b[4mfoo\u001b[34m"
    end

    it "should not output colors when COLORTERM env is set false" do
      env = {"FORCE_COLOR": "false"}
      support = ChalkBox::Supports.new(env)
      chalk = subject.new(enable: support)
      expect(chalk.underline("foo")).must_equal "foo"
    end
  end

  describe "with enabled colors" do
    let(:chalk) { subject.new(enable: true) }

    it "should style string" do
      expect(chalk.underline("foo")).must_equal "\u001b[4mfoo\u001b[34m"
      expect(chalk.red("foo")).must_equal "\u001b[31mfoo\u001b[39m"
      expect(chalk.bgRed("foo")).must_equal "\u001b[41mfoo\u001b[49m"
    end

    it "should support applying multiple styles at once" do
      expected = "\u001b[31m\u001b[42m\u001b[4mfoo\u001b[34m\u001b[49m\u001b[39m"
      expect(chalk.red.bgGreen.underline("foo")).must_equal expected

      expected = "\u001b[4m\u001b[31m\u001b[42mfoo\u001b[49m\u001b[39m\u001b[34m"
      expect(chalk.underline.red.bgGreen("foo")).must_equal expected
    end

    it "should support nesting styles" do
      expected = "\u001b[31mfoo\u001b[4m\u001b[44mbar\u001b[49m\u001b[34m!\u001b[39m"
      result = chalk.red("foo#{chalk.underline.bgBlue("bar")}!")
      expect(result).must_equal expected
    end

    it "should reset all styles with `.reset()`" do
      expected = "\u001b[0m\u001b[31m\u001b[42m\u001b[4mfoo\u001b[34m\u001b[49m\u001b[39mfoo\u001b[0m"
      result = chalk.reset("#{chalk.red.bgGreen.underline("foo")}foo")
      expect(result).must_equal expected
    end

    it "should be able to cache multiple styles" do
      chalk = subject.new(enable: true)
      green = ->chalk.green(String)
      red = ->chalk.red(String)
      expect(red.call("foo")).must_equal chalk.red("foo")
      expect(red.call("foo")).wont_match green.call("foo")
    end

    it "should alias gray to grey" do
      expect(chalk.grey("foo")).must_equal "\u001b[37mfoo\u001b[39m"
    end

    it "should support variable number of arguments" do
      expect(chalk.red("foo", "bar")).must_equal "\u001b[31mfoo bar\u001b[39m"
      expect(chalk.red("foo", 1, :bar)).must_equal "\u001b[31mfoo 1 bar\u001b[39m"
    end

    it "should support falsy values" do
      expect(chalk.red(0)).must_equal "\u001b[31m0\u001b[39m"
    end

    it "shouldn't output escape codes if the input is empty" do
      expect(chalk.red("")).must_equal ""
      expect(chalk.red.blue.black("")).must_equal ""
    end

    it "line breaks should open and close colors" do
      expected = "\u001b[37mhello\u001b[39m\n\n\u001b[37mworld\u001b[39m"
      expect(chalk.grey("hello\n\nworld")).must_equal expected
    end
  end
end
