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


  #groups
  let!(:admin_group) { FactoryBot.create(:group, :admin) }
  let!(:mhc) { FactoryBot.create(:group, :mhc) }

  #racial identities
  let!(:white) { FactoryBot.create(:racial_identity, :white) }
  let!(:black) { FactoryBot.create(:racial_identity, :black) }

  let!(:tanf) { FactoryBot.create(:federal_assistance, :tanf)}

end