require 'spec_helper'

RSpec.describe StatusPageRuby::Status do
  describe '.new' do
    [
      [nil, nil, nil],
      ['', '', ''],
      [1, 2, 3],
      ['Github', 'up', 1_539_506_590]
    ].each do |service, state, time|
      context "with service: #{service.inspect}, state: #{state.inspect} and time: #{time.inspect}" do
        subject { described_class.new(service, state, time) }

        it { expect(subject.service).to eq(service.to_s) }
        it { expect(subject.state).to eq(state.to_s) }
        it { expect(subject.time).to eq(time.to_s) }
      end
    end
  end

  describe '#record' do
    [
      [nil, nil, nil],
      ['', '', ''],
      [1, 2, 3],
      ['Github', 'up', 1_539_506_590]
    ].each do |service, state, time|
      context "with service: #{service.inspect}, state: #{state.inspect} and time: #{time.inspect}" do
        subject { described_class.new(service, state, time).record }

        it { is_expected.to eq([service.to_s, state.to_s, time.to_s]) }
      end
    end
  end

  describe '#to_csv' do
    [
      [[nil, nil, nil],                 "\"\",\"\",\"\"\n"],
      [['', '', ''],                    "\"\",\"\",\"\"\n"],
      [[1, 2, 3],                       "1,2,3\n"],
      [['Github', 'up', 1_539_506_590], "Github,up,1539506590\n"]
    ].each do |args, result|
      context "with service: #{args[0].inspect}, state: #{args[1].inspect} and time: #{args[2].inspect}" do
        subject { described_class.new(*args).to_csv }

        it { is_expected.to eq(result) }
      end
    end
  end
end
