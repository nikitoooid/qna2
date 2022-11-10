class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    current_user.answers.push @answer
    
    @answer.save
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
