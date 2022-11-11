class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def mark_as_best
    self.question.update(best_answer_id: self.id)
  end
end
