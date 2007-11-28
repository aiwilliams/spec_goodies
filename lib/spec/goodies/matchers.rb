Dir[File.dirname(__FILE__) + '/matchers/**/*'].each { |f| require f }

Spec::Runner.configure do |config|
  config.include Spec::Goodies::Matchers
end
