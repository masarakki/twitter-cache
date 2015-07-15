require 'spec_helper'

describe Twitter::Cache::Wrapper do
  let(:twitter) { double }
  let(:wrapper) { described_class.new(twitter) }
  let(:friend_ids) { (11..20).to_a }
  before do
    wrapper.cache.flushall
    allow(twitter).to receive(:current_user) { double(id: 1) }
  end

  describe 'friend_ids' do
    before { expect(twitter).to receive(:friend_ids) { [10, 20, 30] } }

    it 'fetch from api and cached' do
      expect(wrapper.friend_ids).to eq [10, 20, 30]
      expect(wrapper.cache.get('friends:1')).to eq [10, 20, 30]
    end
  end

  describe 'friends' do
    before { allow(twitter).to receive(:friend_ids) { friend_ids } }
    it 'fetch from api and cached' do
      expect(twitter).to receive(:users).with(friend_ids) do |ids|
        ids.map do |id|
          double(id: id, screen_name: '', profile_image_url_https: '')
        end
      end
      wrapper.friends
      friend_ids.each do |id|
        expect(wrapper.cache.get("user:#{id}")).not_to be_nil
      end
    end
  end
end
