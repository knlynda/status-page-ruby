require 'spec_helper'

RSpec.describe StatusPageRuby::Services::BuildLogTable do
  describe '#call' do
    subject { described_class.new.call(records) }

    context 'with records' do
      let(:records) do
        [
          StatusPageRuby::Status.new('test1', 'up', 'Success', '1539506590'),
          StatusPageRuby::Status.new('test2', 'up', 'Success', '1539508592')
        ]
      end

      let(:expected_table) do
        <<-TABLE.gsub(/^ +/, '').strip
          +---------+--------+---------------------+
          | Service | Status | Time                |
          +---------+--------+---------------------+
          | test1   | up     | 14.10.2018 10:43:10 |
          | test2   | up     | 14.10.2018 11:16:32 |
          +---------+--------+---------------------+
        TABLE
      end

      it { is_expected.to eq(expected_table) }
    end

    context 'with empty records' do
      let(:records) { [] }
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
end
