module Spec
  module Goodies
    module Matchers
      
      begin
        require 'json'
      rescue MissingSourceFile => e
        raise "sudo gem install json, please: #{e.message}"
      end
      
      class HaveJson # :nodoc:
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
      
      # Specify that a String or an object responding to :body matches the
      # expected JSON content, given as a String or an object responding to
      # :to_json (like a Hash). Requires that you install the json gem.
      #
      # The matching is done by parsing the actual and expected JSON, thereby
      # converting them into Ruby structures. Equality is then decided by
      # using ==.
      #
      #    "{something: 'value'}".should have_json(:something => "value")
      #    response.should have_json(:something => "value")
      #
      # Note that at present, substrings are not handled. That is, given a
      # large document with a JSON String in it, this will fail, as it must
      # match completely. In Rails, css_select is your friend ;)
      def have_json(expected)
        HaveJson.new(expected)
      end
      
    end
  end
end
