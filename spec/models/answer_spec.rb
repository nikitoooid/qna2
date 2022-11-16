require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many(:links).dependent(:destroy) }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#mark_as_best' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }

    it 'set answer as best answer to the parent question' do
      answer.mark_as_best
      expect(answer.question.best_answer).to eq answer
    end
  end

  describe '#attach_files=' do
    let(:answer) { described_class.new }

    it 'attach new files to existed answer' do
      answer.attach_files = { io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'TestFile' }
      expect(answer.files.last.filename.to_s).to eq 'TestFile'
    end
  end
end
