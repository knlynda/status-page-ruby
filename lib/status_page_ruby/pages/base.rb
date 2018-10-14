module StatusPageRuby
  module Pages
    class Base
      class << self
        attr_reader :url

        def open
          new(Nokogiri::HTML(OpenURI.open_uri(url)), Time.now.utc.to_i)
        end

        private

        def page_url(url)
          @url = url
        end

        def page_success_message(success_message)
          define_method :success_message do
            success_message
          end
        end

        def element(name, type, locator)
          define_method :"#{name}_element" do
            document.public_send("at_#{type}", locator)
          end

          define_method :"has_#{name}_element?" do
            document.public_send(type, locator).size.positive?
          end
        end
      end

      attr_reader :document, :time

      def success?
        status == success_message
      end

      def status
        raise 'Method not implemented.'
      end

      private

      def initialize(document, time)
        @document = document
        @time = time
      end
    end
  end
end
