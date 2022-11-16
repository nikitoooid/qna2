class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, presence: true
  validates :body, presence: true

  def attach_files=(attachables)
    files.attach(attachables)
  end
end
