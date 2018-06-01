module Rapidfire
  class SurveysController < Rapidfire::ApplicationController
    if Rails::VERSION::MAJOR == 5
      before_action :authenticate_administrator!, except: :index
    else
      before_filter :authenticate_administrator!, except: :index
    end

    def index
      @surveys = if defined?(Kaminari)
        Survey.page(params[:page])
      else
        Survey.all
      end
    end

    def new
      @survey = Survey.new
    end

    def create
      @survey = Survey.new(survey_params)
      respond_to do |format|
        if @survey.save
          format.html { redirect_to surveys_path }
          format.json { render json: @survey, status: 201 }
          format.js
        else
          format.html { render :new }
          format.json { render json: @survey.errors, status: 422 }
          format.js
        end
      end
    end

    def destroy
      @survey = Survey.find(params[:id])
      @survey.destroy

      respond_to do |format|
        format.html { redirect_to surveys_path }
        format.json { head 204 }
        format.js
      end
    end

    def results
      @survey = Survey.find(params[:id])
      @survey_results =
        SurveyResults.new(survey: @survey).extract

      respond_to do |format|
        format.json { render json: @survey_results, root: false }
        format.html
        format.js
      end
    end

    private

    def survey_params
      if Rails::VERSION::MAJOR >= 4
        params.require(:survey).permit(:name, :introduction)
      else
        params[:survey]
      end
    end
  end
end
