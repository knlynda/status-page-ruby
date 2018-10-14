module StatusPageRuby
  module Repositories
    class Status
      attr_reader :storage

      def initialize(storage)
        @storage = storage
      end

      def exist?(status)
        storage.include?(status.record)
      end

      def where(service:)
        storage
          .read
          .select { |record| record.first == service }
          .map { |attrs| StatusPageRuby::Status.new(*attrs) }
      end

      def all
        storage
          .read
          .map { |attrs| StatusPageRuby::Status.new(*attrs) }
      end

      def create(status)
        return if exist?(status)

        storage.write(status.record)
      end

      def create_batch(statuses)
        return if statuses.empty?

        storage.merge(statuses.map(&:record))
      end
    end
  end
end
