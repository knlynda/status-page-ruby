require 'spec_helper'

RSpec.describe StatusPageRuby::Services::RestoreData do
  let(:storage) { double }
  let(:service) { described_class.new(storage) }

  describe '#call' do
    it 'triggers restore on storage' do
      expect(storage).to receive(:restore).with('test_path').once
      service.call('test_path')
    end
  end
end
