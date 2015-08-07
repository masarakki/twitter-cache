require 'spec_helper'

describe Twitter::Cache::Wrapper do
  let(:twitter) { double }
  let(:wrapper) { described_class.new(twitter) }
  let(:friend_ids) { (11..20).to_a }
  before do
    wrapper.cache.flushall
    allow(twitter).to receive(:current_user) { double(id: 1) }
    allow(twitter).to receive(:friend_ids) { friend_ids }
  end

  describe 'user' do
    before do
      expect(twitter).to receive(:user) do
        double(id: 1, screen_name: 'a', profile_image_url_https: 'b')
      end
      wrapper.user(1)
    end

    shared_examples :user do
      its(:id) { is_expected.to eq 1 }
      its(:nickname) { is_expected.to eq 'a' }
      its(:image) { is_expected.to eq 'b' }
    end

    it_behaves_like :user do
      subject { wrapper.user(1) }
    end

    describe 'cached' do
      it_behaves_like :user do
        subject { wrapper.user_cache.get(1) }
      end
    end

    describe 'ttl' do
      it { expect(wrapper.user_cache.ttl(1)).to be > 0 }
    end
  end

  describe 'friend_ids' do
    before do
      expect(twitter).to receive(:friend_ids) { [10, 20, 30] }
      wrapper.friend_ids
    end
    shared_examples :friend_ids do
      it { is_expected.to eq [10, 20, 30] }
    end
    it_behaves_like :friend_ids do
      subject { wrapper.friend_ids }
    end

    describe 'cached' do
      it_behaves_like :friend_ids do
        subject { wrapper.friends_cache.get(1) }
      end
    end

    describe 'ttl' do
      it { expect(wrapper.friends_cache.ttl(1)).to be > 0 }
    end
  end

  describe 'friends' do
    context 'not cached' do
      before do
        wrapper.user_cache.set(3000, double)
        allow(twitter).to receive(:friend_ids) { friend_ids + [3000] }
      end

      it 'fetch from api and cached' do
        expect(twitter).to receive(:users).with(friend_ids) do |ids|
          ids.map do |id|
            double(id: id, screen_name: '', profile_image_url_https: '')
          end
        end
        wrapper.friends
        friend_ids.each do |id|
          expect(wrapper.user_cache.get(id)).not_to be_nil
        end
      end
    end

    context 'cached' do
      before { friend_ids.each { |id| wrapper.user_cache.set(id, double) } }
      it 'return from cache' do
        expect(twitter).not_to receive(:users)
        wrapper.friends
      end
    end
  end

  describe 'known_ids' do
    before do
      (6..15).each { |id| wrapper.user_cache.set(id, double) }
    end
    subject { wrapper.send(:known_ids, friend_ids) }
    it { is_expected.to eq [11, 12, 13, 14, 15] }
  end
end
