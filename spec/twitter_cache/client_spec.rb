require 'spec_helper'

def body(name)
  File.read("spec/mock/#{name}")
end

describe TwitterCache::Client do
  context 'unauthorized' do
    let(:client) { described_class.new }
    subject { client.twitter }
    its(:access_token) { is_expected.to be_nil }
    its(:access_token_secret) { is_expected.to be_nil }
  end

  context 'authorized' do
    shared_examples :with_token do
      subject { client }
      its(:access_token) { is_expected.to eq ENV['ACCESS_TOKEN'] }
      its(:access_token_secret) { is_expected.to eq ENV['ACCESS_TOKEN_SECRET'] }
    end

    it_behaves_like :with_token do
      let(:client) do
        described_class.new(access_token: ENV['ACCESS_TOKEN'],
                            access_token_secret: ENV['ACCESS_TOKEN_SECRET'])
      end
    end

    it_behaves_like :with_token do
      let(:client) do
        described_class.new do |conf|
          conf.access_token = ENV['ACCESS_TOKEN']
          conf.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
        end
      end
    end
  end
end
