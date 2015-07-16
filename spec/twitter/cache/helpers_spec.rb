require 'spec_helper'

describe Twitter::Cache::Helpers do
  let(:klass) { Class.new { include Twitter::Cache::Helpers } }
  subject { klass.new }
  it { expect(subject.user_cache).to eq subject.user_cache }
  it { expect(subject.user_cache).not_to eq subject.friends_cache }
end
