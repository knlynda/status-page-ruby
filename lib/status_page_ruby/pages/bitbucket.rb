module StatusPageRuby
  module Pages
    class Bitbucket < Base
      page_url 'https://status.bitbucket.org/'
      page_success_message 'All Systems Operational'

      element :status, :css, '.page-status .status'

      def status
        @status ||= status_element.text.strip
      end
    end
  end
end
