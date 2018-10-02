require 'rails_helper'

describe DateHelper, type: :helper do

  include_context "project setup"

  describe "#initialize_date_range_for_reports" do

    let(:start_date) { Date.new(Date.current.year) }
    let(:end_date) { Date.today }

    it "correctly formats date range to be inclusive of day with .. operator" do
      range = initialize_date_range_for_reports(start_date..end_date)
      expect(range.first).to eq start_date.to_time.beginning_of_day
      expect(range.last).to eq end_date.to_time.end_of_day
    end

    it "correctly formats date range to be inclusive of day with ... operator" do
      range = initialize_date_range_for_reports(start_date...end_date)
      expect(range.first).to eq start_date.to_time.beginning_of_day
      expect(range.last).to eq end_date.to_time.end_of_day
    end

    it "correctly returns a default date range when given a null range" do
      range = initialize_date_range_for_reports(nil)
      expect(range.first).to eq start_date.to_time.beginning_of_day
      expect(range.last).to eq end_date.to_time.end_of_day
    end

  end

end
