class SurveyHistory < ActivityHistory
  COMPLETED_CONSENT_FORM = "COMPLETED_CONSENT_FORM"
  scope :completed_consent_form, -> { where(name: COMPLETED_CONSENT_FORM) }
end