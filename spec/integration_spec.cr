require "./spec_helper"

class FailedCommand < Exception
  getter stdout : String
  getter stderr : String

  def initialize(message, @stdout, @stderr)
    super message
  end
end

describe "Integration spec" do
  def run(command, env = nil, chdir = nil)
    output, error = IO::Memory.new, IO::Memory.new
    status = Process.run(
      "/bin/sh", input: IO::Memory.new(command), output: output, error: error,
      chdir: chdir, env: env
    )

    if status.success?
      output.to_s
    else
      puts output.to_s
      puts error.to_s
      raise FailedCommand.new("command failed: #{command}", output.to_s, error.to_s)
    end
  end

  let(:chdir) { File.join(__DIR__, "../examples/basic") }

  it "should puts without colors" do
    output = run("crystal run src/basic.cr", chdir: chdir)
    expect(output).must_equal "green fields\n"
  end

  it "should puts with colors if forced with args" do
    command = "crystal run src/basic.cr -- --color"
    output = run(command, chdir: chdir)
    chalk = ChalkBox::Base.new(enable: true)
    expect(output).must_equal chalk.green("green fields\n")
  end
end
