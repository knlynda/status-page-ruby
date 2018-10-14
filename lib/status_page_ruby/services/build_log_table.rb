module StatusPageRuby
  module Services
    class BuildLogTable
      HEADINGS = %w[Service Status Time].freeze

      def call(records)
        Terminal::Table.new(
          headings: HEADINGS,
          rows: records.map(&:history_record)
        ).to_s
      end
    end
  end
end
