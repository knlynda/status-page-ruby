module StatusPageRuby
  module Services
    class BuildHistoryTable
      HEADINGS = %w[Service Status Time].freeze

      attr_reader :status_repository

      def initialize(status_repository)
        @status_repository = status_repository
      end

      def call(service = nil)
        Terminal::Table.new(
          headings: HEADINGS,
          rows: build_rows(service)
        ).to_s
      end

      private

      def build_rows(service)
        find_records(service).map(&:history_record)
      end

      def find_records(service)
        return status_repository.all if service.nil?

        status_repository.where(service: service)
      end
    end
  end
end
