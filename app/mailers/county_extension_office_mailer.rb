class CountyExtensionOfficeMailer < ApplicationMailer
  default from: 'snap-ed@uga.edu'

  def program_completions_email
    @completions= params[:completions]
    @county_extension_office = params[:county_extension_office]
    @zip_code = params[:zip_code]
    date_range = params[:date_range]

    format = "%b %d, %Y"
    @start_date = date_range.first.strftime(format)
    @end_date = date_range.last.strftime(format)

    @food_etalk_completed_by_zip = @completions.values[0][:food_etalk]
    @better_u_completed_by_zip = @completions.values[0][:better_u]

    mail(to: "rfrith@uga.edu", subject: "Food eTalk & Better U Completion Report for #{@start_date} - #{@end_date}")

  end
end
