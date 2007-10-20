Spec::DSL::Example.module_eval do
  include Spec::Goodies::Matchers
end
Spec::DSL::ExampleModule.module_eval do
  include Spec::Goodies::Matchers
end
Test::Unit::TestCase.module_eval do
  include Spec::Goodies::Matchers
end