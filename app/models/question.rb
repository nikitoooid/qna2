class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true

  has_many_attached :files

  validates :title, presence: true
  validates :body, presence: true

  def attach_files=(attachables)
    files.attach(attachables)
  end
end
