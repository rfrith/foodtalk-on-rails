class ActivityHistory < ApplicationRecord
  belongs_to :user
  COMPLETED_CONSENT_FORM = "COMPLETED_CONSENT_FORM"
end
