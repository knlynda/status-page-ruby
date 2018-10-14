require 'spec_helper'

RSpec.describe StatusPageRuby::Repositories::Status do
  let(:storage) { double }
  let(:repository) { described_class.new(storage) }

  describe '#exist?' do
    subject { repository.exist?(status) }
    let(:status) { double(record: double) }

    before { allow(storage).to receive(:include?).with(status.record) { is_include } }

    context 'when storage includes status record' do
      let(:is_include) { true }
      it { is_expected.to be_truthy }
    end

    context 'when storage does not include status record' do
      let(:is_include) { false }
      it { is_expected.to be_falsey }
    end
  end

  describe '#where' do
    subject { repository.where(service: 'a') }

    context 'when storage is not empty' do
      context 'when service exists' do
        before { allow(storage).to receive(:read) { [%w[a b c]] } }

        it 'builds statuses' do
          expect(StatusPageRuby::Status).to receive(:new).with('a', 'b', 'c')
          subject
        end
      end

      context 'when service does not exist' do
        before { allow(storage).to receive(:read) { [%w[x x x]] } }

        it 'builds statuses' do
          expect(StatusPageRuby::Status).not_to receive(:new)
          subject
        end
      end
    end

    context 'when storage is empty' do
      before { allow(storage).to receive(:read) { [] } }

      it 'does not build statuses' do
        expect(StatusPageRuby::Status).not_to receive(:new)
        subject
      end
    end
  end

  describe '#all' do
    subject { repository.all }

    context 'when storage is not empty' do
      before { allow(storage).to receive(:read) { [%w[a b c]] } }

      it 'builds statuses' do
        expect(StatusPageRuby::Status).to receive(:new).with('a', 'b', 'c')
        subject
      end
    end
    context 'when storage is empty' do
      before { allow(storage).to receive(:read) { [] } }

      it 'does not build statuses' do
        expect(StatusPageRuby::Status).not_to receive(:new)
        subject
      end
    end
  end

  describe '#create' do
    subject { repository.create(status) }
    let(:status) { double(record: double) }

    before { allow(repository).to receive(:exist?) { status_exists } }

    context 'when status does not exist' do
      let(:status_exists) { false }

      it 'triggers write on storage' do
        expect(storage).to receive(:write).with(status.record).once
        subject
      end
    end

    context 'with status exists' do
      let(:status_exists) { true }

      it 'does not trigger write on storage' do
        expect(storage).not_to receive(:write)
        subject
      end
    end
  end

  describe '#create_batch' do
    subject { repository.create_batch(statuses) }

    context 'with statuses' do
      let(:statuses) { [double(record: double)] }

      it 'triggers merge on storage' do
        expect(storage).to receive(:merge).with(statuses.map(&:record)).once
        subject
      end
    end

    context 'with empty statuses' do
      let(:statuses) { [] }

      it 'does not trigger merge on storage' do
        expect(storage).not_to receive(:merge)
        subject
      end
    end
  end
end
