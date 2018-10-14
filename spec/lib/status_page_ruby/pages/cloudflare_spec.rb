require 'spec_helper'

RSpec.describe StatusPageRuby::Pages::Cloudflare do
  let(:html) do
    <<-HTML
      <html>
      <body>
      <div class='page-status'>
        <div class='status'>All is Failed</div>
      </div>
      <div data-component-id>
        <div class="component-status">#{component_status}</div>
      </div>
      </body>
      </html>
    HTML
  end

  before { allow(OpenURI).to receive(:open_uri).with('https://www.cloudflarestatus.com/') { html } }

  describe '#status' do
    subject { described_class.open.status }

    context 'when component_status is Failed' do
      let(:component_status) { 'Failed' }

      it { is_expected.to eq('All is Failed') }
    end

    context 'when component_status is Re-routed' do
      let(:component_status) { 'Re-routed' }

      it { is_expected.to eq('All Systems Operational') }
    end

    context 'when component_status is Operational' do
      let(:component_status) { 'Operational' }

      it { is_expected.to eq('All Systems Operational') }
    end
  end

  describe '#success?' do
    subject { described_class.open.success? }

    context 'when component_status is Failed' do
      let(:component_status) { 'Failed' }

      it { is_expected.to be_falsey }
    end

    context 'when component_status is Re-routed' do
      let(:component_status) { 'Re-routed' }

      it { is_expected.to be_truthy }
    end

    context 'when component_status is Operational' do
      let(:component_status) { 'Operational' }

      it { is_expected.to be_truthy }
    end
  end
end
