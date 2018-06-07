module Rapidfire
  class QuestionsController < Rapidfire::ApplicationController
    if Rails::VERSION::MAJOR ==  5
      before_action :authenticate_administrator!
      before_action :find_survey!
      before_action :find_question!, :only => [:edit, :update, :destroy]
    else
      before_filter :authenticate_administrator!
      before_filter :find_survey!
      before_filter :find_question!, :only => [:edit, :update, :destroy]
    end

    def index
      @questions = @survey.questions

      respond_to do |format|
        format.html { render :index }
        format.json { render json: @questions }
      end
    end

    def new
      @question_form = QuestionForm.new(:survey => @survey)
    end

    def create
      form_params = question_params.merge(:survey => @survey)

      save_and_redirect(form_params, :new)
    end

    def edit
      @question_form = QuestionForm.new(:question => @question)
    end

    def update
      form_params = question_params.merge(:question => @question)
      save_and_redirect(form_params, :edit)
    end

    def destroy
      @question.destroy
      respond_to do |format|
        format.html { redirect_to index_location }
        format.json { head 204 }
        format.js
      end
    end

    private

    def save_and_redirect(params, on_error_key)
      @question_form = QuestionForm.new(params)
      @question_form.save

      respond_to do |format|
        if @question_form.errors.empty?
          format.html { redirect_to index_location }
          format.json { render json: @question_form, status: 201 }
          format.js
        else
          format.html { render on_error_key.to_sym }
          format.json { render json: @question_form.errors, status: 422 }
          format.js
        end
      end
    end

    def find_survey!
      @survey = Survey.find(params[:survey_id])
    end

    def find_question!
      @question = @survey.questions.find(params[:id])
    end

    def index_location
      survey_questions_url(@survey)
    end

    def question_params
      if Rails::VERSION::MAJOR == 4 || Rails::VERSION::MAJOR == 5
        params.require(:question).permit!
      else
        params[:question]
      end
    end
  end
end
