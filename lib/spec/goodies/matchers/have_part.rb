module Spec
  module Goodies
    module Matchers
      
      class HavePart # :nodoc:all
        def initialize(mail, content_type)
          @mail = mail
          case content_type
          when Regexp
            @content_type = content_type
          when String
            @content_type = Regexp.new(Regexp.escape(content_type))
          end
        end
        
        def matches?(mail = nil, &block)
          @mail = mail || @mail
          if !@mail.multipart? && @content_type == /^text\/plain/
            @found = true
            @text = @mail.to_s
          else
            for part in @mail.parts
              if part["Content-Type"].to_s =~ @content_type
                @found = true
                if part["Content-Type"].to_s =~ /^text\/plain/
                  @text = part.to_s
                end
              end
            end
          end
          
          if @found
            if @text && block
              eval("@text = %Q|#{@text}|", block.binding)
              block.call
            end
          else
            @failure_message = "Mail does not contain any #{@content_type} parts"
          end
          
          !@failure_message
        end
        
        def failure_message
          @failure_message
        end
      end
      
      # Given an instance variable _@mail_, this will allow you to ensure
      # that it has a part of the specificed _content_type_. If you use the
      # default of text/plain, you will have at your disposal, within a given
      # block, a variable _@text_, against which you may further specify
      # behaviour.
      #
      # This is primary designed to be used with _send_email_, as in:
      #
      #   should send_email do
      #     with_part { @text.should include('something') }
      #   end
      def have_part(content_type = /^text\/plain/)
        HavePart.new(@mail, content_type)
      end
      alias_method :with_part, :have_part
    end
  end
end