module StatusPageRuby
  class Status
    attr_reader :service, :state, :time

    def initialize(service, state, time)
      @service = service.to_s
      @state = state.to_s
      @time = time.to_s
    end

    def record
      [service, state, time]
    end

    def to_csv
      record.to_csv
    end
  end
end
