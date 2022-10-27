class AnswersController < ApplicationController
  before_action :set_question, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)

    if @answer.save
      redirect_to question_path(@question), notice: 'Your answer successfully created.'
    else
      flash.now[:alert] = "Your answer not created!"
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])

    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question_path(@answer.question), notice: 'Your answer successfully deleted.'
    else
      flash.now[:alert] = "You don't have enough permissions to delete this answer!"
      render 'questions/show'
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
