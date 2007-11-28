Dir[File.dirname(__FILE__) + '/matchers/**/*.rb'].each { |f| require f }

Spec::Runner.configure do |config|
  config.include Spec::Goodies::Rails::Matchers
  config.include Spec::Goodies::Rails::Matchers::Model, :behaviour_type => :model
end