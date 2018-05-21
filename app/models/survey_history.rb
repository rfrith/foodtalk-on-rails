class SurveyHistory < ActivityHistory
  COMPLETED_CONSENT_FORM = "consent_form#completed"
  scope :completed_consent_form, -> { where(name: COMPLETED_CONSENT_FORM) }
end