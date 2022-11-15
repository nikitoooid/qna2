require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:questions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:object) { create(:question, user: user) }

    it 'returns true if user is creator of the object' do
      expect(user).to be_author_of(object)
    end

    it 'returns false if user is not creator of the object' do
      expect(another_user).not_to be_author_of(object)
    end
  end
end
