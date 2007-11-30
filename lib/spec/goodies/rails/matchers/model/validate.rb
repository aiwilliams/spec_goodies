module Spec
  module Goodies
    module Rails # :nodoc:
      module Matchers # :nodoc:
      
        module Model
          class Validate # :nodoc:
            def initialize(attribute, values)
              @attribute, @values = attribute, values
            end
            
            def matches?(model)
              @model = model
              @valid_values = Array.new
              @invalid_values = Hash.new
              
              @values.flatten.each do |value|
                modified = setup_model(value)
                if modified.valid?
                  @valid_values << value
                else
                  @invalid_values[value] = modified.errors[@attribute].inspect
                end
              end
              _matches?
            end
            
            private
              def base_message
                "expected #{@model.class.name}##{@attribute} to be"
              end
              
              def setup_model(value)
                o = @model.dup
                attributes = o.instance_variable_get('@attributes')
                o.instance_variable_set('@attributes', attributes.dup)
                o.send("#{@attribute}=", value)
                o
              end
          end
          
          class BeValidWith < Validate # :nodoc:
            def _matches?
              @invalid_values.keys.empty?
            end
            
            def failure_message
              "#{base_message} valid with these values:\n#{@invalid_values.inspect}"
            end
            
            def negative_failure_message
              "#{base_message} invalid with these values:\n#{@valid_values.inspect}"
            end
          end
          
          class BeInvalidWith < Validate # :nodoc:
            def _matches?
              @valid_values.empty?
            end
            
            def failure_message
              "#{base_message} invalid with these values:\n#{@valid_values.inspect}"
            end
            
            def negative_failure_message
              "#{base_message} valid with these values:\n#{@invalid_values.inspect}"
            end
          end
          
          # Specify that an ActiveRecord model, given in a valid state,
          # remains valid with the _attribute_ set to each of the given
          # _values_.
          #
          #   model = Person.new(:first_name => "Bobby", :last_name => "Jones")
          #
          #   model.should be_valid_with(:first_name, "Adam", "John", "Joe")
          #   model.should_not be_valid_with(:first_name, "", "   ", nil, "50 Cent")
          #
          # The difference between #be_valid_with and #be_invalid_with is only
          # semantic.
          def be_valid_with(attribute, *values)
            BeValidWith.new(attribute, values)
          end
          
          # Specify that an ActiveRecord model, given in a valid state,
          # becomes invalid with the _attribute_ set to each of the given
          # _values_.
          #
          #   model = Person.new(:first_name => "Bobby", :last_name => "Jones")
          #
          #   model.should_not be_invalid_with(:first_name, "Adam", "John", "Joe")
          #   model.should be_invalid_with(:first_name, "", "   ", nil, "50 Cent")
          #
          # The difference between #be_invalid_with and #be_valid_with is only
          # semantic.
          def be_invalid_with(attribute, *values)
            BeInvalidWith.new(attribute, values)
          end
        end
        
      end
    end
  end
end