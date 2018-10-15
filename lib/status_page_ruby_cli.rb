class StatusPageRubyCli < Thor
  PULL_SECONDS = 10

  def initialize(*args)
    super(*args)
    data_file_path = File.join(ENV['HOME'], '.status_page_ruby_data.csv')
    create_data_file_if_needed(data_file_path)
    storage = StatusPageRuby::Storage.new(data_file_path)
    repository = StatusPageRuby::Repositories::Status.new(storage)
    setup_services(repository)
  end

  desc :pull, 'Pulls, saves and optionally log statuses.'
  option :log, type: :boolean
  def pull
    records = pull_statuses.call
    puts build_log_table.call(records) if options[:log]
  end

  desc :live, "Pulls, saves and log statuses every #{PULL_SECONDS} seconds."
  def live
    loop do
      puts build_log_table.call(pull_statuses.call)
      sleep PULL_SECONDS
    end
  end

  desc :history, 'Display all the data which was gathered.'
  option :service, type: :string, required: false
  def history
    puts build_history_table.call(options[:service])
  end

  desc :stats, 'Summarizes the data and displays it.'
  option :service, type: :string, required: false
  def stats
    puts build_stats_table.call(options[:service])
  end

  desc :backup, 'Backups data.'
  option :path, type: :string, required: true
  def backup
    backup_data.call(options[:path])
  end

  desc :restore, 'Restores data.'
  option :path, type: :string, required: true
  def restore
    restore_data.call(options[:path])
  end

  private

  attr_reader :build_history_table,
              :build_log_table,
              :build_stats_table,
              :pull_statuses,
              :backup_data,
              :restore_data

  def setup_services(status_repository)
    @build_history_table = StatusPageRuby::Services::BuildHistoryTable.new(status_repository)
    @build_log_table = StatusPageRuby::Services::BuildLogTable.new
    @build_stats_table = StatusPageRuby::Services::BuildStatsTable.new(status_repository)
    @pull_statuses = StatusPageRuby::Services::PullStatuses.new(status_repository)
    @backup_data = StatusPageRuby::Services::RestoreData.new(status_repository.storage)
    @restore_data = StatusPageRuby::Services::RestoreData.new(status_repository.storage)
  end

  def create_data_file_if_needed(path)
    return if File.exist?(path)

    FileUtils.mkpath(File.dirname(path))
    FileUtils.touch(path)
  end
end
