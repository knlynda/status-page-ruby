module StatusPageRuby
  module Services
    class BackupData
      attr_reader :storage

      def initialize(storage)
        @storage = storage
      end

      def call(path)
        storage.copy(path)
      end
    end
  end
end
