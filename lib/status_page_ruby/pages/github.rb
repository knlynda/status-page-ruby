module StatusPageRuby
  module Pages
    class Github < Base
      page_url 'https://status.github.com/messages'
      page_success_message 'All systems reporting at 100%'

      element :status, :css, '.message .title'
      element :time, :css, '.message .time'

      def status
        @status ||= status_element.text.strip
      end

      def time
        DateTime.parse(time_element[:datetime].strip).to_time.to_i
      end
    end
  end
end
