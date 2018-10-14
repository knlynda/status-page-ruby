module StatusPageRuby
  module Services
    class BuildStatsTable
      HEADINGS = ['Service', 'Up since', 'Down time'].freeze
      SECONDS_IN_MINUTE = 60
      SECONDS_IN_HOUR = 3600
      SECONDS_IN_DAY = 86_400

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
        find_records(service)
          .group_by(&:service)
          .each_with_object([]) do |(key, records), results|

          results << [
            key,
            readable_time_amount(calculate_up_since(records)),
            readable_time_amount(calculate_down_time(records))
          ]
        end
      end

      def calculate_down_time(records)
        records
          .sort_by { |record| record.time.to_i }
          .each_cons(2)
          .inject(0) { |result, (first, second)| result + duration_between(first, second) }
      end

      def duration_between(first, second)
        return 0 if first.up?

        (second.nil? ? Time.now.to_i : second.time.to_i) - first.time.to_i
      end

      def calculate_up_since(records)
        record = take_up_since(records)
        return if record.nil?

        Time.now.to_i - record.time.to_i
      end

      def readable_time_amount(duration_sec)
        return 'N/A' if duration_sec.nil?
        return "#{duration_sec / SECONDS_IN_MINUTE} minutes" if duration_sec < SECONDS_IN_HOUR
        return "#{duration_sec / SECONDS_IN_HOUR} hours" if duration_sec < SECONDS_IN_DAY

        "#{duration_sec / SECONDS_IN_DAY} days"
      end

      def take_up_since(records)
        records
          .sort_by { |record| -record.time.to_i }
          .take_while(&:up?)
          .first
      end

      def find_records(service)
        return status_repository.all if service.nil?

        status_repository.where(service: service)
      end
    end
  end
end
