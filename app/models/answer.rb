class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many_attached :files

  validates :body, presence: true

  def mark_as_best
    self.question.update(best_answer_id: self.id)
  end

  def attach_files=(attachables)
    files.attach(attachables)
  end
end
