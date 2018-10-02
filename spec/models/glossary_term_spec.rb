require 'rails_helper'

RSpec.describe  GlossaryTerm,  type:  :model  do
  it "has a valid factory" do
    term = FactoryBot.build(:glossary_term)
    expect(term).to be_valid
  end
end
