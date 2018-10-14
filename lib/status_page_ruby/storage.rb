module StatusPageRuby
  class Storage
    attr_reader :data_file_path

    def initialize(data_file_path)
      validate_file(data_file_path)
      @data_file_path = data_file_path
    end

    def include?(record)
      read.lazy.include?(record)
    end

    def read
      CSV.foreach(data_file_path)
    end

    def write(record)
      CSV.open(data_file_path, 'a') do |csv|
        csv << record
      end
    end

    def merge(records)
      updated_records = merge_records(records)
      CSV.open(data_file_path, 'w') do |csv|
        updated_records.each do |record|
          csv << record
        end
      end
    end

    def copy(target_file_path)
      FileUtils.mkpath(File.dirname(target_file_path))
      FileUtils.cp(data_file_path, target_file_path)
    end

    def restore(new_file_path)
      validate_file(new_file_path)
      merge(CSV.foreach(new_file_path).to_a)
    end

    private

    def validate_file(path)
      return if File.file?(path.to_s) && File.readable?(path.to_s)

      raise ArgumentError, 'Invalid file given.'
    end

    def merge_records(records)
      (read.to_a | records).sort_by(&:last)
    end
  end
end
