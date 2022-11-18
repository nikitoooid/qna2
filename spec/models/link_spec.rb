require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'validate url format' do
    it { should allow_value('http://correcturl.com').for(:url) }
    it { should_not allow_value('http://incorrecturl').for(:url) }
  end
end
