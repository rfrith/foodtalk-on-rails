require "#{Rails.root}/app/helpers/curriculum_helper"
include CurriculumHelper

module CountyExtensionOfficeUtils
  extend ActiveSupport::Concern

  def get_curriculum_completion_in_date_range(users=User.all, date_range)
    food_etalk_completion_count = count_users_have_completed_curriculum(users, LearningModules::FOOD_ETALK, date_range)
    better_u_completion_count = count_users_have_completed_curriculum(users, LearningModules::BETTER_U, date_range)
    return {food_etalk: food_etalk_completion_count, better_u: better_u_completion_count}
  end

  def get_curriculum_completion_in_date_range_by_zip_code(date_range)

    zip_codes = ZipCode.all
    completions = []
    zip_codes.each do |zip_code|
      zip = zip_code.zip
      users = User.where(zip_code: zip)
      get_curriculum_completion_in_date_range(users, date_range)
      completion = get_curriculum_completion_in_date_range(users, date_range)
      completions << {zip => completion} unless (completion[:food_etalk] == 0 && completion[:better_u] == 0)
    end

    return completions
  end

end
