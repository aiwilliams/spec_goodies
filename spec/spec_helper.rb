require 'rubygems'
gem 'rspec'
require 'spec'
require 'activerecord'

require 'logger'
RAILS_DEFAULT_LOGGER = Logger.new($STDOUT)
RAILS_DEFAULT_LOGGER.level = Logger::DEBUG
ActiveRecord::Base.logger = RAILS_DEFAULT_LOGGER
ActiveRecord::Base.configurations = {'mysql' => {'adapter' => 'mysql', 'username' => 'root', 'database' => 'spec_goodies_test'}}
ActiveRecord::Base.establish_connection 'mysql'

ActiveRecord::Schema.define do
  create_table "people", :force => true do |t|
    t.column "first_name", :string
    t.column "last_name", :string
  end
end

class Person < ActiveRecord::Base
  validates_presence_of :first_name
  validates_length_of :first_name, :within => 3..20
end

require File.dirname(__FILE__) + '/../lib/spec/goodies'