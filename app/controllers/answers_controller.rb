class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_answer, only: [:update, :destroy, :mark_as_best]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params)
    current_user.answers.push @answer
    
    @answer.save
  end

  def update
    @answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def mark_as_best
    if current_user.author_of?(@answer)
      @answer.mark_as_best
    end

    @question = @answer.question
    @answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], attach_files: [])
  end
end
