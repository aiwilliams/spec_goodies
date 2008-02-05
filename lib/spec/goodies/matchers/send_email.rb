module Spec
  module Goodies
    module Matchers
      
      module Sizable # :nodoc:all
        def count_expectation_met(sizable, expected)
          case expected
          when Integer
            sizable.size == expected
          when String
            eval("#{sizable.size} #{expected}")
          end
        end
      end
      
      class SendEmail # :nodoc:all
        include Sizable
        
        attr_reader :failure_message, :options
        
        def initialize(options)
          @options = {
            :count => ">= 1"
          }.update(options)
        end
        
        def matches?(ignored, &block)
          @deliveries = ActionMailer::Base.deliveries
          
          unless count_expectation_met(@deliveries, options[:count])
            @failure_message = "Expected number of emails (#{options[:count]}) did not match actual (#{@deliveries.size})" 
          end
          
          unless @failure_message || block.nil?
            context_for_block = eval("self", block.binding)
            context_for_block.instance_variable_set("@action_mailer_deliveries", @deliveries)
            @deliveries.each do |mail|
              context_for_block.instance_variable_set("@mail", mail)
              block.call
            end
          end
          
          @failure_message.nil?
        end
        
        def negative_failure_message
          "Expected no emails to be sent, but there were #{@deliveries.size}"
        end
      end
      
      module AddressMatching
        attr_reader :failure_message, :options
        
        def addresses(mail)
          mail["to"].addrs.collect(&:address)
        end
        
        def addresses_match?(mail)
          actual = addresses(mail)
          missing = @addresses.reject {|e| actual.include?(e)}
          extra = actual.reject {|e| @addresses.include?(e)}
          extra.empty? && missing.empty?
        end
      end
      
      class AddressedTo # :nodoc:all
        include Sizable
        include AddressMatching
        
        def initialize(*addresses)
          @options = {
            :count => ">= 1"
          }.update(addresses.extract_options!)
          @addresses = addresses.flatten
        end
        
        def matches?(deliveries)
          found_addressed_to = []
          deliveries.each do |delivery|
            found_addressed_to << delivery if addresses_match?(delivery)
          end
          
          unless count_expectation_met(found_addressed_to, options[:count])
            @failure_message = "Expected number of emails addressed to #{found_addressed_to.inspect} (#{options[:count]}) did not match actual (#{found_addressed_to.size})" 
          end
          
          @failure_message.nil?
        end
      end
      
      class BeAddressedTo
        include AddressMatching
        
        def initialize(*addresses)
          @addresses = addresses.flatten
        end
        
        def matches?(mail)
          @failure_message = "Expected to be addressed to #{@addresses.inspect} but was #{addresses(mail).inspect}" unless addresses_match?(mail)
          @failure_message.nil?
        end
      end
      
      # Use in mailer tests for mail objects, like so:
      #
      #    @mail.should be_addressed_to("jim@nomail.net")
      #    @mail.should be_addressed_to(["jim@nomail.net", "jane@nomail.net"])
      #    @mail.should be_addressed_to(%w{jim@nomail.net jane@nomail.net})
      def be_addressed_to(*addresses)
        BeAddressedTo.new(*addresses)
      end
      
      # Use within a send_email block like so:
      #
      #   should send_email do
      #     addressed_to "james@nomail.net"
      #   end
      #
      # This will look for at least one email to have been sent addressed to
      # ALL of the given addresses. If you want to guarantee the number of
      # emails addressed_to the provided addresses, use the :count option. If
      # you want to guarantee the overall number of emails sent, see
      # _send_email_.
      #
      # You may also call it with arguments like these:
      #
      #     addressed_to "jim@nomail.net", "jane@nomail.net"
      #     addressed_to ["jim@nomail.net", "jane@nomail.net"]
      #     addressed_to %w{jim@nomail.net jane@nomail.net}
      #
      # Options:
      # * <tt>:count</tt> - the number of emails that should have been
      #   addressed to addresses, either as an Integer or a String like ">=
      #   1". Default is that.
      def addressed_to(*options)
        ActionMailer::Base.deliveries.should AddressedTo.new(*options)
      end
      
      # Ensures that an email has been sent with a text part. Be sure to check
      # out _addressed_to_.
      #
      # Options:
      # * <tt>:count</tt> - the total number of emails that should have been
      #   sent, either as an Integer or a String like ">= 1". Default is that.
      def send_email(options = {})
        SendEmail.new(options)
      end
    end
  end
end