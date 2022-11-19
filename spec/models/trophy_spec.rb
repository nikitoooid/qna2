require 'rails_helper'

RSpec.describe Trophy, type: :model do
  it { should belong_to(:question) }

  it { should validate_presence_of :name }

  it 'have one attached image' do
    expect(described_class.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
