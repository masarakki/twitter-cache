require 'spec_helper'

describe Twitter::Cache do
  it 'has a version number' do
    expect(Twitter::Cache::VERSION).not_to be nil
  end
  it '.config' do
    expect(described_class.config).to be_a Twitter::Cache::Config
  end

  it '.new' do
    expect(described_class.new(1)).to be_a Twitter::Cache::Wrapper
  end

  describe 'clean!' do
    let(:redis) { Twitter::Cache::Redis.new }
    before do
      %w(a b c).each { |k| redis.set(k, k) }
    end
    it { expect { Twitter::Cache.clean! }.to change { redis.keys.count }.to(0) }
  end
end
