require 'spec_helper'

RSpec.describe StatusPageRuby::Pages::Github do
  let(:html) do
    <<-HTML
      <html>
      <body>
      <div class='message'>
        <div class='title'>#{status}</div>
        <div class='time' datetime='2018-10-12T22:00:00.000Z'></div>
      </div>
      </body>
      </html>
    HTML
  end

  before { allow(OpenURI).to receive(:open_uri).with('https://status.github.com/messages') { html } }

  describe '#status' do
    subject { described_class.open.status }

    context 'when success status' do
      let(:status) { 'All systems reporting at 100%' }

      it { is_expected.to eq('All systems reporting at 100%') }
    end

    context 'when not success status' do
      let(:status) { 'All is Failed' }

      it { is_expected.to eq('All is Failed') }
    end
  end

  describe '#time' do
    subject { described_class.open.time }
    let(:status) { 'All systems reporting at 100%' }

    it { is_expected.to eq(1_539_381_600) }
  end

  describe '#success?' do
    subject { described_class.open.success? }

    context 'when success status' do
      let(:status) { 'All systems reporting at 100%' }

      it { is_expected.to be_truthy }
    end

    context 'when not success status' do
      let(:status) { 'All is Failed' }

      it { is_expected.to be_falsey }
    end
  end
end
