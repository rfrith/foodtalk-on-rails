class GlossaryTermsController < ApplicationController

  caches_page :index, :expires_in => 1.week

  def index
    @glossary_terms = GlossaryTerm.all
  end
end