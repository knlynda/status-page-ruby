require 'spec_helper'

RSpec.describe StatusPageRuby::Status do
  describe '.new' do
    [
      [nil, nil, nil, nil],
      ['', '', '', ''],
      [1, 2, 2, 3],
      ['Github', 'up', 'All Good', 1_539_506_590]
    ].each do |service, state, status, time|
      context "with service: #{service}, state: #{state}, status: #{status} and time: #{time}" do
        subject { described_class.new(service, state, status, time) }

        it { expect(subject.service).to eq(service.to_s) }
        it { expect(subject.state).to eq(state.to_s) }
        it { expect(subject.time).to eq(time.to_s) }
      end
    end
  end

  describe '#record' do
    [
      [nil, nil, nil, nil],
      ['', '', '', ''],
      [1, 2, 3, 4],
      ['Github', 'up', 'All Good', 1_539_506_590]
    ].each do |service, state, status, time|
      context "with service: #{service}, state: #{state}, status: #{status} and time: #{time}" do
        subject { described_class.new(service, state, status, time).record }

        it { is_expected.to eq([service.to_s, state.to_s, status.to_s, time.to_s]) }
      end
    end
  end

  describe '#to_csv' do
    [
      [[nil, nil, nil, nil],                        "\"\",\"\",\"\",\"\"\n"],
      [['', '', '', ''],                            "\"\",\"\",\"\",\"\"\n"],
      [[1, 2, 3, 4],                                "1,2,3,4\n"],
      [['Github', 'up', 'All Good', 1_539_506_590], "Github,up,All Good,1539506590\n"]
    ].each do |args, result|
      context "with service: #{args[0]}, state: #{args[1]}, status: #{args[2]} and time: #{args[3]}" do
        subject { described_class.new(*args).to_csv }

        it { is_expected.to eq(result) }
      end
    end
  end
end
