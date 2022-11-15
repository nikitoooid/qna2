require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:best_answer).optional(true) }
  it { should have_many(:answers).dependent(:destroy) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it 'have many attached files' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#attach_files=' do
    let(:question) { described_class.new }

    it 'attach new files to existed question' do
      question.attach_files = { io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: 'TestFile' }
      expect(question.files.last.filename.to_s).to eq 'TestFile'
    end
  end
end
