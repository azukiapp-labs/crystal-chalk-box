require "./spec_helper"

spec_mod ChalkBox, includes: true do
  it "should not raise exception with default args" do
    if STDOUT.tty? # is default for supports
      expect(chalk.red("foo")).must_equal "\e[31mfoo\e[39m"
    else
      expect(chalk.red("foo")).must_equal "foo"
    end
  end
end
