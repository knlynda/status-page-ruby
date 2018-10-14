require 'spec_helper'

RSpec.describe StatusPageRuby::Services::BuildStatsTable do
  let(:data_file_path) { Tempfile.new('data_file_path').path }
  let(:service) do
    described_class.new(
      StatusPageRuby::Repositories::Status.new(
        StatusPageRuby::Storage.new(data_file_path)
      )
    )
  end

  describe '#call' do
    before do
      Timecop.freeze(Time.at(1_539_520_990))
      File.write(data_file_path, <<-CSV.delete(' '))
        test1,up,Success,1539506590
        test1,down,Failure,1539510190
        test1,down,Failure,1539513790
        test2,up,Success,1539519190
        test1,up,Success,1539517390
      CSV
    end

    context 'with service parameter' do
      context 'when service exists' do
        subject { service.call('test1') }
        let(:expected_table) do
          <<-TABLE.gsub(/^ +/, '').strip
            +---------+----------+-----------+
            | Service | Up since | Down time |
            +---------+----------+-----------+
            | test1   | 1 hours  | 2 hours   |
            +---------+----------+-----------+
          TABLE
        end

        it { is_expected.to eq(expected_table) }
      end

      context 'when service does not exists' do
        subject { service.call('test3') }
        let(:expected_table) do
          <<-TABLE.gsub(/^ +/, '').strip
            +---------+----------+-----------+
            | Service | Up since | Down time |
            +---------+----------+-----------+
            +---------+----------+-----------+
          TABLE
        end

        it { is_expected.to eq(expected_table) }
      end
    end

    context 'without service parameter' do
      subject { service.call }
      let(:expected_table) do
        <<-TABLE.gsub(/^ +/, '').strip
          +---------+------------+-----------+
          | Service | Up since   | Down time |
          +---------+------------+-----------+
          | test1   | 1 hours    | 2 hours   |
          | test2   | 30 minutes | 0 minutes |
          +---------+------------+-----------+
        TABLE
      end

      it { is_expected.to eq(expected_table) }
    end
  end
end
