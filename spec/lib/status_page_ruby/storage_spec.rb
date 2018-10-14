require 'spec_helper'

RSpec.describe StatusPageRuby::Storage do
  describe '.new' do
    subject { described_class.new(data_file_path) }
    let(:data_file_path) { double(to_s: double) }

    before do
      allow(File).to receive(:file?).with(data_file_path.to_s) { is_file }
      allow(File).to receive(:readable?).with(data_file_path.to_s) { is_readable }
    end

    context 'when file valid' do
      let(:is_file) { true }
      let(:is_readable) { true }

      it { expect(subject.data_file_path).to eq(data_file_path) }
    end

    context 'when file invalid' do
      let(:is_file) { false }
      let(:is_readable) { false }

      it { expect { subject }.to raise_exception(ArgumentError, 'Invalid file given.') }

      context 'when file is not file' do
        let(:is_readable) { true }

        it { expect { subject }.to raise_exception(ArgumentError, 'Invalid file given.') }
      end

      context 'when file is not readable' do
        let(:is_file) { true }

        it { expect { subject }.to raise_exception(ArgumentError, 'Invalid file given.') }
      end
    end
  end

  describe '#include?' do
    let(:data_file_path) { Tempfile.new('data_file_path').path }

    before { File.write(data_file_path, "a,a,a\n1,1,1\n,,\n") }

    [
      [%w[a a a],       true],
      [%w[1 1 1],       true],
      [[1, 1, 1],       false],
      [['', '', ''],    false],
      [[nil, nil, nil], true]
    ].each do |record, result|
      context "when record: #{record.inspect}" do
        subject { described_class.new(data_file_path).include?(record) }

        it { is_expected.to eq(result) }
      end
    end
  end

  describe '#write' do
    let(:data_file_path) { Tempfile.new('data_file_path').path }

    before { File.write(data_file_path, "a,a,a\n") }

    [
      [[nil, nil, nil],                 "a,a,a\n,,\n"],
      [['', '', ''],                    "a,a,a\n\"\",\"\",\"\"\n"],
      [[1, 2, 3],                       "a,a,a\n1,2,3\n"],
      [['Github', 'up', 1_539_506_590], "a,a,a\nGithub,up,1539506590\n"]
    ].each do |record, result|
      context "when record: #{record.inspect}" do
        it do
          described_class.new(data_file_path).write(record)
          expect(File.read(data_file_path)).to eq(result)
        end
      end
    end
  end

  describe '#merge' do
    let(:data_file_path) { Tempfile.new('data_file_path').path }

    before { File.write(data_file_path, "a,a,a\n") }

    [
      [[%w[a a a], %w[b b b]], "a,a,a\nb,b,b\n"],
      [[%w[b b b]], "a,a,a\nb,b,b\n"],
      [[%w[a a a]], "a,a,a\n"]
    ].each do |records, result|
      context "when records: #{records.inspect}" do
        it do
          described_class.new(data_file_path).merge(records)
          expect(File.read(data_file_path)).to eq(result)
        end
      end
    end
  end

  describe '#copy' do
    let(:data_file_path) { Tempfile.new('data_file_path').path }
    let(:target_file_path) { Tempfile.new('data_file_path').path }

    before { File.write(data_file_path, "a,a,a\nb,b,b\nc,c,c\n") }

    it do
      described_class.new(data_file_path).copy(target_file_path)
      expect(File.read(target_file_path)).to eq("a,a,a\nb,b,b\nc,c,c\n")
    end
  end

  describe '#restore' do
    let(:data_file_path) { Tempfile.new('data_file_path').path }
    let(:new_file_path) { Tempfile.new('new_file_path').path }

    [
      %W[a,a,a\nc,c,c\n a,a,a\nb,b,b\n a,a,a\nb,b,b\nc,c,c\n],
      %W[a,a,a\nc,c,c\n a,a,a\n a,a,a\nc,c,c\n],
      %W[a,a,a\nc,c,c\n a,a,a\n a,a,a\nc,c,c\n],
      %W[a,a,a\nc,c,c\n a,a,a\nc,c,c\n a,a,a\nc,c,c\n]
    ].each do |data_file_content, new_file_content, result|
      context do
        before do
          File.write(data_file_path, data_file_content)
          File.write(new_file_path, new_file_content)
        end

        it do
          described_class.new(data_file_path).restore(new_file_path)
          expect(File.read(data_file_path)).to eq(result)
        end
      end
    end
  end
end
