module StatusPageRuby
  module Pages
    class Rubygems < Base
      page_url 'https://status.rubygems.org/'
      page_success_message 'All Systems Operational'

      element :status, :css, '.page-status .status'

      def status
        @status ||= status_element.text.strip
      end
    end
  end
end
