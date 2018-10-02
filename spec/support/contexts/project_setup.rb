RSpec.shared_context "project setup" do

  #users
  let(:user) { FactoryBot.create(:user) }
  let(:static_user) { FactoryBot.create(:user, :static_email_uid) }

  #course_enrollments
  let(:user_with_course_enrollment) { FactoryBot.create(:user, :user_with_course_enrollment) }
  let(:user_with_food_etalk_enrollment) { FactoryBot.create(:user, :user_with_food_etalk_enrollment) }
  let(:user_with_better_u_enrollment) { FactoryBot.create(:user, :user_with_better_u_enrollment) }
  let(:user_has_completed_food_etalk) { FactoryBot.create(:user, :user_has_completed_food_etalk) }
  let(:user_has_completed_better_u) { FactoryBot.create(:user, :user_has_completed_better_u) }

end