require 'spec_helper'

describe TwitterCache::Redis do
  before { cache.flushall }
  let(:cache) { described_class.new }
  let(:key) { 'hello' }
  shared_examples :stored do
    let(:obj) { MyUser.new(id: 1, nickname: 'name') }
    it { is_expected.to be_a MyUser }
    its(:id) { is_expected.to eq 1 }
    its(:nickname) { is_expected.to eq 'name' }
  end

  context 'stored' do
    it_behaves_like :stored do
      before { cache.set(key, obj) }
      subject { cache.get(key) }
    end
  end

  context 'block not given' do
    it { expect(cache.get(key)).to be_nil }
  end

  context 'block given' do
    it_behaves_like :stored do
      subject { cache.get(key) { obj } }
    end
  end
end
