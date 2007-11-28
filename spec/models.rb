class Person < ActiveRecord::Base
  validates_presence_of :first_name
  validates_length_of :first_name, :within => 3..20
end