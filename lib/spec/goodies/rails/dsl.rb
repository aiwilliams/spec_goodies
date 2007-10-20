Dir[File.dirname(__FILE__) + '/dsl/extensions/*.rb'].each { |f| require f }
Dir[File.dirname(__FILE__) + '/dsl/*.rb'].each { |f| require f }