module StatusPageRuby
  module Services
    class PullStatuses
      attr_reader :status_repository

      def initialize(status_repository)
        @status_repository = status_repository
      end

      def call
        fetch_statuses.tap do |statuses|
          status_repository.create_batch(statuses) unless statuses.empty?
        end
      end

      private

      def fetch_statuses
        page_classes
          .map(&:open)
          .map(&method(:build_status))
      end

      def page_classes
        ObjectSpace
          .each_object(Class)
          .select(&method(:page_class?))
      end

      def page_class?(klass)
        klass < ::StatusPageRuby::Pages::Base
      end

      def build_status(page)
        StatusPageRuby::Status.new(
          page.class.name.split('::').last,
          page.success? ? 'up' : 'down',
          page.status,
          page.time
        )
      end
    end
  end
end
