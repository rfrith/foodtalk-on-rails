module DateHelper
  def initialize_date_range_for_reports(date_range)

    if(date_range)
      start_date = date_range.first
      end_date = date_range.last
    end

    start_date ||= Date.new(Date.current.year)
    end_date ||= Date.current

    begin
      #make inclusive for the whole day
      start_date = start_date.to_time.beginning_of_day
      end_date = end_date.to_time.end_of_day
    rescue ArgumentError => e
      #do nothing
    end

    return start_date...end_date
  end

end