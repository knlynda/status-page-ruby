require 'spec_helper'

RSpec.describe StatusPageRuby::Services::BuildHistoryTable do
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
      File.write(data_file_path, <<-CSV.delete(' '))
        test1,up,Success,1
        test1,down,Failure,2
        test2,up,Success,3
      CSV
    end

    context 'with service parameter' do
      context 'when service exists' do
        subject { service.call('test1') }
        let(:expected_table) do
          <<-TABLE.gsub(/^ +/, '').strip
            +---------+--------+------+
            | Service | Status | Time |
            +---------+--------+------+
            | test1   | up     | 1    |
            | test1   | down   | 2    |
            +---------+--------+------+
          TABLE
        end

        it { is_expected.to eq(expected_table) }
      end

      context 'when service does not exists' do
        subject { service.call('test3') }
        let(:expected_table) do
          <<-TABLE.gsub(/^ +/, '').strip
            +---------+--------+------+
            | Service | Status | Time |
            +---------+--------+------+
            +---------+--------+------+
          TABLE
        end

        it { is_expected.to eq(expected_table) }
      end
    end

    context 'without service parameter' do
      subject { service.call }
      let(:expected_table) do
        <<-TABLE.gsub(/^ +/, '').strip
            +---------+--------+------+
            | Service | Status | Time |
            +---------+--------+------+
            | test1   | up     | 1    |
            | test1   | down   | 2    |
            | test2   | up     | 3    |
            +---------+--------+------+
        TABLE
      end

      it { is_expected.to eq(expected_table) }
    end
  end
end
