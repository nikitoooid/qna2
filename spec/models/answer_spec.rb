require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }

  it { should validate_presence_of :body }

  describe '#mark_as_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    it 'returns true if user is creator of the object' do
      answer.mark_as_best
      expect(answer.question.best_answer).to eq answer
    end
  end
end
