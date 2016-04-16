class ChalkBox::Supports
  def initialize(@env = ENV, @argv = ARGV, @stdout = STDOUT)
    @level = -1
    @argv = @argv.take_while { |arg| arg != "--" }
  end

  macro def_has(name, level)
    def {{name.id}}
      return level >= {{level}}
    end
  end

  def_has(hasBasic, 1)
  def_has(has256, 2)
  def_has(has16m, 3)

  def level
    if (@level < 0)
      @level = support
      @level = 1 if @level == 0 && env_flag(@env, "FORCE_COLOR")
    end
    return @level
  end

  private def support
    if has_flag(@argv, [
         "color=false", "colors=false",
         "color=0", "colors=0",
         "no-color", "no-colors",
         "no-colors=false", "no-colors=0",
       ])
      return 0
    elsif has_flag(@argv, [
            "color", "colors",
            "color=true", "colors=true",
            "color=1", "colors=1",
            "color=always", "colors=always",
          ])
      return 1
    elsif has_flag(@argv, ["color=256", "colors=256"])
      return 2
    elsif has_flag(@argv, [
            "color=full", "colors=full",
            "color=16m", "colors=16m",
            "color=truecolor", "colors=truecolor",
          ])
      return 3
    elsif !@stdout.tty?
      return 0
    elsif env_flag(@env, "COLORTERM")
      return 1
    elsif /^xterm-256(?:color)?/ =~ @env["TERM"]
      return 2
    elsif /^screen|^xterm|^vt100|color|ansi|cygwin|linux/i =~ @env["TERM"]
      return 1
    else
      return 0
    end
  end

  private def env_flag(env : Hash(String, String), key)
    value = env[key]?
    !(value.nil? || ["false", "0", "not"].includes?(value))
  end

  private def has_flag(argv, flags : Array)
    flags.any? { |flag| has_flag(argv, flag) }
  end

  private def has_flag(argv, flag : String)
    argv.includes?("--#{flag}")
  end
end
