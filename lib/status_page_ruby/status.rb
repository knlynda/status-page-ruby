module StatusPageRuby
  class Status
    attr_reader :service, :state, :status, :time

    def initialize(service, state, status, time)
      @service = service.to_s
      @state = state.to_s
      @status = status.to_s
      @time = time.to_s
    end

    def history_record
      [service, state, time]
    end

    def record
      [service, state, status, time]
    end

    def to_csv
      record.to_csv
    end
  end
end
