require "../spec_helper"

module ChalkBox::Styles
  extend self
  describe self do
    it("should return ANSI escape codes") do
      green.open.should eq("\u001b[32m")
      green.close.should eq("\u001b[39m")
      bgGreen.open.should eq("\u001b[42m")
      gray.open.should eq(grey.open)
    end

    it("should group related codes into categories") do
      color.magenta.should eq(magenta)
      bgColor.yellow.should eq(bgYellow)
      bgColor.bgYellow.should eq(bgYellow)
      modifier.bold.should eq(bold)
      modifier.underline.open.should eq(Modifier.underline.open)
      modifier.dim.open.should eq(Modifier::Dim.open)
    end

    it("should return open if convert to String") do
      magenta.to_s.should eq(magenta.open)
      "#{yellow}".should eq(yellow.open)
      "#{reset}".should eq(reset)
      "#{yellow.reset}".should eq(yellow.close)
    end

    it("should support reset") do
      reset.should eq("\u001b[0m")
      color.reset.should eq("\u001b[0m")
      color.green.reset.should eq(green.close)
    end
  end
end
