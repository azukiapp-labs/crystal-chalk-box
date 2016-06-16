require "../src/chalk_box"
require "minitest/autorun"

module ChalkBox::SpecHelpers
end

macro let(name, type, &block)
  @{{name.id}} : {{type.id}}
  let({{name.id}}) { {{yield}} }
end

macro spec_mod(mod, subject = true, includes = false, &block)
  describe {{mod.id}} do
    alias SubjectType = Nil | {{mod.id}}
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
