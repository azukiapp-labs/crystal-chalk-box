require "../src/chalk_box"
require "minitest/autorun"

module ChalkBox::SpecHelpers
end

macro spec_mod(mod, subject = true, includes = false, &block)
  describe {{mod.id}} do
    include ChalkBox::SpecHelpers
    {% if includes %}
      include {{mod.id}}
    {% end %}
    {% if subject %}
      let(:subject) { {{mod.id}} }
    {% end %}
    {{block.body}}
  end
end
