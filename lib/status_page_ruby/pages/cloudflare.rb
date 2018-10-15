module StatusPageRuby
  module Pages
    class Cloudflare < Base
      page_url 'https://www.cloudflarestatus.com/'
      page_success_message 'All Systems Operational'

      element :status, :css, '.page-status .status'
      element :failed_status, :xpath, <<-XPATH
        //*[@data-component-id]
        //*[contains(@class,"component-status")]
           [not(contains(.,"Re-routed"))]
           [not(contains(.,"Operational"))]
           [not(contains(.,"Partial Outage"))]
      XPATH

      def status
        @status ||= parse_status
      end

      private

      def parse_status
        return status_element.text.strip if has_failed_status_element?

        success_message
      end
    end
  end
end
