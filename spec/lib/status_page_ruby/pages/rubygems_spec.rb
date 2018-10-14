require 'spec_helper'

RSpec.describe StatusPageRuby::Pages::Rubygems do
  let(:html) { "<html><body><div class='page-status'><div class='status'>#{status}</div></div></body></html>" }

  before { allow(OpenURI).to receive(:open_uri).with('https://status.rubygems.org/') { html } }

  describe '#status' do
    subject { described_class.open.status }

    context 'when success status' do
      let(:status) { 'All Systems Operational' }

      it { is_expected.to eq('All Systems Operational') }
    end

    context 'when not success status' do
      let(:status) { 'All is Failed' }

      it { is_expected.to eq('All is Failed') }
    end
  end

  describe '#success?' do
    subject { described_class.open.success? }

    context 'when success status' do
      let(:status) { 'All Systems Operational' }

      it { is_expected.to be_truthy }
    end

    context 'when not success status' do
      let(:status) { 'All is Failed' }

      it { is_expected.to be_falsey }
    end
  end
end
