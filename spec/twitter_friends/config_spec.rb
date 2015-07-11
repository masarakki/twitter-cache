require 'spec_helper'

describe TwitterFriends::Config do
  let(:config) { TwitterFriends.config }
  subject { config }
  its(:twitter) do
    is_expected.to eq consumer_key: 'CONSUMER_KEY',
                      consumer_secret: 'CONSUMER_SECRET'
  end
  its(:redis) { is_expected.to eq 'redis://127.0.0.1:6379/' }
  its(:ttl) { is_expected.to eq 1800 }
  it { is_expected.to be_frozen }

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
