require 'spec_helper'

RSpec.describe StatusPageRuby::Services::PullStatuses do
  let(:status_repository) { double }
  let(:service) { described_class.new(status_repository) }

  describe '#call' do
    context 'when there is page classes' do
      let(:page_class) { double(open: page) }
      let(:page) { double(class: double(name: 'TestPage'), success?: true, status: 'Success', time: 123) }
      let(:status) { double }
      before { allow(service).to receive(:page_classes) { [page_class] } }

      it 'does not trigger create_batch for status_repository' do
        expect(status_repository).to receive(:create_batch).with([status]).once
        expect(StatusPageRuby::Status).to receive(:new).with('TestPage', 'up', 'Success', 123) { status }.once
        service.call
      end
    end

    context 'when there is no page classes' do
      before { allow(service).to receive(:page_class?) { false } }

      it 'does not trigger create_batch for status_repository' do
        expect(status_repository).not_to receive(:create_batch)
        service.call
      end
    end
  end
end
