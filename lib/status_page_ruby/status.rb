module StatusPageRuby
  class Status
    HISTORY_RECORD_TIME_FORMAT = '%d.%m.%Y %H:%M:%S'.freeze
    UP_STATE = 'up'.freeze
    DOWN_STATE = 'down'.freeze

    attr_reader :service, :state, :status, :time

    def initialize(service, state, status, time)
      @service = service.to_s
      @state = state.to_s
      @status = status.to_s
      @time = time.to_s
    end

    def up?
      state == UP_STATE
    end

    def down?
      state == DOWN_STATE
    end

    def history_record
      [service, state, Time.at(time.to_i).strftime(HISTORY_RECORD_TIME_FORMAT)]
    end

    def record
      [service, state, status, time]
    end

    def to_csv
      record.to_csv
    end
  end
end
