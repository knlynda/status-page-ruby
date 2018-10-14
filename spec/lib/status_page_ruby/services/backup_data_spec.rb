require 'spec_helper'

RSpec.describe StatusPageRuby::Services::BackupData do
  let(:storage) { double }
  let(:service) { described_class.new(storage) }

  describe '#call' do
    it 'triggers copy on storage' do
      expect(storage).to receive(:copy).with('test_path').once
      service.call('test_path')
    end
  end
end
