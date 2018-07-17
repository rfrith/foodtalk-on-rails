class SurveyHistory < ActivityHistory
  STARTED_CONSENT_FORM = "consent_form#started"
  COMPLETED_CONSENT_FORM = "consent_form#completed"
  scope :started_consent_form, -> { where(name: STARTED_CONSENT_FORM) }
  scope :completed_consent_form, -> { where(name: COMPLETED_CONSENT_FORM) }
end