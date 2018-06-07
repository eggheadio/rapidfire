if Rails::VERSION::MAJOR == 5
  version = [Rails::VERSION::MAJOR, Rails::VERSION::MINOR].join('.').to_f
  base = ActiveRecord::Migration[version]
else
  base = ActiveRecord::Migration
end

class MakeSurveyPolymorphic < base
  def change
    change_table :rapidfire_surveys do |t|
      t.references :surveyable, polymorphic: true, index: true
    end
  end
end
