require 'spec_helper'

describe Twitter::Cache::Config do
  let(:config) { Twitter::Cache.config }
  subject { config }
  its(:redis) { is_expected.to eq 'redis://127.0.0.1:6379/' }
  its(:ttl) { is_expected.to eq 1800 }
  it { is_expected.to be_frozen }

  describe '#ttl=' do
    let(:config) { Twitter::Cache::Config.new { |x| x.ttl = 1800 } }
    subject { config.ttl = ttl }
    context '10.minutes' do
      let(:ttl) { 10.minutes }
      it { expect { subject }.to change { config.ttl }.to(600) }
    end

    context 'nil' do
      let(:ttl) { nil }
      it { expect { subject }.to change { config.ttl }.to(nil) }
    end

    context 'false' do
      let(:ttl) { false }
      it { expect { subject }.to change { config.ttl }.to(nil) }
    end

    context 'bad argument' do
      let(:ttl) { true }
      it { expect { subject }.to raise_error 'not an integer' }
    end
  end

  describe 'convert_user' do
    let(:raw) do
      double id: 1, screen_name: 'foo',
             profile_image_url_https: 'https://example.com/images/1'
    end
    subject { config.convert_user(raw) }
    it { is_expected.to be_a MyUser }
    its(:id) { is_expected.to eq 1 }
    its(:nickname) { is_expected.to eq 'foo' }
    its(:image) { is_expected.to eq 'https://example.com/images/1' }
  end
end
