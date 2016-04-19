require "chalk_box"

module Basic
  extend ChalkBox
  extend self

  def main
    puts chalk.green("green fields")
  end
end

Basic.main
