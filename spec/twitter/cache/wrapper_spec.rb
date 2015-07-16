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

  describe 'friend_ids' do
    before { expect(twitter).to receive(:friend_ids) { [10, 20, 30] } }

    it 'fetch from api and cached' do
      expect(wrapper.friend_ids).to eq [10, 20, 30]
      expect(wrapper.friends_cache.get(1)).to eq [10, 20, 30]
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
