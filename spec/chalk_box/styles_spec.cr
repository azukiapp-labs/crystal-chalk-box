require "../spec_helper"

spec_mod ChalkBox::Styles, includes: true do
  it("should return ANSI escape codes") do
    expect(green.open).must_equal("\u001b[32m")
    expect(green.close).must_equal("\u001b[39m")
    expect(bgGreen.open).must_equal("\u001b[42m")
    expect(gray.open).must_equal(grey.open)
  end

  it("should group related codes into categories") do
    expect(color.magenta).must_equal(magenta)
    expect(bgColor.yellow).must_equal(bgYellow)
    expect(bgColor.bgYellow).must_equal(bgYellow)
    expect(modifier.bold).must_equal(bold)
    expect(modifier.underline.open).must_equal(Modifier.underline.open)
    expect(modifier.dim.open).must_equal(Modifier::Dim.open)
  end

  it("should return open if convert to String") do
    expect(magenta.to_s).must_equal(magenta.open)
    expect("#{yellow}").must_equal(yellow.open)
    expect("#{reset}").must_equal(reset)
    expect("#{yellow.reset}").must_equal(yellow.close)
  end

  it("should support reset") do
    expect(reset).must_equal("\u001b[0m")
    expect(color.reset).must_equal("\u001b[0m")
    expect(color.green.reset).must_equal(green.reset)
  end
end
