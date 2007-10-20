module Spec
  module Goodies
    module Matchers
      
      begin
        require 'json'
      rescue MissingSourceFile => e
        raise "sudo gem install json, please: #{e.message}"
      end
      
      class HaveJson
        def initialize(expected)
          @expected = case
            when expected.kind_of?(String): JSON.parse(expected)
            when expected.respond_to?(:to_json): JSON.parse(expected.to_json)
            else raise "Expected have_json to be called with an object that can be converted to JSON but instead received #{expected.class}"
          end
        end
        
        def matches?(actual)
          @actual = actual.kind_of?(String) ? actual : actual.body
          begin
            @expected == JSON.parse(@actual)
          rescue
            @failure_message = "actual value <#{actual.inspect}> is not JSON"
            false
          end
        end
        
        def failure_message
          @failure_message || "expected <#{@actual.inspect}> to contain JSON <#{@expected.inspect}>"
        end
        
        def negative_failure_message
          "expected <#{@actual.inspect}> not to contain JSON <#{@expected}>"
        end
      end
      
      def have_json(expected)
        HaveJson.new(expected)
      end
      
    end
  end
end
