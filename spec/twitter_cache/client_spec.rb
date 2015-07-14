require 'spec_helper'

def body(name)
  File.read("spec/mock/#{name}")
end

describe TwitterCache::Client do
  context 'unauthorized' do
    let(:client) { described_class.new }
    describe 'current_user' do
      it { expect { client.send(:current_user) }.to raise_error StandardError }
    end
  end

  context 'authorized' do
    let(:client) do
      described_class.new(access_token: ENV['ACCESS_TOKEN'],
                          access_token_secret: ENV['ACCESS_TOKEN_SECRET'])
    end
  end
end
