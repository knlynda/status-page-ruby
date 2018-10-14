module StatusPageRuby
  module Services
    class RestoreData
      attr_reader :storage

      def initialize(storage)
        @storage = storage
      end

      def call(path)
        storage.restore(path)
      end
    end
  end
end
