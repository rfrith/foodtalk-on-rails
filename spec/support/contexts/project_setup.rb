RSpec.shared_context "project setup" do

  #users
  let(:user) { FactoryBot.create(:user) }
  let(:static_user) { FactoryBot.create(:user, :static_email_uid) }
  let(:eligible_user) { FactoryBot.create(:user, :eligible) }
  let(:ineligible_user) { FactoryBot.create(:user, :ineligible) }
  let(:admin_user) { FactoryBot.create(:user, :admin) }

  #users with course_enrollments
  let(:user_with_food_etalk_enrollment) { FactoryBot.create(:user, :with_food_etalk_enrollment) }
  let(:user_with_better_u_enrollment) { FactoryBot.create(:user, :with_better_u_enrollment) }
  let(:user_has_completed_food_etalk) { FactoryBot.create(:user, :has_completed_food_etalk) }
  let(:user_has_completed_better_u) { FactoryBot.create(:user, :has_completed_better_u) }

  #users having/not-having completed both curricula
  let(:user_has_completed_program) { FactoryBot.create(:user, :has_completed_program) }
  let(:user_has_not_completed_program) { FactoryBot.create(:user, :has_not_completed_program) }

  #users with survey history
  let(:user_has_started_video_survey_sweet_deceit) { FactoryBot.create(:user, :has_started_video_survey_sweet_deceit) }
  let(:user_has_completed_video_survey_sweet_deceit) { FactoryBot.create(:user, :has_completed_video_survey_sweet_deceit) }

  #groups
  let!(:mhc) { FactoryBot.create(:group, :mhc) }
  let!(:hhip) { FactoryBot.create(:group, :hhip) }

  #racial identities
  let!(:white) { FactoryBot.create(:racial_identity, :white) }
  let!(:black) { FactoryBot.create(:racial_identity, :black) }
  let!(:tanf) { FactoryBot.create(:federal_assistance, :tanf)}

  #zip codes
  FactoryBot.create(:zip_code, :eligible)
  FactoryBot.create(:zip_code, :ineligible)

end