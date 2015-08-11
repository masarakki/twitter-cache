require 'spec_helper'

describe Twitter::Cache::Redis do
  before { cache.client.flushall }
  let(:cache) { described_class.new }
  let(:key) { 'hello' }

  shared_examples :stored do
    let(:obj) { MyUser.new(id: 1, nickname: 'name') }
    it { is_expected.to be_a MyUser }
    its(:id) { is_expected.to eq 1 }
    its(:nickname) { is_expected.to eq 'name' }
  end

  describe 'prefix' do
    it_behaves_like :stored do
      before { cache.set('user:1', obj) }
      subject { described_class.new('user').get(1) }
    end
  end

  describe 'get' do
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

  describe 'expire' do
    it do
      cache.get('hello', ttl: 1) do
        'hoge'
      end
      expect(cache.get('hello')).to eq 'hoge'
      sleep 2
      expect(cache.get('hello')).to be_nil
    end
  end

  describe 'flushall' do
    subject { cache.flushall }
    before do
      cache.client.redis.set 'other', -1
      cache.set 'hello', 1
      cache.set 'world', 2
    end

    describe 'delete namespaced keys' do
      it do
        expect { subject }.to change {
          cache.keys.count
        }.from(2).to(0)
      end
    end

    describe 'other keys are not deleted' do
      it do
        expect { subject }.to change {
          cache.client.redis.keys.count
        }.from(3).to(1)
      end
    end
  end
end
