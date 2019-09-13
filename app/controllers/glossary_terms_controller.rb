class GlossaryTermsController < ApplicationController
  def index
    @glossary_terms = Rails.cache.fetch("all_glossary_terms", expires_in: 1.day) do
      GlossaryTerm.all
    end
  end
end